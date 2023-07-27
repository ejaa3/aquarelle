/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use compact_str::CompactString;
use serde::{Serialize, Deserialize, ser, de};
use std::collections::BTreeMap;
use crate::{cache, mapping, map, namespace, path, theme, Value};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Arrangement {
	pub name: rhai::ImmutableString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	default_path: DefaultPath,
	replica: Replica,
	
	#[serde(default, skip_serializing_if = "EngineSafety::is_default")]
	engine: EngineSafety,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	options: BTreeMap<CompactString, BTreeMap<CompactString, Value>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub(crate) schemes: BTreeMap<CompactString, BTreeMap<CompactString, theme::Request>>,
	
	maps: BTreeMap<CompactString, map::Request>,
}

struct DefaultPath(path::Located);

impl std::ops::Deref for DefaultPath {
	type Target = path::Located;
	fn deref(&self) -> &path::Located { &self.0 }
}

impl Serialize for DefaultPath {
	fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
	where S: serde::Serializer {
		if let path::Location::Default = self.0.location {
			Err(ser::Error::custom("cannot be `Location::Default`"))
		} else { self.0.serialize(serializer) }
	}
}

impl<'de> Deserialize<'de> for DefaultPath {
	fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
	where D: serde::Deserializer<'de> {
		let path = path::Located::deserialize(deserializer)?;
		
		if let path::Location::Default = path.location {
			Err(de::Error::custom("cannot be `default`"))
		} else { Ok(Self(path)) }
	}
}

#[derive(Default, PartialEq, Serialize, Deserialize)]
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
	
	pub(crate) fn or(&self, fallback: &EngineSafety) -> EngineSafety {
		EngineSafety {
			max_array_size : self.max_array_size .or(fallback.max_array_size),
			max_call_levels: self.max_call_levels.or(fallback.max_call_levels),
			max_expr_depths: self.max_expr_depths.or(fallback.max_expr_depths),
			max_map_size   : self.max_map_size   .or(fallback.max_map_size),
			max_modules    : self.max_modules    .or(fallback.max_modules),
			max_operations : self.max_operations .or(fallback.max_operations),
			max_string_size: self.max_string_size.or(fallback.max_string_size),
		}
	}
}

#[derive(Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Replica { HardLink, SymbolicLink, Copy }

pub fn arrange<'a>(
	         cache: &'a cache::Cache,
	  namespace_id: &'a str,
	arrangement_id: &'a rhai::ImmutableString,
	    schemes_id: &'a str,
	    options_id: Option<&'a str>,
	        map_id: Option<&'a str>,
) -> Result<Vec<impl FnOnce() -> mapping::Result<'a>>, Error<'a>> {
	let (namespace, bin) = cache.namespace(namespace_id).map_err(Error::Cache)?;
	
	let arrangement = namespace.arrangement(arrangement_id, bin)
		.map_err(|error| Error::Namespace { namespace_id, error })?;
	
	let default_path = arrangement.default_path.to_path_buf(None).ok_or_else(||
		Error::MissingDefaultPath { default_path: &arrangement.default_path })?;
	
	let schemes = theme::list_schemes(
		arrangement, schemes_id, namespace_id, cache, &arrangement.engine
	).map_err(Error::SchemeListing)?;
	
	let options = if let Some(id) = options_id {
		Some(arrangement.options.get(id).ok_or(Error::OptionsNotFound { id })?)
	} else { None };
	
	if let Some(id) = map_id {
		let request = arrangement.maps.get(id).ok_or(Error::MapNotFound { id })?;
		
		return Ok(vec![map::lazy_mapping(
			(id, request), namespace_id, cache, &schemes, schemes_id,
			arrangement_id.clone(), arrangement.name.clone(), request.engine.or(&arrangement.engine),
			&default_path, arrangement.replica, &mut vec![], options
		).map_err(Error::Map)?])
	}
	
	let mut previous_paths = vec![];
	let mut mappings = Vec::with_capacity(arrangement.maps.len());
	
	for (id, request) in &arrangement.maps {
		if request.disabled { continue }
		
		mappings.push(map::lazy_mapping(
			(id, request), namespace_id, cache, &schemes, schemes_id,
			arrangement_id.clone(), arrangement.name.clone(), request.engine.or(&arrangement.engine),
			&default_path, arrangement.replica, &mut previous_paths, options
		).map_err(Error::Map)?)
	}
	
	Ok(mappings)
}

pub enum Error<'a> {
             Cache (Box<cache::Error<'a>>),
         Namespace { namespace_id: &'a str, error: Box<namespace::Error<'a>> },
MissingDefaultPath { default_path: &'a path::Located },
     SchemeListing (Box<theme::ListingError<'a>>),
       MapNotFound { id: &'a str },
   OptionsNotFound { id: &'a str },
               Map (map::Error<'a>),
}

#[cfg(feature = "cli")]
pub fn show_error(mut out: impl std::io::Write, error: Error, aid: &str) -> std::io::Result<i32> {
	crate::warn(&mut out, true)?;
	writeln!(out, crate::csi!("In the arrangement " /fg yellow; "{:?}"! ":"), aid)?;
	
	match error {
		Error::Cache(error) => error.show(&mut out),
		
		Error::Namespace { namespace_id, error } => error.show(&mut out, namespace_id),
			
		Error::MissingDefaultPath { default_path } => {
			writeln!(out, crate::csi! {
				"Unable to parse " /fg blue; "default-path"! " as "
			})?;
			
			path::show_located(&mut out, default_path)?; writeln!(out)?;
			Ok(exitcode::SOFTWARE)
		}
		Error::SchemeListing(error) => error.show(&mut out),
		
		Error::MapNotFound { id } => {
			writeln!(out, crate::csi!(/fg blue; "[maps." /fg red; "{:?}" /fg blue; ']'! " not found "), id)?;
			Ok(exitcode::TEMPFAIL)
		}
		Error::OptionsNotFound { id } => { // TODO test
			writeln!(out, crate::csi!(/fg blue; "[options." /fg red; "{:?}" /fg blue; ']'! " not found"), id)?;
			Ok(exitcode::TEMPFAIL)
		}
		Error::Map(error) => map::show_error(out, error),
	}
}
