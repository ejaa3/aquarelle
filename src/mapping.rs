/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{collections::BTreeMap, io::Write, rc::Rc, result};
use compact_str::CompactString;
use serde::{Deserialize, Serialize};
use crate::{arrangement, map, path, scheme, script, Value};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct Map {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(rename = "type")]
	pub(crate) variant: Type,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub(crate) display: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub(crate) nomenclature: CompactString,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) schemes: BTreeMap<CompactString, Scheme>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) options: BTreeMap<CompactString, crate::Optional>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) suggested_paths: BTreeMap<CompactString, path::Location>,
	
	#[serde(default, skip_serializing_if = "FileType::is_default")]
	pub(crate) default_file_type: FileType,
	
	#[serde(default, skip_serializing_if = "<[_]>::is_empty")]
	pub(crate) subdirectories: Vec<CompactString>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) files: BTreeMap<CompactString, File>,
	
	#[serde(skip)]
	pub(crate) script_path: Option<Rc<std::path::Path>>,
}

#[derive(Default, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub(crate) enum Type { Directory, EditTextFile, SvgToPngFile, #[default] TextFile, ZipFile }

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub(crate) struct Scheme {
	name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	about: CompactString,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	pub(crate) fallback: Option<CompactString>,
}

#[derive(Serialize, Deserialize)]
pub struct File {
	#[serde(default, skip_serializing_if = "Option::is_none")]
	pub variant: Option<FileType>,
	
	#[serde(default, skip_serializing_if = "is_zero")]
	pub at: u32,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub name: CompactString,
}

fn is_zero(number: &u32) -> bool { *number == 0 }

#[derive(Default, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum FileType { #[default] Text, TextEdit, SvgToPng }

impl FileType { fn is_default(&self) -> bool { *self == Self::Text } }

pub enum Files<'c> {
	Single  (Vec<path::Parsed<'c>>),
	Several (Vec<ParsedFile<'c>>),
}

pub struct ParsedFile<'c> {
	pub(crate)    file_id: &'c str,
	pub(crate)    variant: FileType,
	pub(crate) file_paths: Vec<path::Parsed<'c>>,
}

pub struct Ready<'a> {
	pub     map: &'a Map,
	pub      id: &'a str,
	pub  map_id: &'a rhai::ImmutableString,
	pub options: BTreeMap<CompactString, Value>,
	pub display: rhai::ImmutableString,
	pub    name: rhai::ImmutableString,
	pub schemes: Rc<BTreeMap<CompactString, Rc<scheme::Data>>>,
	pub  safety: arrangement::EngineSafety,
	pub   paths: Option<Files<'a>>,
	pub replica: (map::Replica, arrangement::Replica),
}

impl<'a> Ready<'a> {
	pub fn perform(self) -> Result<'a> { perform(self) }
}

