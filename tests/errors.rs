/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::OnceCell, io::{self, Write}, path::PathBuf, rc::Rc};
use annotate_snippets::Renderer;
use aquarelle::{cache, namespace as ns, theme, path, script, Spanned, Value};
use compact_str::CompactString;

fn path() -> PathBuf { PathBuf::from("some/file/or/directory/path") }

fn show<'a, const N: usize, E>(out: &mut dyn Write, error: E) -> io::Result<()>
where for<'b> E: aquarelle::Msg<'a, 'b, N> {
	writeln!(out, "\n{}", annotate_snippets::Renderer::styled()
		.render(error.msg(std::array::from_fn(|_| Default::default()).each_mut())))
}

const MSG: &str = "SOME ERROR MESSAGE";

#[test]
fn print_scan_errors() -> io::Result<()> {
	use cache::ScanError::*;
	let (stdout, path) = (&mut io::stdout(), &path());
	
	writeln!(stdout, "=== START ===")?;
	
	for error in [
		   Path { user: false, path, error: io::Error::new(io::ErrorKind::Other, MSG) },
		  Entry { user: true , path, error: io::Error::new(io::ErrorKind::Other, MSG) },
		Unicode { user: false, path },
	] { show(stdout, error)? }
	
	writeln!(stdout, "=== END ===")
}

fn toml_error() -> toml::de::Error {
	match toml::de::from_str::<()>("invalid-toml") {
		Ok(_) => panic!("the TOML is valid"), Err(error) => error
	}
}

#[test]
fn print_cache_errors() -> io::Result<()> {
	let (stdout, path) = (&mut io::stdout(), &path());
	
	writeln!(stdout, "=== START ===")?;
	
	for error in [
		cache::Error::Io(true , path, io::Error::new(io::ErrorKind::Other, MSG)),
		cache::Error::De(false, path, Box::from(toml_error())),
		cache::Error::NotFound
	] { show(stdout, error)? }
	
	writeln!(stdout, "=== END ===")
}

fn bin() -> cache::Bin {
	cache::Bin { user: true, data: OnceCell::new(), path: Rc::from(path()) }
}

const NAMESPACE: &str = /*TOML*/ "\
name = 'Some name'
about = 'Some about'

themes.some-theme = 'path/to/some/theme'
schemes.some-scheme = 'path/to/some/scheme'

[maps]
some-map = 'path/to/some/map'

[arrangements]
some-arrangement = 'path/to/some/arrangement'";

fn span<T: Default>(span: std::ops::Range<usize>) -> Spanned<T>
	{ Spanned::new(span, Default::default()) }

#[test]
fn print_namespace_errors() -> anyhow::Result<()> {
	use ns::{Error, Object::*, Of::*};
	let (stdout, bin) = (&mut io::stdout(), &bin());
	
	writeln!(stdout, "=== START ===")?;
	
	for (range, object) in [(180..196, Arrangement), (134..142, Map), (90..101, Scheme), (48..58, Theme)] {
		for error in [
			Error(object, Io(&span(range.clone()), io::Error::new(io::ErrorKind::Other, MSG)), bin, NAMESPACE),
			Error(object, De(&span(range), toml_error()), bin, NAMESPACE),
			Error(object, NotFound, bin, NAMESPACE),
		] { show(stdout, error)? }
	}
	
	Ok(writeln!(stdout, "=== END ===")?)
}

