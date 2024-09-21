/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{fmt, path::PathBuf};
use compact_str::CompactString;
use serde::{de, ser::SerializeMap, Deserialize, Deserializer, Serialize, Serializer};

#[derive(Clone)]
pub struct Parsed<'a> {
	pub        id: &'a crate::Spanned,
	pub    source: &'a crate::Src,
	pub  location: &'a crate::Spanned<Location>,
	pub   map_src: &'a crate::Src,
	pub file_name: Option<&'a crate::Spanned>,
	pub       buf: std::rc::Rc<PathBuf>,
}

pub struct Location { pub prefix: Prefix, pub path: CompactString }

#[derive(Clone, Copy, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Prefix {
	Custom, Temporary, Default,
	Cache, Config, Data, Home, LocalData, Preferences,
	Desktop, Documents, Downloads, Music, Pictures, Public, Templates, Videos,
}

const PREFIXES: [&str; 17] = [
	"custom", "temporary", "default",
	"cache", "config", "data", "home", "local-data", "preferences",
	"desktop", "documents", "downloads", "music", "pictures", "public", "templates", "videos"
];

impl From<Prefix> for &str {
	fn from(prefix: Prefix) -> Self { PREFIXES[prefix as usize] }
}

impl Location {
	pub fn to_path_buf(&self, default: Option<&PathBuf>) -> Option<PathBuf> {
		let mut path = match self.prefix {
			Prefix::Custom      => PathBuf::new(),
			Prefix::Temporary   => std::env::temp_dir(),
			Prefix::Default     => default.cloned()?,
			Prefix::Cache       => dirs::cache_dir()?,
			Prefix::Config      => dirs::config_dir()?,
			Prefix::Data        => dirs::data_dir()?,
			Prefix::Home        => dirs::home_dir()?,
			Prefix::LocalData   => dirs::data_local_dir()?,
			Prefix::Preferences => dirs::preference_dir()?,
			Prefix::Desktop     => dirs::desktop_dir()?,
			Prefix::Documents   => dirs::document_dir()?,
			Prefix::Downloads   => dirs::download_dir()?,
			Prefix::Music       => dirs::audio_dir()?,
			Prefix::Pictures    => dirs::picture_dir()?,
			Prefix::Public      => dirs::public_dir()?,
			Prefix::Templates   => dirs::template_dir()?,
			Prefix::Videos      => dirs::video_dir()?,
		};
		
		path.push(&self.path as &str);
		Some(path)
	}
}

impl Serialize for Location {
	fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		if let Prefix::Custom = self.prefix {
			self.path.serialize(serializer)
		} else {
			let mut map = serializer.serialize_map(Some(1))?;
			map.serialize_entry(<&str>::from(self.prefix), &self.path)?;
			map.end()
		}
	}
}

impl<'de> Deserialize<'de> for Location {
	fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		struct Visitor;
		
		impl<'de> de::Visitor<'de> for Visitor {
			type Value = Location;
			
			fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
				formatter.write_str("a path string, or a localized path such as `{ prefix = 'path/string' }`")
			}
			
			fn visit_str<E: de::Error>(self, value: &str) -> Result<Self::Value, E> {
				Ok(Location { prefix: Prefix::Custom, path: CompactString::from(value) })
			}
			
			fn visit_string<E: de::Error>(self, path: String) -> Result<Self::Value, E> {
				Ok(Location { prefix: Prefix::Custom, path: CompactString::from(path) })
			}
			
			fn visit_map<A: de::MapAccess<'de>>(self, mut map: A) -> Result<Self::Value, A::Error> {
				let (prefix, path) = map.next_entry()?.ok_or(de::Error::unknown_variant("", &PREFIXES))?; // NOTE ""
				Ok(Location { prefix, path })
			}
			
			/* fn visit_enum<A: de::EnumAccess<'de>>(self, data: A) -> Result<Self::Value, A::Error> {
				let (prefix, access): (Prefix, _) = data.variant()?;
				Ok(Location { prefix, path: access.newtype_variant()? })
			} */
		}
		deserializer.deserialize_map(Visitor) // deserialize_enum("Location", &PREFIXES, Visitor)
	}
}

pub(crate) fn check_name<S: AsRef<str>, E>(name: S, error: E) -> Result<S, E> {
	let n = name.as_ref();
	(n != "." || n != ".." || !n.contains('/')|| !n.contains('\\')).then_some(name).ok_or(error)
}

pub(crate) const BAD_NAME: &str = r"the name cannot be `.` or `..`, nor contain `/` or `\`.";
