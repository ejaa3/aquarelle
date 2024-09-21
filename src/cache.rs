/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, collections::BTreeMap, path, rc::Rc};
use annotate_snippets::{Level, Message};
use compact_str::CompactString;
use crate::{config::{PREFIX_DIR, DATA_DIR, APP}, namespace::Namespace};

#[derive(Default)]
pub struct Cache { pub namespaces: BTreeMap<CompactString, Bin> }

pub struct Bin {
	pub user: bool,
	pub data: OnceCell<Namespace>,
	pub path: Rc<path::PathBuf>,
}

pub fn system_path() -> path::PathBuf { [PREFIX_DIR, DATA_DIR, APP].iter().collect() }
pub fn   user_path() -> path::PathBuf {
	let mut path = dirs::data_dir().unwrap(); path.push(APP); path
}

impl Cache {
	pub fn update(&mut self, mut handle: impl FnMut(ScanError) -> bool) {
		for (user, path) in [(false, &system_path()), (true, &user_path())] {
			match std::fs::read_dir(path) {
				Ok(entries) => for entry in entries {
					let entry = match entry {
						Ok(entry) => entry, Err(error) => {
							if handle(ScanError::Entry { user, path, error })
								{ continue } else { return }
						}
					};
					
					let mut path = entry.path(); path.push("Aquarelle.toml");
					let name = entry.file_name();
					
					let Some(name) = name.to_str() else {
						if handle(ScanError::Unicode { user, path: &path })
							{ continue } else { return }
					};
					
					self.namespaces.insert(name.into(), Bin {
						path: Rc::from(path), user, data: OnceCell::new()
					});
				}
				Err(error) => if handle(ScanError::Path { user, path, error })
					{ continue } else { return }
			}
		}
	}
	
	pub fn namespace<'a>(&'a self, id: &'a str) -> Result<(&Namespace, &Bin), Error> {
		let bin = self.namespaces.get(id).ok_or(Error::NotFound)?;
		Ok((bin.get()?, bin))
	}
}

impl Bin {
	pub fn get(&self) -> Result<&Namespace, Error> {
		if let Some(data) = self.data.get() { return Ok(data) }
		
		let source = std::fs::read_to_string(self.path.as_path())
			.map_err(|error| Error::Io(self.user, &self.path, error))?;
		
		let mut namespace = toml::de::from_str::<Namespace>(&source)
			.map_err(|error| Error::De(self.user, &self.path, Box::from(error)))?;
		
		namespace.source = Some(std::rc::Rc::from(Cow::Owned(source)));
		
		Ok(self.data.get_or_init(|| namespace))
	}
}

pub enum ScanError<'a> {
	   Path { user: bool, path: &'a path::Path, error: std::io::Error },
	  Entry { user: bool, path: &'a path::Path, error: std::io::Error },
	Unicode { user: bool, path: &'a path::Path },
}

macro_rules! title {
	($left:literal, $user:ident, $right:literal) => (match $user {
		true => concat!($left, " user ", $right),
		_    => concat!($left, " system ", $right)
	})
}

impl<'a, 'b> crate::Msg<'a, 'b, 2> for ScanError<'a> {
	fn msg(self, [cow_0, cow_1]: [&'b mut Cow<'a, str>; 2]) -> Message<'b> {
		match self {
			Self::Path { user, path, error } => {
				(*cow_0, *cow_1) = (path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Warning.title(title!("unable to read", user, "namespaces path"))
					.footer(Level::Info .title(cow_0)).footer(Level::Error.title(cow_1))
			}
			Self::Entry { user, path, error } => {
				(*cow_0, *cow_1) = (path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Warning.title(title!("unable to read path to a", user, "namespace"))
					.footer(Level::Info .title(cow_0)).footer(Level::Error.title(cow_1))
			}
			Self::Unicode { user, path } => {
				*cow_0 = path.to_string_lossy();
				
				Level::Warning.title(title!("invalid Unicode", user, "namespace directory name"))
					.footer(Level::Info.title(cow_0))
			}
		}
	}
}

pub enum Error<'a> {
	Io(bool, &'a path::Path, std::io::Error),
	De(bool, &'a path::Path, Box<toml::de::Error>),
	NotFound,
}

impl<'a ,'b> crate::Msg<'a, 'b, 2> for Error<'a> {
	fn msg(self, [cow_0, cow_1]: [&'b mut Cow<'a, str>; 2]) -> Message<'b> {
		match self {
			Self::Io(user, path, error) => {
				(*cow_0, *cow_1) = (path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Warning.title(title!("unable to read", user, "namespace"))
					.footer(Level::Info.title(cow_0)).footer(Level::Error.title(cow_1))
			}
			Self::De(user, path, error) => {
				(*cow_0, *cow_1) = (path.to_string_lossy(), Cow::Owned(error.to_string()));
				
				Level::Warning.title(title!("failed to deserialize", user, "namespace"))
					.footer(Level::Info.title(cow_0)).footer(Level::Error.title(cow_1))
			}
			Self::NotFound => Level::Error.title("namespace not found")
		}
	}
}
