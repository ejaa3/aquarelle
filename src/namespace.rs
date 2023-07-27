/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::OnceCell, collections::BTreeMap, path::PathBuf};
use compact_str::CompactString;
use serde::{Serialize, Deserialize};
use crate::{arrangement::Arrangement, mapping::Map, cache::Bin, scheme, theme::Theme};

#[derive(Serialize, Deserialize)]
pub struct Namespace {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub arrangements: BTreeMap<CompactString, Item<CompactString, Arrangement>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub maps: BTreeMap<rhai::ImmutableString, Item<Paths, Map>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub schemes: BTreeMap<rhai::ImmutableString, Item<Paths, scheme::Dynamic>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub themes: BTreeMap<CompactString, Item<CompactString, Theme>>,
}

#[derive(Serialize, Deserialize)]
pub struct Paths { rhai: CompactString, toml: CompactString }

pub struct Item<P, V> { path: P, value: OnceCell<V>, }

impl<P: Serialize, V> Serialize for Item<P, V> {
	fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
	where S: serde::Serializer { self.path.serialize(serializer) }
}

impl<'de, P: Deserialize<'de>, V> Deserialize<'de> for Item<P, V> {
	fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		Ok(Item { path: P::deserialize(deserializer)?, value: OnceCell::new() })
	}
}

impl Namespace {
	pub fn arrangement<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&Arrangement, Box<Error>> {
		self.arrangements.get(id).ok_or(Error(Object::Arrangement, id, bin.local, Of::NotFound))?.get(id, bin)
	}
	
	pub fn map<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<(&rhai::ImmutableString, &Map), Box<Error>> {
		let (id, item) = self.maps.get_key_value(id).ok_or(Error(Object::Map, id, bin.local, Of::NotFound))?;
		
		item.get(id, bin).map(|map| (id, map))
	}
	
	pub fn scheme<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<(&rhai::ImmutableString, &scheme::Dynamic), Box<Error>> {
		let (id, item) = self.schemes.get_key_value(id).ok_or(Error(Object::Scheme, id, bin.local, Of::NotFound))?;
		item.get(id, bin).map(|scheme| (id, scheme))
	}
	
	pub fn theme<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&Theme, Box<Error>> {
		self.themes.get(id).ok_or(Error(Object::Theme, id, bin.local, Of::NotFound))?.get(id, bin)
	}
}

impl Item<CompactString, Arrangement> {
	pub fn get<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&Arrangement, Box<Error>> {
		if let Some(arrangement) = self.value.get() { return Ok(arrangement) }
		
		let path = bin.path.parent().unwrap().join(self.path.as_str());
		
		let toml = match std::fs::read_to_string(&path) {
			Ok(text) => text, Err(error) => return Err(Box::new(
				Error(Object::Arrangement, id, bin.local, Of::Io(path, error))
			))
		};
		
		let value = toml_edit::de::from_str(&toml).map_err(|error| Box::new(
			Error(Object::Arrangement, id, bin.local, Of::De(path, Box::new(error)))
		))?;
		
		Ok(self.value.get_or_init(|| value))
	}
}

impl Item<Paths, Map> {
	pub fn get<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&Map, Box<Error>> {
		if let Some(map) = self.value.get() { return Ok(map) }
		
		let mut path = bin.path.parent().unwrap().join(self.path.toml.as_str());
		
		let toml = match std::fs::read_to_string(&path) {
			Ok(text) => text, Err(error) => return Err(Box::new(
				Error(Object::Map, id, bin.local, Of::Io(path, error))
			))
		};
		
		let mut map: Map = match toml_edit::de::from_str(&toml) {
			Ok(map) => map, Err(error) => return Err(Box::new(
				Error(Object::Map, id, bin.local, Of::De(path, Box::new(error)))
			))
		};
		
		path.clear();
		path.push(bin.path.parent().unwrap());
		path.push(self.path.rhai.as_str());
		
		map.script_path = Some(path.into());
		Ok(self.value.get_or_init(|| map))
	}
}

impl Item<Paths, scheme::Dynamic> {
	pub fn get<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&scheme::Dynamic, Box<Error>> {
		if let Some(scheme) = self.value.get() { return Ok(scheme) }
		
		let mut path = bin.path.parent().unwrap().join(self.path.toml.as_str());
		
		let toml = match std::fs::read_to_string(&path) {
			Ok(text) => text, Err(error) => return Err(Box::new(
				Error(Object::Scheme, id, bin.local, Of::Io(path, error))
			))
		};
		
		let mut scheme: scheme::Dynamic = match toml_edit::de::from_str(&toml) {
			Ok(scheme) => scheme, Err(error) => return Err(Box::new(
				Error(Object::Scheme, id, bin.local, Of::De(path, Box::new(error)))
			))
		};
		
		path.clear();
		path.push(bin.path.parent().unwrap());
		path.push(self.path.rhai.as_str());
		
		scheme.script_path = Some(path.into());
		Ok(self.value.get_or_init(|| scheme))
	}
}

impl Item<CompactString, Theme> {
	pub fn get<'a>(&'a self, id: &'a str, bin: &'a Bin) -> Result<&Theme, Box<Error>> {
		if let Some(theme) = self.value.get() { return Ok(theme) }
		
		let path = bin.path.parent().unwrap().join(self.path.as_str());
		
		let toml = match std::fs::read_to_string(&path) {
			Ok(text) => text, Err(error) => return Err(Box::new(
				Error(Object::Theme, id, bin.local, Of::Io(path, error))
			))
		};
		
		let theme = toml_edit::de::from_str(&toml).map_err(|error| Box::new(
			Error(Object::Theme, id, bin.local, Of::De(path, Box::new(error)), )
		))?;
		
		Ok(self.value.get_or_init(|| theme))
	}
}

pub struct Error<'a>(pub Object, pub &'a str, pub bool, pub Of);

pub enum Of { Io(PathBuf, std::io::Error), De(PathBuf, Box<toml_edit::de::Error>), NotFound }

#[derive(Clone, Copy)]
pub enum Object { Arrangement, Map, Scheme, Theme }

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl std::io::Write, at: &str) -> std::io::Result<i32> {
		let Self(object, id, local, of) = self;
		
		let object = match object {
			Object::Arrangement => ("arrangement", "Arrangement"),
			Object::Map => ("map", "Map"),
			Object::Scheme => ("scheme", "Scheme"),
			Object::Theme => ("theme", "Theme"),
		};
		
		match of {
			Of::Io(path, error) => {
				write!(out, crate::csi! {
					"In the {} namespace " /fg yellow; "{:?}"! "\n"
					"Unable to read {} " /fg red; "{:?}"! " from\n" /fg cyan; "{}"! "\n{}\n"
				}, crate::location(local), at, object.0, id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::NOINPUT)
			}
			Of::De(path, error) => {
				write!(out, crate::csi! {
					"In the {} namespace " /fg yellow; "{:?}"! "\n"
					"Failed to deserialize {} " /fg red; "{:?}"! " from\n" /fg cyan; "{}"! "\n\n{}"
				}, crate::location(local), at, object.0, id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::DATAERR)
			}
			Of::NotFound => {
				writeln!(out, crate::csi! {
					"In the {} namespace " /fg green; "{:?}"! "\n{} " /fg red; "{:?}"! " not found"
				}, crate::location(local), at, object.1, id)?;
				
				Ok(exitcode::UNAVAILABLE)
			}
		}
	}
}
