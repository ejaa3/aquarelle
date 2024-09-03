/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::OnceCell, collections::BTreeMap, path};
use compact_str::CompactString;
use crate::{config::{PREFIX_DIR, DATA_DIR, APP}, namespace::Namespace};

pub struct Cache { pub namespaces: BTreeMap<CompactString, Bin> }

pub struct Bin {
	pub user: bool,
	    data: OnceCell<Namespace>,
	pub path: path::PathBuf,
}

pub fn system_path() -> path::PathBuf { [PREFIX_DIR, DATA_DIR, APP].iter().collect() }
pub fn   user_path() -> path::PathBuf {
	let mut path = dirs::data_dir().unwrap(); path.push(APP); path
}

impl Cache {
	pub fn new(mut handle: impl FnMut(ScanError)) -> Self {
		let mut namespaces = BTreeMap::new();
		
		for (user, path) in [(false, &system_path()), (true, &user_path())] {
			match std::fs::read_dir(path) {
				Ok(entries) => for entry in entries {
					let entry = match entry {
						Ok(entry) => entry, Err(error) => {
							handle(ScanError::Entry { user, path, error });
							continue
						}
					};
					
					let mut path = entry.path(); path.push("Aquarelle.toml");
					let name = entry.file_name();
					
					let Some(name) = name.to_str() else {
						handle(ScanError::Unicode { user, path: &path });
						continue
					};
					
					namespaces.insert(name.into(), Bin { path, user, data: OnceCell::new() });
				}
				Err(error) => handle(ScanError::Path { user, path, error })
			}
		}
		
		Cache { namespaces }
	}
	
	pub fn namespace<'a>(&'a self, id: &'a str) -> Result<(&Namespace, &Bin), Box<Error>> {
		let bin = self.namespaces.get(id).ok_or(Error::NotFound { id })?;
		Ok((bin.get(id)?, bin))
	}
}

impl Bin {
	pub fn get<'a>(&'a self, id: &'a str) -> Result<&Namespace, Box<Error>> {
		if let Some(data) = self.data.get() { return Ok(data) }
		
		let toml = std::fs::read_to_string(&self.path)
			.map_err(|error| Error::Io(self.user, id, &self.path, error))?;
		
		let data = toml::de::from_str::<Namespace>(&toml)
			.map_err(|error| Error::De(self.user, id, &self.path, Box::from(error)))?;
		
		Ok(self.data.get_or_init(|| data))
	}
}

#[cfg(feature = "cli")]
use {std::io, crate::{csi, location}};

pub enum ScanError<'a> {
	   Path { user: bool, path: &'a path::Path, error: std::io::Error },
	  Entry { user: bool, path: &'a path::Path, error: std::io::Error },
	Unicode { user: bool, path: &'a path::Path },
}

impl ScanError<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl io::Write) -> io::Result<()> {
		match self {
			Self::Path { user, path, error } => {
				crate::warn(out, !user)?;
				writeln!(out, csi! {
					"Unable to read {} namespaces path at\n" /fg cyan; "{}"! "\n{}"
				}, location(user), path.to_string_lossy(), error)
			}
			Self::Entry { user, path, error } => {
				crate::warn(out, true)?;
				writeln!(out, csi! {
					"Unable to read {} namespace entry at\n" /fg cyan; "{}"! "\n{}"
				}, location(user), path.to_string_lossy(), error)
			}
			Self::Unicode { user, path } => {
				crate::warn(out, true)?;
				writeln!(out, csi! {
					"Invalid Unicode {} namespace directory name for\n" /fg cyan; "{}"!
				}, location(user), path.to_string_lossy())
			}
		}
	}
}

pub enum Error<'a> {
	Io(bool, &'a str, &'a path::Path, std::io::Error),
	De(bool, &'a str, &'a path::Path, Box<toml::de::Error>),
	NotFound { id: &'a str },
}

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl io::Write) -> io::Result<i32> {
		match self {
			Self::Io(user, id, path, error) => {
				writeln!(out, csi! {
					"Unable to read {} namespace " /fg red; "{:?}"!
					" from\n" /fg cyan; "{}"! "\n{}"!
				}, location(user), id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::NOINPUT)
			}
			Self::De(user, id, path, error) => {
				write!(out, csi! {
					"Failed to deserialize {} namespace " /fg red; "{:?}"!
					" from\n" /fg cyan; "{}"! "\n\n{}"!
				}, location(user), id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::DATAERR)
			}
			Self::NotFound { id } => {
				writeln!(out, csi!("No namespace " /fg red; "{:?}"! " was found"), id)?;
				Ok(exitcode::UNAVAILABLE)
			}
		}
	}
}
