/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

mod colors;
mod icons;
mod namespaces;
mod scheme;
mod schemes;
mod settings;
mod themes;
mod window;

   use gettextrs::  gettext as i18n;
// use gettextrs:: pgettext as i18nc;
// use gettextrs:: ngettext as i18np;
// use gettextrs::npgettext as i18ncp;

fn main() -> gtk::glib::ExitCode {
	use aquarelle::config;
	use gtk::{gio, prelude::*};
	
	gio::resources_register_include!("resources.gresource").unwrap();
	
	let locale_path = [config::PREFIX_DIR, config::LOCALE_DIR]
		.iter().collect::<std::path::PathBuf>();
	
	gettextrs::bindtextdomain(config::APP as &str, locale_path).unwrap();
	gettextrs::bind_textdomain_codeset(config::APP as &str, "UTF-8").unwrap();
	gettextrs::textdomain(config::APP as &str).unwrap();
	
	let app = adw::Application::new(Some(config::APP_ID), Default::default());
	app.connect_activate(window::start);
	app.run()
}

fn shortcut(trigger: &str, action: &str) -> gtk::ShortcutController {
	use declarative::{construct, block as view};
	view![ gtk::ShortcutController controller {
		set_scope: gtk::ShortcutScope::Managed
		add_shortcut: _ @ gtk::Shortcut {
			set_trigger: gtk::ShortcutTrigger::parse_string(trigger)
			set_action: gtk::ShortcutAction::parse_string(action)
		}!
	}! ]; controller
}

fn rgba(color: u32) -> gtk::gdk::RGBA {
	use palette::{Srgba, rgb::channels::Rgba};
	let color = Srgba::from_u32::<Rgba>(color).into_format();
	gtk::gdk::RGBA::new(color.red, color.green, color.blue, color.alpha)
}

thread_local! {
	static TERM: vte::Terminal = vte::Terminal::new();
	static MSG: std::cell::RefCell<String> = const { std::cell::RefCell::new(String::new()) }
}

trait Log<T, const N: usize> { fn log(self) -> Option<T>; }

impl<'a, T, const N: usize, E> Log<T, N> for Result<T, E>
where for<'b> E: aquarelle::Msg<'a, 'b, N> {
	fn log(self) -> Option<T> {
		self.map_err(|error| TERM.with(|term| MSG.with_borrow_mut(|msg| {
			use {std::{array::from_fn, fmt::Write}, vte::TerminalExt};
			msg.clear();
			
			writeln!(msg, "{}", annotate_snippets::Renderer::styled()
				.term_width(term.column_count() as usize)
				.render(error.msg(from_fn(|_| Default::default()).each_mut()))
			).unwrap_or_else(|error| critical!("{error}"));
			
			for line in msg.lines() {
				term.feed(line.as_bytes());
				term.feed(b"\r\n")
			}
		}))).ok()
	}
}

macro_rules! critical(($($arg:expr),*) => {
	gtk::glib::g_critical!(aquarelle::config::APP_ID, $($arg),*)
});

macro_rules! send { [$msg:expr => $tx:expr] => [$tx.send_blocking($msg).unwrap()] }

use {critical, send};
