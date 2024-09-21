/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, collections::BTreeMap, rc::Rc};
use annotate_snippets::{Level, Message, Snippet};
use compact_str::CompactString;
use serde::{Serialize, Deserialize, Serializer, Deserializer, ser, de};
use crate::{cache, mapping, map, namespace, path, theme, scheme, Src, Key, Spanned, Value};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct Arrangement {
	pub name: rhai::ImmutableString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub(crate) about: CompactString,
	
	pub(crate) replica: Replica,
	default_path: Spanned<DefaultPath>,
	
	#[serde(default, skip_serializing_if = "EngineSafety::is_default", rename = "engine")]
	pub(crate) safety: EngineSafety,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) presets: BTreeMap<CompactString, Value>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) schemes: BTreeMap<Key, BTreeMap<Key, Request>>,
	
	pub(crate) maps: BTreeMap<Key, map::Map>,
	
	#[serde(skip)]
	pub(crate) source: OnceCell<crate::Src>,
}

#[derive(Clone, Copy, Default, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Replica { HardLink, SymbolicLink, #[default] Copy }

struct DefaultPath(path::Location);

impl std::ops::Deref for DefaultPath {
	type Target = path::Location;
	fn deref(&self) -> &path::Location { &self.0 }
}

impl Serialize for DefaultPath {
	fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		if let path::Prefix::Default = self.0.prefix {
			Err(ser::Error::custom("cannot be `Prefix::Default`"))
		} else { self.0.serialize(serializer) }
	}
}

impl<'de> Deserialize<'de> for DefaultPath {
	fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		let location = path::Location::deserialize(deserializer)?;
		
		if let path::Prefix::Default = location.prefix {
			Err(de::Error::custom("cannot be `default`"))
		} else { Ok(Self(location)) }
	}
}

#[derive(Default, PartialEq, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct EngineSafety {
	max_array_size : Option<usize>,
	max_call_levels: Option<usize>,
	max_expr_depths: Option<MaxExprDepths>,
	max_map_size   : Option<usize>,
	max_modules    : Option<usize>,
	max_operations : Option<u64>,
	max_string_size: Option<usize>,
}

#[derive(Clone, Copy, PartialEq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct MaxExprDepths { global: usize, function: usize }

impl EngineSafety {
	pub(crate) fn is_default(&self) -> bool { self == &EngineSafety::default() }
	
	pub(crate) fn set(&self, engine: &mut rhai::Engine) {
		if let Some(value) = self.max_array_size  { engine.set_max_array_size (value); }
		if let Some(value) = self.max_call_levels { engine.set_max_call_levels(value); }
		if let Some(value) = self.max_expr_depths { engine.set_max_expr_depths(value.global, value.function); }
		if let Some(value) = self.max_map_size    { engine.set_max_map_size   (value); }
		if let Some(value) = self.max_modules     { engine.set_max_modules    (value); }
		if let Some(value) = self.max_operations  { engine.set_max_operations (value); }
		if let Some(value) = self.max_string_size { engine.set_max_string_size(value); }
	}
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
	#[serde(default, rename = "theme")]
	theme_id: Option<Spanned>,
	
	#[serde(rename = "scheme")]
	scheme_id: Spanned,
	
	#[serde(default, rename = "from")]
	namespace_id: Option<Spanned>,
}

pub fn arrange<'a>(
	            cache: &'a cache::Cache,
	main_namespace_id: &'a str,
	   arrangement_id: rhai::ImmutableString,
	       schemes_id: &'a str,
	           map_id: Option<&'a str>,
) -> Result<Vec<mapping::Ready<'a>>, Error<'a>> {
	let (namespace, bin) = cache.namespace(main_namespace_id).map_err(Error::Cache)?;
	let arrangement = namespace.arrangement(&arrangement_id, bin).map_err(Error::Namespace)?;
	let src = arrangement.source.get().unwrap();
	
	let default_path = &arrangement.default_path.get_ref().to_path_buf(None).ok_or_else(||
		Error::MissingDefaultPath { src, default_path: &arrangement.default_path })?;
	
	let (schemes_id, requests) = arrangement.schemes.get_key_value(schemes_id)
		.ok_or(Error::SchemesNotFound)?;
	
	let schemes = &mut BTreeMap::<&str, Rc<scheme::Data>>::new();
	let main_namespace = (namespace, bin);
	
	for (id, request) in requests {
		let Request { theme_id, scheme_id, namespace_id } = &request;
		
		let scheme = if let Some(theme_id) = theme_id {
			let (namespace, bin) = namespace_id.as_ref().map_or(Ok(main_namespace),
				|namespace_id| cache.namespace(namespace_id.get_ref())
					.map_err(|error| Error::ThemeCache { src, schemes_id, id, namespace_id, error }))?;
			
			let theme = namespace.theme(theme_id.get_ref(), bin).map_err(|error|
				Error::ThemeNamespace { src, schemes_id, id, theme_id, error })?;
			
			Rc::clone(theme.scheme(scheme_id.get_ref(), (namespace, bin), cache, &arrangement.safety)
				.map_err(|error| Error::Theme { src, schemes_id, id, theme_id, scheme_id, error })?)
		} else {
			Rc::clone(schemes.get(scheme_id.get_ref() as &str)
				.ok_or(Error::SchemeNotFound { src, schemes_id, id, scheme_id })?)
		};
		schemes.insert(id.get_ref(), scheme);
	}
	
	if let Some(id) = map_id {
		let (id, map) = arrangement.maps.get_key_value(id).ok_or(Error::MapNotFound)?;
		
		return Ok(vec![map::Exam {
			id, map, main_namespace, cache, schemes, arrangement_id,
			arrangement, default_path, previous_paths: &mut vec![]
		}.examine().map_err(Error::Map)?])
	}
	
	let mut previous_paths = vec![];
	let mut mappings = Vec::with_capacity(arrangement.maps.len());
	
	for (id, map) in &arrangement.maps {
		if map.disabled { continue }
		
		mappings.push(map::Exam {
			id, map, main_namespace, cache, schemes, arrangement, default_path,
			arrangement_id: arrangement_id.clone(), previous_paths: &mut previous_paths
		}.examine().map_err(Error::Map)?)
	}
	
	Ok(mappings)
}

