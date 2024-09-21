/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{collections::BTreeMap, rc::Rc};
use annotate_snippets::{Level, Snippet};
use crate::*;

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct Map {
	request: Request,
	
	#[serde(default, skip_serializing_if = "std::ops::Not::not")]
	pub(crate) disabled: bool,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	display: Option<Spanned>,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	nomenclature: Option<Spanned>,
	
	#[serde(default, skip_serializing_if = "is_arrangement")]
	replica: Replica,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	options: BTreeMap<Key, Value>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	schemes: BTreeMap<compact_str::CompactString, Spanned>,
	
	#[serde(default, skip_serializing_if = "pathing::includes_nothing")]
	pub paths: pathing::Paths,
	
	#[serde(default, skip_serializing_if = "Vec::is_empty")]
	pub(crate) custom_paths: Vec<Spanned<path::Location>>,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
	#[serde(default, skip_serializing_if = "Option::is_none", rename = "from")]
	namespace_id: Option<Spanned>,
	
	#[serde(rename = "map")]
	map_id: Spanned,
}

#[derive(Clone, Copy, Default, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Replica { #[default] Arrangement, HardLink, SymbolicLink, Copy }

fn is_arrangement(value: &Replica) -> bool {
	matches!(value, Replica::Arrangement)
}

pub(crate) struct Exam<'a, 'b> {
	pub(crate)             id: &'a Spanned,
	pub(crate)            map: &'a Map,
	pub(crate) main_namespace: (&'a namespace::Namespace, &'a cache::Bin),
	pub(crate)          cache: &'a cache::Cache,
	pub(crate)        schemes: &'b BTreeMap<&'b str, Rc<scheme::Data>>,
	pub(crate) arrangement_id: rhai::ImmutableString,
	pub(crate)    arrangement: &'a arrangement::Arrangement,
	pub(crate)   default_path: &'b std::path::PathBuf,
	pub(crate) previous_paths: &'b mut Vec<path::Parsed<'a>>,
}

impl<'a> Exam<'a, '_> {
	pub fn examine(self) -> Result<mapping::Ready<'a>, Error<'a>>
	{ examine(self) }
}

