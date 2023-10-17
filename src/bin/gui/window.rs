/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::rc::Rc;
use adw::{gio, glib, prelude::*};
use aquarelle::{cache, config};
use declarative::{clone, construct, view};
use crate::{icons, log, schemes, utils, i18n, critical};

const WINDOW_WIDTH : &str = "window-width";
const WINDOW_HEIGHT: &str = "window-height";
const LOG_HEIGHT   : &str = "log-height";
const LAST_VIEW    : &str = "last-view";

const SHOW_LOG : &str = "win.show-log";
const CLEAR_LOG: &str = "win.clear-log";
const SHORTCUTS: &str = "win.show-help-overlay";
const ABOUT    : &str = "win.about";

#[view {
	adw::BreakpointCondition::new_length(
		adw::BreakpointConditionLengthType::MaxWidth, 360.0 * 1.75, adw::LengthUnit::Sp
	) max_width { }
	
	adw::ApplicationWindow window {
		application: app
		default_height: settings.int(WINDOW_HEIGHT)
		default_width: settings.int(WINDOW_WIDTH)
		height_request: 360
		width_request: 360
		~/title: i18n("Aquarelle")
		
		#[cfg(debug_assertions)]
		add_css_class: "devel"
		
		add_breakpoint: _ @ adw::Breakpoint::new(max_width) {
			add_setter: &bar, "reveal", &true.to_value()
			add_setter: &header_bar, "title-widget", &gtk::Widget::NONE.to_value()
		}
		
		set_content: Some(&_) @ gtk::Box {
			~orientation: gtk::Orientation::Vertical
			
			append: &_ @ adw::HeaderBar header_bar {
				centering_policy: adw::CenteringPolicy::Strict
				
				~title_widget: &_ @ adw::ViewSwitcher {
					stack: &stack
					policy: adw::ViewSwitcherPolicy::Wide
				}
				
				pack_start: &_ @ gtk::ToggleButton {
					icon_name: icons::DOCK_BOTTOM
					action_name: SHOW_LOG
					// Translators: Button tooltip (keyboard shortcut).
					~tooltip_text: i18n("Show log (F12)")
					bind_property: "active", &log, "visible" 'back { bidirectional; sync_create; }
				}
				
				pack_start: &_ @ ref themes.buttons {
					'bind set_visible: view == "themes"
				}
				
				pack_end: &_ @ gtk::MenuButton {
					icon_name: icons::OPEN_MENU
					// Translators: Main menu button tooltip (keyboard shortcut).
					tooltip_text: i18n("Menu (F10)")
					
					~menu_model: &_ @ gio::Menu common_menu {
						append: Some(&i18n("_Clear Log")), Some(CLEAR_LOG)
						append: Some(&i18n("_Keyboard Shortcuts")), Some(SHORTCUTS)
						// Translators: Translate as "About [application name]"
						append: Some(&i18n("About A_quarelle")), Some(ABOUT)
						freeze;
					}!
					
					add_controller: utils::shortcut("F10", "activate")
					'bind set_visible: view != "themes"
				}
				
				pack_end: &_ @ gtk::MenuButton {
					icon_name: icons::OPEN_MENU
					// Translators: Main menu button tooltip (keyboard shortcut).
					tooltip_text: i18n("Menu (F10)")
					
					~menu_model: &_ @ gio::Menu {
						append_section: Some(&i18n("Show")), &_ @ gio::Menu {
							append: Some(&i18n(  "_All schemes")), Some(schemes::show::ALL)
							append: Some(&i18n("_Light schemes")), Some(schemes::show::LIGHT)
							append: Some(&i18n( "_Dark schemes")), Some(schemes::show::DARK)
						}!
						append_section: Some(&i18n("Appearance")), &_ @ gio::Menu {
							append: Some(&i18n( "De_fault scheme")), Some(schemes::appearance::DEFAULT)
							append: Some(&i18n("_Selected scheme")), Some(schemes::appearance::SELECTED)
							append: Some(&i18n(  "Do not chan_ge")), Some(schemes::appearance::NO_CHANGE)
						}!
						append_section: None, &common_menu
						freeze;
					}!
					
					add_controller: utils::shortcut("F10", "activate")
					'bind set_visible: view == "themes"
				}
			}
			
			append: &_ @ adw::ToastOverlay content {
				set_child: Some(&_) @ adw::ViewStack stack {
					add: &adw::Bin::new() 'back { // TODO component
						set_name: Some("arrangements")
						set_title: Some(&i18n("Arrangements"))
						set_icon_name: Some(icons::BRUSH_MONITOR)
					}!
					add: &_.root @ crate::themes::Themes themes {
						cache: Rc::clone(&cache)
						selection: selection.clone()
						settings: &settings
						tags: tags.clone()
						window: &window
					}? 'back {
						set_name: Some("themes")
						set_title: Some(&i18n("Themes"))
						set_icon_name: Some(icons::APPLICATIONS_GRAPHICS)
					}!
					add: &crate::settings::start(tags) 'back {
						set_name: Some("settings")
						set_title: Some(&i18n("Settings"))
						set_icon_name: Some(icons::SETTINGS)
					}!
				}!
			}!
			
			append: &_ @ adw::Bin handle {
				name: "handle"
				~height_request: 5
				set_cursor_from_name: Some("ns-resize")
				
				add_controller: _ @ gtk::GestureDrag {
					~propagation_phase: gtk::PropagationPhase::Capture
					
					connect_drag_update: clone! {
						content, log, min_height = content.preferred_size().0.height();
						move |_this, _x, y| {
							let new = log.allocated_height() - y.round() as i32;
							let max = content.allocated_height() + log.allocated_height() - min_height;
							if new >= 0 && new < max { log.set_height_request(new) }
						}
					}
				}
			}
			
			append: &_ @ gtk::ScrolledWindow log {
				height_request: settings.int(LOG_HEIGHT)
				name: "log"
				
				~child: &_ @ gtk::TextView {
					editable: false
					monospace: true
					wrap_mode: gtk::WrapMode::Word
					
					top_margin: 6
					bottom_margin: 6
					left_margin: 12
					right_margin: 12
					
					buffer: &_ @ ref buffer {
						connect_changed: clone![log, content, toast; move |this|
							if this.char_count() > 0 && !log.is_visible() {
								content.add_toast(toast.clone())
							}]
						
						emit_by_name::<()>: "changed", &[]
					}
				}
				
				bind_property: "visible", &handle, "visible" 'back { sync_create; }
				
				connect_show: move |_| _.dismiss() @ adw::Toast toast {
					title: i18n("Something went wrong")
					action_name: SHOW_LOG
					button_label: i18n("_Log")
				}
			}
			
			append: &_ @ adw::ViewSwitcherBar bar { stack: &stack }
		}
		
		add_action: &settings.create_action(&SHOW_LOG[4..])
		
		add_action: &_ @ gio::SimpleAction::new(&CLEAR_LOG[4..], None) {
			connect_activate: move |_, _|
				buffer.delete(&mut buffer.start_iter(), &mut buffer.end_iter())
		}
		
		help_overlay; 'back {
			'bind set_view_name: Some(view) // BUG not working
			~~unwrap;
		}
		
		add_action: &_ @ settings.create_action(LAST_VIEW) {
			connect_state_notify: move |this| {
				let view = this.state().unwrap();
				let view = view.str().unwrap();
				bindings! { }
			}
			notify: "state"
		}
		
		add_action: &_ @ gio::SimpleAction::new(&ABOUT[4..], None) {
			connect_activate: move |_, _| _.present() @ adw::AboutWindow {
				modal: true; transient_for: &window
				
				application_icon: config::APP_ID
				// Translators: "Aquarelle" is the application name, but translate it as the English word it is.
				application_name: i18n("Aquarelle")
				comments: i18n("Theming software")
				copyright: "© 2022 Eduardo Javier Alvarado Aarón"
				developer_name: "Eduardo Javier Alvarado Aarón"
				issue_url: "https://github.com/ejaa3/aquarelle/issues"
				license_type: gtk::License::Agpl30Only
				support_url: "https://matrix.to/#/#aquarelle:matrix.org"
				translator_credits: i18n("translator-credits")
				version: config::VERSION
			}
		}
		
		connect_maximized_notify: |this| {
			glib::idle_add_local_once(clone![this; move || this.notify("default-width")]);
		}
		
		connect_show: |this| this.notify("maximized")
		
		connect_close_request: clone![settings, log; move |this| {
			settings.set(WINDOW_WIDTH, this.default_width()).unwrap_or_else(
				|error| critical!("Failed to save {WINDOW_WIDTH:?} setting: {error}")
			);
			settings.set(WINDOW_HEIGHT, this.default_height()).unwrap_or_else(
				|error| critical!("Failed to save {WINDOW_HEIGHT:?} setting: {error}")
			);
			settings.set(LOG_HEIGHT, log.height_request()).unwrap_or_else(
				|error| critical!("Failed to save {LOG_HEIGHT:?} setting: {error}")
			);
			glib::Propagation::Proceed
		}]
	}
	
	ref app {
		set_accels_for_action: SHOW_LOG, &["F12"]
		set_accels_for_action: CLEAR_LOG, &["<Ctrl>K"]
		
		set_accels_for_action: schemes::show::ALL  , &["<Ctrl>1"]
		set_accels_for_action: schemes::show::LIGHT, &["<Ctrl>2"]
		set_accels_for_action: schemes::show::DARK , &["<Ctrl>3"]
		
		set_accels_for_action: schemes::appearance::DEFAULT  , &["<Ctrl>4"]
		set_accels_for_action: schemes::appearance::SELECTED , &["<Ctrl>5"]
		set_accels_for_action: schemes::appearance::NO_CHANGE, &["<Ctrl>6"]
		
		set_accels_for_action: "window.close", &["<Ctrl>W"]
	}
}]

pub fn start(app: &adw::Application) {
	let settings = gio::Settings::new(config::APP_ID);
	let tags = utils::Tags::new();
	let buffer = tags.buffer.clone(); // WARNING clone workaround
	
	let cache = Rc::new(cache::Cache::new(|error| {
		(if let cache::ScanError::Path { local: true, .. } = error
			{ log::warning } else { log::error }) (&tags, true);
		
		log::scan_error(&tags, error, ())
	}));
	
	let selection = crate::namespaces::SharedSelection::default();
	
	expand_view_here! { }
	
	settings.bind("window-maximized", &window, "maximized").build();
	settings.bind(LAST_VIEW, &stack, "visible-child-name").build();
	window.present()
}
