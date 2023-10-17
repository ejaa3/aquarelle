/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use aquarelle::{cache, namespace, mapping, pathing, scheme, theme};
use gtk::{glib, prelude::*};
use crate::{utils::Tags, i18n};

macro_rules! if_colon {
	($buffer:ident :) => { $buffer.insert_at_cursor("\n"); };
	($buffer:ident ;) => { };
	($buffer:ident $tag:ident :) => {
		$buffer.insert_with_tags(&mut $buffer.end_iter(), "\"", &[$tag]);
	};
	($buffer:ident $tag:ident ;) => { }
}

macro_rules! insert {
	($buffer:ident => [$tag:ident $sep:tt $($expr:expr),+]) => {
		if_colon!($buffer $tag $sep);
		$($buffer.insert_with_tags(&mut $buffer.end_iter(), $expr, &[$tag]);)+
		if_colon!($buffer $tag $sep);
	};
	($buffer:ident => $expr:expr) => { $buffer.insert_at_cursor($expr) };
	($buffer:ident $sep:tt $($tt:tt),*) => {{
		$(insert!($buffer => $tt);)*
		if_colon!($buffer $sep);
	}}
}

trait Placeholders {
	fn placeholders<T: AsRef<str>>(self, arguments: impl FnMut(&regex::Captures) -> T) -> String;
}

impl Placeholders for String {
	/// ## Example
	/// ~~~
	/// "{one} + {one} = {two}"
	///     .placeholders(|captures| match &captures[0] {
	///         "{one}" => "1",
	///         "{two}" => "2",
	///          other  => unreachable!("{other:?}")
	///     })
	/// ~~~
	fn placeholders<T: AsRef<str>>(self, arguments: impl FnMut(&regex::Captures) -> T) -> String {
		thread_local![static RE: regex::Regex = regex::Regex::new(r"\{(\w*?)\}").unwrap()];
		
		RE.with(|re| match re.replace_all(&self, arguments) {
			std::borrow::Cow::Borrowed(_) => self,
			std::borrow::Cow::Owned(text) => text,
		})
	}
}

fn time(buffer: &gtk::TextBuffer, twelve: bool) {
	let time = glib::DateTime::now_local().and_then(
		move |time| time.format(if twelve {"%I:%M:%S"} else {"%T"})
	);
	insert!(buffer; "\n[", (time.as_deref().unwrap_or("")), "] ")
}

pub fn critical(Tags { buffer, magenta, .. }: &Tags, twelve: bool) {
	time(buffer, twelve);
	insert!(buffer: [magenta; &i18n("CRITICAL")])
}

pub fn error(Tags { buffer, red, .. }: &Tags, twelve: bool) {
	time(buffer, twelve);
	insert!(buffer: [red; &i18n("ERROR")])
}

pub fn warning(Tags { buffer, yellow, .. }: &Tags, twelve: bool) {
	time(buffer, twelve);
	insert!(buffer: [yellow; &i18n("WARNING")])
}

pub trait Log<T, E, U> {
	fn log(self,
		variant: impl FnOnce(&E) -> fn(&Tags, bool),
		printer: fn(&Tags, E, U),
		    etc: U,
		   tags: &Tags,
		 twelve: bool,
	) -> Option<T>;
}

impl<T, E, U> Log<T, E, U> for Result<T, E> {
	fn log(self,
		variant: impl FnOnce(&E) -> fn(&Tags, bool),
		printer: fn(&Tags, E, U),
		    etc: U,
		   tags: &Tags,
		 twelve: bool,
	) -> Option<T> {
		match self {
			Ok(value) => Some(value), Err(error) => {
				variant(&error) (tags, twelve);
				printer(tags, error, etc);
				None
			}
		}
	}
}

fn show_path(buffer: &gtk::TextBuffer, path: &str) {
	/* REMOVE let mut it = path.iter().map(move |str| str as &str);
	
	buffer.insert_markup(&mut buffer.end_iter(), &format!("\
		<span color='blue'>[</span>\
		<span color='yellow'>{:?}</span>\
	", it.next().unwrap_or("")));
	
	for str in it {
		buffer.insert_markup(&mut buffer.end_iter(), &format!("\
			<span color='blue'>, </span>\
			<span color='yellow'>{str:?}</span>\
		"));
	}
	
	buffer.insert_markup(&mut buffer.end_iter(), &format!("<span color='blue'>]</span>")); */
}