#[allow(private_interfaces)]
pub enum Error<'a> {
             Cache (cache::Error<'a>),
         Namespace (Box<namespace::Error<'a>>),
MissingDefaultPath { src: &'a Src, default_path: &'a Spanned<DefaultPath> },
   SchemesNotFound,
        ThemeCache { src: &'a Src, schemes_id: &'a Spanned, id: &'a Spanned, namespace_id: &'a Spanned, error: cache::Error<'a> },
    ThemeNamespace { src: &'a Src, schemes_id: &'a Spanned, id: &'a Spanned, theme_id: &'a Spanned, error: Box<namespace::Error<'a>> },
             Theme { src: &'a Src, schemes_id: &'a Spanned, id: &'a Spanned, theme_id: &'a Spanned, scheme_id: &'a Spanned, error: theme::Error<'a> },
    SchemeNotFound { src: &'a Src, schemes_id: &'a Spanned, id: &'a Spanned, scheme_id: &'a Spanned },
       MapNotFound,
               Map (map::Error<'a>),
}

impl<'a, 'b> crate::Msg<'a, 'b, 6> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2, cow_3, cow_4, cow_5]: [&'b mut Cow<'a, str>; 6]) -> Message<'b> {
		match self {
			Self::Cache(error) => error.msg([cow_0, cow_1]),
			Self::Namespace(error) => error.msg([cow_0, cow_1]),
			Self::MissingDefaultPath { src, default_path } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Warning.title("missing default path")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(default_path.span()).label("this path")))
			}
			Self::SchemesNotFound => Level::Error.title("schemes not found"),
			Self::SchemeNotFound { src, schemes_id, id, scheme_id } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Warning.title("requested scheme not found")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(scheme_id.span()).label("this scheme has not been requested"))
						.annotation(Level::Warning.span(id.span()).label("at this request"))
						.annotation(Level::Warning.span(schemes_id.span()).label("in this variant of schemes")))
			}
			Self::ThemeCache { src, schemes_id, id, namespace_id, error } => {
				let level = if matches!(error, cache::Error::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(namespace_id.span()).label("this requested namespace"))
					.annotation(Level::Warning.span(id.span()).label("at this request"))
					.annotation(Level::Warning.span(schemes_id.span()).label("at this variant of schemes")))
			}
			Self::ThemeNamespace { src, schemes_id, id, theme_id, error } => {
				let level = if matches!(error.1, namespace::Of::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(theme_id.span()).label("this requested theme"))
					.annotation(Level::Warning.span(id.span()).label("at this request"))
					.annotation(Level::Warning.span(schemes_id.span()).label("at this variant of schemes")))
			}
			Self::Theme { src, schemes_id, id, theme_id, scheme_id, error } => {
				let level = if matches!(error, theme::Error::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2, cow_3, cow_4])
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(level.span(scheme_id.span()).label("this requested scheme"))
						.annotation(Level::Warning.span(theme_id.span()).label("in this requested theme"))
						.annotation(Level::Warning.span(id.span()).label("at this request"))
						.annotation(Level::Warning.span(schemes_id.span()).label("at this variant of schemes")))
			}
			Self::MapNotFound => Level::Error.title("map not found"),
			Self::Map(error) => error.msg([cow_0, cow_1, cow_2, cow_3, cow_4, cow_5]),
		}
	}
}
