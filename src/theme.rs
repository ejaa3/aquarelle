/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, collections::BTreeMap, rc::Rc};
use compact_str::CompactString;
use annotate_snippets::{Level, Message, Snippet};
use serde::{Serialize, Deserialize, Serializer, Deserializer};
use crate::{arrangement, cache, namespace, scheme, Key, Src, Spanned, Value};

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Theme {
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub   about: CompactString,
	pub    name: CompactString,
	pub schemes: BTreeMap<Key, Scheme>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub presets: BTreeMap<CompactString, Value>,
	
	#[serde(skip)]
	pub source: OnceCell<crate::Src>,
}

#[derive(Serialize, Deserialize)]
pub struct Scheme {
	#[serde(flatten)]
	pub data: Data,
	
	#[serde(default, skip_serializing_if = "Option::is_none")]
	pub request: Option<Request>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub options: BTreeMap<Key, Value>,
	
	#[serde(skip)]
	#[cfg(feature = "gui")]
	pub metadata: OnceCell<Box<dyn std::any::Any>>,
}

pub enum Data { Hard(Rc<scheme::Data>), Cell(OnceCell<Rc<scheme::Data>>) }

impl Serialize for Data {
	fn serialize<S: Serializer>(&self, serializer: S) -> Result<S::Ok, S::Error> {
		if let Data::Hard(data) = self { data.serialize(serializer) }
		else { serializer.serialize_none() }
	}
}

impl<'de> Deserialize<'de> for Data {
	fn deserialize<D: Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
		Ok(Rc::deserialize(deserializer).map(Data::Hard).unwrap_or(Data::Cell(OnceCell::new())))
	}
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
	#[serde(rename = "scheme")]
	pub scheme_id: Spanned,
	
	#[serde(default, rename = "from")]
	pub namespace_id: Option<Spanned>,
}

impl Theme {
	pub fn scheme<'a>(&'a self,
		       id:  &'a str,
		namespace: (&'a namespace::Namespace, &'a cache::Bin),
		    cache:  &'a cache::Cache,
		   safety:  &'a arrangement::EngineSafety,
	) -> Result<&'a Rc<scheme::Data>, Error<'a>> {
		let (scheme_id, scheme) = self.schemes.get_key_value(id).ok_or(Error::NotFound)?;
		
		let cell = match &scheme.data {
			Data::Hard(data) => return Ok(data),
			Data::Cell(cell) => cell,
		};
		
		if let Some(data) = cell.get() { return Ok(data) }
		
		let src = self.source.get().unwrap();
		
		let Request { scheme_id, namespace_id } = &scheme.request.as_ref()
			.ok_or(Error::NoRequest { src, scheme_id })?;
		
		let (namespace, bin) = namespace_id.as_ref().map_or(Ok(namespace),
			|namespace_id| cache.namespace(namespace_id.get_ref())
				.map_err(|error| Error::Cache { src, namespace_id, error }))?;
		
		let parametric = namespace.scheme(scheme_id.get_ref(), bin)
			.map_err(|error| Error::Namespace { src, scheme_id, error })?;
		
		let data = parametric.data(
			&scheme.options, &self.presets, src, Some(scheme_id), safety
		).map_err(|error| Error::Scheme { src, scheme_id, error })?;
		
		Ok(cell.get_or_init(|| Rc::from(data)))
	}
}

pub enum Error<'a> {
	 NotFound,
	NoRequest { src: &'a Src, scheme_id: &'a Spanned },
	    Cache { src: &'a Src, namespace_id: &'a Spanned, error: cache::Error<'a> },
	Namespace { src: &'a Src, scheme_id: &'a Spanned, error: Box<namespace::Error<'a>> },
	   Scheme { src: &'a Src, scheme_id: &'a Spanned, error: Box<scheme::Error<'a>> },
}

impl<'a, 'b> crate::Msg<'a, 'b, 4> for Error<'a> {
	fn msg(self, [cow_0, cow_1, cow_2, cow_3]: [&'b mut Cow<'a, str>; 4]) -> Message<'b> {
		match self {
			Self::NotFound => Level::Error.title("scheme not found"),
			Self::NoRequest { src, scheme_id } => {
				*cow_0 = src.1.to_string_lossy();
				
				Level::Error.title("scheme without colors or request")
					.snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
						.annotation(Level::Error.span(scheme_id.span()).label("this scheme")))
			}
			Self::Cache { src, namespace_id, error } => {
				let level = if let cache::Error::NotFound = error { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(namespace_id.span()).label("this requested namespace")))
			}
			Self::Namespace { src, scheme_id, error } => {
				let level = if let namespace::Of::NotFound = error.1 { Level::Error } else { Level::Warning };
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(level.span(scheme_id.span()).label("this requested scheme")))
			}
			Self::Scheme { src, scheme_id, error } => if let scheme::Error::Types {..} = &*error {
				error.msg([cow_0, cow_1, cow_2])
			} else {
				*cow_0 = src.1.to_string_lossy();
				
				error.msg([cow_1, cow_2, cow_3]).snippet(Snippet::source(&src.0).origin(cow_0).fold(true)
					.annotation(Level::Warning.span(scheme_id.span()).label("in this requested scheme")))
			}
		}
	}
}
