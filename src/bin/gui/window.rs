/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, cell::RefCell, fmt::Write, rc::Rc};
use adw::{gio, glib, prelude::*};
use vte::prelude::*;
use aquarelle::{cache, config, Msg};
use declarative::{clone, construct, view};
use crate::{icons, schemes, i18n, critical};

const WIDTH : &str = "width";
const HEIGHT: &str = "height";
const VIEW  : &str = "view";

const BOLD     : &str = "win.bold";
const CLEAR    : &str = "win.clear";
const SHORTCUTS: &str = "win.show-help-overlay";
const ABOUT    : &str = "win.about";

#[view {
	adw::BreakpointCondition::new_length(
		adw::BreakpointConditionLengthType::MaxWidth, 360.0 * 1.5, adw::LengthUnit::Sp
	) max_width { }
	
	adw::ApplicationWindow window {
		application: app
		default_height: settings.int(HEIGHT)
		default_width: settings.int(WIDTH)
		height_request: 360
		width_request: 360
		title: i18n("Aquarelle") ~>
		
		#[cfg(debug_assertions)]
		add_css_class: "devel"
		
		add_breakpoint: _ @ adw::Breakpoint::new(max_width) {
			add_setter: &bar, "reveal", Some(&true.to_value())
			add_setter: &themes.root, "collapsed", Some(&true.to_value())
			add_setter: &header_bar, "title-widget", Some(&gtk::Widget::NONE.to_value())
			
			connect_apply:   clone![themes.sidebar; move |_| sidebar.remove_css_class("sidebar")]
			connect_unapply: clone![themes.sidebar; move |_| sidebar.add_css_class("sidebar")]
		}
		
		set_content: Some(&_) @ adw::BottomSheet sheet {
			content: &_ @ adw::ToolbarView {
				set_top_bar_style: adw::ToolbarStyle::Raised
				
				add_top_bar: &_ @ adw::HeaderBar header_bar {
					title_widget: &_ @ adw::ViewSwitcher {
						stack: &stack
						policy: adw::ViewSwitcherPolicy::Wide
					} ~
					
					pack_start: &_ @ gtk::ToggleButton {
						icon_name: icons::DOCK_BOTTOM
						// Translators: Button tooltip (keyboard shortcut).
						tooltip_text: i18n("Show log (F12)") ~
						add_controller: crate::shortcut("F12", "activate")
						bind_property: "active", &sheet, "open" 'back { bidirectional; sync_create; }
					}
					
					pack_start: &_ @ ref themes.buttons {
						'bind set_visible: view == "themes"
					}
					
					pack_end: &_ @ gtk::MenuButton {
						icon_name: icons::OPEN_MENU
						// Translators: Menu button tooltip (keyboard shortcut).
						tooltip_text: i18n("Menu (F10)")
						
						menu_model: &_ @ gio::Menu common_menu {
							append: Some(&i18n("_Keyboard Shortcuts")), Some(SHORTCUTS)
							append: Some(&i18n("About A_quarelle")), Some(ABOUT)
							freeze;
						}! ~
						
						add_controller: crate::shortcut("F10", "activate")
						'bind set_visible: view != "themes"
					}
					
					pack_end: &_ @ gtk::MenuButton {
						icon_name: icons::OPEN_MENU
						tooltip_text: i18n("Menu (F10)")
						
						menu_model: &_ @ gio::Menu {
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
						}! ~
						
						add_controller: crate::shortcut("F10", "activate")
						'bind set_visible: view == "themes"
					}
				}
				set_content: Some(&_) @ adw::ViewStack stack {
					add: &adw::Bin::new() 'back { // TODO component
						set_name: Some("arrangements")
						set_title: Some(&i18n("Arrangements"))
						set_icon_name: Some(icons::BRUSH_MONITOR)
					}!
					add: &_.root @ crate::themes::Themes themes {
						cache: Rc::clone(&cache)
						selection: selection.clone()
						settings: &settings
						window: &window
					}? 'back {
						set_name: Some("themes")
						set_title: Some(&i18n("Themes"))
						set_icon_name: Some(icons::APPLICATIONS_GRAPHICS)
					}!
					add: &crate::settings::start() 'back {
						set_name: Some("settings")
						set_title: Some(&i18n("Settings"))
						set_icon_name: Some(icons::SETTINGS)
					}!
				}!
				add_bottom_bar: &_ @ adw::ViewSwitcherBar bar { stack: &stack }
			}!
			
			sheet: &_ @ adw::ToolbarView {
				css_classes: ["view"]
				content: &_ @ gtk::ScrolledWindow {
					propagate_natural_height: true
					child: &_ @ ref term {
						connect_cursor_moved: clone![sheet; move |_| sheet.set_open(true)]
						set_xalign: vte::Align::Center
					}
				} ~
				add_top_bar: &_ @ adw::HeaderBar {
					pack_end: &_ @ gtk::MenuButton {
						icon_name: icons::OPEN_MENU
						tooltip_text: i18n("Menu (F10)")
						
						menu_model: &_ @ gio::Menu {
							append: Some(&i18n("_Bold"))     , Some(BOLD)
							append: Some(&i18n("_Clear Log")), Some(CLEAR)
							freeze;
						}!
					}
				}!
			}
		}
		
		add_action: &settings.create_action(&BOLD[4..])
		add_action: &_ @ gio::SimpleAction::new(&CLEAR[4..], None) {
			connect_activate: clone![term; move |_, _| term.reset(true, true)]
		}
		
		help_overlay; 'back {
			'bind set_view_name: Some(view) // BUG not working
			unwrap; ~~
		}
		
		add_action: &_ @ settings.create_action(VIEW) {
			connect_state_notify: move |this| {
				let view = this.state().unwrap();
				let view = view.str().unwrap();
				bindings! { }
			}
			notify: "state"
		}
		
		add_action: &_ @ gio::SimpleAction::new(&ABOUT[4..], None) {
			// FIXME Some(&window) instead of gtk::Widget::NONE
			connect_activate: move |_, _| _.present(gtk::Widget::NONE) @ adw::AboutDialog {
				application_icon: config::APP_ID
				application_name: i18n("Aquarelle")
				comments: i18n("Color scheme processor")
				copyright: "© 2024 Eduardo Javier Alvarado Aarón"
				developer_name: "Eduardo Javier Alvarado Aarón"
				issue_url: "https://github.com/ejaa3/aquarelle/issues"
				license_type: gtk::License::Agpl30Only
				support_url: "https://github.com/ejaa3/aquarelle"
				translator_credits: i18n("translator-credits")
				version: config::VERSION
			}
		}
		
		connect_maximized_notify: |this| {
			glib::idle_add_local_once(clone![this; move || this.notify("default-width")]);
		}
		
		connect_show: |this| this.notify("maximized")
		
		connect_close_request: clone![settings; move |this| {
			settings.set(WIDTH, this.default_width()).unwrap_or_else(
				|error| critical!("Failed to save {WIDTH:?} setting: {error}")
			);
			settings.set(HEIGHT, this.default_height()).unwrap_or_else(
				|error| critical!("Failed to save {HEIGHT:?} setting: {error}")
			);
			glib::Propagation::Proceed
		}]
	}
	
	ref app {
		set_accels_for_action: BOLD     , &["<Ctrl>B"]
		set_accels_for_action: CLEAR, &["<Ctrl>K"]
		
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
	
	let cache = Rc::new(RefCell::new(cache::Cache::default()));
	
	cache.borrow_mut().update(|error| crate::MSG.with_borrow_mut(|msg| {
		writeln!(msg, "{}", annotate_snippets::Renderer::styled()
			.render(error.msg(<[Cow<_>; 2]>::default().each_mut())))
			.unwrap_or_else(|error| critical!("{error}"));
		true
	}));
	
	let selection = crate::namespaces::SharedSelection::default();
	let term = crate::TERM.with(vte::Terminal::clone);
	expand_view_here! { }
	
	crate::MSG.with_borrow(|msg| if !msg.is_empty() {
		for line in msg.split('\n') {
			term.feed(line.as_bytes());
			term.feed(b"\r\n")
		}
	});
	
	settings.bind("maximized", &window, "maximized").build();
	settings.bind(VIEW, &stack, "visible-child-name").build();
	window.present()
}
