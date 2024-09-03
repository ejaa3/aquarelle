/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::io::{Cursor, Result, Stderr, Write};
use aquarelle::{arrangement, cache, mapping, path, scheme, csi, location};
use compact_str::CompactString;
use palette::{rgb::channels::Rgba, Srgb};

fn main() -> Result<()> { std::process::exit(start()?) }

#[derive(clap::Parser)]
#[command(name = "Aquarelle", version, about)]
enum Cli {
	/// List available items
	List { #[command(subcommand)] subcommand: List },
	
	/// Perform an arrangement
	Arrange {
		/// Namespace where the arrangement is located
		#[arg(short, long)]
		from: CompactString,
		
		/// Arrangement to apply
		#[arg(short, long)]
		arrangement: String,
		
		/// Variant of schemes to be applied from the arrangement
		#[arg(short, long)]
		schemes: CompactString,
		
		/// If set, only this map will be applied from the arrangement
		#[arg(short, long)]
		map: Option<CompactString>,
	},
	
	/// Print a scheme of a theme
	Print {
		/// Namespace where the theme is located
		#[arg(short, long)]
		from: CompactString,
		
		/// Theme where the scheme is located
		#[arg(short, long)]
		theme: CompactString,
		
		/// Background number for accent texts
		#[arg(short, long, default_value = "1")]
		bg: u8,
		
		/// Schemes to print
		schemes: Vec<CompactString>,
	},
	
	/// Debug a scheme
	Debug {
		/// Namespace where the scheme is located
		#[arg(short, long)]
		from: CompactString,
		
		/// The scheme to debug
		#[arg(short, long)]
		scheme: CompactString,
		
		/// Background number for accent texts
		#[arg(short, long, default_value = "2")]
		bg: u8,
		
		/// Scheme options in TOML
		options: Option<CompactString>,
	},
}

#[derive(clap::Subcommand)]
enum List {
	/// Lists all available namespaces
	Namespaces,
	
	/// Lists all available arrangements
	Arrangements,
	
	/// Lists all available maps
	Maps,
	
	/// Lists all available schemes
	Schemes,
	
