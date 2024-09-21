/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, collections::BTreeMap, io::Write, path, rc::Rc, result};
use annotate_snippets::{Level, Message, Snippet};
use compact_str::CompactString;
use serde::{Deserialize, Serialize};
use crate::{arrangement, map, path::Location, scheme, script, Key, Spanned, Value};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct Map {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(rename = "type")]
	pub(crate) variant: Type,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	pub(crate) display: Option<Spanned>,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	pub(crate) nomenclature: Option<Spanned>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) schemes: BTreeMap<Key, Scheme>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) options: BTreeMap<Spanned, crate::Optional>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) suggested_paths: BTreeMap<CompactString, Spanned<Location>>,
	
	#[serde(default, skip_serializing_if = "FileType::is_default")]
	pub(crate) default_file_type: FileType,
	
	#[serde(default, skip_serializing_if = "<[_]>::is_empty")]
	pub(crate) subdirectories: Vec<Spanned>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) files: BTreeMap<Key, File>,
	
	script: crate::Script,
	
	#[serde(skip)]
	pub(crate) source: std::cell::OnceCell<crate::Src>,
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
	pub(crate) fallback: Option<Spanned>,
}

#[derive(Serialize, Deserialize)]
pub struct File {
	#[serde(default, skip_serializing_if = "Option::is_none", rename = "type")]
	pub variant: Option<FileType>,
	
	#[serde(default = "zero", skip_serializing_if = "is_zero")]
	pub at: Spanned<u32>,
	
	pub name: Spanned,
}

fn zero() -> Spanned<u32> { Spanned::new(0..0, 0) }
fn is_zero(number: &Spanned<u32>) -> bool { *number.get_ref() == 0 }

#[derive(Default, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum FileType { #[default] Text, TextEdit, SvgToPng }

impl FileType { fn is_default(&self) -> bool { *self == Self::Text } }

#[allow(private_interfaces)]
pub enum Files<'c> {
	Single  (Vec<Rc<path::PathBuf>>),
	Several (Vec<ParsedFile<'c>>),
}

pub(crate) struct ParsedFile<'c> {
	pub(crate) file_id: &'c Spanned,
	pub(crate) variant: FileType,
	pub(crate)   paths: Vec<Rc<path::PathBuf>>,
}

#[allow(private_interfaces)]
pub struct Ready<'a> {
	pub     map: &'a Map,
	pub     src: &'a crate::Src,
	pub      id: &'a Spanned,
	pub  map_id: &'a Spanned,
	pub options: BTreeMap<CompactString, Value>,
	pub display: rhai::ImmutableString,
	pub    name: rhai::ImmutableString,
	pub schemes: Rc<BTreeMap<CompactString, Rc<scheme::Data>>>,
	pub  safety: &'a arrangement::EngineSafety,
	pub   paths: Option<Files<'a>>,
	pub replica: (map::Replica, arrangement::Replica),
}

impl<'a> Ready<'a> {
	pub fn perform(self) -> Result<'a> { perform(self) }
}