fn perform<'a>(ready: Ready<'a>) -> Result<'a> {
	let Ready { map, id, map_id, options, display, name, schemes, safety, paths, replica } = ready;
	let path = map.script_path.as_ref().unwrap();
	
	let script = std::fs::read_to_string(&path)
		.map_err(|error| Error { id, map_id, of: Of::Loading { path, error } })?;
	
	let slice = if script.starts_with("#!") {
		&script[script.find('\n').unwrap_or(0)..]
	} else { &script };
	
	let mut cfg_module = script::cfg_module(map_id.clone(), options);
	cfg_module
		.set_var("display", display)
		.set_var("name", name)
		
		.set_native_fn("scheme", move |context: rhai::NativeCallContext, index: &str|
			match schemes.get(index) {
				Some(scheme) => Ok(Rc::clone(scheme)),
				None => rhai::EvalAltResult::ErrorIndexNotFound(index.into(), context.position()).into()
			}
		);
	
	let mut engine = script::engine(path.parent().unwrap());
	
	safety.set(engine
		.set_optimization_level(rhai::OptimizationLevel::None)
		.register_global_module(script::MAP_MODULE.with(|module| Rc::clone(module)))
		.register_static_module("cfg", Rc::new(cfg_module)));
	
	let (mut scope, ast) = (rhai::Scope::new(), match engine.compile(slice) {
		Ok(ast) => ast,
		Err(error) => return Err(Error { id, map_id, of: Of::Rhai { path, script, error: error.into() } })
	});
	
	for (name, _, value) in ast.iter_literal_variables(true, false) { scope.push_constant(name, value); }
	engine.set_optimization_level(rhai::OptimizationLevel::Full);
	let ast = engine.optimize_ast(&scope, ast, engine.optimization_level());
	
	let Some(paths) = paths else {
		return Ok(Success { id, errors: Box::new([]), text: Some(engine.eval_ast(&ast)
			.map_err(|error| Error { id, map_id, of: Of::Rhai { path, script, error } })?) })
	};
	
	let mut io_errors = vec![];
	
	if let Files::Single(paths) = paths {
		if let Type::ZipFile = map.variant {
			let mut zip = zip::ZipWriter::new(std::io::Cursor::new(vec![]));
			
			for (at, subdir) in map.subdirectories.iter().enumerate() {
				let split: Vec<_> = subdir.split(['/', '\\']).collect();
				if let None | Some(&"") = split.get(0) { continue }
				
				for i in 1..split.len() {
					let value = &split[0..i];
					let mut string = String::with_capacity(
						value.iter().fold(0, |acc, str| acc + str.len() + 1)
					);
					
					for str in value.iter() { string.extend([str, "/"]) }
					
					zip.add_directory::<_, ()>(string, Default::default())
						.map_err(|error| Error { id, map_id, of: Of::ZipDir { at, subdir, error } })?
				}
			}
			
			let rmap: rhai::Map = engine.eval_ast(&ast)
				.map_err(|error| Error { id, map_id, of: Of::Rhai { path, script, error } })?;
			
			for (file_id, file) in map.files.iter() {
				let value = rmap.get(file_id as &str).ok_or(Error { id, map_id, of: Of::MissingFile { file_id } })?;
				
				let content = value.clone().into_immutable_string()
					.map_err(|type_name| Error { id, map_id, of: Of::InvalidType { file_id, type_name } })?;
				
				let png = if let FileType::SvgToPng = file.variant.unwrap_or(map.default_file_type) {
					Some(svg_to_png(id, map_id, content.as_bytes())?)
				} else { None };
				
				let content = png.as_deref().unwrap_or(content.as_bytes());
				
				let subdir = if file.at > 0 {
					map.subdirectories.get(file.at as usize - 1)
						.ok_or(Error { id, map_id, of: Of::NoSubdir {
							file_id, at: file.at, available: map.subdirectories.len()
						} })?
				} else { "" };
				
				// NOTE https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT (4.4.17)
				let no_slash = subdir.is_empty() || subdir.ends_with('/');
				let name = String::from_iter([subdir, if no_slash {""} else {"/"}, &file.name]);
				
				zip.start_file::<_, ()>(name, Default::default())
					.map_err(|error| Error { id, map_id, of: Of::ZipFile { file_id, file, subdir, error } })?;
				
				zip.write_all(content)
					.map_err(|error| Error { id, map_id, of: Of::ZipIo { file_id, file, subdir, error } })?;
			}
			
			write(paths, &mut io_errors, replica, &zip.finish()
				.map_err(|error| Error { id, map_id, of: Of::Zip(error) })?.into_inner())?
		} else {
			let content: rhai::ImmutableString = engine.eval_ast(&ast)
				.map_err(|error| Error { id, map_id, of: Of::Rhai { path, script, error } })?;
			
			let png = if let Type::SvgToPngFile = map.variant {
				Some(svg_to_png(id, map_id, content.as_bytes())?)
			} else { None };
			
			let content = png.as_deref().unwrap_or(content.as_bytes());
			write(paths, &mut io_errors, replica, content)?
		}
	} else if let Files::Several(paths) = paths {
		let map: rhai::Map = engine.eval_ast(&ast)
			.map_err(|error| Error { id, map_id, of: Of::Rhai { path, script, error } })?;
		
		for ParsedFile { file_id, variant, file_paths } in paths {
			let value = map.get(file_id).ok_or(Error { id, map_id, of: Of::MissingFile { file_id } })?;
			
			let content = value.clone().into_immutable_string()
				.map_err(|type_name| Error { id, map_id, of: Of::InvalidType { file_id, type_name } })?;
			
			let png = if let FileType::SvgToPng = variant {
				Some(svg_to_png(id, map_id, content.as_bytes())?)
			} else { None };
			
			let content = png.as_deref().unwrap_or(content.as_bytes());
			write(file_paths, &mut io_errors, replica, content)?
		}
	}
	
	Ok(Success { id, text: None, errors: io_errors.into_boxed_slice() })
}

