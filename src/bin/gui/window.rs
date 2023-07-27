/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::rc::Rc;
use adw::{gio, glib, prelude::*};
use aquarelle::{cache, config};
use declarative::{builder_mode, clone, view};
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
	adw::Toast toast !{
		title: i18n("Something went wrong")
		action_name: SHOW_LOG
		button_label: i18n("_Log")
	}
	
	adw::ApplicationWindow window !{
		application: app
		default_height: settings.int(WINDOW_HEIGHT)
		default_width: settings.int(WINDOW_WIDTH)
		~/title: i18n("Aquarelle")
		
		#[cfg(debug_assertions)]
		add_css_class: "devel"
		
		gtk::Box #set_content(Some(&#)) !{
			~orientation: gtk::Orientation::Vertical
			
			adw::HeaderBar #append(&#) !{
				centering_policy: adw::CenteringPolicy::Strict
				
				~adw::ViewSwitcherTitle #title_widget(&#) !{
					stack: &stack
					~title: i18n("Aquarelle")
					bind_property: "title-visible", &bar, "reveal" 'back !{ }
				}
				
				gtk::ToggleButton #pack_start(&#) !{
					icon_name: icons::DOCK_BOTTOM
					action_name: SHOW_LOG
					// Translators: Button tooltip (keyboard shortcut).
					~tooltip_text: i18n("Show log (F12)")
					bind_property: "active", &flap, "reveal-flap" 'back !{ bidirectional; sync_create; }
				}
				
				ref themes.buttons #pack_start(&#) {
					'bind set_visible: view == "themes"
				}
				
				gtk::MenuButton #pack_end(&#) !{
					icon_name: icons::OPEN_MENU
					// Translators: Main menu button tooltip (keyboard shortcut).
					tooltip_text: i18n("Menu (F10)")
					
					~gio::Menu common_menu #menu_model(&#) {
						append: Some(&i18n("_Clear Log")), Some(CLEAR_LOG)
						append: Some(&i18n("_Keyboard Shortcuts")), Some(SHORTCUTS)
						// Translators: Translate as "About [application name]"
						append: Some(&i18n("About A_quarelle")), Some(ABOUT)
						freeze;
					}
					
					add_controller: utils::shortcut("F10", "activate")
					'bind set_visible: view != "themes"
				}
				
				gtk::MenuButton #pack_end(&#) !{
					icon_name: icons::OPEN_MENU
					// Translators: Main menu button tooltip (keyboard shortcut).
					tooltip_text: i18n("Menu (F10)")
					
					~gio::Menu #menu_model(&#) {
						gio::Menu #append_section(Some(&i18n("Show")), &#) {
							append: Some(&i18n(  "_All schemes")), Some(schemes::show::ALL)
							append: Some(&i18n("_Light schemes")), Some(schemes::show::LIGHT)
							append: Some(&i18n( "_Dark schemes")), Some(schemes::show::DARK)
						}
						gio::Menu #append_section(Some(&i18n("Appearance")), &#) {
							append: Some(&i18n( "De_fault scheme")), Some(schemes::appearance::DEFAULT)
							append: Some(&i18n("_Selected scheme")), Some(schemes::appearance::SELECTED)
							append: Some(&i18n(  "Do not chan_ge")), Some(schemes::appearance::NO_CHANGE)
						}
						append_section: None, &common_menu
						freeze;
					}
					
					add_controller: utils::shortcut("F10", "activate")
					'bind set_visible: view == "themes"
				}
			}
			
			adw::Flap flap #append(&#) !{
				flap_position: gtk::PackType::End
				fold_policy: adw::FlapFoldPolicy::Never
				orientation: gtk::Orientation::Vertical
				
				adw::ToastOverlay content #content(&#) {
					adw::ViewStack stack #set_child(Some(&#)) {
						adw::Bin #add(&#) 'back { // TODO component
							set_name: Some("arrangements")
							set_title: Some(&i18n("Arrangements"))
							set_icon_name: Some(icons::BRUSH_MONITOR)
						}
						crate::themes::Themes themes ~{
							cache: Rc::clone(&cache)
							selection: selection.clone()
							settings: &settings
							tags;
							window: &window
							
							#add(&#.root) 'back {
								set_name: Some("themes")
								set_title: Some(&i18n("Themes"))
								set_icon_name: Some(icons::APPLICATIONS_GRAPHICS)
							}
						}
						crate::settings::start(tags.clone()) #add(&#) 'back {
							set_name: Some("settings")
							set_title: Some(&i18n("Settings"))
							set_icon_name: Some(icons::SETTINGS)
						}
					}
				}
				
				~gtk::Box #flap(&#) !{
					css_classes: ["view"]
					orientation: gtk::Orientation::Vertical
					~spacing: 0
					
					adw::Bin #append(&#) !{
						name: "handle"
						~height_request: 5
						set_cursor_from_name: Some("ns-resize")
						
						gtk::GestureDrag #add_controller(#) !{
							~propagation_phase: gtk::PropagationPhase::Capture
							
							connect_drag_update: clone! {
								log, flap, no_hide = content.preferred_size().0.height() + 5;
								move |_this, _x, y| {
									let new = log.allocated_height() - y.round() as i32;
									
									if new >= 50 && new < flap.allocated_height() - no_hide {
										log.set_height_request(new)
									}
								}
							}
						}
					}
					
					gtk::ScrolledWindow log #append(&#) !{
						height_request: settings.int(LOG_HEIGHT)
						name: "log"
						
						gtk::TextView #child(&#) !{
							editable: false
							monospace: true
							wrap_mode: gtk::WrapMode::Word
							
							top_margin: 6
							bottom_margin: 6
							left_margin: 12
							right_margin: 12
							
							ref buffer #buffer(&#) {
								connect_changed: clone![flap, content, toast; move |this|
									if this.char_count() > 0 && !flap.reveals_flap() {
										content.add_toast(toast.clone())
									}]
								
								emit_by_name::<()>: "changed", &[]
							}
						}
					}
				}
				
				connect_reveal_flap_notify: clone![toast; move |_| toast.dismiss()]
			}
			
			adw::ViewSwitcherBar bar #append(&#) !{ stack: &stack }
		}
		
		add_action: &settings.create_action(&SHOW_LOG[4..])
		
		gio::SimpleAction::new(&CLEAR_LOG[4..], None) #add_action(&#) {
			connect_activate: move |_, _|
				buffer.delete(&mut buffer.start_iter(), &mut buffer.end_iter())
		}
		
		help_overlay; 'back !{
			'bind set_view_name: Some(view) // BUG not working
			~~unwrap;
		}
		
		settings.create_action(LAST_VIEW) #add_action(&#) {
			connect_state_notify: @move |this| {
				let view = this.state().unwrap();
				let view = view.str().unwrap();
				bindings! { }
			}
			notify: "state"
		}
		
		gio::SimpleAction::new(&ABOUT[4..], None) #add_action(&#) {
			connect_activate: move |_, _| about_dialog.present()
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
			glib::signal::Inhibit(false)
		}]
	}
	
	adw::AboutWindow about_dialog !{
		modal: true; transient_for: &window
		
		application_icon: config::APP_ID
		// Translators: "Aquarelle" is the application name, but translate it as the English word it is.
		application_name: i18n("Aquarelle")
		comments: i18n("Color schemes designer and adaptor")
		copyright: "© 2022 Eduardo Javier Alvarado Aarón"
		developer_name: "Eduardo Javier Alvarado Aarón"
		issue_url: "https://github.com/ejaa3/aquarelle/issues"
		license_type: gtk::License::Agpl30Only
		support_url: "https://matrix.to/#/#aquarelle:matrix.org"
		translator_credits: i18n("translator-credits")
		version: config::VERSION
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
