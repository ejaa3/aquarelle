/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{collections::BTreeMap, rc::Rc};
use compact_str::CompactString;
use serde::{Serialize, Deserialize};
use crate::{arrangement, cache, mapping, namespace, path, pathing, scheme, script, Value};

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case", deny_unknown_fields)]
pub struct Request {
	#[serde(rename = "request")]
	params: Params,
	
	#[serde(default, skip_serializing_if = "std::ops::Not::not")]
	pub(crate) disabled: bool,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	display: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	nomenclature: CompactString,
	
	#[serde(default, skip_serializing_if = "is_arrangement")]
	replica: Replica,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	options: BTreeMap<CompactString, Value>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	schemes: BTreeMap<CompactString, CompactString>,
	
	#[serde(default, skip_serializing_if = "pathing::includes_nothing")]
	pub(crate) paths: pathing::Paths,
	
	#[serde(default, skip_serializing_if = "<[_]>::is_empty")]
	pub(crate) custom_paths: Box<[path::Location]>,
	
	#[serde(default, skip_serializing_if = "arrangement::EngineSafety::is_default")]
	pub(crate) engine: arrangement::EngineSafety,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct Params {
	#[serde(default, rename = "from")]
	namespace_id: CompactString,
	
	#[serde(rename = "map")]
	map_id: CompactString,
}

#[derive(Clone, Copy, Default, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Replica { #[default] Arrangement, HardLink, SymbolicLink, Copy }

fn is_arrangement(value: &Replica) -> bool {
	if let Replica::Arrangement = value { true } else { false }
}

pub fn lazy_mapping<'a>(
	    (id, request): (&'a str, &'a Request),
	main_namespace_id: &'a str,
	            cache: &'a cache::Cache,
	          schemes: & BTreeMap<&str, Rc<scheme::Data>>,
	       schemes_id: &'a str,
	   arrangement_id: rhai::ImmutableString,
	 arrangement_name: rhai::ImmutableString,
	           safety: arrangement::EngineSafety,
	     default_path: &std::path::PathBuf,
	          replica: arrangement::Replica,
	   previous_paths: &mut Vec<path::ParsedFrom<'a>>,
) -> Result<impl FnOnce() -> mapping::Result<'a>, Error<'a>> {
	let Params { namespace_id, map_id } = &request.params;
	
	let namespace_id = if namespace_id.is_empty() { main_namespace_id } else { namespace_id };
	
	let (namespace, bin) = cache.namespace(namespace_id)
		.map_err(|error| Error::Namespace { id, error })?;
	
	let (map_id, map) = namespace.map(map_id, bin)
		.map_err(|error| Error::Map { id, namespace_id, error })?;
	
	let mut scheme_bindings = BTreeMap::new();
	let mut fallbacks = smallvec::SmallVec::<[_; 4]>::new();
	
	for (main_binding_id, mut binding) in &map.schemes {
		let mut binding_id = main_binding_id;
		fallbacks.clear();
		
		let response = loop {
			if let Some(response) = request.schemes.get(binding_id as &str) { break response }
			
			let fallback_id = binding.fallback.as_ref()
				.ok_or(Error::BindingNotFound { id, map_id, binding_id })?;
			
			fallbacks.push((binding_id, binding));
			
			for (previous_binding_id, _) in &fallbacks {
				if fallback_id as &str == previous_binding_id as &str {
					Err(Error::FallbackCycle { id, map_id })?
				}
			}
			
			(binding_id, binding) = map.schemes.get_key_value(fallback_id as &str)
				.ok_or(Error::FallbackNotFound { id, map_id, binding_id, fallback_id })?;
		};
		
		let scheme = schemes.get(response as &str)
			.ok_or(Error::SchemeNotFound { id, schemes_id, binding_id, response })?;
		
		scheme_bindings.insert(main_binding_id.clone(), Rc::clone(scheme));
	}
	
	let schemes = Rc::from(scheme_bindings);
	
	let mut options = BTreeMap::new();
	
	for (option_id, option) in &map.options {
		request.options.get(option_id)
			.and_then(|value| Some(value.has_same_type(&option.default)
				.then(|| options.insert(option_id.clone(), value.clone()))
				.ok_or(Error::OptionType { id, option_id, value, required: &option.default })))
			.or_else(|| Some(Ok(options.insert(option_id.clone(), option.default.clone()))))
			.transpose()?;
	}
	
	let mut engine = script::naming_engine(arrangement_id, arrangement_name, Rc::clone(&schemes));
	safety.set(&mut engine);
	
	let display = if !request.display.is_empty() {
		engine.eval(&request.display).map_err(|error|
			Error::BadDisplaying { id, script: &map.display, error })?
	} else if !map.display.is_empty() {
		engine.eval(&map.display).map_err(|error|
			Error::BadMapDisplaying { id, map_id, script: &map.display, error })?
	} else {
		rhai::ImmutableString::new()
	};
	
	let name = if !request.nomenclature.is_empty() {
		engine.eval(&request.nomenclature).map_err(|error|
			Error::BadNaming { id, script: &map.nomenclature, error })?
	} else if !map.nomenclature.is_empty() {
		engine.eval(&map.nomenclature).map_err(|error|
			Error::BadMapNaming { id, map_id, script: &map.nomenclature, error })?
	} else { rhai::ImmutableString::new() };
	
	let paths = Some(pathing::resolve(
		(id, request), map, map_id, cache, default_path, &name, previous_paths
	).map_err(Error::Pathing)?);
	
	Ok(move || mapping::Ready {
		map, id, map_id, options, display, name, schemes,
		safety, paths, replica: (request.replica, replica)
	}.perform())
}