	/// Lists all available themes
	Themes,
}

fn start() -> Result<i32> {
	let mut io_errors = vec![];
	let mut scan_error = false;
	let mut stderr = std::io::stderr();
	
	let cache = cache::Cache::new(|error| {
		scan_error = true;
		error.show(&mut stderr).unwrap_or_else(|error| io_errors.push(error));
	});
	
	for error in io_errors { Err(error)? }
	
	let code = match clap::Parser::parse() {
		Cli::List { subcommand } => list(subcommand, stderr, cache),
		
		Cli::Arrange { from, arrangement, schemes, map } => {
			let arrangement = arrangement.into();
			let result = arrangement::arrange(&cache, &from, &arrangement, &schemes, map.as_deref());
			
			match result {
				Ok(mappings) => show_mapping_results(stderr, mappings),
				Err(error) => arrangement::show_error(stderr, error, &arrangement)
			}
		}
		
		Cli::Print { from, theme: theme_id, schemes, bg } => {
			let (namespace, bin) = match cache.namespace(&from) {
				Ok(namespace) => namespace, Err(error) => {
					write!(stderr, csi!(/b:fg red; "ERROR:"! ' '))?;
					return error.show(&mut stderr)
				}
			};
			let theme = match namespace.theme(&theme_id, bin) {
				Ok(theme) => theme, Err(error) => {
					write!(stderr, csi!(/b:fg red; "ERROR:"! ' '))?;
					return error.show(&mut stderr, &from)
				}
			};
			for (i, scheme) in schemes.into_iter().enumerate() {
				let scheme = match theme.scheme(&scheme, &from, &cache, Default::default()) {
					Ok(data) => data, Err(error) => {
						write!(stderr, csi!(/b:fg red; "ERROR:"! ' '))?;
						return error.show(&mut stderr, &theme_id)
					}
				};
				print_scheme(scheme, bg, i as _)?;
			};
			Ok(exitcode::OK)
		}
		
		Cli::Debug { from, scheme, options, bg } => {
			let params = scheme::Params {
				scheme_id: scheme,
				namespace_id: CompactString::const_new(""),
			};
			
			let options = if let Some(options) = options {
				match toml::de::from_str(&options) {
					Ok(options) => options, Err(error) => {
						write!(stderr, csi!(/b:fg red; "ERROR:"! "invalid TOML\n" /F 7 "{}"), error)?;
						return Ok(exitcode::USAGE)
					}
				}
			} else { Default::default() };
			
			let request = scheme::Request { params, options, data: Default::default() };
			
			match scheme::data(&request, &from, &cache, &Default::default()) {
				Ok(scheme) => { print_scheme(scheme, bg, 0)?; Ok(exitcode::OK) }
				Err(error) => {
					write!(stderr, csi!(/b:fg red; "ERROR:"! ' '))?;
					error.show(&mut stderr)
				}
			}
		}
	}?;
	
	Ok(if code == exitcode::OK {
		if scan_error { exitcode::UNAVAILABLE } else { code }
	} else { code })
}

fn list(command: List, mut stderr: Stderr, cache: cache::Cache) -> Result<i32> {
	let mut stdout = std::io::stdout();
	let mut errors = Cursor::new(vec![]);
	
	match command {
		List::Namespaces => {
			for (id, bin) in &cache.namespaces {
				match bin.get(id) {
					Ok(namespace) => write!(stdout, csi! {
						"\n{} {}: " /fg green; "{:?}"! ' ' /d; "({})"!
					}, if bin.user { "-  " } else { "-" }, location(bin.user), id, namespace.name)?,
					
					Err(error) => {
						aquarelle::warn(&mut errors, if let cache::Error::Io(..) = *error { false } else { true })?;
						error.show(&mut errors)?;
					}
				}
			}
			if errors.position() == 0 { writeln!(stdout)?; }
			
			write!(stdout, csi!("\n  user path: " /fg blue; "{}\n"! "system path: " /fg blue; "{}"! '\n'),
				cache::user_path().to_string_lossy(), cache::system_path().to_string_lossy())?;
		}
		List::Arrangements => for (at, bin) in &cache.namespaces {
			match bin.get(at) {
				Ok(namespace) => if !namespace.arrangements.is_empty() {
					writeln!(stdout,
						csi!("\nAt {} namespace " /fg magenta; "{:?}"! ":"),
						location(bin.user), at)?;
					
					for (id, item) in &namespace.arrangements {
						match item.get(id, bin) {
							Ok(arrangement) => writeln!(stdout,
								csi!("- " /fg green; "{:?}"! ' ' /d; "({})"!), id, arrangement.name)?,
							
							Err(error) => {
								aquarelle::warn(&mut errors, true)?;
								error.show(&mut errors, at)?;
								continue
							}
						}
					}
				}
				Err(error) => {
					aquarelle::warn(&mut errors, true)?;
					error.show(&mut errors)?;
				}
			}
		}
		List::Maps => for (at, bin) in &cache.namespaces {
			match bin.get(at) {
				Ok(namespace) => if !namespace.maps.is_empty() {
					writeln!(stdout,
						csi!("\nAt {} namespace " /fg magenta; "{:?}"! ":"),
						location(bin.user), at)?;
					
					for (id, item) in &namespace.maps {
						match item.get(id, bin) {
							Ok(map) => writeln!(stdout,
								csi!("- " /fg green; "{:?}"! ' ' /d; "({})"!), id, map.name)?,
							
							Err(error) => {
								aquarelle::warn(&mut errors, true)?;
								error.show(&mut errors, at)?;
								continue
							}
						}
					}
				}
				Err(error) => {
					aquarelle::warn(&mut errors, true)?;
					error.show(&mut errors)?;
				}
			}
		}
		List::Schemes => for (at, bin) in &cache.namespaces {
			match bin.get(at) {
				Ok(namespace) => if !namespace.schemes.is_empty() {
					writeln!(stdout,
						csi!("\nAt {} namespace " /fg magenta; "{:?}"! ":"),
						location(bin.user), at)?;
					
					for (id, item) in &namespace.schemes {
						match item.get(id, bin) {
							Ok(palette) => writeln!(stdout,
								csi!("- " /fg green; "{:?}"! ' ' /d; "({})"!), id, palette.name)?,
							
							Err(error) => {
								aquarelle::warn(&mut errors, true)?;
								error.show(&mut errors, at)?;
								continue
							}
						}
					}
				}
				Err(error) => {
					aquarelle::warn(&mut errors, true)?;
					error.show(&mut errors)?;
				}
			}
		}
		List::Themes => for (at, bin) in &cache.namespaces {
			match bin.get(at) {
				Ok(namespace) => if !namespace.themes.is_empty() {
					writeln!(stdout,
						csi!("\nAt {} namespace " /fg magenta; "{:?}"! ":"),
						location(bin.user), at)?;
					
					for (id, item) in &namespace.themes {
						match item.get(id, bin) {
							Ok(theme) => writeln!(stdout,
								csi!("- " /fg green; "{:?}"! ' ' /d; "({})"!), id, theme.name)?,
							
							Err(error) => {
								aquarelle::warn(&mut errors, true)?;
								error.show(&mut errors, at)?;
								continue
							}
						}
					}
				}
				Err(error) => {
					aquarelle::warn(&mut errors, true)?;
					error.show(&mut errors)?;
				}
			}
		}
	}
	
	writeln!(stdout)?;
	
	let errors = errors.into_inner();
	Write::write_all(&mut stderr, &errors)?;
	
	Ok(if errors.is_empty() { exitcode::OK } else { exitcode::UNAVAILABLE })
}

fn show_mapping_results<'a>(
	mut out: impl Write, mappings: Vec<impl FnOnce() -> mapping::Result<'a>>
) -> Result<i32> {
	let mut   successful = 0_u8;
	let mut missmappings = 0_u8;
	let mut     failures = 0_u8;
	
	for mapping in mappings {
		match mapping() {
			Ok(mapping::Success { id, errors, .. }) => if errors.is_empty() { successful += 1 } else {
				missmappings += 1;
				
				writeln!(out, csi! { '\n' /b:fg magenta; "WARNING:"! ' '
					"There were some errors for "
					/fg blue; "[maps." /fg yellow; "{:?}" /fg blue; ".paths]"! ':'
				}, id)?;
				
				for mapping::IoError { error, path } in errors.iter() {
					write!(out, csi!('\n' /6 F "for: "))?;
					path::show_location(&mut out, &path.location)?;
					writeln!(out, csi! {
						'\n' /7 F "as: " /fg cyan; "{}"! '\n' /4 F /b:fg red; "error:"! " {}"
					}, path.buf.to_string_lossy(), error)?;
				}
			}
			
			Err(error) => {
				failures += 1;
				mapping::show_error(&mut out, error)?
			}
		}
	}
	
	writeln!(std::io::stdout(), csi! { '\n'
		"{3} SUCCESSFUL:"! " {0}\n"
		"{4}MISMAPPINGS:"! " {1}\n"
		"{5}   FAILURES:"! " {2}\n"
	}, successful, missmappings, failures,
		if   successful > 0 { csi!(/b:fg green;)  } else { csi!(/d;) },
		if missmappings > 0 { csi!(/b:fg yellow;) } else { csi!(/d;) },
		if     failures > 0 { csi!(/b:fg red;)    } else { csi!(/d;) },
	)?;
	
	use exitcode::{CANTCREAT, UNAVAILABLE, OK};
	// IOERR should be used instead of CANTCREAT if the mapping involves reading
	Ok(if missmappings > 0 { CANTCREAT } else if failures > 0 { UNAVAILABLE } else { OK })
}

