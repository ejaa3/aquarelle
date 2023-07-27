/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::collections::BTreeMap;
use compact_str::CompactString;
use itertools::Itertools;
use serde::{Serialize, Deserialize};
use crate::{cache, map, mapping, namespace, path};

#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum Paths {
	Suggested (bool),
	Include { include: Vec<CompactString> },
	Exclude { exclude: Vec<CompactString> },
	Requests (BTreeMap<CompactString, BTreeMap<CompactString, MapPaths>>)
}

impl Default for Paths {
	fn default() -> Self { Paths::Suggested(false) }
}

pub fn no_suggestions(paths: &Paths) -> bool {
	if let Paths::Suggested(false) = *paths { true } else { false }
}

#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum MapPaths {
	Suggested (()),
	Include { include: Vec<CompactString> },
	Exclude { exclude: Vec<CompactString> },
}

pub fn resolve<'a>(
	 (id, request): (&'a str, &'a map::Request),
	           map: &'a mapping::Map,
	        map_id: &'a str,
	         cache: &'a cache::Cache,
	  default_path: &std::path::PathBuf,
	          name: &str,
	previous_paths: &mut Vec<path::ParsedFrom<'a>>,
) -> Result<mapping::Files<'a>, Error<'a>> {
	let request_paths: Box<dyn Iterator<Item = _>> = match request.paths {
		Paths::Suggested(false) =>
			Box::new(request.custom_paths.iter().map(|path| Ok((None, path)))),
		
		Paths::Suggested(true) => Box::new(
			map.suggested_paths.iter()
				.map(|(id, path)| Ok((Some(id), path)))
				.chain(request.custom_paths.iter().map(|path| Ok((None, path))))
		),
		
		Paths::Include { ref include } => Box::new(
			include.iter().map(
				|include_id| Ok((
					Some(include_id), map.suggested_paths.get(include_id)
						.ok_or(Error::IncludeNotFound { id, map_id, include_id })?
				))
			).chain(request.custom_paths.iter().map(|path| Ok((None, path))))
		),
		
		Paths::Exclude { ref exclude } => Box::new(
			map.suggested_paths.iter()
				.filter_map(|(id, path)| (!exclude.contains(id)).then(|| Ok((Some(id), path))))
				.chain(request.custom_paths.iter().map(|path| Ok((None, path))))
		),
		
		Paths::Requests(ref map) => Box::new(
			map.iter().map(|(namespace_id, map_paths)| {
				let (namespace, bin) = cache.namespace(namespace_id)
					.map_err(|error| Error::Namespace { id, error })?;
				
				Ok(map_paths.iter().map(|(map_id, paths)| {
					let (_, map) = namespace.map(map_id, bin)
						.map_err(|error| Error::Map { id, namespace_id, error })?;
					
					Ok::<Box<dyn Iterator<Item = Result<_, Error>>>, Error>(match paths {
						MapPaths::Suggested(_) =>
							Box::new(map.suggested_paths.iter().map(|(id, path)| Ok((Some(id), path)))),
						
						MapPaths::Include { include } => Box::new(
							include.iter().map(|include_id| Ok((
								Some(include_id), map.suggested_paths.get(include_id)
									.ok_or(Error::PathsIncludeNotFound { id, namespace_id, map_id, include_id })?
							)))
						),
						
						MapPaths::Exclude { exclude } => Box::new(
							map.suggested_paths.iter().filter_map(|(id, path)|
								if exclude.contains(id) { None } else { Some(Ok((Some(id), path))) })
						),
					})
				}).flatten_ok().flatten_ok())
			}).flatten_ok().flatten_ok().chain(request.custom_paths.iter().map(|path| Ok((None, path))))
		)
	};
	
	match map.variant {
		mapping::Type::TextFileEdit => todo!(), // TODO
		
		mapping::Type::TextFile     | mapping::Type::TextFiles     |
		mapping::Type::SvgToPngFile | mapping::Type::SvgToPngFiles |
		mapping::Type::ZipFile      | mapping::Type::ZipFiles      => {
			let mut paths = vec![];
			
			for request_path in request_paths.into_iter() {
				let (suggested_id, located) = request_path?;
				
				/* if let mapping::Type::TextFile  |
				       mapping::Type::SvgToPngFile |
				       mapping::Type::ZipFile      = map.variant
				{ if located.path.is_empty() { Err(Error::EmptyPath { id, map_id, located })? } } */
				
				let get_path = || located.to_path_buf(Some(default_path))
					.ok_or(Error::MissingPath { id, located });
				
				let buf = match map.variant {
					mapping::Type::TextFiles     |
					mapping::Type::SvgToPngFiles |
					mapping::Type::ZipFiles      => {
						let string = format!("{name}{}", map.extension);
						
						path::is_bad(&string)
							.map_err(|error| Error::BadNaming { id, map_id, error })?;
						
						let mut path = get_path()?; path.push(string);
						path
					}
					_ => get_path()?
				};
				
				let suggested_id = suggested_id.map(|id| id as _);
				let path = path::Parsed { suggested_id, located, file: None, buf };
				
				if is_unique_among_maps(path.clone(), previous_paths, id)? {
					paths.push(path.clone());
					previous_paths.push(path::ParsedFrom { id, path });
				}
			}
			
			if paths.is_empty() { None } else { Some(mapping::Files::Single(paths)) }
		}
		
		mapping::Type::Directory   |
		mapping::Type::Directories => {
			if let mapping::Type::Directories = map.variant {
				path::is_bad(&name)
					.map_err(|error| Error::BadNaming { id, map_id, error })?;
			}
			
			let request_paths = request_paths.collect::<Result<Box<_>, _>>()?;
			let mut paths = Vec::with_capacity(request_paths.len());
			let mut no_paths = true;
			
			for (file_id, file) in &map.files {
				let mut file_paths = vec![];
				
				for (suggested_id, located) in request_paths.iter() {
					let mut buf = located.to_path_buf(Some(default_path))
						.ok_or(Error::MissingPath { id, located })?;
					
					if let mapping::Type::Directories = map.variant { buf.push(name); }
					
					let subdir = if file.at > 0 {
						let subdir = map.subdirectories.get(file.at as usize - 1)
							.ok_or(Error::NoSubdirectory {
								id, map_id, file_id, at: file.at, available: map.subdirectories.len()
							})?;
						
						buf.extend([subdir.as_str(), &file.name]);
						subdir
					} else { buf.push(file.name.as_str()); "" };
					
					let suggested_id = suggested_id.map(|id| id as _);
					let file = Some(path::File { file_id, file, subdir });
					let path = path::Parsed { suggested_id, located, file, buf };
					
					if is_unique_among_maps(path.clone(), previous_paths, id)? {
						file_paths.push(path.clone());
						previous_paths.push(path::ParsedFrom { id, path });
					}
				}
				
				no_paths &= file_paths.is_empty();
				
				paths.push(mapping::ParsedFile { file_id, variant: file.variant, file_paths });
			}
			
			if no_paths { None } else { Some(mapping::Files::Several(paths)) }
		}
	}.ok_or(Error::NoPaths { id })
}