pub fn scan_error(Tags { buffer, cyan, .. }: &Tags, error: cache::ScanError, _: ()) {
	match error {
		cache::ScanError::Path { local, path, error } => insert! {
			buffer: (&match local {
				true  => i18n("Unable to read local namespaces path at"),
				false => i18n("Unable to read system namespaces path at")
			}), "\n", [cyan; &path.to_string_lossy()], "\n", (&error.to_string())
		},
		cache::ScanError::Entry { local, path, error } => insert! {
			buffer: (&match local {
				true  => i18n("Unable to read local namespace entry at"),
				false => i18n("Unable to read system namespace entry at")
			}), "\n", [cyan; &path.to_string_lossy()], "\n", (&error.to_string())
		},
		cache::ScanError::Unicode { local, path } => insert! {
			buffer: (&match local {
				true  => i18n("Invalid Unicode directory name for local namespace at"),
				false => i18n("Invalid Unicode directory name for system namespace at")
			}), "\n", [cyan; &path.to_string_lossy()]
		}
	}
}

pub fn cache_error(Tags { buffer, red, cyan, .. }: &Tags, error: Box<cache::Error>, _: ()) {
	match *error {
		cache::Error::Io(local, id, path, error) => {
			let text = match local {
				true  => i18n("Unable to read local namespace {id} from"),
				false => i18n("Unable to read system namespace {id} from")
			};
			let (left, right) = text.split_once("{id}").unwrap_or(match local {
				true  => ("Unable to read local namespace ", " from"),
				false => ("Unable to read system namespace ", " from")
			});
			insert!(buffer: left, [red: id], right, "\n",
				[cyan; &path.to_string_lossy()], "\n", (&error.to_string()))
		}
		cache::Error::De(local, id, path, error) => {
			let text = match local {
				true  => i18n("Failed to deserialize local namespace {id} from"),
				false => i18n("Failed to deserialize system namespace {id} from")
			};
			let (left, right) = text.split_once("{id}").unwrap_or(match local {
				true  => ("Failed to deserialize local namespace ", " from"),
				false => ("Failed to deserialize system namespace ", " from")
			});
			insert!(buffer; left, [red: id], right, "\n",
				[cyan; &path.to_string_lossy()], "\n\n", (&error.to_string()))
		}
		cache::Error::NotFound { id } => {
			let text = i18n("No namespace {id} was found");
			
			let (left, right) = text.split_once("{id}")
				.unwrap_or(("No namespace ", " was found"));
			
			insert!(buffer: left, [red: id], right)
		}
	}
}

pub fn namespace_error(
	Tags { buffer, red, cyan, green, yellow, .. }: &Tags,
	error: Box<namespace::Error>, namespace_id: &str
) {
	use namespace::{Error, Of, Object::*};
	let Error(object, id, local, of) = error.as_ref();
	
	let text = match local {
		true  => i18n("In the local namespace {id}"),
		false => i18n("In the system namespace {id}")
	};
	let (left, right) = text.split_once("{id}").unwrap_or(match local {
		true  => ("In the local namespace ", ""),
		false => ("In the system namespace ", "")
	});
	let tag = if let Of::NotFound = of {green} else {yellow};
	insert!(buffer: left, [tag: namespace_id], right);
	
	let (text, error) = match of {
		Of::Io(path, error) => (match object {
			Arrangement => i18n("Unable to read arrangement {id} from"),
			        Map => i18n("Unable to read map {id} from"),
			     Scheme => i18n("Unable to read scheme {id} from"),
			      Theme => i18n("Unable to read theme {id} from"),
		}, Some((path, error.to_string(), false))),
		
		Of::De(path, error) => (match object {
			Arrangement => i18n("Failed to deserialize arrangement {id} from"),
			        Map => i18n("Failed to deserialize map {id} from"),
			     Scheme => i18n("Failed to deserialize scheme {id} from"),
			      Theme => i18n("Failed to deserialize theme {id} from"),
		}, Some((path, error.to_string(), true))),
		
		Of::NotFound => (match object {
			Arrangement => i18n("Arrangement {id} not found"),
			        Map => i18n("Map {id} not found"),
			     Scheme => i18n("Scheme {id} not found"),
			      Theme => i18n("Theme {id} not found"),
		}, None),
	};
	let (left, right) = text.split_once("{id}").unwrap_or(match of {
		Of::Io(..) => match object {
			Arrangement => ("Unable to read arrangement ", " from"),
			        Map => ("Unable to read map ", " from"),
			     Scheme => ("Unable to read scheme ", " from"),
			      Theme => ("Unable to read theme ", " from"),
		}
		Of::De(..) => match object {
			Arrangement => ("Failed to deserialize arrangement ", " from"),
			        Map => ("Failed to deserialize map ", " from"),
			     Scheme => ("Failed to deserialize scheme ", " from"),
			      Theme => ("Failed to deserialize theme ", " from"),
		}
		Of::NotFound => match object {
			Arrangement => ("Arrangement ", " not found"),
			        Map => ("Map ", " not found"),
			     Scheme => ("Scheme ", " not found"),
			      Theme => ("Theme ", " not found"),
		}
	});
	insert!(buffer: left, [red: id], right);
	
	if let Some((path, error, de)) = error {
		insert!(buffer; [cyan; &path.to_string_lossy()], (if de {"\n\n"} else {"\n"}), (&error.to_string()));
		if !de { insert!(buffer:) }
	}
}

