/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{array::from_fn, borrow::Cow, io::{Stderr, Stdout, Write}, ops::Deref};
use aquarelle::{arrangement, cache, namespace::Namespace, scheme, csi, Key, Msg};
use clap::builder::styling;
use compact_str::CompactString;
use palette::{rgb::channels::Rgba, Srgb};

enum Error { Aquarelle, Io(std::io::Error) }

impl Error {
	fn io(self) -> Result<(), std::io::Error> {
		if let Self::Io(error) = self { Err(error) } else { Ok(()) }
	}
}

impl From<std::io::Error> for Error {
	fn from(value: std::io::Error) -> Self { Self::Io(value) }
}

fn main() -> std::process::ExitCode {
	match start() {
		Ok(_) => std::process::ExitCode::SUCCESS,
		Err(Error::Aquarelle) => std::process::ExitCode::FAILURE,
		Err(Error::Io(error)) => {
			eprintln!("{error}");
			std::process::ExitCode::FAILURE
		}
	}
}

const STYLES: styling::Styles = styling::Styles::styled()
	.usage(styling::AnsiColor::Green.on_default().bold())
	.header(styling::AnsiColor::Green.on_default().bold())
	.literal(styling::AnsiColor::Blue.on_default().bold())
	.placeholder(styling::AnsiColor::Yellow.on_default());

#[derive(clap::Parser)]
#[command(version, about, styles = STYLES)]
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
		arrangement: CompactString,
		
		/// Variant of schemes to be applied from the arrangement
		#[arg(short, long)]
		schemes: CompactString,
		
		/// If set, only this map will be applied from the arrangement
		#[arg(short, long)]
		map: Option<CompactString>,
	},
	
	/// Print schemes of a theme
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
		options: Option<String>,
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

fn start() -> Result<(), Error> {
	let mut cache = cache::Cache::default();
	let mut scan_error = false;
	let mut stderr = std::io::stderr();
	let mut io_errors = vec![];
	
	cache.update(|error| {
		scan_error = true;
		writeln!(stderr, "{}", annotate_snippets::Renderer::styled()
			.render(error.msg(<[Cow<_>; 2]>::default().each_mut())))
			.unwrap_or_else(|error| io_errors.push(error));
		true
	});
	
	for error in io_errors { Err(error)? }
	
	match clap::Parser::parse() {
		Cli::List { subcommand } => list(subcommand, stderr, cache),
		
		Cli::Arrange { from, arrangement, schemes, map } => {
			let mappings = arrangement::arrange(
				&cache, &from, arrangement.as_str().into(), &schemes, map.as_deref()
			).log(&mut stderr)?;
			
			let mut successful = 0_u8;
			let mut failures   = 0_u8;
			
			for mapping in mappings {
				if let Err(error) = mapping.perform().log(&mut stderr)
					{ error.io()?; failures += 1; } else { successful += 1 }
			}
			
			Ok(writeln!(std::io::stdout(), csi! { '\n'
				"{2} SUCCESSFUL:"! " {0}\n"
				"{3}   FAILURES:"! " {1}\n"
			}, successful, failures,
				if successful > 0 { csi!(/b:fg green;)  } else { csi!(/d;) },
				if   failures > 0 { csi!(/b:fg red;)    } else { csi!(/d;) },
			)?)
		}
		
		Cli::Print { from, theme, schemes, bg } => {
			let (namespace, bin) = cache.namespace(&from).log(&mut stderr)?;
			let theme = namespace.theme(&theme, bin).log(&mut stderr)?;
			let safety = Default::default(); // FIXME
			
			if schemes.is_empty() {
				for (i, scheme) in theme.schemes.keys().map(Key::deref).map(aquarelle::Spanned::get_ref).enumerate() {
					let scheme = theme.scheme(scheme, (namespace, bin), &cache, &safety).log(&mut stderr)?;
					print_scheme(scheme, bg, i as _)?;
				}
			}
			for (i, scheme) in schemes.into_iter().enumerate() {
				let scheme = theme.scheme(&scheme, (namespace, bin), &cache, &safety).log(&mut stderr)?;
				print_scheme(scheme, bg, i as _)?;
			};
			Ok(())
		}
		
		Cli::Debug { from, scheme, options, bg } => {
			let (namespace, bin) = cache.namespace(&from).log(&mut stderr)?;
			let scheme = namespace.scheme(&scheme, bin).log(&mut stderr)?;
			
			let (map, cow) = if let Some(mut options) = options {
				while let Some((left, _)) = options.split_once(", ") {
					options.replace_range(left.len()..(left.len() + 2), " \n");
				}
				(toml::de::from_str(&options).or_else(|error| {
					writeln!(stderr, "{error}")?; Err(Error::Aquarelle)
				})?, Cow::Owned(options))
			} else { Default::default() };
			
			let src = &(std::rc::Rc::new(cow), Default::default());
			
			print_scheme(&scheme.data(
				&map, &Default::default(), src, None, &Default::default() // FIXME safety
			).log(&mut stderr)?, bg, 0)
		}
	}
}