pub enum Error<'a> {
       Namespace { id: &'a str, error: Box<cache::Error<'a>> },
             Map { id: &'a str, namespace_id: &'a str, error: Box<namespace::Error<'a>> },
 BindingNotFound { id: &'a str, map_id: &'a str, binding_id: &'a str },
FallbackNotFound { id: &'a str, map_id: &'a str, binding_id: &'a str, fallback_id: &'a str },
   FallbackCycle { id: &'a str, map_id: &'a str },
  SchemeNotFound { id: &'a str, schemes_id: &'a str, binding_id: &'a str, response: &'a str },
      OptionType { id: &'a str, option_id: &'a str, value: &'a Value, required: &'a Value },
BadMapDisplaying { id: &'a str, map_id: &'a str, script: &'a str, error: Box<rhai::EvalAltResult> },
   BadDisplaying { id: &'a str, script: &'a str, error: Box<rhai::EvalAltResult> },
    BadMapNaming { id: &'a str, map_id: &'a str, script: &'a str, error: Box<rhai::EvalAltResult> },
       BadNaming { id: &'a str, script: &'a str, error: Box<rhai::EvalAltResult> },
         Pathing (pathing::Error<'a>),
}

#[cfg(feature = "cli")]
pub fn show_error(mut out: impl std::io::Write, error: Error) -> std::io::Result<i32> {
	match error {
		Error::Namespace { id, error } => {
			let code = error.show(&mut out)?;
			
			writeln!(out, crate::csi! {
				"\nRequested by " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'!
			}, id)?;
			
			Ok(code)
		}
		Error::Map { id, namespace_id, error } => {
			let code = error.show(&mut out, namespace_id)?;
			
			writeln!(out, crate::csi! {
				"\nRequested by " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'!
			}, id)?;
			
			Ok(code)
		}
		Error::BindingNotFound { id, map_id, binding_id } => {
			write!(out, crate::csi! {
				"map " /fg green; "{:?}"!
				" requested by " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ']'!
				" requires " /fg blue; "[]" /fg blue; ".schemes." /fg red; "{:?}"! '\n'
			}, map_id, id, binding_id)?;
			
			Ok(exitcode::CONFIG)
		}
		Error::FallbackNotFound { id, map_id, binding_id, fallback_id } => {
			writeln!(out, crate::csi! {
				/fg blue; "[schemes." /fg yellow; "{:?}" /fg blue; ']'! " falls to "
				/fg blue; "[schemes." /fg red;    "{:?}" /fg blue; ']'! " which does not exist in map "
				/fg yellow; "{:?}"! ", requested by " /fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			}, binding_id, fallback_id, map_id, id)?;
			
			Ok(exitcode::CONFIG)
		}
		Error::FallbackCycle { id, map_id } => {
			writeln!(out, crate::csi! {
				"Cycle of scheme fallbacks detected in map " /fg yellow; "{:?}"!
				", requested by " /fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			}, map_id, id)?;
			
			Ok(exitcode::CONFIG)
		}
		Error::SchemeNotFound { id, schemes_id, binding_id, response } => {
			write!(out, crate::csi! {
				/fg blue; "[maps." /fg green; "{:?}" /fg blue; ".schemes." /fg yellow; "{:?}" /fg blue; ']'! " requires "
				/fg blue; "[schemes." /fg yellow; "{:?}" /fg blue; '.' /fg red; "{:?}" /fg blue; ']'! '\n'
			}, id, binding_id, schemes_id, response)?;
			
			Ok(exitcode::CONFIG)
		}
		Error::OptionType { id, option_id, value, required } => {
			writeln!(out, crate::csi! {
				"Datatype of " /fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".options." /fg red; "{:?}" /fg blue; ']'!
				" is " /fg magenta; "{}"! " instead of " /fg magenta; "{}"!
			}, id, option_id, value.type_str(), required.type_str())?;
			
			Ok(exitcode::DATAERR)
		}
		Error::BadMapDisplaying { id, map_id, script, error } => {
			writeln!(out, crate::csi! {
				"At map " /fg red; "{:?}"! ' ' /fg blue; "displaying"! ", requested by "
				/fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			}, map_id, id)?;
			
			script::show_error(&mut out, error, &script)
		}
		Error::BadDisplaying { id, script, error } => {
			writeln!(out, crate::csi!("At " /fg blue; "[maps." /fg red; "{:?}" /fg blue; "].displaying"!), id)?;
			script::show_error(&mut out, error, &script)
		}
		Error::BadMapNaming { id, map_id, script, error } => {
			writeln!(out, crate::csi! {
				"At map " /fg red; "{:?}"! ' ' /fg blue; "naming"! ", requested by "
				/fg blue; "[maps." /fg green; "{:?}" /fg blue; ']'!
			}, map_id, id)?;
			
			script::show_error(&mut out, error, &script)
		}
		Error::BadNaming { id, script, error } => {
			writeln!(out, crate::csi!("At " /fg blue; "[maps." /fg red; "{:?}" /fg blue; "].naming"!), id)?;
			script::show_error(&mut out, error, &script)
		}
		Error::Pathing(error) => error.show(&mut out)
	}
}