fn perform(Ready {
	map, src, id, map_id, options, display, name, schemes, safety, paths, replica
}: Ready) -> Result {
	let prefix = map.source.get().unwrap().1.parent().unwrap();
	let mut script_path = None;
	let map_src = map.source.get().unwrap();
	
	let (script, path, code): (_, &str, Cow<str>) = match &map.script {
		crate::Script::Path(script) => {
			(script, script.get_ref(), Cow::Owned(std::fs::read_to_string(script_path
				.get_or_insert(prefix.join(script.get_ref() as &str)))
				.map_err(|error| Error { src, id, map_src, of: Of::ScriptIo { script, error } })?))
		}
		crate::Script::Embedded(script) => (script, "", Cow::Borrowed(script.get_ref())),
	};
	
	let slice = if code.starts_with("#!") {
		&code[code.find('\n').unwrap_or(0)..]
	} else { &code };
	
	let mut cfg_module = script::cfg_module(map_id.get_ref(), options);
	cfg_module
		.set_var("display", display)
		.set_var("name", name)
		
		.set_native_fn("scheme", move |context: rhai::NativeCallContext, index: &str|
			match schemes.get(index) {
				Some(scheme) => Ok(Rc::clone(scheme)),
				None => rhai::EvalAltResult::ErrorIndexNotFound(index.into(), context.position()).into()
			}
		);
	
	let mut engine = script::engine(script_path.as_deref()
		.and_then(path::Path::parent).unwrap_or(prefix));
	
	safety.set(engine
		.set_optimization_level(rhai::OptimizationLevel::None)
		.register_global_module(script::MAP_MODULE.with(Rc::clone))
		.register_static_module("cfg", Rc::new(cfg_module)));
	
	let (mut scope, ast) = (rhai::Scope::new(), match engine.compile(slice) {
		Ok(ast) => ast, Err(error) => return Err(Error {
			src, id, map_src, of: Of::Rhai { script, path, code, error: error.into() }
		})
	});
	
	for (name, _, value) in ast.iter_literal_variables(true, false) { scope.push_constant(name, value); }
	engine.set_optimization_level(rhai::OptimizationLevel::Full);
	let ast = engine.optimize_ast(&scope, ast, engine.optimization_level());
	
	let Some(paths) = paths else {
		return Ok(Some(engine.eval_ast(&ast).map_err(|error| Error {
			src, id, map_src, of: Of::Rhai { script, path, code, error }
		})?))
	};
	
	if let Files::Single(paths) = paths {
		if let Type::ZipFile = map.variant {
			let mut zip = zip::ZipWriter::new(std::io::Cursor::new(vec![]));
			
			for subdir in &map.subdirectories {
				let split: Vec<_> = subdir.get_ref().split(['/', '\\']).collect();
				if let None | Some(&"") = split.first() { continue }
				
				for i in 1..split.len() {
					let value = &split[0..i];
					let mut string = String::with_capacity(
						value.iter().fold(0, |acc, str| acc + str.len() + 1)
					);
					
					for str in value.iter() { string.extend([str, "/"]) }
					
					zip.add_directory::<_, ()>(string, Default::default())
						.map_err(|error| Error { src, id, map_src, of: Of::ZipDir { subdir, error } })?
				}
			}
			
			let rmap: rhai::Map = engine.eval_ast(&ast)
				.map_err(|error| Error { src, id, map_src, of: Of::Rhai { script, path, code, error } })?;
			
			for (file_id, file) in map.files.iter() {
				let value = rmap.get(file_id.get_ref() as &str)
					.ok_or(Error { src, id, map_src, of: Of::MissingFile { script, file_id } })?;
				
				let content = value.clone().into_immutable_string()
					.map_err(|type_name| Error { src, id, map_src, of: Of::InvalidType { script, file_id, type_name } })?;
				
				let png = if let FileType::SvgToPng = file.variant.unwrap_or(map.default_file_type) {
					Some(svg_to_png(content.as_bytes(), src, id, map_src, Some(file_id))?)
				} else { None };
				
				let content = png.as_deref().unwrap_or(content.as_bytes());
				
				let subdir = if *file.at.get_ref() > 0 {
					map.subdirectories.get(*file.at.get_ref() as usize - 1)
						.ok_or(Error { src, id, map_src, of: Of::NoSubdir {
							file_id, at: &file.at, available: map.subdirectories.len()
						} })?.get_ref()
				} else { "" };
				
				// NOTE https://pkware.cachefly.net/webdocs/casestudies/APPNOTE.TXT (4.4.17)
				let no_slash = subdir.is_empty() || subdir.ends_with('/');
				let name = String::from_iter([subdir, if no_slash {""} else {"/"}, file.name.get_ref()]);
				
				zip.start_file::<_, ()>(name, Default::default())
					.map_err(|error| Error { src, id, map_src, of: Of::ZipFile { file_id, error } })?;
				
				zip.write_all(content)
					.map_err(|error| Error { src, id, map_src, of: Of::ZipIo { file_id, error } })?;
			}
			
			write(paths, replica, &zip.finish()
				.map_err(|error| Error { src, id, map_src, of: Of::Zip(error) })?.into_inner(), src, id, map_src, None)?
		} else {
			let content: rhai::ImmutableString = engine.eval_ast(&ast)
				.map_err(|error| Error { src, id, map_src, of: Of::Rhai { script, path, code, error } })?;
			
			let png = if let Type::SvgToPngFile = map.variant {
				Some(svg_to_png(content.as_bytes(), src, id, map_src, None)?)
			} else { None };
			
			let content = png.as_deref().unwrap_or(content.as_bytes());
			write(paths, replica, content, src, id, map_src, None)?
		}
	} else if let Files::Several(paths) = paths {
		let map: rhai::Map = engine.eval_ast(&ast)
			.map_err(|error| Error { src, id, map_src, of: Of::Rhai { script, path, code, error } })?;
		
		for ParsedFile { file_id, variant, paths } in paths {
			let value = map.get(file_id.get_ref() as &str)
				.ok_or(Error { src, id, map_src, of: Of::MissingFile { script, file_id } })?;
			
			let content = value.clone().into_immutable_string()
				.map_err(|type_name| Error { src, id, map_src, of: Of::InvalidType { script, file_id, type_name } })?;
			
			let png = if let FileType::SvgToPng = variant {
				Some(svg_to_png(content.as_bytes(), src, id, map_src, Some(file_id))?)
			} else { None };
			
			let content = png.as_deref().unwrap_or(content.as_bytes());
			write(paths, replica, content, src, id, map_src, Some(file_id))?
		}
	} Ok(None)
}