pub fn script_error(Tags { buffer, magenta, red, .. }: &Tags, mut error: Box<rhai::EvalAltResult>, script: &str) {
	let pos = error.take_position();
	
	if pos.is_none() { insert!(buffer: (&error.to_string())) } else {
		let line = pos.line().unwrap();
		
		insert!(buffer: "\n", (&line.to_string()), ": ", [
			magenta; &script.split('\n').nth(line - 1).unwrap().replace('\t', " ")
		], (&compact_str::format_compact! {
			"{:1$}", "\n", 3 + (line as f64).log10() as usize + pos.position().unwrap()
		}), [red; "^ "], (&error.to_string()))
	}
}

pub fn scheme_error(tags @ Tags { buffer, yellow, red, green, cyan, .. }: &Tags, error: scheme::Error, _: ()) {
	match error {
		scheme::Error::Cache(error) => cache_error(tags, error, ()),
		
		scheme::Error::Namespace { namespace_id, error } => namespace_error(tags, error, namespace_id),
		
		scheme::Error::OptionType { option_id, current, required } => {
			let text = i18n("The data assigned to option {id} is of type {current} instead of {required}");
			let (current, required) = (current.type_str(), required.type_str());
			
			if let Some((left_1, right_1)) = text.split_once("{id}") {
				if let Some((left_2, right_2)) = left_1.split_once("{current}") {
					if let Some((left_3, right_3)) = left_2.split_once("{required}") {
						return insert!(buffer: left_3, [green; required], right_3, [red; current], right_2, [yellow: option_id], right_1)
					} else if let Some((left_3, right_3)) = right_2.split_once("{required}") {
						return insert!(buffer: left_2, [red; current], left_3, [green; required], right_3, [yellow: option_id], right_1)
					}
				} else if let Some((left_2, right_2)) = right_1.split_once("{current}") {
					if let Some((left_3, right_3)) = left_2.split_once("{required}") {
						return insert!(buffer: left_1, [yellow: option_id], left_3, [green; required], right_3, [red; current], right_2)
					} else if let Some((left_3, right_3)) = right_2.split_once("{required}") {
						return insert!(buffer: left_1, [yellow: option_id], left_2, [red; current], left_3, [green; required], right_3)
					}
				}
			}
			insert!(buffer: "The data assigned to option ", [yellow: option_id], " is of type ", [red; current], " instead of ", [green; required])
		}
		scheme::Error::Loading { scheme_id, path, error } => {
			let text = i18n("Unable to read script for scheme {id} at");
			let (left, right) = text.split_once("{id}")
				.unwrap_or(("Unable to read script for scheme ", " at"));
			
			insert!(buffer: left, [yellow: scheme_id], right, "\n",
				[cyan; &path.to_string_lossy()], "\n", (&error.to_string()))
		}
		scheme::Error::Rhai { scheme_id, path, script, error } => {
			let text = i18n("In the script for scheme {id} located at");
			let (left, right) = text.split_once("{id}")
				.unwrap_or(("In the script for scheme ", " located at"));
			
			insert!(buffer: left, [yellow: scheme_id],
				right, "\n", [cyan; &path.to_string_lossy()]);
			
			script_error(tags, error, &script)
		}
		scheme::Error::Toml { scheme_id, path, error } => {
			let text = i18n("Script for scheme {id} returns invalid TOML, located at");
			let (left, right) = text.split_once("{id}")
				.unwrap_or(("Script for scheme ", " returns invalid TOML, located at"));
			
			insert!(buffer; left, [yellow: scheme_id], right, "\n",
				[cyan; &path.to_string_lossy()], "\n\n", (&error.to_string()))
		}
	}
}