fn script_errors() -> [(Cow<'static, str>, Box<rhai::EvalAltResult>); 2] {
	let first = match rhai::Engine::new_raw().eval::<&str>("0") {
		Ok(_) => panic!("the script is valid"),
		Err(error) => (Cow::Borrowed("0"), error),
	};
	
	let script = "let something = (2 + 2 = 4);";
	
	let second = match rhai::Engine::new_raw().eval::<()>(script) {
		Ok(_) => panic!("the script is valid"),
		Err(error) => (Cow::Borrowed(script), error),
	};
	
	[first, second]
}

#[test]
fn print_script_errors() -> io::Result<()> {
	let stdout = &mut io::stdout();
	
	writeln!(stdout, "=== START ===")?;
	
	for (script, error) in script_errors() { writeln!(stdout, "\n{}", Renderer::styled()
		.render(script::error_msg(error, &mut Cow::default(), &script, ("test/path", ""), "", &span(0..0))))? }
	
	writeln!(stdout, "=== END ===")
}

fn find(str: &str, text: &'static str) -> anyhow::Result<Spanned> {
	let find = str.find(text).ok_or_else(|| anyhow::anyhow!("{text} not found"))?;
	Ok(Spanned::new(find..(find + text.len()), CompactString::const_new(text)))
}

#[test]
fn print_scheme_errors() -> anyhow::Result<()> {
	use aquarelle::scheme::Error::*;
	let stdout = &mut io::stdout();
	
	let scheme_src = Cow::Borrowed(include_str!("../aquarelle/non_maps/neon_cake.toml"));
	let  theme_src = Cow::Borrowed(include_str!("../aquarelle/Aquarelle.toml"));
	
	let s_ol   = &find(&scheme_src, "overall-luminance")?;
	let t_ol   = &find(& theme_src, "overall-luminance")?;
	let t_id   = &find(& theme_src, " light")?;
	let script = &find(&scheme_src, "'''")?;
	
	let src    = &(Rc::from(scheme_src), Rc::from(PathBuf::from("aquarelle/non_maps/neon_cake.toml")));
	let source = &(Rc::from( theme_src), Rc::from(PathBuf::from("aquarelle/Aquarelle.toml")));
	
	let [(code, error_1), (code_2, error)] = script_errors();
	
	writeln!(stdout, "=== START ===")?;
	for error in [
		Types { sources: [src, source], options: [s_ol, t_ol], values: [&Value::Int(0), &Value::Float(0.0)], scheme_id: None },
		Types { sources: [src, source], options: [s_ol, t_ol], values: [&Value::Int(0), &Value::Float(0.0)], scheme_id: Some(t_id) },
		Io { src, script, error: io::Error::new(io::ErrorKind::Other, MSG) },
		Rhai { src, script, path: "some/script/path", code, error: error_1 },
		Rhai { src, script, path: "some/script/path", code: code_2, error },
		Toml { src, script, error: Box::from(toml_error()) }
	] { show(stdout, error)? }
	
	Ok(writeln!(stdout, "=== END ===")?)
}

fn cache_1() -> cache::Error<'static> { cache::Error::NotFound }

fn cache_2<'a>(path: &'a std::path::Path) -> cache::Error<'a> {
	cache::Error::Io(false, path, io::Error::new(io::ErrorKind::Other, MSG))
}

fn ns_1<'a>(bin: &'a cache::Bin, object: ns::Object) -> ns::Error<'a> {
	ns::Error(object, ns::Of::NotFound, bin, NAMESPACE)
}

fn ns_2<'a>(bin: &'a cache::Bin, object: ns::Object, spanned: &'a Spanned) -> ns::Error<'a> {
	ns::Error(object, ns::Of::Io(
		spanned, io::Error::new(io::ErrorKind::Other, MSG)
	), bin, NAMESPACE)
}

