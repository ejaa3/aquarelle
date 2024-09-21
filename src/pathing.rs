/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, collections::{BTreeMap, BTreeSet}, rc::Rc};
use annotate_snippets::{Level, Message, Snippet};
use itertools::Itertools;
use serde::{Serialize, Deserialize};
use crate::{cache, map, mapping, namespace, path, Src, Key, Spanned};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Paths {
	Include (Vec<Spanned>),
	Exclude (BTreeSet<Key>),
	In (BTreeMap<Key, MapPaths>),
	At (BTreeMap<Key, BTreeMap<Key, MapPaths>>),
}

impl Default for Paths { fn default() -> Self { Paths::Include(Vec::new()) } }

pub(crate) fn includes_nothing(paths: &Paths) -> bool {
	if let Paths::Include(vec) = paths { vec.is_empty() } else { false }
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum MapPaths { Include (Vec<Spanned>), Exclude (BTreeSet<Key>) }

pub(crate) struct Exam<'a, 'b> {
	pub(crate)             id: &'a Spanned,
	pub(crate)            map: &'a map::Map,
	pub(crate)            src: &'a Src,
	pub(crate)        mapping: &'a mapping::Map,
	pub(crate)      namespace: &'a namespace::Namespace,
	pub(crate)            bin: &'a cache::Bin,
	pub(crate)          cache: &'a cache::Cache,
	pub(crate)   default_path: &'b std::path::PathBuf,
	pub(crate)           name: &'b str,
	pub(crate) previous_paths: &'b mut Vec<path::Parsed<'a>>,
}

impl<'a> Exam<'a, '_> {
	pub(crate) fn examine(self) -> Result<mapping::Files<'a>, Error<'a>>
	{ examine(self) }
}

