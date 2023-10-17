/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use serde::{Serialize, Deserialize};

pub mod arrangement;
pub mod cache;
pub mod config;
pub mod mapping;
pub mod namespace;
pub mod path;
pub mod pathing;
pub mod scheme;
pub mod theme;

mod css_filter;
mod map;
mod script;

#[cfg(feature = "cli")]
pub use script::show_error as show_script_error;

mod set {
	pub const   LOWER: &str = "lower";
	pub const   UPPER: &str = "upper";
	pub const     RED: &str = "red";
	pub const  YELLOW: &str = "yellow";
	pub const   GREEN: &str = "green";
	pub const    CYAN: &str = "cyan";
	pub const    BLUE: &str = "blue";
	pub const MAGENTA: &str = "magenta";
	pub const     ANY: &str = "any";
}

mod role {
	pub const LIKE: &str = "like";
	pub const AREA: &str = "area";
	pub const TEXT: &str = "text";
}

#[derive(Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Set { Lower, Upper, Red, Yellow, Green, Cyan, Blue, Magenta, Any }

impl Set {
	pub const fn to_str(self) -> &'static str {
		match self {
			Set::Lower   => set::LOWER,
			Set::Upper   => set::UPPER,
			Set::Red     => set::RED,
			Set::Yellow  => set::YELLOW,
			Set::Green   => set::GREEN,
			Set::Cyan    => set::CYAN,
			Set::Blue    => set::BLUE,
			Set::Magenta => set::MAGENTA,
			Set::Any     => set::ANY,
		}
	}
}

#[derive(Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Role { Like, Area, Text }

impl Role {
	const fn to_str(self) -> &'static str {
		match self {
			Role::Like => role::LIKE,
			Role::Area => role::AREA,
			Role::Text => role::TEXT,
		}
	}
}

#[derive(Serialize, Deserialize)]
pub struct Optional {
	pub name: compact_str::CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: compact_str::CompactString,
	
	pub default: Value,
}

#[derive(Clone, Serialize, Deserialize)]
#[serde(untagged)]
pub enum Value {
	Bool (bool),
	Int (rhai::INT),
	Float   (rhai::FLOAT),
	String  (rhai::ImmutableString),
	Set     {  set: Set },
	Role    { role: Role },
	Binding ((compact_str::CompactString,)),
	Bind    ([(); 0]),
}

impl Value {
	const fn has_same_type(&self, other: &Value) -> bool {
		match (self, other) {
			(Value::Bool (..), Value::Bool (..)) |
			(Value::Int (..), Value::Int (..)) |
			(Value::Float   (..), Value::Float   (..)) |
			(Value::String  (..), Value::String  (..)) |
			(Value::Set     {..}, Value::Set     {..}) |
			(Value::Role    {..}, Value::Role    {..}) => true,
			_ => false
		}
	}
	
	pub const fn type_str(&self) -> &'static str {
		match self {
			Value::Bool (..) => "boolean",
			Value::Int (..) => "integer",
			Value::Float   (..) => "float",
			Value::String  (..) => "string",
			Value::Set     {..} => "color-set",
			Value::Role    {..} => "color-role",
			Value::Binding {..} |
			Value::Bind    {..} => "binding",
		}
	}
}

#[macro_export]
/// https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences
macro_rules! csi {
	($($arg:tt)+) => { concat!($($crate::impl_csi!($arg),)+) };
}

