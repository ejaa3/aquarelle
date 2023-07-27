/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{fmt, path::PathBuf};
use serde::{Serialize, Deserialize, Serializer, Deserializer, ser::SerializeMap, de};

pub(crate) fn is_bad(str: &str) -> Result<(), &'static str> {
	if str.is_empty() || str == "." || str == ".." || str.contains('/') || str.contains('\\')
		{ Err("Strings cannot be '.', '..' or empty, nor contain '/' or '\\'") } else { Ok(()) }
}

pub struct Located { pub location: Location, pub path: String }

impl Located {
	pub fn to_path_buf(&self, default: Option<&PathBuf>) -> Option<PathBuf> {
		let mut path = match self.location {
			Location::None      => PathBuf::new(),
			Location::Temporary => std::env::temp_dir(),
			Location::Default   => default.cloned()?,
			
			Location::Cache       => dirs::cache_dir()?,
			Location::Config      => dirs::config_dir()?,
			Location::Data        => dirs::data_dir()?,
			Location::Home        => dirs::home_dir()?,
			Location::LocalData   => dirs::data_local_dir()?,
			Location::Preferences => dirs::preference_dir()?,
			
			Location::Desktop     => dirs::desktop_dir()?,
			Location::Documents   => dirs::document_dir()?,
			Location::Downloads   => dirs::download_dir()?,
			Location::Music       => dirs::audio_dir()?,
			Location::Pictures    => dirs::picture_dir()?,
			Location::Public      => dirs::public_dir()?,
			Location::Templates   => dirs::template_dir()?,
			Location::Videos      => dirs::video_dir()?,
		};
		
		path.push(self.path.as_str());
		Some(path)
	}
}

impl Serialize for Located {
	fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		if let Location::None = self.location {
			self.path.serialize(serializer)
		} else {
			let mut map = serializer.serialize_map(Some(1))?;
			map.serialize_entry(<&str>::from(self.location), &self.path)?;
			map.end()
		}
	}
}

impl<'de> Deserialize<'de> for Located {
	fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		struct Visitor;
		
		impl<'de> de::Visitor<'de> for Visitor {
			type Value = Located;
			
			fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
				formatter.write_str("a path string, or a localized path such as `{ location = 'path/string' }`")
			}
			
			fn visit_str<E>(self, value: &str) -> Result<Self::Value, E> where E: de::Error {
				Ok(Located { location: Location::None, path: value.to_owned() })
			}
			
			fn visit_string<E>(self, path: String) -> Result<Self::Value, E> where E: de::Error {
				Ok(Located { location: Location::None, path })
			}
			
			fn visit_map<A>(self, mut map: A) -> Result<Self::Value, A::Error> where A: de::MapAccess<'de> {
				let (location, path) = map.next_entry()?.ok_or(de::Error::invalid_length(0, &self))?;
				Ok(Located { location, path })
			}
		}
		deserializer.deserialize_seq(Visitor)
	}
}

#[derive(Copy, Clone, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Location {
	#[serde(skip)]
	None, Temporary, Default,
	
	Cache, Config, Data, Home, LocalData, Preferences,
	
	Desktop, Documents, Downloads, Music,
	Pictures, Public, Templates, Videos
}

impl From<Location> for &str {
	fn from(value: Location) -> Self {
		match value {
			Location::None        => unreachable!(),
			Location::Default     => "default",
			Location::Home        => "home",
			Location::Cache       => "cache",
			Location::Config      => "config",
			Location::Data        => "data",
			Location::LocalData   => "local-data",
			Location::Preferences => "preferences",
			Location::Desktop     => "desktop",
			Location::Documents   => "documents",
			Location::Downloads   => "downloads",
			Location::Music       => "music",
			Location::Pictures    => "pictures",
			Location::Public      => "public",
			Location::Templates   => "templates",
			Location::Videos      => "videos",
			Location::Temporary   => "temporary",
		}
	}
}

#[derive(Clone)]
pub struct Parsed<'c> {
	pub suggested_id: Option<&'c str>,
	pub      located: &'c Located,
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
pub fn show_located(out: &mut impl io::Write, path: &Located) -> io::Result<()> {
	if let Location::None = path.location {
		return write!(out, csi!(/fg yellow; "{:?}"!), path.path)
	}
	write!(out, csi!(/fg blue; "{{ {} = " /fg yellow; "{:?}" /fg blue; " }}"!),
	       <&str>::from(path.location), path.path)
}