fn write<'a>(
	file_paths: Vec<Rc<path::PathBuf>>,
	   replica: (map::Replica, arrangement::Replica),
	   content: &[u8],
	       src: &'a crate::Src,
	        id: &'a Spanned,
	   map_src: &'a crate::Src,
	   file_id: Option<&'a Spanned>,
) -> result::Result<(), Error<'a>> {
	let mut written_path: Option<Rc<path::PathBuf>> = None;
	
	for path in file_paths {
		if let Some(parent) = path.parent() {
			if let Err(error) = std::fs::create_dir_all(parent)
				{ return Err(Error { src, id, map_src, of: Of::Io { file_id, path, error } }) }
		}
		
		if let Some(written_path) = &written_path {
			if let Err(error) = std::fs::remove_file(path.as_path()) {
				if error.kind() != std::io::ErrorKind::NotFound {
					return Err(Error { src, id, map_src, of: Of::Io { file_id, path, error } })
				}
			}
			
			macro_rules! policy (($policy:ident) => {
				(map::Replica::Arrangement, arrangement::Replica::$policy) |
				(map::Replica::$policy    , _)
			});
			
			match replica {
				policy!(HardLink) => {
					std::fs::hard_link(written_path.as_path(), path.as_path())
				}
				policy!(SymbolicLink) => {
					#[cfg(unix)]
					std::os::unix::fs::symlink(written_path.as_path(), path.as_path())
				}
				policy!(Copy) => {
					std::fs::copy(written_path.as_path(), path.as_path()).map(|_| ())
				}
			}.map_err(|error| Error { src, id, map_src, of: Of::Io { file_id, path, error } })?
		} else {
			if let Err(error) = std::fs::File::create(path.as_path()).map(|mut file| file.write_all(content))
				{ return Err(Error { src, id, map_src, of: Of::Io { file_id, path, error } }) }
			written_path = Some(path);
		}
	} Ok(())
}

// WATCH https://github.com/RazrFalcon/resvg/blob/master/crates/resvg/examples/minimal.rs
fn svg_to_png<'a>(
	svg: &[u8], src: &'a crate::Src, id: &'a Spanned, map_src: &'a crate::Src, file_id: Option<&'a Spanned>
) -> result::Result<Vec<u8>, Error<'a>> {
	let mut options = resvg::usvg::Options::default();
	options.fontdb_mut().load_system_fonts();
	
	let tree = resvg::usvg::Tree::from_data(svg, &options)
		.map_err(|error| Error { src, id, map_src, of: Of::Svg { file_id, error } })?;
	
	let size = tree.size().to_int_size();
	
	let mut pixmap = resvg::tiny_skia::Pixmap::new(size.width(), size.height())
		.ok_or(Error { src, id, map_src, of: Of::NoPixmap { file_id } })?;
	
	resvg::render(&tree, resvg::usvg::Transform::default(), &mut pixmap.as_mut());
	
	pixmap.encode_png().map_err(|error| Error { src, id, map_src, of: Of::Png { file_id, error } })
}

pub type Result<'a> = result::Result<Option<rhai::ImmutableString>, Error<'a>>;

pub struct Error<'a> {
	pub     src: &'a crate::Src,
	pub      id: &'a Spanned,
	pub map_src: &'a crate::Src,
	pub      of: Of<'a>,
}