fn is_unique_among_maps<'a>(
	          path: path::Parsed<'a>,
	previous_paths: &[path::ParsedFrom<'a>],
	            id: &'a str,
) -> Result<bool, Error<'a>> {
	for previous in previous_paths.iter() {
		macro_rules! conflict { () => {
			return Err(Error::ConflictingPath {
				 current: path::ParsedFrom { id, path },
				previous: previous.clone(),
			})
		}; }
		
		if previous.buf == path.buf {
			if previous.id != id { conflict!() }
			
			match previous.file.as_ref().zip(path.file.as_ref()) {
				None => return Ok(false),
				
				Some((previous, current))
					if previous.file_id == current.file_id => return Ok(false),
				
				Some(_) => conflict!()
			}
		}
		
		let (shorter, longer) =
			if path.buf.as_os_str().len() < previous.buf.as_os_str().len()
				{ (&path.buf, &previous.buf) } else { (&previous.buf, &path.buf) };
		
		for ancestor in longer.ancestors() {
			if shorter.as_path() == ancestor { conflict!() }
		}
	}
	
	Ok(true)
}

pub enum Error<'a> {
     IncludeNotFound { id: &'a str, map_id: &'a str, include_id: &'a str },
           Namespace { id: &'a str, error: Box<cache::Error<'a>> },
                 Map { id: &'a str, namespace_id: &'a str, error: Box<namespace::Error<'a>> },
PathsIncludeNotFound { id: &'a str, namespace_id: &'a str, map_id: &'a str, include_id: &'a str },
//         EmptyPath { id: &'a str, map_id: &'a str, located: &'a path::Located },
         MissingPath { id: &'a str, located: &'a path::Located },
           BadNaming { id: &'a str, map_id: &'a str, error: &'static str },
      NoSubdirectory { id: &'a str, map_id: &'a str, file_id: &'a str, at: u32, available: usize },
             NoPaths { id: &'a str },
     ConflictingPath { previous: path::ParsedFrom<'a>, current: path::ParsedFrom<'a> },
}

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl std::io::Write) -> std::io::Result<i32> {
		match self {
			Self::IncludeNotFound { id, map_id, include_id } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".paths]"! " failed\n"
					"Suggested path " /fg red; "{:?}"! " not found in map " /fg green; "{:?}"!
				}, id, include_id, map_id)?;
				
				Ok(exitcode::CONFIG)
			}
			Self::Namespace { id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".paths]"! " failed"
				}, id)?;
				
				error.show(out)
			}
			Self::Map { id, namespace_id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".paths]"! " failed"
				}, id)?;
				
				error.show(out, namespace_id)
			}
			Self::PathsIncludeNotFound { id, namespace_id, map_id, include_id } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".paths]"! " failed\n"
					"Suggested path " /fg red; "{:?}"! " not found in map " /fg green; "{:?}"!
					" at namespace " /fg green; "{:?}"!
				}, id, include_id, map_id, namespace_id)?;
				
				Ok(exitcode::CONFIG)
			}
			Self::MissingPath { id, located } => {
				write!(out, crate::csi! {
					"Unable to parse " /fg blue; "[[maps." /fg yellow; "{:?}" /fg blue; ".custom-paths]]"!
					" with value "
				}, id)?;
				
				path::show_located(out, &located)?; writeln!(out)?;
				
				Ok(exitcode::SOFTWARE)
			}
			Self::NoPaths { id } => {
				writeln!(out, crate::csi! {
					"No paths were provided for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'!
				}, id)?;
				
				Ok(exitcode::CONFIG)
			}
			/* Self::EmptyPath { id, map_id, located } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'! " failed\n"
					"The path " /fg blue; "{{ {} = " /fg yellow; "''" /fg blue; " }}"!
					" has been provided or suggested to the map " /fg yellow; "{:?}"!
					" which is not of a plural type, so its path cannot be just the location"
				}, map_id, <&str>::from(located.location), id)?;
				
				Ok(exitcode::CONFIG)
			} */
			Self::NoSubdirectory { id, map_id, file_id, at, available } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg green; "{:?}" /fg blue; "]"! " failed\n"
					/fg blue; "[files." /fg yellow; "{:?}" /fg blue; ']'! " in map " /fg yellow; "{:?}"!
					" requires subdirectory " /fg red; "{}"! " but there are only " /fg green; "{}"!
				}, file_id, map_id, id, at, available)?;
				
				Ok(exitcode::DATAERR)
			}
			Self::BadNaming { id, map_id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'! "failed\n"
					"Bad " /fg blue; "naming"! " found for plural type map " /fg yellow; "{:?}"! "\n{}"
				}, map_id, id, error)?;
				
				Ok(exitcode::DATAERR)
			}
			Self::ConflictingPath { previous, current } => {
				writeln!(out, "There are conflicting paths\n")?;
				
				show_conflict(out, previous, " first")?;
				show_conflict(out,  current, "second")?;
				
				Ok(exitcode::DATAERR)
			}
		}
	}
}

#[cfg(feature = "cli")]
fn show_conflict(out: &mut impl std::io::Write, parsed: path::ParsedFrom, pos: &str) -> std::io::Result<()> {
	write!(out, crate::csi! {
		"\t{} cause: " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; "]"! "\n\t     at path: "
	}, pos, parsed.id)?;
	
	path::show_located(out, parsed.path.located)?;
	
	if let Some(id) = parsed.suggested_id {
		write!(out, crate::csi!(" suggested as " /fg yellow; "{:?}"!), id)?;
	}
	
	if let Some(ref file) = parsed.file {
		write!(out, crate::csi! {
			"\n\t     at file: " /fg yellow; "{:?}"! " as " /fg yellow; "{:?}"! " + " /fg yellow; "{:?}"!
		}, file.file_id, file.subdir, file.file.name)?
	}
	
	writeln!(out, crate::csi!("\n\t      result: " /fg cyan; "{}"! '\n'), parsed.buf.to_string_lossy())
}