fn examine<'a>(Exam {
	id, map, src, mapping, namespace, bin, cache, default_path, name, previous_paths
}: Exam<'a, '_>) -> Result<mapping::Files<'a>, Error<'a>> {
	let map_src = mapping.source.get().unwrap();
	
	let get_map_paths = |paths: &'a _, map: &'a mapping::Map| {
		let map_src = map.source.get().unwrap();
		
		Ok::<Box<dyn Iterator<Item = Result<_, Error>>>, Error>(match paths {
			MapPaths::Include(include) => Box::new(
				include.iter().map(move |suggested| Ok((
					map_src, map.suggested_paths.get(suggested.get_ref())
						.ok_or(Error::SuggestedNotFound { src, id, suggested })?
				)))
			),
			
			MapPaths::Exclude(exclude) if exclude.is_empty() => Box::new(
				map.suggested_paths.values().map(move |path| Ok((map_src, path)))
			),
			
			MapPaths::Exclude(exclude) => {
				for suggested in exclude {
					if !map.suggested_paths.contains_key(suggested.get_ref()) {
						Err(Error::SuggestedNotFound { src, id, suggested })?
					}
				}
				Box::new(map.suggested_paths.iter().filter_map(move |(id, path)|
					(!exclude.contains(id as &str)).then_some(Ok((map_src, path)))))
			}
		})
	};
	
	let request_paths: Box<dyn Iterator<Item = _>> = match map.paths {
		Paths::Include(ref include) if include.is_empty() => Box::new(
			map.custom_paths.iter().map(|path| Ok((src, path)))
		),
		
		Paths::Exclude(ref exclude) if exclude.is_empty() => Box::new(
			mapping.suggested_paths.values().map(|path| Ok((map_src, path)))
				.chain(map.custom_paths.iter().map(|path| Ok((src, path))))
		),
		
		Paths::Include(ref include) => Box::new(
			include.iter().map(|suggested| Ok((
				map_src, mapping.suggested_paths.get(suggested.get_ref())
					.ok_or(Error::SuggestedNotFound { src, id, suggested })?
			))).chain(map.custom_paths.iter().map(|path| Ok((src, path))))
		),
		
		Paths::Exclude(ref exclude) => {
			for suggested in exclude {
				if !mapping.suggested_paths.contains_key(suggested.get_ref()) {
					Err(Error::SuggestedNotFound { src, id, suggested })?
				}
			}
			Box::new(mapping.suggested_paths.iter()
				.filter(|(id, _)| !exclude.contains(id as &str))
				.map(|(_, path)| Ok((map_src, path)))
				.chain(map.custom_paths.iter().map(|path| Ok((src, path)))))
		}
		
		Paths::In(ref map_paths) => Box::new(
			map_paths.iter().map(|(map_id, paths)|
				get_map_paths(paths, namespace.map(map_id.get_ref(), bin)
					.map_err(|error| Error::MainNamespace { src, id, map_id, error })?.1)
			).flatten_ok().flatten_ok()
		),
		
		Paths::At(ref namespaces) => Box::new(
			namespaces.iter().map(|(namespace_id, map_paths)| {
				let (namespace, bin) = cache.namespace(namespace_id.get_ref())
					.map_err(|error| Error::Cache { src, id, namespace_id, error })?;
				
				Ok(map_paths.iter().map(|(map_id, paths)|
					get_map_paths(paths, namespace.map(map_id.get_ref(), bin)
						.map_err(|error| Error::Namespace { src, id, namespace_id, map_id, error })?.1)
				).flatten_ok().flatten_ok())
			}).flatten_ok().flatten_ok().chain(map.custom_paths.iter().map(|path| Ok((src, path))))
		)
	};
	
	match mapping.variant {
		mapping::Type::EditTextFile => todo!(), // TODO
		
		mapping::Type::TextFile | mapping::Type::SvgToPngFile | mapping::Type::ZipFile => {
			let mut paths = vec![];
			
			for request_path in request_paths.into_iter() {
				let (source, location) = request_path?;
				
				let get_path = || location.get_ref().to_path_buf(Some(default_path))
					.ok_or(Error::MissingPath { src, id, source, location });
				
				let buf = if name.is_empty() { get_path()? } else {
					let mut path = get_path()?; path.push(name); path
				};
				
				let path = path::Parsed {
					id, source, location, map_src, file_name: None, buf: Rc::from(buf)
				};
				
				if is_unique_among_maps(previous_paths, &path, src)? {
					paths.push(Rc::clone(&path.buf));
					previous_paths.push(path);
				}
			}
			if paths.is_empty() { None } else { Some(mapping::Files::Single(paths)) }
		}
		
		mapping::Type::Directory => {
			let request_paths = request_paths.collect::<Result<Box<_>, _>>()?;
			let mut paths = Vec::with_capacity(request_paths.len());
			let mut no_paths = true;
			
			for (file_id, file) in &mapping.files {
				let mut file_paths = vec![];
				
				for (source, location) in request_paths.iter() {
					let mut buf = location.get_ref().to_path_buf(Some(default_path))
						.ok_or(Error::MissingPath { src, id, source, location })?;
					
					if !name.is_empty() { buf.push(name); }
					
					if *file.at.get_ref() > 0 {
						buf.push(mapping.subdirectories.get(*file.at.get_ref() as usize - 1)
							.ok_or(Error::NoSubdirectory {
								src, id, map_src, file_id, at: &file.at,
								available: mapping.subdirectories.len()
							})?.get_ref() as &str);
					};
					
					buf.push(path::check_name(file.name.get_ref() as &str,
						Error::BadName { src, id, map_src, file_id, name: &file.name })?);
					
					let path = path::Parsed {
						id, source, location, map_src, file_name: Some(&file.name), buf: Rc::from(buf)
					};
					
					if is_unique_among_maps(previous_paths, &path, src)? {
						file_paths.push(Rc::clone(&path.buf));
						previous_paths.push(path);
					}
				}
				
				no_paths &= file_paths.is_empty();
				
				paths.push(mapping::ParsedFile {
					file_id, variant: file.variant.unwrap_or(mapping.default_file_type), paths: file_paths
				});
			}
			
			if no_paths { None } else { Some(mapping::Files::Several(paths)) }
		}
	}.ok_or_else(|| Error::NoPaths { src, id })
}