pub fn theme_error(tags @ Tags { buffer, blue, red, yellow, .. }: &Tags, error: theme::Error, _: ()) {
	match error {
		theme::Error::NotFound { id } => {
			let text = i18n("{id} not found");
			let (left, right) = text.split_once("{id}").unwrap_or(("", " not found"));
			insert!(buffer: left, [blue; "[schemes."], [red: id], [blue; "]"], right);
		}
		theme::Error::Scheme { id, error } => {
			let text = i18n("Request for {id} failed");
			let (left, right) = text.split_once("{id}").unwrap_or(("Request for ", " failed"));
			insert!(buffer: left, [blue; "[schemes."], [yellow: id], [blue; "]"], right);
			scheme_error(tags, *error, ());
		}
	}
}

pub fn listing_error(tags @ Tags { buffer, blue, red, green, yellow, .. }: &Tags, error: theme::ListingError, _: ()) {
	match error {
		theme::ListingError::NotFound { schemes_id } => {
			let text = i18n("{id} not found");
			let (left, right) = text.split_once("{id}").unwrap_or(("", " not found"));
			insert!(buffer: left, [blue; "[schemes."], [red: schemes_id], [blue; "]"], right)
		}
		theme::ListingError::LocalNotFound { schemes_id, id, scheme_id } => {
			let text = i18n("{first} requires {second}");
			if let Some((left_1, right_1)) = text.split_once("{first}") {
				if let Some((left_2, right_2)) = left_1.split_once("{second}") {
					return insert!(buffer: left_2,
						[blue; "[schemes."], [green: schemes_id], [blue; "."], [red: scheme_id], [blue; "]"], right_2,
						[blue; "[schemes."], [green: schemes_id], [blue; "."], [yellow:     id], [blue; "]"], right_1)
				} else if let Some((left_2, right_2)) = right_1.split_once("{second}") {
					return insert!(buffer: left_1,
						[blue; "[schemes."], [green: schemes_id], [blue; "."], [yellow:     id], [blue; "]"], left_2,
						[blue; "[schemes."], [green: schemes_id], [blue; "."], [red: scheme_id], [blue; "]"], right_2)
				}
			}
			insert!(buffer:
				[blue; "[schemes."], [green: schemes_id], [blue; "."], [yellow:     id], [blue; "]"], " requires ",
				[blue; "[schemes."], [green: schemes_id], [blue; "."], [red: scheme_id], [blue; "]"])
		}
		theme::ListingError::Cache { schemes_id, error } => {
			let text = i18n("Request for {id} failed");
			let (left, right) = text.split_once("{id}").unwrap_or(("Request for ", " failed"));
			insert!(buffer: left, [blue; "[schemes."], [yellow: schemes_id], [blue; "]"], right);
			cache_error(tags, error, ())
		}
		theme::ListingError::GlobalNotFound { schemes_id, id, namespace_id, error } => {
			let text = i18n("Request for {id} failed");
			let (left, right) = text.split_once("{id}").unwrap_or(("Request for ", " failed"));
			insert!(buffer: left, [blue; "[schemes."], [green: schemes_id], [blue; "."], [yellow: id], [blue; "]"], right);
			namespace_error(tags, error, namespace_id)
		}
		theme::ListingError::Theme { schemes_id, id, theme_id, error } => {
			let text = i18n("Request for {id} failed");
			let (left, right) = text.split_once("{id}").unwrap_or(("Request for ", " failed"));
			insert!(buffer: left, [blue; "[schemes."], [green: schemes_id], [blue; "."], [yellow: id], [blue; "]"], right);
			
			let text = i18n("In the theme {id}");
			let (left, right) = text.split_once("{id}").unwrap_or(("In the theme ", ""));
			insert!(buffer: left, [yellow: theme_id], right);
			
			theme_error(tags, error, ())
		}
	}
}

