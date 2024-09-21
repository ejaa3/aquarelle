/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, collections::BTreeMap};
use annotate_snippets::{Level, Message, Snippet};
use compact_str::CompactString;
use serde::{Serialize, Deserialize};
use crate::{arrangement, script, Key, Spanned, Src, Value};

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Parametric {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub options: BTreeMap<Key, crate::Optional>,
	
	pub script: crate::Script,
	
	#[serde(skip)]
	pub(crate) source: OnceCell<Src>,
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Data {
	pub    name: rhai::ImmutableString,
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
#[serde(deny_unknown_fields)]
pub struct Roles { pub like: u32, pub area: u32, pub text: u32 }

impl Parametric {
	pub fn data<'a>(&'a self,
		scheme_options: &'a BTreeMap<Key, Value>,
		       presets: &'a BTreeMap<CompactString, Value>,
		    option_src: &'a Src,
		     scheme_id: Option<&'a Spanned>,
		        safety: & arrangement::EngineSafety,
	) -> Result<Data, Box<Error<'a>>> {
		let mut options = BTreeMap::new();
		let src = self.source.get().unwrap();
		
		for (option_id, option) in &self.options {
			scheme_options.get_key_value(option_id.0.get_ref() as &str)
				.and_then(|(key, value)| {
					let value = match value {
						Value::Bind { bind } if bind.is_empty() => presets.get(key.0.get_ref())?,
						Value::Bind { bind } => presets.get(bind)?,
						_ => value
					};
					Some(value.has_same_type(&option.default)
						.then(|| options.insert(option_id.0.get_ref().clone(), value.clone()))
						.ok_or(Error::Types {
							sources: [src, option_src],
							options: [option_id, key],
							 values: [&option.default, value], scheme_id
						}))
				})
				.or_else(|| Some(Ok(options.insert(option_id.0.get_ref().clone(), option.default.clone()))))
				.transpose()?;
		}
		
		let prefix = src.1.parent().unwrap();
		let mut script_path = None;
		
		let (script, path, code): (_, &str, Cow<str>) = match &self.script {
			crate::Script::Path(script) => {
				(script, script.get_ref(), Cow::Owned(std::fs::read_to_string(script_path
					.get_or_insert(prefix.join(script.get_ref() as &str)))
					.map_err(|error| Error::Io { src, script, error })?))
			}
			crate::Script::Embedded(script) => (script, "", Cow::Borrowed(script.get_ref())),
		};
		
		let slice = if code.starts_with("#!") {
			&code[code.find('\n').unwrap_or(0)..]
		} else { &code };
		
		let mut engine = script::engine(script_path.as_deref()
			.and_then(std::path::Path::parent).unwrap_or(prefix));
		
		let cfg_module = script::cfg_module(scheme_id.map(Spanned::get_ref)
			.map(CompactString::as_str).unwrap_or("unnamed"), options);
		
		safety.set(engine
			.register_fn("to_string", |rgba: rhai::INT| (rgba as u32).to_string())
			.register_static_module("cfg", std::rc::Rc::new(cfg_module)));
		
		toml::de::from_str(&engine.eval::<rhai::ImmutableString>(slice)
			.map_err(|error| Error::Rhai { src, script, code, path, error })?
		).map_err(|error| Box::new(Error::Toml { src, script, error: Box::from(error) }))
	}
}

pub enum Error<'a> {
	Types { sources: [&'a Src; 2], options: [&'a Spanned; 2], values: [&'a Value; 2], scheme_id: Option<&'a Spanned> },
	   Io { src: &'a Src, script: &'a Spanned, error: std::io::Error },
	 Rhai { src: &'a Src, script: &'a Spanned, code: Cow<'a, str>, path: &'a str, error: Box<rhai::EvalAltResult> },
	 Toml { src: &'a Src, script: &'a Spanned, error: Box<toml::de::Error> },
}

impl<'a, 'b> crate::Msg<'a, 'b, 3> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2]: [&'b mut Cow<'a, str>; 3]) -> Message<'b> {
		match self {
			Self::Types { sources, options, values, scheme_id } => {
				*cow_0 = sources[0].1.to_string_lossy();
				*cow_1 = sources[1].1.to_string_lossy();
				
				let snippet = Snippet::source(&sources[1].0).origin(cow_1).fold(true)
					.annotation(Level::Error.span(options[1].span()).label(values[1].other()));
				
				Level::Error.title("incorrect optional value type")
					.snippet(if let Some(scheme_id) = scheme_id { snippet.annotation(Level::Warning
						.span(scheme_id.span()).label("in this requested scheme")) } else { snippet })
					.snippet(Snippet::source(&sources[0].0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(options[0].span()).label(values[0].original())))
			}
			Self::Io { src, script, error } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = Cow::Owned(error.to_string());
				
				Level::Warning.title("unable to read script")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Warning.span(script.span()).label("this script")))
					.footer(Level::Error.title(cow_1))
			}
			Self::Rhai { src, script, code, path, error } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = code;
				
				let level = if error.position().is_none() { Level::Error } else { Level::Warning };
				
				script::error_msg(error, cow_2, cow_1, (path, cow_0), &src.0, script)
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(script.span()).label("when evaluating this script")))
			}
			Self::Toml { src, script, error } => {
				*cow_0 = src.1.to_string_lossy();
				*cow_1 = Cow::Owned(error.to_string());
				
				Level::Error.title("invalid TOML")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(script.span()).label("when evaluating this script")))
					.footer(Level::Info.title(cow_1))
			}
		}
	}
}