fn write<'a>(
	file_paths: Vec<path::Parsed<'a>>,
	 io_errors: &mut Vec<IoError<'a>>,
	   replica: (map::Replica, arrangement::Replica),
	   content: &[u8],
) -> result::Result<(), Error<'a>> {
	let mut written_path: Option<std::path::PathBuf> = None;
	
	for path in file_paths {
		if let Some(parent) = path.buf.parent() {
			if let Err(error) = std::fs::create_dir_all(parent) {
				io_errors.push(IoError { path, error });
				continue
			}
		}
		
		if let Some(ref written_path) = written_path {
			if let Err(error) = std::fs::remove_file(path.buf.as_path()) {
				if error.kind() != std::io::ErrorKind::NotFound {
					io_errors.push(IoError { path, error });
					continue
				}
			}
			
			macro_rules! policy (($policy:ident) => {
				(map::Replica::Arrangement, arrangement::Replica::$policy) |
				(map::Replica::$policy    , _)
			});
			
			let result = match replica {
				policy!(HardLink) => {
					std::fs::hard_link(written_path.as_path(), path.buf.as_path()).err()
				}
				policy!(SymbolicLink) => {
					#[cfg(unix)]
					std::os::unix::fs::symlink(written_path.as_path(), path.buf.as_path()).err()
				}
				policy!(Copy) => std::fs::copy(written_path.as_path(), path.buf.as_path()).err()
			};
			
			if let Some(error) = result { io_errors.push(IoError { path, error }) }
		} else {
			let result = std::fs::File::create(path.buf.as_path())
				.map(|mut file| file.write_all(content));
			
			match result {
				Ok(_)      => written_path = Some(path.buf),
				Err(error) => io_errors.push(IoError { path, error })
			};
		}
	} Ok(())
}

// WATCH https://github.com/RazrFalcon/resvg/blob/master/crates/resvg/examples/minimal.rs
fn svg_to_png<'a>(id: &'a str, map_id: &'a str, svg: &[u8]) -> result::Result<Vec<u8>, Error<'a>> {
	let mut options = resvg::usvg::Options::default();
	options.fontdb_mut().load_system_fonts();
	
	let tree = resvg::usvg::Tree::from_data(svg, &options)
		.map_err(|error| Error { id, map_id, of: Of::Svg(error) })?;
	
	let size = tree.size().to_int_size();
	
	let mut pixmap = resvg::tiny_skia::Pixmap::new(size.width(), size.height())
		.ok_or(Error { id, map_id, of: Of::NoPixmap })?;
	
	resvg::render(&tree, resvg::usvg::Transform::default(), &mut pixmap.as_mut());
	
	pixmap.encode_png().map_err(|error| Error { id, map_id, of: Of::Png(error) })
}

pub type Result<'a> = result::Result<Success<'a>, Error<'a>>;

pub struct Success<'a> {
	pub     id: &'a str,
	pub   text: Option<rhai::ImmutableString>,
	pub errors: Box<[IoError<'a>]>,
}

pub struct IoError<'a> {
	pub error: std::io::Error,
	pub  path: path::Parsed<'a>,
}

pub struct Error<'a> {
	pub     id: &'a str,
	pub map_id: &'a str,
	pub     of: Of<'a>,
}

