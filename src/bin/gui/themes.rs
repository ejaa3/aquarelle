/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::RefCell, rc::Rc, thread::LocalKey};
use adw::{gtk::pango, gio, glib, prelude::*};
use aquarelle::{cache, Value};
use declarative::{clone, construct, view};
use crate::{icons, namespaces, scheme, schemes, Log, i18n, send};

pub type SelectedScheme = Rc<RefCell<Option<scheme::Object>>>;

pub struct Themes<'a> {
	pub     cache: Rc<RefCell<cache::Cache>>,
	pub selection: namespaces::SharedSelection,
	pub  settings: &'a gio::Settings,
	pub    window: &'a adw::ApplicationWindow,
}

impl Themes<'_> {
	pub fn start(self) -> Template { start(self) }
}

#[view {
	pub struct Template { }
	
	gtk::Revealer pub buttons {
		transition_type: gtk::RevealerTransitionType::SwingRight
		
		child: &_ @ gtk::Stack stack {
			transition_type: gtk::StackTransitionType::SlideLeftRight
			~
			add_child: &_ @ gtk::Button next {
				icon_name: icons::GO_NEXT ~
				connect_clicked: clone![root; move |_| root.set_show_content(true)]
			}
			add_child: &_ @ gtk::Button previous {
				icon_name: icons::GO_PREVIOUS ~
				connect_clicked: clone![root; move |_| root.set_show_content(false)]
			}
		}
	}
	
	adw::NavigationSplitView pub root {
		max_sidebar_width: 648.0
		min_sidebar_width: 324.0
		sidebar_width_fraction: 0.375
		vexpand: true
		
		sidebar: &_ @ adw::NavigationPage pub sidebar {
			css_classes: ["background", "sidebar"]
			title: i18n("Themes")
			
			child: &_.root @ namespaces::pane() {
				root.set_hexpand: false
				vbox.append: &_ @ adw::PreferencesGroup group { }
				
				vbox.prepend: &_ @ gtk::CheckButton {
					active: true
					label: i18n("_Do not filter by namespace or theme")
					namespaces::populate: &_, &cache.borrow(), &group, &tx, &selection
					use_underline: true
					~
					connect_toggled: clone![schemes.tx; move |this| if this.is_active() {
						let mut selected = selection.borrow_mut();
						selected.namespace.clear();
						selected.group.clear();
						send!(schemes::Msg::SelectItem => tx);
					}]
				}
				
				vbox.append: &_.root @ crate::colors::start() colors { }
				
				vbox.append: &_ @ adw::PreferencesGroup preset_group {
					title: i18n("Preset values")
					description: i18n("Bindable to parametric schemes")
					
					header_suffix: &_ @ gtk::MenuButton {
						css_classes: ["circular"]
						icon_name: icons::LIST_ADD
						valign: gtk::Align::Center
						
						menu_model: &_ @ gio::Menu {
							append: Some(&i18n("Boolean")              ), Some("win.bool")
							append: Some(&i18n("Integer number")       ), Some("win.int")
							append: Some(&i18n("Floating-point number")), Some("win.float")
							append: Some(&i18n("Text string")          ), Some("win.string")
							append: Some(&i18n("Accent color")         ), Some("win.accent")
							freeze;
						}!
					}
				}
			}
		}
		
		content: &_ @ adw::NavigationPage {
			title: i18n("Schemes")
			child: &_.root @ schemes::Schemes schemes {
				cache: Rc::clone(&cache)
				scheme: Rc::clone(&scheme)
				selection: Rc::clone(&selection)
				settings: settings.clone()
				themes: tx.clone()
				window;
			}?
		} ~
		
		bind_property: "collapsed", &buttons, "reveal-child" 'back { sync_create; }
		
		connect_show_content_notify: clone![stack, next, previous; move |this|
			stack.set_visible_child(if this.shows_content() { &previous } else { &next })]
	}
}]

