/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::OnceCell, collections::BTreeMap, path};
use compact_str::CompactString;
use crate::{config::{PREFIX_DIR, DATA_DIR, APP}, namespace::Namespace};

pub struct Cache { pub namespaces: BTreeMap<CompactString, Bin> }

pub struct Bin {
	pub local: bool,
	     data: OnceCell<Namespace>,
	pub  path: path::PathBuf,
}

impl Cache {
	pub fn new(mut handle: impl FnMut(ScanError)) -> Self {
		let mut namespaces = BTreeMap::new();
		
		let system_path = &[PREFIX_DIR, DATA_DIR, APP].iter().collect::<path::PathBuf>();
		let  local_path = &mut dirs::data_dir().unwrap(); local_path.push(APP);
		
		for (local, path) in [(false, system_path), (true, local_path)] {
			match std::fs::read_dir(path) {
				Ok(entries) => for entry in entries {
					let entry = match entry {
						Ok(entry) => entry, Err(error) => {
							handle(ScanError::Entry { local, path, error });
							continue
						}
					};
					
					let mut path = entry.path(); path.push("Aquarelle.toml");
					let name = entry.file_name();
					
					let Some(name) = name.to_str() else {
						handle(ScanError::Unicode { local, path: &path });
						continue
					};
					
					namespaces.insert(name.into(), Bin { path, local, data: OnceCell::new() });
				}
				Err(error) => handle(ScanError::Path { local, path, error })
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
			.map_err(|error| Error::Io(self.local, id, &self.path, error))?;
		
		let data = toml_edit::de::from_str::<Namespace>(&toml)
			.map_err(|error| Error::De(self.local, id, &self.path, Box::new(error)))?;
		
		Ok(self.data.get_or_init(|| data))
	}
}

#[cfg(feature = "cli")]
use {std::io, crate::{csi, location}};

pub enum ScanError<'a> {
	   Path { local: bool, path: &'a path::Path, error: std::io::Error },
	  Entry { local: bool, path: &'a path::Path, error: std::io::Error },
	Unicode { local: bool, path: &'a path::Path },
}

impl ScanError<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl io::Write) -> io::Result<()> {
		match self {
			Self::Path { local, path, error } => {
				crate::warn(out, !local)?;
				writeln!(out, csi! {
					"Unable to read {} namespaces path at\n" /fg cyan; "{}"! "\n{}"
				}, location(local), path.to_string_lossy(), error)
			}
			Self::Entry { local, path, error } => {
				crate::warn(out, true)?;
				writeln!(out, csi! {
					"Unable to read {} namespace entry at\n" /fg cyan; "{}"! "\n{}"
				}, location(local), path.to_string_lossy(), error)
			}
			Self::Unicode { local, path } => {
				crate::warn(out, true)?;
				writeln!(out, csi! {
					"Invalid Unicode {} namespace directory name for\n" /fg cyan; "{}"!
				}, location(local), path.to_string_lossy())
			}
		}
	}
}

pub enum Error<'a> {
	Io(bool, &'a str, &'a path::Path, std::io::Error),
	De(bool, &'a str, &'a path::Path, Box<toml_edit::de::Error>),
	NotFound { id: &'a str },
}

impl Error<'_> {
	#[cfg(feature = "cli")]
	pub fn show(self, out: &mut impl io::Write) -> io::Result<i32> {
		match self {
			Self::Io(local, id, path, error) => {
				writeln!(out, csi! {
					"Unable to read {} namespace " /fg red; "{:?}"!
					" from\n" /fg cyan; "{}"! "\n{}"!
				}, location(local), id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::NOINPUT)
			}
			Self::De(local, id, path, error) => {
				write!(out, csi! {
					"Failed to deserialize {} namespace " /fg red; "{:?}"!
					" from\n" /fg cyan; "{}"! "\n\n{}"!
				}, location(local), id, path.to_string_lossy(), error)?;
				
				Ok(exitcode::DATAERR)
			}
			Self::NotFound { id } => {
				writeln!(out, csi!("No namespace " /fg red; "{:?}"! " was found"), id)?;
				Ok(exitcode::UNAVAILABLE)
			}
		}
	}
}