pub fn pathing_errors(tags @ Tags { buffer, blue, yellow, red, green, .. }: &Tags, error: pathing::Error, _: ()) {
	let failed = |id| {
		let text = i18n("Request for {id} failed");
		let (left, right) = text.split_once("{id}").unwrap_or(("Request for ", " failed"));
		insert!(buffer: left, [blue; "[maps."], [yellow: id], [blue; ".paths]"], right);
	};
	match error {
		pathing::Error::IncludeNotFound { id, map_id, include_id } => {
			failed(id);
			let text = i18n("Suggested path {id} not found in map {map-id}");
			
			if let Some((left_1, right_1)) = text.split_once("{id}") {
				if let Some((left_2, right_2)) = left_1.split_once("{map-id}") {
					return insert!(buffer: left_2, [green: map_id], right_2, [red: include_id], right_1)
				} else if let Some((left_2, right_2)) = right_1.split_once("{map-id}") {
					return insert!(buffer: left_1, [red: include_id], left_2, [green: map_id], right_2)
				}
			}
			insert!(buffer: "Suggested path ", [red: include_id], " not found in map ", [green: map_id])
		}
		pathing::Error::Namespace { id, error } => { failed(id); cache_error(tags, error, ()) }
		pathing::Error::Map { id, namespace_id, error } => { failed(id); namespace_error(tags, error, namespace_id) },
		pathing::Error::PathsIncludeNotFound { id, namespace_id, map_id, include_id } => {
			failed(id);
			let text = i18n("Suggested path {id} not found in map {map-id} at namespace {namespace-id}");
			
			if let Some((left_1, right_1)) = text.split_once("{id}") {
				if let Some((left_2, right_2)) = left_1.split_once("{map-id}") {
					if let Some((left_3, right_3)) = left_2.split_once("{namespace-id}") {
						return insert!(buffer: left_3, [green: namespace_id], right_3, [green: map_id], right_2, [red: include_id], right_1)
					} else if let Some((left_3, right_3)) = right_2.split_once("{namespace-id}") {
						return insert!(buffer: left_2, [green: map_id], left_3, [green: namespace_id], right_3, [red: include_id], right_1)
					}
				} else if let Some((left_2, right_2)) = right_1.split_once("{map-id}") {
					if let Some((left_3, right_3)) = left_2.split_once("{namespace-id}") {
						return insert!(buffer: left_1, [red: include_id], left_3, [green: namespace_id], right_3, [green: map_id], right_2)
					} else if let Some((left_3, right_3)) = right_2.split_once("{namespace-id}") {
						return insert!(buffer: left_1, [red: include_id], left_2, [green: map_id], left_3, [green: namespace_id], right_3)
					}
				}
			}
			insert!(buffer: "Suggested path ", [red: include_id], " not found in map ", [green: map_id], " at namespace ", [green: namespace_id])
		}
		pathing::Error::MissingPath { id, located } => {
			let text = i18n("Unable to parse {id} with value {value}");
			
			if let Some((left_1, right_1)) = text.split_once("{id}") {
				if let Some((left_2, right_2)) = left_1.split_once("{value}") {
					insert!(buffer: left_2, [blue; "[[maps."], [yellow: id], [blue; ".custom-paths]]"], right_2);
					show_located_path(tags, located);
					return insert!(buffer; right_1)
				} else if let Some((left_2, right_2)) = right_1.split_once("{value}") {
					insert!(buffer: left_1);
					show_located_path(tags, located);
					return insert!(buffer; left_2, [blue; "[[maps."], [yellow: id], [blue; ".custom-paths]]"], right_2)
				}
			}
			insert!(buffer: "Unable to parse ", [blue; "[[maps."], [yellow: id], [blue; ".custom-paths]]"], " with value ");
			show_located_path(tags, located);
		}
		pathing::Error::BadNaming { id, map_id, error } => {
			failed(id);
			let text = i18n("Bad {naming} found for plural type map {id}");
			
		}
		pathing::Error::NoSubdirectory { id, map_id, file_id, at, available } => todo!(),
		pathing::Error::NoPaths { id } => todo!(),
		pathing::Error::ConflictingPath { previous, current } => todo!(),
	}
}