fn start(Themes { cache, selection, settings, window }: Themes) -> Template {
	let (tx, rx) = async_channel::bounded(1);
	let scheme = SelectedScheme::default();
	
	expand_view_here! { }
	
	let mut preset_rows = vec![];
	
	#[allow(clippy::unit_arg)]
	let mut update = move |msg| Some(match msg {
		namespaces::Msg::Select =>
			send!(schemes::Msg::SelectItem => schemes.tx),
		
		namespaces::Msg::SelectItem => {
			let scheme = scheme.borrow();
			let scheme::Scheme { data, namespace_id, theme_id, .. }
			  = scheme.as_ref().unwrap().borrow();
			
			(colors.refresh) (data);
			
			let cache = cache.borrow();
			let (namespace, bin) = cache.namespace(namespace_id).log()?;
			let theme = namespace.theme(theme_id, bin).log()?;
			
			for row in &preset_rows { preset_group.remove(row); }
			preset_rows.clear();
			
			for (id, value) in &theme.presets {
				let row = preset_row(id, value);
				preset_group.add(&row);
				preset_rows.push(row);
			}
		}
	});
	
	glib::spawn_future_local(async move {
		while let Ok(msg) = rx.recv().await { update(msg); }
	});
	
	Template { root, sidebar, buttons }
}

#[view[ adw::EntryRow root {
	text: id
	title: match value {
		Value::Bool  (_) => i18n("Boolean"),
		Value::Int   (_) => i18n("Integer"),
		Value::Float (_) => i18n("Decimal number"),
		Value::Str   (_) => i18n("Text"),
		Value::Acc  {..} => i18n("Accent color"),
		Value::Bind {..} => unreachable!(),
	} ~
	
	add_suffix: &_ @ gtk::Box {
		if let Value::Bool(..) = value
			{ set_spacing: 6 } else { add_css_class: "linked" }
		
		append: &_ @ gtk::Button {
			if let Value::Bool(..) = value { add_css_class: "flat" }
			icon_name: icons::USER_TRASH
			valign: gtk::Align::Center
		}
		
		match value {
			Value::Bool(value) => append: &_ @ gtk::Switch {
				active: *value
				valign: gtk::Align::Center
			}
			Value::Int(value) => append: &_ @ gtk::SpinButton {
				climb_rate: 1.0
				valign: gtk::Align::Center
				value: *value as f64
				width_chars: 4
				
				adjustment: &_ @ gtk::Adjustment {
					lower: rhai::INT::MIN as f64
					upper: rhai::INT::MAX as f64
					step_increment: 1.0
				}
			}
			Value::Float(value) => append: &_ @ gtk::SpinButton {
				climb_rate: 1.0
				digits: 2
				valign: gtk::Align::Center
				value: *value as f64
				width_chars: 6
				
				adjustment: &_ @ gtk::Adjustment {
					lower: rhai::FLOAT::MIN as f64
					upper: rhai::FLOAT::MAX as f64
					step_increment: 1.0
				}
			}
			Value::Str(value) => append: &_ @ gtk::Button {
				valign: gtk::Align::Center
				
				child: &_ @ gtk::Label {
					ellipsize: pango::EllipsizeMode::End
					label: value.lines().next().unwrap_or("")
					max_width_chars: 11
					single_line_mode: true
					
					attributes: &_ @ pango::AttrList {
						insert: pango::AttrFontDesc::new(&_) @
							pango::FontDescription mut {
								set_weight: pango::Weight::Book
							}!
					}!
				}
			}
			Value::Acc { accent } => append: &_ @ gtk::DropDown {
				selected: *accent as u32
				valign: gtk::Align::Center
				with_list: &_, &ACCENTS
			}
			Value::Bind { .. } => { }
		}
	}!
} ]]

fn preset_row(id: &str, value: &Value) -> adw::EntryRow {
	expand_view_here! { }
	root
}

thread_local! {
	static ACCENTS: gtk::StringList = gtk::StringList::new(&[
		&i18n("Red"), &i18n("Yellow"), &i18n("Green"), &i18n("Cyan"),
		&i18n("Blue"), &i18n("Magenta"), &i18n("Any"),
	]);
}

fn with_list(drop_down: &gtk::DropDown, list: &'static LocalKey<gtk::StringList>) {
	list.with(|list| drop_down.set_model(Some(list)));
}