pub enum Of<'a> {
     ZipDir { subdir: &'a Spanned, error: zip::result::ZipError },
    ZipFile { file_id: &'a Spanned, error: zip::result::ZipError },
      ZipIo { file_id: &'a Spanned, error: std::io::Error },
        Zip (zip::result::ZipError),
   ScriptIo { script: &'a Spanned, error: std::io::Error },
       Rhai { script: &'a Spanned, code: Cow<'a, str>, path: &'a str, error: Box<rhai::EvalAltResult> },
MissingFile { script: &'a Spanned, file_id: &'a Spanned },
InvalidType { script: &'a Spanned, file_id: &'a Spanned, type_name: &'static str },
   NoSubdir { file_id: &'a Spanned, at: &'a Spanned<u32>, available: usize },
        Svg { file_id: Option<&'a Spanned>, error: resvg::usvg::Error },
   NoPixmap { file_id: Option<&'a Spanned> },
        Png { file_id: Option<&'a Spanned>, error: png::EncodingError },
         Io { file_id: Option<&'a Spanned>, path: Rc<path::PathBuf>, error: std::io::Error },
}

impl<'a, 'b> crate::Msg<'a, 'b, 4> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2, cow_3]: [&'b mut Cow<'a, str>; 4]) -> Message<'b> {
		let Error { src, id, map_src, of } = self;
		
		*cow_0 =     src.1.to_string_lossy();
		*cow_1 = map_src.1.to_string_lossy();
		
		match of {
			Of::ZipDir { subdir, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("zip error")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(subdir.span()).label("at this subdirectory")))
					.footer(Level::Error.title(cow_2))
			}
			Of::ZipFile { file_id, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("zip error")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(file_id.span()).label("at this file")))
					.footer(Level::Error.title(cow_2))
			}
			Of::ZipIo { file_id, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("unable to write zip")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(file_id.span()).label("at this file")))
					.footer(Level::Error.title(cow_2))
			}
			Of::Zip(error) => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("zip error")
					.footer(Level::Info.title(cow_1))
					.footer(Level::Error.title(cow_2))
			}
			Of::ScriptIo { script, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("unable to read script")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(script.span()).label("this script")))
					.footer(Level::Error.title(cow_2))
			}
			Of::Rhai { script, code, path, error } => {
				let level = if error.position().is_none() { Level::Error } else { Level::Warning };
				*cow_3 = code;
				script::error_msg(error, cow_2, cow_3, (path, cow_1), &map_src.0, script)
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(level.span(script.span()).label("when evaluating this script")))
			}
			Of::MissingFile { script, file_id } => {
				Level::Error.title("missing file content")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(file_id.span()).label("this file is specified"))
						.annotation(Level::Error.span(script.span()).label("this script does not specify it")))
			}
			Of::InvalidType { script, file_id, type_name } => {
				Level::Error.title("invalid type")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(file_id.span()).label("this file requires a string"))
						.annotation(Level::Error.span(script.span()).label("this script gives the file another info")))
					.footer(Level::Info.title(type_name))
			}
			Of::NoSubdir { file_id, at, available } => {
				*cow_2 = Cow::Owned(format!("this index is greater than {available}"));
				Level::Error.title("directory index out of bounds")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(file_id.span()).label("in this file"))
						.annotation(Level::Error.span(at.span()).label(cow_2)))
			}
			Of::Svg { file_id: Some(file_id), error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("svg error")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(file_id.span()).label("at this file")))
					.footer(Level::Error.title(cow_2))
			}
			Of::Svg { file_id: None, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("svg error")
					.footer(Level::Info.title(cow_1))
					.footer(Level::Error.title(cow_2))
			}
			Of::NoPixmap { file_id: Some(file_id) } => {
				Level::Warning.title("failed to allocate a pixel-map")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(file_id.span()).label("for this file")))
			}
			Of::NoPixmap { file_id: None } => {
				Level::Warning.title("failed to allocate a pixel-map")
					.footer(Level::Info.title(cow_1))
			}
			Of::Png { file_id: Some(file_id), error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("failed to encode in PNG to a pixel-map")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(file_id.span()).label("for this file")))
					.footer(Level::Error.title(cow_2))
			}
			Of::Png { file_id: None, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				Level::Warning.title("failed to encode in PNG to a pixel-map")
					.footer(Level::Info.title(cow_1))
					.footer(Level::Error.title(cow_2))
			}
			Of::Io { file_id: Some(file_id), path, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				*cow_3 = Rc::into_inner(path).map(|path| Cow::Owned(path.into_os_string()
					.into_string().unwrap_or_else(|oss| oss.to_string_lossy().into_owned())
				)).unwrap_or(Cow::Borrowed("missing path (bug)"));
				
				Level::Warning.title("input/output error on the info path")
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(file_id.span()).label("at this file")))
					.footer(Level::Info.title(cow_3))
					.footer(Level::Error.title(cow_2))
			}
			Of::Io { file_id: None, path, error } => {
				*cow_2 = Cow::Owned(error.to_string());
				*cow_3 = Rc::into_inner(path).map(|path| Cow::Owned(path.into_os_string()
					.into_string().unwrap_or_else(|oss| oss.to_string_lossy().into_owned())
				)).unwrap_or(Cow::Borrowed("missing path (bug)"));
				
				Level::Warning.title("input/output error on the second info path")
					.footer(Level::Info.title(cow_1))
					.footer(Level::Info.title(cow_3))
					.footer(Level::Error.title(cow_2))
			}
		}.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
			.annotation(Level::Warning.span(id.span()).label("at this map request")))
	}
}