pub enum Of<'a> {
     ZipDir { at: usize, subdir: &'a str, error: zip::result::ZipError },
    ZipFile { file_id: &'a str, file: &'a File, subdir: &'a str, error: zip::result::ZipError },
      ZipIo { file_id: &'a str, file: &'a File, subdir: &'a str, error: std::io::Error },
        Zip (zip::result::ZipError),
    Loading { path: &'a std::path::Path, error: std::io::Error },
       Rhai { path: &'a std::path::Path, script: String, error: Box<rhai::EvalAltResult> },
MissingFile { file_id: &'a str },
InvalidType { file_id: &'a str, type_name: &'static str },
   NoSubdir { file_id: &'a str, at: u32, available: usize },
        Svg (resvg::usvg::Error),
   NoPixmap,
   NoRender,
        Png (png::EncodingError),
}

#[cfg(feature = "cli")]
pub fn show_error(out: &mut impl std::io::Write, Error { id, map_id, of }: Error) -> std::io::Result<()> {
	write!(out, crate::csi!('\n' /b:fg magenta; "FAILURE:"! ' '))?;
	
	match of {
		Of::ZipDir { at, subdir, error } => write!(out, crate::csi! {
			"ZIP error for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " at subdirectory " /fg red; "{}"!
			" as " /fg yellow; "{:?}"! '\n' /9 F /b; "{}"!
		}, map_id, id, at, subdir, error),
		
		Of::ZipFile { file_id, file, subdir, error } => write!(out, crate::csi! {
			"ZIP error for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " at file " /fg red; "{:?}"!
			" as " /fg yellow; "{:?}"! " + " /fg yellow; "{:?}"! '\n' /9 F /b; "{}"!
		}, map_id, id, file_id, subdir, file.name, error),
		
		Of::ZipIo { file_id, file, subdir, error } => write!(out, crate::csi! {
			"ZIP I/O error for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " at file " /fg red; "{:?}"!
			" as " " + " /fg yellow; "{:?}"! " + " /fg yellow; "{:?}"! '\n' /9 F /b; "{}"!
		}, map_id, id, file_id, subdir, file.name, error),
		
		Of::Zip(error) => writeln!(out, crate::csi! {
			"ZIP error for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! '\n' /9 F /b; "{}"!
		}, map_id, id, error),
		
		Of::Loading { path, error } => write!(out, crate::csi! {
			"Unable to read script for map " /fg yellow; "{:?}"!
			" requested by " /fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			" at:\n" /9 F /fg cyan; "{}"! '\n' /9 F /b; "{}"! '\n'
		}, map_id, id, path.to_string_lossy(), error),
		
		Of::Rhai { path, script, error } => {
			writeln!(out, crate::csi! {
				"At map " /fg red; "{:?}"! " script, requested by "
				/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! ", located in:\n"
				/9 F /fg cyan; "{}"! ' '
			}, map_id, id, path.to_string_lossy())?;
			
			Ok({ script::show_error(out, error, &script)?; })
		}
		
		Of::MissingFile { file_id } => writeln!(out, crate::csi! {
			"Map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " specifies file " /fg red; "{}"!
			", but the object map returned by the script does not include it"
		}, map_id, id, file_id),
		
		Of::InvalidType { file_id, type_name } => writeln!(out, crate::csi! {
			"The script for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"!
			" assigns data of type " /fg magenta; "{}"! " instead of " /fg magenta; "string"!
			" to file " /fg red; "{}"! " in the returned object map"
		}, map_id, id, file_id, type_name),
		
		Of::NoSubdir { file_id, at, available } => writeln!(out, crate::csi! {
			/fg blue; "[files." /fg yellow; "{:?}" /fg blue; ']'! " in map " /fg yellow; "{:?}"!
			" requested by " /fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			" requires subdirectory " /fg red; "{}"! " but there are only " /fg green; "{}"!
		}, file_id, map_id, id, at, available),
		
		Of::Svg(error) => writeln!(out, crate::csi! {
			"SVG error for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! '\n' /9 F /b; "{}"!
		}, map_id, id, error),
		
		Of::NoPixmap => writeln!(out, crate::csi! {
			"Could not allocate a pixel-map for map " /fg yellow; "{:?}"!
			" requested by " /fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"!
		}, map_id, id),
		
		Of::NoRender => writeln!(out, crate::csi! {
			"SVG generated by map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " was not rendered!"
		}, map_id, id),
		
		Of::Png(error) => writeln!(out, crate::csi! {
			"Failed to encode in PNG to a pixel-map for map " /fg yellow; "{:?}"! " requested by "
			/fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! '\n' /9 F /b; "{}"!
		}, map_id, id, error),
	}
}
