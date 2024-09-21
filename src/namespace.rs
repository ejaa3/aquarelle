/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, collections::BTreeMap, rc::Rc, path::PathBuf};
use compact_str::CompactString;
use serde::{de, Serialize, Deserialize, Serializer, Deserializer};
use annotate_snippets::{Level, Message, Snippet};
use crate::Spanned;
use crate::{arrangement::Arrangement, cache::Bin, mapping::Map};
use crate::{scheme::Parametric, theme::Theme, Key};

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Namespace {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub arrangements: BTreeMap<Key, Item<Arrangement>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub maps: BTreeMap<Key, Item<Map>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub schemes: BTreeMap<Key, Item<Parametric>>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub themes: BTreeMap<Key, Item<Theme>>,
	
	#[serde(skip)]
	pub source: Option<Rc<Cow<'static, str>>>,
}

pub enum Item<V> { Data(V), Path { path: CompactString, cell: OnceCell<V> } }

impl<V: Serialize> Serialize for Item<V> {
	fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		match self {
			Item::Data(value) => value.serialize(serializer),
			Item::Path { path, .. } => path.serialize(serializer),
		}
	}
}

impl<'de, T: Deserialize<'de>> Deserialize<'de> for Item<T> {
	fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		struct Visitor<T>(std::marker::PhantomData<T>);
		
		impl<'de, T: Deserialize<'de>> de::Visitor<'de> for Visitor<T> {
			type Value = Item<T>;
		
			fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
				write!(formatter, "algo")
			}
			
			fn visit_str<E: de::Error>(self, path: &str) -> Result<Item<T>, E> {
				Ok(Item::Path { path: CompactString::from(path), cell: OnceCell::new() })
			}
			
			fn visit_string<E: de::Error>(self, path: String) -> Result<Item<T>, E> {
				Ok(Item::Path { path: CompactString::from(path), cell: OnceCell::new() })
			}
			
			fn visit_map<A: de::MapAccess<'de>>(self, map: A) -> Result<Item<T>, A::Error> {
				T::deserialize(de::value::MapAccessDeserializer::new(map)).map(Item::Data)
			}
			
		}
		deserializer.deserialize_map(Visitor(std::marker::PhantomData))
	}
}

impl Namespace {
	pub fn arrangement<'a>(&'a self, id: &str, bin: &'a Bin) -> Result<&Arrangement, Box<Error>> {
		let source = self.source.as_ref().unwrap();
		let (id, item) = self.arrangements.get_key_value(id).ok_or(Error(Object::Arrangement, Of::NotFound, bin, source))?;
		item.get(&id.0, bin, source)
	}
	
	pub fn map<'a>(&'a self, id: &str, bin: &'a Bin) -> Result<(&Key, &Map), Box<Error>> {
		let source = self.source.as_ref().unwrap();
		let (id, item) = self.maps.get_key_value(id).ok_or(Error(Object::Map, Of::NotFound, bin, source))?;
		item.get(&id.0, bin, source).map(|map| (id, map))
	}
	
	pub fn scheme<'a>(&'a self, id: &str, bin: &'a Bin) -> Result<&Parametric, Box<Error>> {
		let source = self.source.as_ref().unwrap();
		let (id, item) = self.schemes.get_key_value(id).ok_or(Error(Object::Scheme, Of::NotFound, bin, source))?;
		item.get(&id.0, bin, source)
	}
	
	pub fn theme<'a>(&'a self, id: &str, bin: &'a Bin) -> Result<&Theme, Box<Error>> {
		let source = self.source.as_ref().unwrap();
		let (id, item) = self.themes.get_key_value(id).ok_or(Error(Object::Theme, Of::NotFound, bin, source))?;
		item.get(&id.0, bin, source)
	}
}

