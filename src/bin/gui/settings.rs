/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::{gio, glib, prelude::*};
use aquarelle::{cache, config, errors::*, namespace::Object::*, Value};
use declarative::{builder_mode, clone, view};
use crate::{icons, log, utils, i18n, send};

#[view(ref row {
	gtk::SpinButton spin #add_suffix(&#) !{
		gtk::Adjustment #adjustment(&#) !{
			lower: 0.0
			upper: upper
			step_increment: 1.0
		}
		climb_rate: 1.0
		valign: gtk::Align::Center
		value: value
		width_chars: 4
	}
	gtk::CheckButton #add_prefix(&#) !{
		~valign: gtk::Align::Center
		bind_property: "active", &spin, "sensitive" 'back !{ sync_create; }
	}
})]

fn rhai_max_value(row: &adw::ActionRow, value: f64, upper: f64) {
	expand_view_here! { }
}

#[view {
	gtk::ScrolledWindow root !{
		~adw::Clamp #child(&#) !{
			margin_bottom: 12
			margin_end: 12
			margin_start: 12
			margin_top: 12
			maximum_size: 480
			tightening_threshold: 384
			
			gtk::Box #child(&#) !{
				orientation: gtk::Orientation::Vertical
				~spacing: 12
				
				adw::PreferencesGroup #append(&#) !{
					title: i18n("Maximum values for Rhai engine")
					description: i18n("Zero means “no limits”")
					
					~gtk::LinkButton #header_suffix(&#) !{
						icon_name: icons::OPEN_BOOK
						tooltip_text: i18n("About this in the Rhai book")
						uri: "https://rhai.rs/book/safety/index.html"
						valign: gtk::Align::Center
					}
					
					adw::ActionRow #add(&#) !{
						title: i18n("Length of strings")
						@rhai_max_value(&#, 0.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Size of arrays")
						@rhai_max_value(&#, 0.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Size of object maps")
						@rhai_max_value(&#, 0.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Number of operations")
						@rhai_max_value(&#, 0.0, u64::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Number of modules")
						@rhai_max_value(&#, 0.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Call stack depth")
						@rhai_max_value(&#, 64.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Expression nesting depth")
						subtitle: i18n("At global level")
						@rhai_max_value(&#, 64.0, usize::MAX as f64)
					}
					adw::ActionRow #add(&#) !{
						title: i18n("Expression nesting depth")
						subtitle: i18n("Within function bodies")
						@rhai_max_value(&#, 32.0 ,usize::MAX as f64)
					}
				}
				
				adw::PreferencesGroup #append(&#) !{
					~title: i18n("Miscellaneous")
					
					adw::ActionRow #add(&#) !{
						title: i18n("Print errors in the log panel")
						subtitle: i18n("Use this function to test a translation")
						~activatable_widget: &button
						
						gtk::MenuButton button #add_suffix(&#) !{
							icon_name: icons::OPEN_MENU
							valign: gtk::Align::Center
							
							gio::Menu #menu_model(&#) {
								append: Some(&i18n(          "_Scan errors")), Some("show-errors.scan")
								append: Some(&i18n(         "_Cache errors")), Some("show-errors.cache")
								append: Some(&i18n(     "_Namespace errors")), Some("show-errors.namespace")
								append: Some(&i18n(        "_Scheme errors")), Some("show-errors.scheme")
								append: Some(&i18n(         "_Theme errors")), Some("show-errors.theme")
								append: Some(&i18n("Scheme _listing errors")), Some("show-errors.listing")
								
								gio::Menu #append_section(Some(&i18n("Untranslatable")), &#) {
									append: Some(&i18n("_Rhai errors")), Some("show-errors.rhai")
								}
							}
						}
					}
				}
			}
		}
		gio::SimpleActionGroup #insert_action_group("show-errors", Some(&#)) {
			gio::SimpleAction::new("scan", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Scan => tx)]
			}
			gio::SimpleAction::new("cache", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Cache => tx)]
			}
			gio::SimpleAction::new("namespace", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Namespace => tx)]
			}
			gio::SimpleAction::new("rhai", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Rhai => tx)]
			}
			gio::SimpleAction::new("scheme", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Scheme => tx)]
			}
			gio::SimpleAction::new("theme", None) #add_action(&#) {
				connect_activate: clone![tx; move |_, _| send!(ShowErrors::Theme => tx)]
			}
			gio::SimpleAction::new("listing", None) #add_action(&#) {
				connect_activate: move |_, _| send!(ShowErrors::Listing => tx)
			}
		}
	}
}]

pub fn start(tags: utils::Tags) -> gtk::ScrolledWindow {
	enum ShowErrors { Scan, Cache, Namespace, Rhai, Scheme, Theme, Listing }
	let (tx, rx) = glib::MainContext::channel(glib::Priority::DEFAULT);
	
	expand_view_here! { }
	
	let show_errors = move |show| match show {
		ShowErrors::Scan => for error in scan_errors(&path()) {
			(if let cache::ScanError::Path { local: true, .. } = error
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
		ShowErrors::Scheme => for error in scheme_errors(&path(), &Value::Integer(0), &Value::Float(0.0)) {
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
	
	rx.attach(None, move |show| { show_errors(show); glib::ControlFlow::Continue });
	root
}