#[test]
fn print_theme_errors() -> anyhow::Result<()> {
	let (stdout, path, bin) = (&mut io::stdout(), &path(), &bin());
	
	let scheme_src = Cow::Borrowed(include_str!("../aquarelle/non_maps/neon_cake.toml"));
	let  theme_src = Cow::Borrowed(include_str!("../aquarelle/Aquarelle.toml"));
	
	let ns_scheme_id = &find(&theme_src, " dark")?;
	let scheme_id    = &find(&theme_src, "'neon-cake'")?;
	let namespace_id = &find(&theme_src, "'Aquarelle'")?; // NOTE fake
	let script       = &find(&scheme_src, "'''")?;
	
	let source = &(Rc::from(scheme_src), Rc::from(PathBuf::from("aquarelle/non_maps/neon_cake.toml")));
	let src    = &(Rc::from( theme_src), Rc::from(PathBuf::from("aquarelle/Aquarelle.toml")));
	
	writeln!(stdout, "=== START ===")?;
	
	for error in [
		theme::Error::NotFound,
		theme::Error::NoRequest { src, scheme_id: ns_scheme_id },
		theme::Error::Cache { src, namespace_id, error: cache_1() },
		theme::Error::Cache { src, namespace_id, error: cache_2(path) },
		theme::Error::Namespace { src, scheme_id, error: Box::new(ns_1(bin, ns::Object::Scheme)) },
		theme::Error::Namespace { src, scheme_id, error: Box::new(ns_2(bin, ns::Object::Scheme, &span(48..58))) },
		theme::Error::Scheme { src, scheme_id, error: Box::new(aquarelle::scheme::Error::Io {
			src: source, script, error: io::Error::new(io::ErrorKind::Other, MSG)
		}), }
	] { show(stdout, error)? }
	
	Ok(writeln!(stdout, "=== END ===")?)
} // toml

const ARRANGEMENT: &str = "\
name = 'Arrangement Test'
default-path = { desktop = 'arrangement-test' }
replica = 'hard-link'

[maps.some-map-1]
request = { map = 'map-requested', from = 'namespace-requested' }
paths.include = ['some-include']

[maps.some-map-2]
request.map = 'map-requested'
paths.request.some-namespace.another-map.exclude = ['some-exclude']"; // toml

const MAP: &str = "\
name = 'Some Map'
type = 'directory'

subdirectories = ['first', 'second']

[suggested-paths]
default = { home = 'some/path' }

[files]
one = { name = 'file.one' }
two = { at = 3, name = 'file.two' }";

#[test]
fn print_pathing_errors() -> anyhow::Result<()> {
	use aquarelle::pathing::Error::*;
	let (stdout, bin) = (&mut io::stdout(), &bin());
	let src = &(Rc::from(Cow::Borrowed(ARRANGEMENT)), Rc::from(path()));
	let map_src = &(Rc::from(Cow::Borrowed(MAP)), Rc::from(path()));
	
	let location = &Spanned::new(198..212, path::Location {
		prefix: path::Prefix::Custom, path: Default::default()
	});
	
	let lo = &Spanned::new(113..124, path::Location {
		prefix: path::Prefix::Custom, path: Default::default()
	});
	
	writeln!(stdout, "=== START ===")?;
	
	for error in [
		SuggestedNotFound { src, id: &span(103..113), suggested: &span(198..212) },
		Cache { src, id: &span(221..231), namespace_id: &span(277..291), error: cache_1() },
		Cache { src, id: &span(221..231), namespace_id: &span(277..291), error: cache_2(&path()) },
		Namespace { src, id: &span(221..231), namespace_id: &span(277..291), map_id: &span(292..303), error: Box::new(ns_1(bin, ns::Object::Map)) },
		Namespace { src, id: &span(221..231), namespace_id: &span(277..291), map_id: &span(292..303), error: Box::new(ns_2(bin, ns::Object::Map, &span(134..142))) },
		MissingPath { src, id: &span(103..113), source: src, location },
		NoSubdirectory { src, id: &span(103..113), map_src, file_id: &span(164..167), at: &span(172..174), available: 2 },
		NoPaths { src, id: &span(103..113) },
		ConflictingPath {
			src, previous: Box::new(path::Parsed { id: &span(103..113), source: src, location, map_src, file_name: None, buf: Rc::from(path()) }),
			path: Box::new(path::Parsed { id: &span(221..231), source: map_src, location: lo, map_src, file_name: Some(&span(151..161)), buf: Rc::from(path()) })
		}
	] { show(stdout, error)? }
	
	Ok(writeln!(stdout, "=== END ===")?)
}