trait Gettable {
	const OBJECT: Object;
	fn init(&self, source: &Rc<Cow<'static, str>>, path: &Rc<PathBuf>);
	fn  set(&mut self, source: Rc<Cow<'static, str>>, path: Rc<PathBuf>);
}

impl Gettable for Arrangement {
	const OBJECT: Object = Object::Arrangement;
	
	fn init(&self, source: &Rc<Cow<'static, str>>, path: &Rc<PathBuf>)
		{ self.source.get_or_init(|| (Rc::clone(source), Rc::clone(path))); }
	
	fn set(&mut self, source: Rc<Cow<'static, str>>, path: Rc<PathBuf>)
		{ self.source = OnceCell::from((source, path)); }
}

impl Gettable for Map {
	const OBJECT: Object = Object::Map;
	
	fn init(&self, source: &Rc<Cow<'static, str>>, path: &Rc<PathBuf>)
		{ self.source.get_or_init(|| (Rc::clone(source), Rc::clone(path))); }
	
	fn set(&mut self, source: Rc<Cow<'static, str>>, path: Rc<PathBuf>) {
		self.source = OnceCell::from((source, path));
	}
}

impl Gettable for Parametric {
	const OBJECT: Object = Object::Scheme;
	
	fn init(&self, source: &Rc<Cow<'static, str>>, path: &Rc<PathBuf>)
		{ self.source.get_or_init(|| (Rc::clone(source), Rc::clone(path))); }
	
	fn set(&mut self, source: Rc<Cow<'static, str>>, path: Rc<PathBuf>) {
		self.source = OnceCell::from((source, path));
	}
}

impl Gettable for Theme {
	const OBJECT: Object = Object::Theme;
	
	fn init(&self, source: &Rc<Cow<'static, str>>, path: &Rc<PathBuf>)
		{ self.source.get_or_init(|| (Rc::clone(source), Rc::clone(path))); }
	
	fn set(&mut self, source: Rc<Cow<'static, str>>, path: Rc<PathBuf>)
		{ self.source = OnceCell::from((source, path)); }
}

#[allow(private_bounds)]
impl<V: for<'de> Deserialize<'de> + Gettable> Item<V> {
	pub fn get<'a>(
		&'a self, id: &'a Spanned, bin: &'a Bin, source: &'a Rc<Cow<'static, str>>
	) -> Result<&V, Box<Error>> {
		let (path, cell) = match self {
			Item::Data(value) => {
				value.init(source, &bin.path);
				return Ok(value)
			}
			Item::Path { path, cell: value } => (path, value),
		};
		
		if let Some(value) = cell.get() { return Ok(value) }
		
		let pat = bin.path.parent().unwrap().join(path as &str);
		
		let item_source = match std::fs::read_to_string(&pat) {
			Ok(text) => text, Err(error) => return Err(Box::new(
				Error(V::OBJECT, Of::Io(id, error), bin, source)
			))
		};
		
		let mut value: V = match toml::de::from_str(&item_source) {
			Ok(map) => map, Err(error) => return Err(Box::new(
				Error(V::OBJECT, Of::De(id, error), bin, source)
			))
		};
		
		value.set(Rc::from(Cow::Owned(item_source)), Rc::from(pat));
		Ok(cell.get_or_init(|| value))
	}
}

pub struct Error<'a>(pub Object, pub Of<'a>, pub &'a Bin, pub &'a str);

pub enum Of<'a> { Io(&'a Spanned, std::io::Error), De(&'a Spanned, toml::de::Error), NotFound }

#[derive(Clone, Copy)]
pub enum Object { Arrangement, Map, Scheme, Theme }

impl<'a, 'b> crate::Msg<'a, 'b, 2> for Error<'a> {
	fn msg(self, [cow_0, cow_1]: [&'b mut Cow<'a, str>; 2]) -> Message<'b> {
		let Self(object, of, bin, source) = self;
		
		macro_rules! title {
			($left:literal, $right:literal) => (match object {
				Object::Arrangement => concat!($left, "arrangement", $right),
				Object::Map => concat!($left, "map", $right),
				Object::Scheme => concat!($left, "parametric scheme", $right),
				Object::Theme => concat!($left, "theme", $right),
			})
		}
		
		let this = title!("this ", "");
		
		match of {
			Of::Io(path, error) => {
				(*cow_0, *cow_1) = (bin.path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Error.title(title!("unable to read ", ""))
					.snippet(Snippet::source(source).origin(cow_0).fold(true)
						.annotation(Level::Error.span(path.span()).label(this)))
					.footer(Level::Info.title(cow_1))
			}
			Of::De(path, error) => {
				(*cow_0, *cow_1) = (bin.path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Error.title(title!("failed to deserialize ", ""))
					.snippet(Snippet::source(source).origin(cow_0).fold(true)
						.annotation(Level::Error.span(path.span()).label(this)))
					.footer(Level::Info.title(cow_1))
			}
			Of::NotFound => {
				*cow_0 = bin.path.to_string_lossy();
				
				Level::Error.title(title!("", " not found"))
					.footer(Level::Info.title(cow_0))
			}
		}
	}
}
