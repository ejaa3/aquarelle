/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::OnceCell, collections::BTreeMap, path::Path, rc::Rc};
use compact_str::CompactString;
use serde::{Serialize, Deserialize};
use crate::{arrangement, cache, namespace, script, Value};

#[derive(Serialize, Deserialize)]
pub struct Static {
	pub   name: rhai::ImmutableString,
	pub    dim: rhai::FLOAT,
	pub border: rhai::FLOAT,
	
	#[serde(flatten)]
	pub sets: Sets,
}

#[derive(Serialize, Deserialize)]
pub struct Sets {
	pub   lower: Roles,
	pub   upper: Roles,
	pub     red: Roles,
	pub  yellow: Roles,
	pub   green: Roles,
	pub    cyan: Roles,
	pub    blue: Roles,
	pub magenta: Roles,
	pub     any: Roles,
}

#[derive(Clone, Copy, Serialize, Deserialize)]
pub struct Roles { pub like: u32, pub area: u32, pub text: u32 }

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Dynamic {
	pub name: rhai::ImmutableString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub options: BTreeMap<CompactString, crate::Optional>,
	
	#[serde(skip)]
	pub script_path: Option<Rc<std::path::Path>>,
}

pub struct Scheme { variant: Variant, pub metadata: OnceCell<Box<dyn std::any::Any>> }

impl Scheme {
	pub fn data<'a>(&'a self,
	  namespace_id: &'a str,
	         cache: &'a cache::Cache,
	        safety: & arrangement::EngineSafety,
	       options: &'a BTreeMap<CompactString, Value>,
	) -> Result<&'a Rc<Static>, Box<Error<'a>>> {
		match &self.variant {
			Variant::Static(scheme) => Ok(scheme),
			Variant::Dynamic(request) => data(request, namespace_id, cache, safety, options),
		}
	}
}

impl Serialize for Scheme {
	fn serialize<S: serde::Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		self.variant.serialize(serializer)
	}
}

impl<'de> Deserialize<'de> for Scheme {
	fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		Ok(Scheme {
			 variant: Variant::deserialize(deserializer)?,
			metadata: Default::default(),
		})
	}
}

#[derive(Serialize, Deserialize)]
#[serde(untagged)]
pub enum Variant { Static(Rc<Static>), Dynamic(Request) }

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub struct Request {
	#[serde(rename = "request")]
	pub params: Params,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub options: BTreeMap<CompactString, Value>,
	
	#[serde(skip)]
	pub data: std::cell::OnceCell<Rc<Static>>,
}

#[derive(Serialize, Deserialize)]
pub struct Params {
	#[serde(rename = "scheme")]
	pub scheme_id: CompactString,
	
	#[serde(default, rename = "from")]
	pub namespace_id: CompactString,
}

pub fn data<'a>(
	          request: &'a Request,
	main_namespace_id: &'a str,
	            cache: &'a cache::Cache,
	           safety: & arrangement::EngineSafety,
	   global_options: &'a BTreeMap<CompactString, Value>,
) -> Result<&'a Rc<Static>, Box<Error<'a>>> {
	if let Some(data) = request.data.get() { return Ok(data) }
	
	let Params { scheme_id, namespace_id } = &request.params;
	
	let namespace_id = if namespace_id.is_empty()
		{ main_namespace_id } else { namespace_id };
	
	let (namespace, bin) = cache.namespace(namespace_id).map_err(Error::Cache)?;
	
	let (scheme_id, scheme) = namespace.scheme(scheme_id, bin)
		.map_err(|error| Error::Namespace { namespace_id, error })?;
	
	let mut options = BTreeMap::new();
	
	for (option_id, option) in &scheme.options {
		request.options.get(option_id)
			.and_then(|value| {
				let current = match value {
					Value::Binding((bind,)) => global_options.get(bind)?,
					Value::Bind(..) => global_options.get(option_id)?,
					_ => value
				};
				Some(current.has_same_type(&option.default)
					.then(|| options.insert(option_id.clone(), current.clone()))
					.ok_or(Error::OptionType { option_id, current, required: &option.default }))
			})
			.or_else(|| Some(Ok(options.insert(option_id.clone(), option.default.clone()))))
			.transpose()?;
	}
	
	let path = scheme.script_path.as_ref().unwrap();
	
	let script = std::fs::read_to_string(&path)
		.map_err(|error| Error::Loading { scheme_id, path, error })?;
	
	let slice = if script.starts_with("#!") {
		&script[script.find('\n').unwrap_or(0)..]
	} else { &script };
	
	let mut engine = script::engine(path.parent().unwrap());
	let cfg_module = script::cfg_module(scheme_id.clone(), options);
	
	safety.set(engine
		.register_fn("to_string", |rgba: rhai::INT| (rgba as u32).to_string())
		.register_static_module("cfg", Rc::new(cfg_module)));
	
	let data = toml_edit::de::from_str(&engine.eval::<rhai::ImmutableString>(slice)
		.map_err(|error| Error::Rhai { scheme_id, path, script, error })?
	).map_err(|error| Box::new(Error::Toml { scheme_id, path, error: Box::new(error) }))?;
	
	Ok(request.data.get_or_init(|| data))
}

pub enum Error<'a> {
	     Cache (Box<cache::Error<'a>>),
	 Namespace { namespace_id: &'a str, error: Box<namespace::Error<'a>> },
	OptionType { option_id: &'a str, current: &'a Value, required: &'a Value },
	   Loading { scheme_id: &'a str, path: &'a Path, error: std::io::Error },
	      Rhai { scheme_id: &'a str, path: &'a Path, script: String, error: Box<rhai::EvalAltResult> },
	      Toml { scheme_id: &'a str, path: &'a Path, error: Box<toml_edit::de::Error> },
}

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl std::io::Write) -> std::io::Result<i32> {
		match self {
			Self::Cache(error) => error.show(out),
			
			Self::Namespace { namespace_id, error } => error.show(out, namespace_id),
			
			Self::OptionType { option_id, current, required } => {
				writeln!(out, crate::csi! {
					"The data assigned to option " /fg yellow; "{:?}"! " is of type "
					/fg red; "{}"! " instead of " /fg green; "{}"!
				}, option_id, current.type_str(), required.type_str())?;
				
				Ok(exitcode::DATAERR)
			}
			Self::Loading { scheme_id, path, error } => {
				writeln!(out, crate::csi! {
					"Unable to read script for scheme " /fg yellow; "{:?}"!
					" at\n" /fg cyan; "{}"! "\n{}"
				}, scheme_id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::IOERR)
			}
			Self::Rhai { scheme_id, path, script, error } => {
				writeln!(out, crate::csi! {
					"In the script for scheme " /fg yellow; "{:?}"! " located at\n" /fg cyan; "{}"!
				}, scheme_id, path.to_string_lossy())?;
				
				script::show_error(out, error, &script)
			}
			Self::Toml { scheme_id, path, error } => {
				write!(out, crate::csi! {
					"Script for scheme " /fg yellow; "{:?}"! " returns invalid TOML, located at\n"
					/fg cyan; "{}"! "\n\n{}"
				}, scheme_id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::DATAERR)
			}
		}
	}
}
