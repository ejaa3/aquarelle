/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

mod colors;
mod icons;
mod log;
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

mod utils {
	use declarative::{construct, view};
	use gtk::{gdk, prelude::TextTagExt};
	
	#[view[ gtk::ShortcutController controller {
		set_scope: gtk::ShortcutScope::Managed
		add_shortcut: _ @ gtk::Shortcut {
			set_trigger: gtk::ShortcutTrigger::parse_string(trigger)
			set_action: gtk::ShortcutAction::parse_string(action)
		}!
	}! ]]
	
	pub fn shortcut(trigger: &str, action: &str) -> gtk::ShortcutController {
		expand_view_here! { }
		controller
	}
	
	pub fn rgba(color: u32) -> gdk::RGBA {
		use palette::{Srgba, rgb::channels::Rgba};
		let color = Srgba::from_u32::<Rgba>(color).into_format();
		gdk::RGBA::new(color.red, color.green, color.blue, color.alpha)
	}
	
	#[view {
		#[derive(Clone)]
		pub struct Tags { }
		
		gtk::TextBuffer pub buffer { tag_table: &table }
		
		gtk::TextTagTable table {
			add: &_ @ gtk::TextTag pub red {
				foreground: "red"
				'bind set_foreground_rgba: Some(&rgba(scheme.red.like))
			}
			add: &_ @ gtk::TextTag pub yellow {
				foreground: "yellow"
				'bind set_foreground_rgba: Some(&rgba(scheme.yellow.like))
			}
			add: &_ @ gtk::TextTag pub green {
				foreground: "green"
				'bind set_foreground_rgba: Some(&rgba(scheme.green.like))
			}
			add: &_ @ gtk::TextTag pub cyan {
				foreground: "cyan"
				'bind set_foreground_rgba: Some(&rgba(scheme.cyan.like))
			}
			add: &_ @ gtk::TextTag pub blue {
				foreground: "blue"
				'bind set_foreground_rgba: Some(&rgba(scheme.blue.like))
			}
			add: &_ @ gtk::TextTag pub magenta {
				foreground: "magenta"
				'bind set_foreground_rgba: Some(&rgba(scheme.magenta.like))
			}
			add: &_ @ gtk::TextTag pub any {
				foreground: "purple"
				'bind set_foreground_rgba: Some(&rgba(scheme.any.like))
			}
		}!
	}]
	
	impl Tags {
		pub fn new() -> Self {
			expand_view_here! { }
			Self { red, yellow, green, cyan, blue, magenta, any, buffer }
		}
		pub fn refresh(&self, scheme: &aquarelle::scheme::Data) {
			let Self { red, yellow, green, cyan, blue, magenta, any, .. } = self;
			bindings! { }
		}
	}
}

macro_rules! send { [$msg:expr => $tx:expr] => [$tx.send_blocking($msg).unwrap()] }

macro_rules! critical {
	($($arg:expr),*) => {
		glib::g_critical!(aquarelle::config::APP_ID, $($arg),*)
	}
}

pub(crate) use {send, critical};