#[cfg(feature = "cli")]
fn print_scheme(scheme: &scheme::Data, bg: u8, i: u8) -> Result<()> {
	let mut stdout = &std::io::stdout();
	write!(stdout, "{}", if i == 0 { "\n" } else { csi!(/10 U) })?;
	
	for (set, roles) in [
		(aquarelle::Set::Lower, scheme.lower),
		(aquarelle::Set::Upper, scheme.upper),
	] {
		let like = Srgb::from_u32::<Rgba>(roles.like);
		let area = Srgb::from_u32::<Rgba>(roles.area);
		let text = Srgb::from_u32::<Rgba>(roles.text);
		
		writeln!(stdout, csi! { /"{10}" F
			/bg rgb("{1};{2};{3}"):fg rgb("{7};{8};{9}"); "{0:^9}"!
			/bg rgb("{4};{5};{6}"):fg rgb("{7};{8};{9}"); "{0:^9}"!
		}, set.to_str(),
			like.red, like.green, like.blue,
			area.red, area.green, area.blue,
			text.red, text.green, text.blue, i * 19 + 1
		)?
	}
	
	let bg = Srgb::from_u32::<Rgba>(match bg {
		1 => scheme.lower.area,
		3 => scheme.upper.like,
		4 => scheme.upper.area,
		_ => scheme.lower.like,
	});
	
	for (set, roles) in [
		(aquarelle::Set::Red,     scheme.red),
		(aquarelle::Set::Yellow,  scheme.yellow),
		(aquarelle::Set::Green,   scheme.green),
		(aquarelle::Set::Cyan,    scheme.cyan),
		(aquarelle::Set::Blue,    scheme.blue),
		(aquarelle::Set::Magenta, scheme.magenta),
		(aquarelle::Set::Any,     scheme.any),
	] {
		let like = Srgb::from_u32::<Rgba>(roles.like);
		let area = Srgb::from_u32::<Rgba>(roles.area);
		let text = Srgb::from_u32::<Rgba>(roles.text);
		
		writeln!(stdout, csi! { /"{13}" F
			/bg rgb("{1};{2};{3}"):fg rgb("{4};{5};{6}");    "{0:^9}"!
			/bg rgb("{7};{8};{9}"):fg rgb("{10};{11};{12}"); "{0:^9}"!
		}, set.to_str(), bg.red, bg.green, bg.blue,
			like.red, like.green, like.blue,
			area.red, area.green, area.blue,
			text.red, text.green, text.blue, i * 19 + 1
		)?
	}
	
	writeln!(stdout)
}
