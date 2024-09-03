/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::{gio, glib, prelude::*};
use aquarelle::{cache, config, errors::*, namespace::Object::*, Value};
use declarative::{clone, construct, view};
use crate::{icons, log, utils, i18n, send};

#[view[ ref row {
	add_suffix: &_ @ gtk::SpinButton spin {
		adjustment: &_ @ gtk::Adjustment {
			lower: 0.0
			upper: upper
			step_increment: 1.0
		}
		climb_rate: 1.0
		valign: gtk::Align::Center
		value: value
		width_chars: 4
	}
	add_prefix: &_ @ gtk::CheckButton {
		valign: gtk::Align::Center ~
		bind_property: "active", &spin, "sensitive" 'back { sync_create; }
	}
} ]]

fn rhai_max_value(row: &adw::ActionRow, value: f64, upper: f64) {
	expand_view_here! { }
}

#[view[ gtk::ScrolledWindow root {
	child: &_ @ adw::Clamp {
		margin_bottom: 12
		margin_end: 12
		margin_start: 12
		margin_top: 12
		maximum_size: 480
		tightening_threshold: 384
		
		child: &_ @ gtk::Box {
			orientation: gtk::Orientation::Vertical
			spacing: 12
			~
			append: &_ @ adw::PreferencesGroup {
				title: i18n("Maximum values for Rhai engine")
				description: i18n("Zero means “no limits”")
				
				header_suffix: &_ @ gtk::LinkButton {
					icon_name: icons::OPEN_BOOK
					tooltip_text: i18n("About this in the Rhai book")
					uri: "https://rhai.rs/book/safety/index.html"
					valign: gtk::Align::Center
				} ~
				add: &_ @ adw::ActionRow {
					title: i18n("Length of strings")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Size of arrays")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Size of object maps")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Number of operations")
					rhai_max_value: &_, 0.0, u64::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Number of modules")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Call stack depth")
					rhai_max_value: &_, 64.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Expression nesting depth")
					subtitle: i18n("At global level")
					rhai_max_value: &_, 64.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Expression nesting depth")
					subtitle: i18n("Within function bodies")
					rhai_max_value: &_, 32.0 ,usize::MAX as f64
				}
			}
			append: &_ @ adw::PreferencesGroup {
				title: i18n("Miscellaneous")
				~
				add: &_ @ adw::ActionRow {
					title: i18n("Print errors in the log panel")
					subtitle: i18n("Use this function to test a translation")
					activatable_widget: &button
					~
					add_suffix: &_ @ gtk::MenuButton button {
						icon_name: icons::OPEN_MENU
						valign: gtk::Align::Center
						
						menu_model: &_ @ gio::Menu {
							append: Some(&i18n(          "_Scan errors")), Some("show-errors.scan")
							append: Some(&i18n(         "_Cache errors")), Some("show-errors.cache")
							append: Some(&i18n(     "_Namespace errors")), Some("show-errors.namespace")
							append: Some(&i18n(        "_Scheme errors")), Some("show-errors.scheme")
							append: Some(&i18n(         "_Theme errors")), Some("show-errors.theme")
							append: Some(&i18n("Scheme _listing errors")), Some("show-errors.listing")
							
							append_section: Some(&i18n("Untranslatable")), &_ @ gio::Menu {
								append: Some(&i18n("_Rhai errors")), Some("show-errors.rhai")
							}!
						}!
					}
				}
			}
		}
	} ~
	insert_action_group: "show-errors", Some(&_) @ gio::SimpleActionGroup {
		add_action: &_ @ gio::SimpleAction::new("scan", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Scan => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("cache", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Cache => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("namespace", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Namespace => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("rhai", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Rhai => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("scheme", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Scheme => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("theme", None) {
			connect_activate: clone![tx; move |_, _| send!(ShowErrors::Theme => tx)]
		}
		add_action: &_ @ gio::SimpleAction::new("listing", None) {
			connect_activate: move |_, _| send!(ShowErrors::Listing => tx)
		}
	}!
} ]]

pub fn start(tags: utils::Tags) -> gtk::ScrolledWindow {
	enum ShowErrors { Scan, Cache, Namespace, Rhai, Scheme, Theme, Listing }
	let (tx, rx) = async_channel::bounded(1);
	
	expand_view_here! { }
	
	let show_errors = move |show| match show {
		ShowErrors::Scan => for error in scan_errors(&path()) {
			(if let cache::ScanError::Path { user: true, .. } = error
				{ log::warning } else { log::error }) (&tags, true);
			
			log::scan_error(&tags, error, ())
		}
		ShowErrors::Cache => for error in cache_errors(&path()) {
			log::error(&tags, true);
			log::cache_error(&tags, Box::new(error), ())
		}
		ShowErrors::Namespace => for object in [Arrangement, Map, Scheme, Theme] {
			for error in namespace_errors(object) {
				log::error(&tags, true);
				log::namespace_error(&tags, Box::new(error), config::APP)
			}
		}
		ShowErrors::Rhai => for (script, error) in script_errors() {
			log::script_error(&tags, error, script)
		}
		ShowErrors::Scheme => for error in scheme_errors(&path(), &Value::Int(0), &Value::Float(0.0)) {
			log::error(&tags, true);
			log::scheme_error(&tags, error, ())
		}
		ShowErrors::Theme => for error in theme_errors(&path()) {
			log::error(&tags, true);
			log::theme_error(&tags, error, ())
		}
		ShowErrors::Listing => for error in scheme_listing_errors() {
			log::error(&tags, true);
			log::listing_error(&tags, error, ())
		}
	};
	
	glib::spawn_future_local(async move {
		while let Ok(show) = rx.recv().await { show_errors(show) }
	});
	
	root
}