fn examine<'a>(Exam {
	id, map, main_namespace, cache, schemes, arrangement_id, arrangement, default_path, previous_paths,
}: Exam<'a, '_>) -> Result<mapping::Ready<'a>, Error<'a>> {
	let Request { namespace_id, map_id } = &map.request;
	
	let src = arrangement.source.get().unwrap();
	
	let (namespace, bin) = namespace_id.as_ref().map_or(Ok(main_namespace),
		|namespace_id| cache.namespace(namespace_id.get_ref())
			.map_err(|error| Error::Cache { src, id, namespace_id, error }))?;
	
	let (_, mapping) = namespace.map(map_id.get_ref(), bin)
		.map_err(|error| Error::Namespace { src, id, map_id, error })?;
	
	let mut scheme_bindings = BTreeMap::new();
	let mut fallbacks = BTreeMap::new();
	let map_src = mapping.source.get().unwrap();
	
	for (main_binding_id, mut binding) in &mapping.schemes {
		let mut binding_id = main_binding_id;
		fallbacks.clear();
		
		let response = loop {
			if let Some(response) = map.schemes.get(binding_id.get_ref() as &str) { break response }
			
			let fallback_id = binding.fallback.as_ref()
				.ok_or(Error::BindingNotFound { src, id, map_id, map_src, binding_id })?;
			
			fallbacks.insert(binding_id.get_ref() as &str, binding);
			
			if fallbacks.contains_key(fallback_id.get_ref() as &str) {
				Err(Error::FallbackCycle { src, id, map_id, map_src, fallback_id })?
			}
			
			(binding_id, binding) = mapping.schemes.get_key_value(fallback_id.get_ref() as &str)
				.ok_or(Error::FallbackNotFound { src, id, map_id, map_src, fallback_id })?;
		};
		
		let scheme = schemes.get(response.get_ref() as &str)
			.ok_or(Error::SchemeNotFound { src, id, response })?;
		
		scheme_bindings.insert(main_binding_id.get_ref().clone(), Rc::clone(scheme));
	}
	
	let schemes = Rc::from(scheme_bindings);
	
	let mut options = BTreeMap::new();
	
	for (option_id, option) in &mapping.options {
		map.options.get_key_value(option_id.get_ref() as &str)
			.and_then(|(key, value)| {
				let value = match value {
					Value::Bind { bind } if bind.is_empty() => arrangement.presets.get(option_id.get_ref())?,
					Value::Bind { bind } => arrangement.presets.get(bind)?,
					_ => value
				};
				Some(value.has_same_type(&option.default)
					.then(|| options.insert(option_id.get_ref().clone(), value.clone()))
					.ok_or(Error::OptionType {
						sources: [map_src, src],
						options: [option_id, key],
						 values: [value, &option.default],
					}))
			})
			.or_else(|| Some(Ok(options.insert(option_id.get_ref().clone(), option.default.clone()))))
			.transpose()?;
	}
	
	let mut engine = script::naming_engine(arrangement_id, &arrangement.name, Rc::clone(&schemes));
	arrangement.safety.set(&mut engine);
	
	let display = if let Some(spanned) = &map.display {
		if spanned.get_ref().is_empty() { rhai::ImmutableString::new() }
		else { engine.eval(spanned.get_ref())
			.map_err(|error| Error::RhaiMap { src, id, spanned, error })? }
	} else if let Some(spanned) = &mapping.display {
		engine.eval(spanned.get_ref())
			.map_err(|error| Error::Rhai { src, id, spanned, error, map_src, map_id })?
	} else { rhai::ImmutableString::new() };
	
	let name = if let Some(spanned) = &map.nomenclature {
		if spanned.get_ref().is_empty() { rhai::ImmutableString::new() }
		else { path::check_name(engine.eval(spanned.get_ref())
			.map_err(|error| Error::RhaiMap { src, id, spanned, error })?,
			Error::BadNameMap { src, id, spanned })? }
	} else if let Some(spanned) = &mapping.nomenclature {
		path::check_name(engine.eval(spanned.get_ref())
			.map_err(|error| Error::Rhai { src, id, spanned, error, map_src, map_id })?,
			Error::BadName { src, id, spanned, map_src, map_id })?
	} else { rhai::ImmutableString::new() };
	
	let (namespace, bin) = main_namespace;
	
	let paths = Some(pathing::Exam {
		id, map, src, mapping, namespace, bin, cache, default_path, name: &name, previous_paths
	}.examine().map_err(Error::Pathing)?);
	
	Ok(mapping::Ready {
		map: mapping, src, id, map_id, options, display, name, schemes,
		safety: &arrangement.safety, paths, replica: (map.replica, arrangement.replica)
	})
}