#[macro_export]
macro_rules! impl_csi {
	(/) => {"\x1B["}; // begin command
	
	// end commands:
	
	(U) => {'A'}; // cursor up
	(D) => {'B'}; // cursor down
	(F) => {'C'}; // cursor forward
	(B) => {'D'}; // cursor back
	(S) => {'s'}; // save current cursor position
	(R) => {'u'}; // restore saved cursor position
	(;) => {'m'}; // SGR
	
	// SGR (Select Graphics Rendintion):
	
	(:) => {';'}; // format
	(-) => { 2 }; // unset
	(b) => { 1 }; // bold
	(d) => { 2 }; // dim or faint
	(i) => { 3 }; // italic (could be Inversed or Blink)
	(u) => { 4 }; // underline
	(v) => { 5 }; // slow blink
	(w) => { 6 }; // rapid blink
	(r) => { 7 }; // reversed (invert)
	(h) => { 8 }; // hide
	(s) => { 9 }; // strike
	
	(!) => { "\x1B[m" }; // reset (better than /;)
	
	// color prefixes:
	
	(fg) => {  3 }; // normal foreground
	(bg) => {  4 }; // normal background
	(FG) => {  9 }; // intense foreground
	(BG) => { 10 }; // intense background
	
	// basic colors:
	
	  (black) => { 0 };
	    (red) => { 1 };
	  (green) => { 2 };
	 (yellow) => { 3 };
	   (blue) => { 4 };
	(magenta) => { 5 };
	   (cyan) => { 6 };
	  (white) => { 7 };
	 (normal) => { 9 };
	
	// more colors (do not prefix with FG or BG):
	
	(color) => {"8;5"}; // 256 colors (N)
	  (rgb) => {"8;2"}; // true color (R, G, B)
	
	(($($arg:literal $(,)?)+)) => { concat!($(';', $arg,)+) };
	($lit:literal) => { $lit };
}

#[cfg(feature = "cli")]
pub const fn location(local: bool) -> &'static str {
	if local { "local" } else { "system" }
}

#[cfg(feature = "cli")]
pub fn warn(io: &mut impl std::io::Write, error: bool) -> std::io::Result<()> {
	let item = time::macros::format_description!(version = 2, "[hour]:[minute]:[second]");
	write!(io, "\n[{}] ", time::OffsetDateTime::now_utc().format(&item).unwrap())?;
	
	if error { writeln!(io, csi!(/b:fg red; "ERROR"!)) }
	else     { writeln!(io, csi!(/b:fg yellow; "WARNING"!)) }
}

pub mod errors {
	use std::{io, path::Path};
	use crate::{cache, namespace, path, pathing, scheme, theme, Value};
	
	const  ID: &str = "test";
	const MSG: &str = "SOME ERROR MESSAGE";
	
	pub fn path() -> std::path::PathBuf {
		["some", "file", "or", "directory", "path"].iter().collect()
	}
	
	fn toml_error() -> Box<toml_edit::de::Error> {
		match toml_edit::de::from_str::<()>("invalid-toml") {
			Ok(_) => panic!("the TOML is valid"), Err(error) => Box::new(error)
		}
	}
	
	pub fn scan_errors(path: &Path) -> [cache::ScanError; 3] {
		use cache::ScanError::*;
		
		[  Path { local: false, path, error: io::Error::new(io::ErrorKind::Other, MSG) },
		  Entry { local: true , path, error: io::Error::new(io::ErrorKind::Other, MSG) },
		Unicode { local: false, path }]
	}
	
	pub fn cache_errors(path: &Path) -> [cache::Error; 3] {
		[cache::Error::Io(true , ID, path, io::Error::new(io::ErrorKind::Other, MSG)),
		 cache::Error::De(false, ID, path, toml_error()),
		 cache::Error::NotFound { id: ID }]
	}
	
	pub fn namespace_errors(object: namespace::Object) -> [namespace::Error<'static>; 3] {
		use namespace::{Error, Object, Of::*};
		let local = match object { Object::Arrangement | Object::Scheme => true, _ => false };
		
		[Error(object, ID,  local, Io(path(), io::Error::new(io::ErrorKind::Other, MSG))),
		 Error(object, ID, !local, De(path(), toml_error())),
		 Error(object, ID,  local, NotFound)]
	}
	