fn is_unique_among_maps<'a>(
	previous_paths: &[path::Parsed<'a>], path: &path::Parsed<'a>, src: &'a Src
) -> Result<bool, Error<'a>> {
	for previous in previous_paths.iter() {
		macro_rules! conflict (() => (return Err(Error::ConflictingPath {
			src, previous: Box::new(previous.clone()), path: Box::new(path.clone())
		} )));
		
		if previous.buf == path.buf { conflict!() }
		
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
SuggestedNotFound { src: &'a Src, id: &'a Spanned, suggested: &'a Spanned },
            Cache { src: &'a Src, id: &'a Spanned, namespace_id: &'a Spanned, error: cache::Error<'a> },
    MainNamespace { src: &'a Src, id: &'a Spanned, map_id: &'a Spanned, error: Box<namespace::Error<'a>> },
        Namespace { src: &'a Src, id: &'a Spanned, namespace_id: &'a Spanned, map_id: &'a Spanned, error: Box<namespace::Error<'a>> },
      MissingPath { src: &'a Src, id: &'a Spanned, source: &'a Src, location: &'a Spanned<path::Location> },
   NoSubdirectory { src: &'a Src, id: &'a Spanned, map_src: &'a Src, file_id: &'a Spanned, at: &'a Spanned<u32>, available: usize },
          BadName { src: &'a Src, id: &'a Spanned, map_src: &'a Src, file_id: &'a Spanned, name: &'a Spanned },
          NoPaths { src: &'a Src, id: &'a Spanned },
  ConflictingPath { src: &'a Src, previous: Box<path::Parsed<'a>>, path: Box<path::Parsed<'a>> },
}

impl<'a, 'b> crate::Msg<'a, 'b, 6> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2, cow_3, cow_4, cow_5]: [&'b mut Cow<'a, str>; 6]) -> Message<'b> {
		match self {
			Self::SuggestedNotFound { src, id, suggested } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Error.title("suggested path not found")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(suggested.span()).label("this suggested path"))
						.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::Cache { src, id, namespace_id, error } => {
				let level = if matches!(error, cache::Error::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(namespace_id.span()).label("this requested namespace"))
					.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::MainNamespace { src, id, map_id, error } => {
				let level = if matches!(error.1, namespace::Of::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(map_id.span()).label("this requested map"))
					.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::Namespace { src, id, namespace_id, map_id, error } => {
				let level = if matches!(error.1, namespace::Of::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(map_id.span()).label("this requested map"))
					.annotation(Level::Warning.span(namespace_id.span()).label("in this namespace"))
					.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::MissingPath { src, id, source, location } => {
				*cow_0 = source.1.to_string_lossy();
				*cow_1 = src.1.to_string_lossy();
				
				Level::Error.title("unable to parse path")
					.snippet(Snippet::source(&source.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(location.span()).label("this path")))
					.snippet(Snippet::source(&src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::NoSubdirectory { src, id, map_src, file_id, at, available } => {
				*cow_0 = map_src.1.to_string_lossy();
				*cow_1 = Cow::Owned(format!("this index is greater than {available}"));
				*cow_2 = src.1.to_string_lossy();
				
				Level::Error.title("directory index out of bounds")
					.snippet(Snippet::source(&map_src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(at.span()).label(cow_1))
						.annotation(Level::Warning.span(file_id.span()).label("in this file")))
					.snippet(Snippet::source(&src.0).origin(cow_2).fold(true)
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::NoPaths { src, id } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Error.title("no paths were provided for a map")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(id.span()).label("in this map request")))
			}
			Self::BadName { src, id, map_src, file_id, name } => {
				*cow_0 = map_src.1.to_string_lossy();
				*cow_1 = src.1.to_string_lossy();
				
				Level::Error.title(path::BAD_NAME)
					.snippet(Snippet::source(&map_src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(name.span()).label("this file name"))
						.annotation(Level::Warning.span(file_id.span()).label("in this file")))
					.snippet(Snippet::source(&src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::ConflictingPath { src, previous, path } => {
				*cow_0 = previous. source.1.to_string_lossy();
				*cow_1 = previous.map_src.1.to_string_lossy();
				*cow_2 =     path. source.1.to_string_lossy();
				*cow_3 =     path.map_src.1.to_string_lossy();
				*cow_4 =              src.1.to_string_lossy();
				*cow_5 = Cow::Owned(format!("using the same path {}", if previous.file_name
					.is_some() { &previous.buf } else { &path.buf }.to_string_lossy()));
				
				let mut msg = Level::Error.title(cow_5)
					.snippet(Snippet::source(&previous.source.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(previous.location.span()).label("this path")));
				
				if let Some(name) = previous.file_name {
					msg = msg.snippet(Snippet::source(&previous.map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(name.span()).label("with this file")))
				};
				
				msg = msg.snippet(Snippet::source(&path.source.0).origin(cow_2).fold(true)
					.annotation(Level::Warning.span(path.location.span()).label("this path")));
				
				if let Some(name) = path.file_name {
					msg = msg.snippet(Snippet::source(&path.map_src.0).origin(cow_3).fold(true)
						.annotation(Level::Warning.span(name.span()).label("with this file")))
				};
				
				let mut snippet = Snippet::source(&src.0).origin(cow_4).fold(true)
					.annotation(Level::Error.span(previous.id.span()).label("at this map request"));
				
				if previous.id != path.id {
					snippet = snippet.annotation(Level::Error.span(path.id.span()).label("and this map request"));
				}
				
				msg.snippet(snippet)
			}
		}
	}
}