fn show_located_path(Tags { buffer, yellow, blue, .. }: &Tags, path: &aquarelle::path::Located) {
	if let aquarelle::path::Location::None = path.location {
		return insert!(buffer; [yellow: &path.path])
	}
	insert!(buffer; [blue; "{ ", <&str>::from(path.location), " = "], [yellow: &path.path], [blue; " }"])
}

pub fn mapping_error(tags @ Tags { buffer, .. }: &Tags, mapping::Error { id, map_id, of }: mapping::Error, _: ()) {
	buffer.insert_markup(&mut buffer.end_iter(),
		&i18n("At map {map_id}, requested by {id}\n")
			.placeholders(move |captures| match &captures[0] {
				"{map_id}" => format!("<span color='yellow'>{map_id:?}</span>"),
				"{id}" => format!("\
					<span color='blue'>[maps.</span>\
					<span color='green'>{id:?}</span>\
					<span color='blue'>]</span>\
				"),
				x => unreachable!("{x:?}")
			})
	);
	
	match of {
		mapping::Of::ZipDir { at, subdir, error } => {
			buffer.insert_markup(&mut buffer.end_iter(),
				&i18n("ZIP error at subdirectory {id} as: ")
					.placeholders(move |captures| match &captures[0] {
						"{id}" => format!("<span color='red'>{at:?}</span>"),
						x => unreachable!("{x:?}")
					})
			);
			show_path(buffer, subdir);
			buffer.insert_markup(&mut buffer.end_iter(), &format!(
				"\n<span color='orange'>{error}</span>\n\n"
			));
		}
		
		mapping::Of::ZipFile { file_id, file, subdir, error } => {
			buffer.insert_markup(&mut buffer.end_iter(),
				&i18n("ZIP error at file {id} as: ")
					.placeholders(move |captures| match &captures[0] {
						"{id}" => format!("<span color='red'>{file_id:?}</span>"),
						x => unreachable!("{x:?}")
					})
			);
			show_path(buffer, subdir);
			buffer.insert_markup(&mut buffer.end_iter(), &format!(" + \
				<span color='yellow'>{}</span>\n\
				<span color='orange'>{error}</span>\n\n\
			", file.name));
		},
		
		mapping::Of::ZipIo { file_id, file, subdir, error } => {
			buffer.insert_markup(&mut buffer.end_iter(),
				&i18n("ZIP I/O error at file {id} as: ")
					.placeholders(move |captures| match &captures[0] {
						"{id}" => format!("<span color='red'>{file_id:?}</span>"),
						x => unreachable!("{x:?}")
					})
			);
			show_path(buffer, subdir);
			buffer.insert_markup(&mut buffer.end_iter(), &format!(" + \
				<span color='yellow'>{}</span>\n\
				<span color='orange'>{error}</span>\n\n\
			", file.name));
		},
		
		mapping::Of::Zip(error) => buffer.insert_markup(
			&mut buffer.end_iter(), &i18n("ZIP error: {error}\n\n")
				.placeholders(move |captures| match &captures[0] {
					"{error}" => format!("<span color='orange'>{error}</span>"),
					x => unreachable!("{x:?}")
				})
		),
		
		mapping::Of::Loading { path, error } => {
			buffer.insert_markup(&mut buffer.end_iter(), &i18n("Unable to read script located at"));
			buffer.insert_markup(&mut buffer.end_iter(), &format!("\
				\n<span color='cyan'>{}</span>\
				\n<span color='orange'>{error}</span>\n\n
			", path.to_string_lossy()));
		},
		
		mapping::Of::Rhai { path, script, error } => {
			buffer.insert_markup(&mut buffer.end_iter(), &i18n("Error in the script located at"));
			buffer.insert_markup(&mut buffer.end_iter(), &format!(
				"\n<span color='cyan'>{}</span>\n", path.to_string_lossy()
			));
			script_error(tags, error, &script)
		}
		
		mapping::Of::MissingFile { file_id } => todo!(),
		mapping::Of::InvalidType { file_id, type_name } => todo!(),
		mapping::Of::NoSubdir { file_id, at, available } => todo!(),
		mapping::Of::Svg(error) => todo!(),
		mapping::Of::NoPixmap => todo!(),
		mapping::Of::NoRender => todo!(),
		mapping::Of::Png(error) => todo!(),
	}
}