	pub fn script_errors() -> [(&'static str, Box<rhai::EvalAltResult>); 2] {
		let first = match rhai::Engine::new_raw().eval::<&str>("0") {
			Ok(_) => panic!("the script is valid"),
			Err(error) => ("0", error),
		};
		
		let script = "let something = (2 + 2 = 4);";
		
		let second = match rhai::Engine::new_raw().eval::<()>(script) {
			Ok(_) => panic!("the script is valid"),
			Err(error) => (script, error),
		};
		
		[first, second]
	}
	
	pub fn scheme_errors<'a>(path: &'a Path, current: &'a Value, required: &'a Value) -> [scheme::Error<'a>; 7] {
		let [(script_1, error_1), (script_2, error_2)] = script_errors();
		
		[scheme::Error::Cache(Box::new(
			cache::Error::Io(true, ID, path, io::Error::new(io::ErrorKind::Other, MSG))
		)),
		scheme::Error::Namespace {
			namespace_id: "namespace-id", error: Box::new(
				namespace::Error(namespace::Object::Scheme, ID, false, namespace::Of::NotFound)
			)
		},
		scheme::Error::OptionType {
			option_id: "option-id", current, required
		},
		scheme::Error::Loading {
			scheme_id: "scheme-id", path, error: io::Error::new(io::ErrorKind::Other, MSG)
		},
		scheme::Error::Rhai {
			scheme_id: "scheme-id", path, script: script_1.to_string(), error: error_1
		},
		scheme::Error::Rhai {
			scheme_id: "scheme-id", path, script: script_2.to_string(), error: error_2
		},
		scheme::Error::Toml {
			scheme_id: "scheme-id", path, error: toml_error()
		}]
	}
	
	pub fn theme_errors(path: &Path) -> [theme::Error; 2] {
		[theme::Error::NotFound { id: ID }, theme::Error::Scheme {
			id: ID, error: Box::new(scheme::Error::Loading {
				scheme_id: "scheme-id", path, error: io::Error::new(io::ErrorKind::Other, MSG)
			})
		}]
	}
	
	pub fn scheme_listing_errors() -> [theme::ListingError<'static>; 5] {
		let (schemes_id, id) = ("schemes-id", ID);
		[
			theme::ListingError::NotFound { schemes_id },
			theme::ListingError::LocalNotFound { schemes_id, id, scheme_id: "scheme-id" },
			theme::ListingError::Cache {
				schemes_id, error: Box::new(cache::Error::NotFound { id })
			},
			theme::ListingError::GlobalNotFound {
				schemes_id, id, namespace_id: "namespace-id", error: Box::new(
					namespace::Error(namespace::Object::Scheme, ID, false, namespace::Of::NotFound)
				)
			},
			theme::ListingError::Theme {
				schemes_id, id, theme_id: "theme-id", error: theme::Error::NotFound { id }
			},
		]
	}
	
	pub fn pathing_errors<'a>(
		located: &'a path::Located, previous: path::ParsedFrom<'a>, current: path::ParsedFrom<'a>
	) -> [pathing::Error<'a>; 9] {
		let (id, map_id, include_id, namespace_id) = ("map-id", "map-request", "suggested-id", "namespace-id");
		[
			pathing::Error::IncludeNotFound { id, map_id, include_id },
			pathing::Error::Namespace { id, error: Box::new(cache::Error::NotFound { id: namespace_id }) },
			pathing::Error::Map { id, namespace_id, error: Box::new(
				namespace::Error(namespace::Object::Map, map_id, false, namespace::Of::NotFound)
			) },
			pathing::Error::PathsIncludeNotFound { id, namespace_id, map_id, include_id },
			// pathing::Error::EmptyPath { id, map_id, located },
			pathing::Error::MissingPath { id, located },
			pathing::Error::BadNaming { id, map_id, error: MSG },
			pathing::Error::NoSubdirectory { id, map_id, file_id: "file-id", at: 4, available: 2 },
			pathing::Error::NoPaths { id },
			pathing::Error::ConflictingPath { previous, current },
		]
	}
}