fn list(command: List, mut stderr: Stderr, cache: cache::Cache) -> Result<(), Error> {
	let stdout = &mut std::io::stdout();
	let mut errors = std::io::Cursor::new(vec![]);
	let mut first = true;
	NL.set("\n");
	
	let print_namespace = |out: &mut Stdout, id, bin: &cache::Bin, namespace: &Namespace|
		writeln!(out, csi!(/fg blue; "in {} namespace:"! " {:?} " /d; "({})"!),
			if bin.user { "user" } else { "system" }, id, namespace.name);
	
	let print_item = |out: &mut Stdout, id: &aquarelle::Spanned, name: &str|
		writeln!(out, csi!("- {:?}" /d; ": {}"!), id.get_ref(), name);
	
	macro_rules! print_items(($item:ident) => (for (id, bin) in &cache.namespaces {
		match bin.get().log(&mut errors) {
			Ok(namespace) => if !namespace.$item.is_empty() {
				if first { first = false } else { writeln!(stdout)? }
				print_namespace(stdout, id, bin, namespace)?;
				
				for (id, item) in &namespace.$item {
					match item.get(id, bin, namespace.source.as_ref().unwrap()).log(&mut errors) {
						Ok(item) => print_item(stdout, id, &item.name), Err(error) => error.io()
					}?
				}
			}, Err(error) => error.io()?
		}
	}));
	
	match command {
		List::Namespaces => {
			for (id, bin) in &cache.namespaces {
				match bin.get().log(&mut errors) {
					Ok(namespace) => writeln!(stdout, csi!(/fg blue; "{}:"! " {:?} " /d; "({})"!),
						if bin.user { "  user" } else { "system" }, id, namespace.name),
					Err(error) => error.io(),
				}?
			}
			writeln!(stdout, csi!("\n  " /fg green; "user path:"! " {}\n" /fg green; "system path:"! " {}"!),
				cache::user_path().to_string_lossy(), cache::system_path().to_string_lossy())?;
		}
		List::Arrangements => print_items!(arrangements),
		List::Maps => print_items!(maps),
		List::Schemes => print_items!(schemes),
		List::Themes => print_items!(themes),
	}
	Ok(stderr.write_all(&errors.into_inner())?)
}

fn print_scheme(scheme: &scheme::Data, bg: u8, i: u8) -> Result<(), Error> {
	let mut stdout = &std::io::stdout();
	write!(stdout, "{}", if i == 0 { "\n" } else { csi!(/10 U) })?;
	
	for (set, roles) in [("lower", scheme.lower), ("upper", scheme.upper)] {
		let like = Srgb::from_u32::<Rgba>(roles.like);
		let area = Srgb::from_u32::<Rgba>(roles.area);
		let text = Srgb::from_u32::<Rgba>(roles.text);
		
		writeln!(stdout, csi! { /"{10}" F
			/bg rgb("{1};{2};{3}"):fg rgb("{7};{8};{9}"); "{0:^9}"!
			/bg rgb("{4};{5};{6}"):fg rgb("{7};{8};{9}"); "{0:^9}"!
		}, set,
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
		(aquarelle::Accent::Red,     scheme.red),
		(aquarelle::Accent::Yellow,  scheme.yellow),
		(aquarelle::Accent::Green,   scheme.green),
		(aquarelle::Accent::Cyan,    scheme.cyan),
		(aquarelle::Accent::Blue,    scheme.blue),
		(aquarelle::Accent::Magenta, scheme.magenta),
		(aquarelle::Accent::Any,     scheme.any),
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
	Ok(writeln!(stdout)?)
}

thread_local! {
	static NL: std::cell::Cell<&'static str> = const { std::cell::Cell::new("") }
}

trait Log<T, const N: usize> {
	fn log(self, stderr: &mut dyn std::io::Write) -> Result<T, Error>;
}

impl<'a, T, const N: usize, E: for<'b> Msg<'a, 'b, N>> Log<T, N> for Result<T, E> {
	fn log(self, stderr: &mut dyn std::io::Write) -> Result<T, Error> {
		self.or_else(|error| {
			writeln!(stderr, "{}{}", NL.get(), annotate_snippets::Renderer::styled()
				.render(error.msg(from_fn(|_| Cow::default()).each_mut())))?;
			Err(Error::Aquarelle)
		})
	}
}
