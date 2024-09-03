/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::io::{self, Write};
use compact_str::CompactString as String;
use aquarelle::{errors::*, path, Value};

#[test]
fn print_scan_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for error in scan_errors(&path()) {
		error.show(stdout)?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_cache_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for error in cache_errors(&path()) {
		aquarelle::warn(stdout, true)?;
		error.show(stdout)?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_namespace_errors() -> io::Result<()> {
	use aquarelle::namespace::Object::*;
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for object in [Arrangement, Map, Scheme, Theme] {
		for error in namespace_errors(object) {
			aquarelle::warn(stdout, true)?;
			error.show(stdout, "aquarelle")?;
		}
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_script_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for (script, error) in script_errors() {
		aquarelle::show_script_error(stdout, error, script)?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_scheme_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for error in scheme_errors(&path(), &Value::Int(0), &Value::Float(0.0)) {
		aquarelle::warn(stdout, true)?;
		error.show(stdout)?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_theme_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for error in theme_errors(&path()) {
		aquarelle::warn(stdout, true)?;
		error.show(stdout, "theme-id")?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_listing_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	for error in scheme_listing_errors() {
		aquarelle::warn(stdout, true)?;
		error.show(stdout)?;
	}
	writeln!(stdout, "=== END ===")
}

#[test]
fn print_pathing_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	let location = path::Location {
		prefix: path::Prefix::Home,
		  path: String::const_new(".local/share"),
	};
	
	let parsed = path::ParsedFrom {
		  id: "first-parsed-id",
		path: path::Parsed {
			suggested_id: None,
			    location: &location,
			        file: None,
			         buf: location.to_path_buf(None).unwrap()
		}
	};
	
	let location_2 = path::Location {
		prefix: path::Prefix::Custom,
		  path: String::const_new("/sub/directory"),
	};
	
	let file = path::File {
		file_id: "file-id",
		file: &aquarelle::mapping::File {
			variant: Some(aquarelle::mapping::FileType::SvgToPng),
			     at: 4,
			   name: String::const_new("file_name.txt"),
		},
		subdir: "hello/world"
	};
	
	let parsed_2 = path::ParsedFrom {
		  id: "second-parsed-id",
		path: path::Parsed {
			suggested_id: Some("suggested-id"),
			    location: &location_2,
			        file: Some(file),
			         buf: std::path::PathBuf::from("/sub/directory/hello/world/file_name.txt"),
		}
	};
	
	writeln!(stdout, "=== START ===")?;
	for error in pathing_errors(&location, parsed, parsed_2) {
		aquarelle::warn(stdout, true)?;
		error.show(stdout)?;
	}
	writeln!(stdout, "=== END ===")
}
