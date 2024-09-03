/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{fmt, path::PathBuf};
use compact_str::CompactString;
use serde::{de, ser::SerializeMap, Serialize, Serializer, Deserialize, Deserializer};

pub(crate) fn is_bad(str: &str) -> Result<(), &'static str> {
	if str.is_empty() || str == "." || str == ".." || str.contains('/') || str.contains('\\')
		{ Err("strings cannot be '.', '..' or empty, nor contain '/' or '\\'") } else { Ok(()) }
}

pub struct Location { pub prefix: Prefix, pub path: CompactString }

#[derive(Clone, Copy, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Prefix {
	Custom, Temporary, Default,
	Cache, Config, Data, Home, LocalData, Preferences,
	Desktop, Documents, Downloads, Music, Pictures, Public, Templates, Videos,
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
		
		path.push(self.path.as_str());
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
				let (prefix, path) = map.next_entry()?.ok_or(de::Error::invalid_length(0, &self))?;
				Ok(Location { prefix, path })
			}
		}
		deserializer.deserialize_seq(Visitor)
	}
}

impl From<Prefix> for &str {
	fn from(value: Prefix) -> Self {
		match value {
			Prefix::Custom      => "custom",
			Prefix::Default     => "default",
			Prefix::Home        => "home",
			Prefix::Cache       => "cache",
			Prefix::Config      => "config",
			Prefix::Data        => "data",
			Prefix::LocalData   => "local-data",
			Prefix::Preferences => "preferences",
			Prefix::Desktop     => "desktop",
			Prefix::Documents   => "documents",
			Prefix::Downloads   => "downloads",
			Prefix::Music       => "music",
			Prefix::Pictures    => "pictures",
			Prefix::Public      => "public",
			Prefix::Templates   => "templates",
			Prefix::Videos      => "videos",
			Prefix::Temporary   => "temporary",
		}
	}
}

#[derive(Clone)]
pub struct Parsed<'c> {
	pub suggested_id: Option<&'c str>,
	pub     location: &'c Location,
	pub         file: Option<File<'c>>,
	pub          buf: PathBuf,
}

#[derive(Clone)]
pub struct File<'a> {
	pub file_id: &'a str,
	pub    file: &'a crate::mapping::File,
	pub  subdir: &'a str,
}

#[derive(Clone)]
pub struct ParsedFrom<'a> { pub id: &'a str, pub path: Parsed<'a> }

impl<'a> std::ops::Deref for ParsedFrom<'a> {
	type Target = Parsed<'a>;
	fn deref(&self) -> &Parsed<'a> { &self.path }
}

#[cfg(feature = "cli")]
use {std::io, crate::csi};

#[cfg(feature = "cli")]
pub fn show_location(out: &mut impl io::Write, location: &Location) -> io::Result<()> {
	if let Prefix::Custom = location.prefix {
		return write!(out, csi!(/fg yellow; "{:?}"!), location.path) // FIXME show_location
	}
	write!(out, csi!(/fg blue; "{{ {} = " /fg yellow; "{:?}" /fg blue; " }}"!),
	       <&str>::from(location.prefix), location.path)
}
