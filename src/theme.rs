/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{collections::BTreeMap, rc::Rc};
use compact_str::CompactString;
use serde::{Serialize, Deserialize};
use crate::{arrangement, cache, namespace, scheme, Value};

#[derive(Serialize, Deserialize)]
pub struct Theme {
	pub name: CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: CompactString,
	
	pub schemes: BTreeMap<CompactString, scheme::Scheme>,
	
	#[serde(default, skip_serializing_if = "BTreeMap::is_empty")]
	pub options: BTreeMap<CompactString, Value>,
}

impl Theme {
	pub fn scheme<'a>(&'a self,
	          id: &'a str,
	namespace_id: &'a str,
	       cache: &'a cache::Cache,
	      safety: arrangement::EngineSafety,
	) -> Result<&'a Rc<scheme::Static>, Error<'a>> {
		self.schemes.get(id)
			.ok_or(Error::NotFound { id })?
			.data(namespace_id, cache, &safety, &self.options)
			.map_err(|error| Error::Scheme { id, error })
	}
}

pub enum Error<'a> {
	NotFound { id: &'a str },
	  Scheme { id: &'a str, error: Box<scheme::Error<'a>> }
}

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl std::io::Write, id: &str) -> std::io::Result<i32> {
		writeln!(out, crate::csi!("In the theme " /fg yellow; "{:?}"!), id)?;
		match self {
			Self::NotFound { id } => {
				writeln!(out, crate::csi! {
					/fg blue; "[schemes." /fg red; "{:?}" /fg blue; ']'! " not found"
				}, id)?;
				
				Ok(exitcode::TEMPFAIL)
			}
			Self::Scheme { id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[schemes." /fg yellow; "{:?}" /fg blue; ']'! " failed"
				}, id)?;
				
				error.show(out)
			}
		}
	}
}

#[derive(Serialize, Deserialize)]
pub struct Request {
	#[serde(rename = "request")]
	params: Params,
	
	#[serde(default, skip_serializing_if = "arrangement::EngineSafety::is_default")]
	engine: arrangement::EngineSafety,
}

#[derive(Serialize, Deserialize)]
struct Params {
	#[serde(default, rename = "theme")]
	theme_id: CompactString,
	
	#[serde(rename = "scheme")]
	scheme_id: CompactString,
	
	#[serde(default, rename = "from")]
	namespace_id: CompactString,
}

pub(crate) fn list_schemes<'a>(
	      arrangement: &'a arrangement::Arrangement,
	       schemes_id: &'a str,
	main_namespace_id: &'a str,
	            cache: &'a cache::Cache,
	           safety: & arrangement::EngineSafety,
) -> Result<BTreeMap<&'a str, Rc<scheme::Static>>, Box<ListingError<'a>>> {
	let requests = arrangement.schemes.get(schemes_id)
		.ok_or(ListingError::NotFound { schemes_id })?;
	
	let mut schemes = BTreeMap::<&str, Rc<scheme::Static>>::new();
	
	for (id, request) in requests {
		let scheme = 'block: {
			let Params { theme_id, scheme_id, namespace_id } = &request.params;
			
			if scheme_id.is_empty() {
				break 'block Rc::clone(schemes.get(scheme_id as &str)
					.ok_or(ListingError::LocalNotFound { schemes_id, id, scheme_id })?)
			}
			
			let namespace_id = if namespace_id.is_empty()
				{ main_namespace_id } else { namespace_id };
			
			let (namespace, bin) = cache.namespace(namespace_id)
				.map_err(|error| ListingError::Cache { error, schemes_id })?;
			
			let theme = namespace.theme(theme_id, bin).map_err(|error|
				ListingError::GlobalNotFound { schemes_id, id, namespace_id, error })?;
			
			break 'block Rc::clone(
				theme.scheme(scheme_id, namespace_id, cache, request.engine.or(safety))
					.map_err(|error| ListingError::Theme { schemes_id, id, theme_id, error })?
			)
		};
		
		schemes.insert(id, scheme);
	}
	
	Ok(schemes)
}

pub enum ListingError<'a> {
      NotFound { schemes_id: &'a str },
 LocalNotFound { schemes_id: &'a str, id: &'a str, scheme_id: &'a str },
         Cache { schemes_id: &'a str, error: Box<cache::Error<'a>> },
GlobalNotFound { schemes_id: &'a str, id: &'a str, namespace_id: &'a str, error: Box<namespace::Error<'a>> },
         Theme { schemes_id: &'a str, id: &'a str, theme_id: &'a str, error: Error<'a> },
}

impl ListingError<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl std::io::Write) -> std::io::Result<i32> {
		match self {
			Self::NotFound { schemes_id } => {
				writeln!(out, crate::csi! {
					/fg blue; "[schemes." /fg red; "{:?}" /fg blue; ']'! " not found"
				}, schemes_id)?;
				
				Ok(exitcode::TEMPFAIL)
			}
			Self::LocalNotFound { schemes_id, id, scheme_id } => {
				writeln!(out, crate::csi! {
					/fg blue; "[schemes." /fg green; "{0:?}" /fg blue; '.' /fg yellow; "{1:?}" /fg blue; "]"! " requires "
					/fg blue; "[schemes." /fg green; "{0:?}" /fg blue; '.' /fg red;    "{2:?}" /fg blue; "]"!
				}, schemes_id, id, scheme_id)?;
				
				Ok(exitcode::CONFIG)
			}
			Self::Cache { schemes_id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[schemes." /fg yellow; "{:?}" /fg blue; "]"! " failed"
				}, schemes_id)?;
				
				error.show(out)
			}
			Self::GlobalNotFound { schemes_id, id, namespace_id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[schemes." /fg green; "{:?}" /fg blue; '.' /fg yellow; "{:?}" /fg blue; "]"! " failed"
				}, schemes_id, id)?;
				
				error.show(out, namespace_id)
			}
			Self::Theme { schemes_id, id, theme_id, error } => {
				writeln!(out, crate::csi! {
					"Request for " /fg blue; "[schemes." /fg green; "{:?}" /fg blue; '.' /fg yellow; "{:?}" /fg blue; "]"! " failed"
				}, schemes_id, id)?;
				
				error.show(out, theme_id)
			}
		}
	}
}