pub enum Error<'a> {
             Cache { src: &'a Src, id: &'a Spanned, namespace_id: &'a Spanned, error: cache::Error<'a> },
         Namespace { src: &'a Src, id: &'a Spanned, map_id: &'a Spanned, error: Box<namespace::Error<'a>> },
   BindingNotFound { src: &'a Src, id: &'a Spanned, map_id: &'a Spanned, map_src: &'a Src, binding_id: &'a Spanned },
     FallbackCycle { src: &'a Src, id: &'a Spanned, map_id: &'a Spanned, map_src: &'a Src, fallback_id: &'a Spanned },
  FallbackNotFound { src: &'a Src, id: &'a Spanned, map_id: &'a Spanned, map_src: &'a Src, fallback_id: &'a Spanned },
    SchemeNotFound { src: &'a Src, id: &'a Spanned, response: &'a Spanned },
        OptionType { sources: [&'a Src; 2], options: [&'a Spanned; 2], values: [&'a Value; 2] },
           RhaiMap { src: &'a Src, id: &'a Spanned, spanned: &'a Spanned, error: Box<rhai::EvalAltResult> },
              Rhai { src: &'a Src, id: &'a Spanned, spanned: &'a Spanned, error: Box<rhai::EvalAltResult>, map_src: &'a Src, map_id: &'a Spanned },
        BadNameMap { src: &'a Src, id: &'a Spanned, spanned: &'a Spanned },
           BadName { src: &'a Src, id: &'a Spanned, spanned: &'a Spanned, map_src: &'a Src, map_id: &'a Spanned },
           Pathing (pathing::Error<'a>),
}

impl<'a, 'b> crate::Msg<'a, 'b, 6> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2, cow_3, cow_4, cow_5]: [&'b mut Cow<'a, str>; 6]) -> Message<'b> {
		match self {
			Self::Cache { src, id, namespace_id, error } => {
				let level = if matches!(error, cache::Error::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(namespace_id.span()).label("this namespace"))
					.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::Namespace { src, id, map_id, error } => {
				let level = if matches!(error.1, namespace::Of::NotFound) { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(map_id.span()).label("this requested map"))
					.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::BindingNotFound { src, id, map_id, map_src, binding_id } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = map_src.1.to_string_lossy();
				
				Level::Error.title("scheme binding not specified")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(id.span()).label("in this map request"))
						.annotation(Level::Warning.span(map_id.span()).label("this map requires a binding")))
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(binding_id.span()).label("this scheme binding is missing")))
			}
			Self::FallbackCycle { src, id, map_id, map_src, fallback_id } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = map_src.1.to_string_lossy();
				
				Level::Error.title("fallback cycle")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(map_id.span()).label("in this requested map"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(fallback_id.span()).label("this fallback is cyclical")))
			}
			Self::FallbackNotFound { src, id, map_id, map_src, fallback_id } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = map_src.1.to_string_lossy();
				
				Level::Error.title("fallback not found")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(map_id.span()).label("in this requested map"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(fallback_id.span()).label("scheme binding not found")))
			}
			Self::SchemeNotFound { src, id, response } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Error.title("unbound scheme")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(response.span()).label("this scheme was not requested"))
						.annotation(Level::Warning.span(id.span()).label("for this map request")))
			}
			Self::OptionType { sources, options, values } => {
				*cow_0 = sources[0].1.to_string_lossy();
				*cow_1 = sources[1].1.to_string_lossy();
				
				Level::Error.title("incorrect optional value type")
					.snippet(Snippet::source(&sources[0].0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(options[0].span()).label(values[0].original())))
					.snippet(Snippet::source(&sources[1].0).origin(cow_1).fold(true)
						.annotation(Level::Error.span(options[1].span()).label(values[1].other())))
			}
			Self::RhaiMap { src, id, spanned, error } => {
				*cow_0 = src.1.to_string_lossy();
				script::error_msg(error, cow_1, spanned.get_ref(), ("", cow_0), &src.0, spanned)
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(spanned.span()).label("in this script"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::Rhai { src, id, spanned, error, map_src, map_id } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = map_src.1.to_string_lossy();
				
				script::error_msg(error, cow_2, spanned.get_ref(), ("", cow_1), &map_src.0, spanned)
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(spanned.span()).label("in this script")))
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(map_id.span()).label("in this requested map"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::BadNameMap { src, id, spanned } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Error.title(path::BAD_NAME)
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(spanned.span()).label("in this script"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::BadName { src, id, spanned, map_src, map_id } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = map_src.1.to_string_lossy();
				
				Level::Error.title(path::BAD_NAME)
					.snippet(Snippet::source(&map_src.0).origin(cow_1).fold(true)
						.annotation(Level::Warning.span(spanned.span()).label("in this script")))
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(map_id.span()).label("in this requested map"))
						.annotation(Level::Warning.span(id.span()).label("at this map request")))
			}
			Self::Pathing(error) => error.msg([cow_0, cow_1, cow_2, cow_3, cow_4, cow_5])
		}
	}
}
