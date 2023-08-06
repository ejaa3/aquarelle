/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::RefCell, rc::Rc, thread::LocalKey};
use adw::{gtk::pango, gio, glib, prelude::*};
use aquarelle::{cache, Value};
use declarative::{builder_mode, clone, view};
use crate::{icons, log, log::Log, namespaces, scheme, schemes, i18n, send};

pub type SelectedScheme = Rc<RefCell<Option<scheme::Object>>>;

pub struct Themes<'a> {
	pub     cache: Rc<cache::Cache>,
	pub selection: namespaces::SharedSelection,
	pub  settings: &'a gio::Settings,
	pub      tags: crate::utils::Tags,
	pub    window: &'a adw::ApplicationWindow,
}

impl Themes<'_> {
	pub fn start(self) -> Template { start(self) }
}

#[view {
	pub struct Template { }
	
	gtk::Revealer pub buttons: !{
		transition_type: gtk::RevealerTransitionType::SwingRight
		
		gtk::Stack stack #child(&#) !{
			~transition_type: gtk::StackTransitionType::SlideLeftRight
			
			gtk::Button next #add_child(&#) !{
				~icon_name: icons::GO_NEXT
				
				connect_clicked: clone![root; move |_| {
					root.navigate(adw::NavigationDirection::Forward);
				}]
			}
			
			gtk::Button previous #add_child(&#) !{
				~icon_name: icons::GO_PREVIOUS
				
				connect_clicked: clone![root; move |_| {
					root.navigate(adw::NavigationDirection::Back);
				}]
			}
		}
	}
	
	adw::Leaflet pub root: !{
		can_navigate_back: true
		can_navigate_forward: true
		~transition_type: adw::LeafletTransitionType::Slide
		
		bind_property: "folded", &buttons, "reveal-child" 'back !{ sync_create; }
		
		namespaces::pane(window) pane {
			#append(&#.root) 'back { set_name: Some("pane") }
			root.set_hexpand: false
			
			adw::PreferencesGroup group #vbox.append(&#) { }
			
			gtk::CheckButton #vbox.prepend(&#) !{
				active: true
				label: i18n("_Do not filter by namespace or theme")
				~use_underline: true
				@namespaces::populate(&#, &tags, &cache, &group, &selection, &tx)
				
				connect_toggled: clone![schemes.tx; move |this| if this.is_active() {
					let mut selected = selection.borrow_mut();
					selected.namespace.clear();
					selected.group.clear();
					send!(schemes::Msg::SelectItem => tx);
				}]
			}
			
			crate::colors::start() colors #vbox.append(&#.root) { }
			
			adw::PreferencesGroup option_group #vbox.append(&#) !{
				title: i18n("Shared options")
				description: i18n("Bindable to dynamic schemes")
				
				gtk::MenuButton #header_suffix(&#) !{
					css_classes: ["circular"]
					icon_name: icons::LIST_ADD
					valign: gtk::Align::Center
					
					gio::Menu #menu_model(&#) {
						append: Some(&i18n("Boolean")       ), Some("win.boolean")
						append: Some(&i18n("Integer")       ), Some("win.integer")
						append: Some(&i18n("Decimal number")), Some("win.float")
						append: Some(&i18n("Text")          ), Some("win.string")
						append: Some(&i18n("Color Set")     ), Some("win.set")
						append: Some(&i18n("Color Role")    ), Some("win.role")
						freeze;
					}
				}
			}
		}
		
		gtk::Separator #append(&#) 'back { set_navigatable: false }
		
		schemes::Schemes schemes ~{
			#append(&#.root) 'back { set_name: Some("schemes") }
			cache: Rc::clone(&cache)
			scheme: Rc::clone(&scheme)
			selection: Rc::clone(&selection)
			settings: settings.clone()
			tags: tags.clone()
			themes: tx.clone()
			window;
		}
		
		connect_visible_child_notify: clone![stack, next, previous;
			move |this| match this.visible_child_name().as_deref() {
				Some("pane") => stack.set_visible_child(&next),
				Some("schemes") => stack.set_visible_child(&previous),
				_ => unreachable!(),
			}]
	}
}]

fn start(Themes { cache, selection, settings, tags, window }: Themes) -> Template {
	let (tx, rx) = glib::MainContext::channel(glib::Priority::DEFAULT);
	
	let scheme = SelectedScheme::default();
	
	expand_view_here! { }
	
	let mut option_rows = vec![];
	
	let mut update = move |msg| Some(match msg {
		namespaces::Msg::Select =>
			send!(schemes::Msg::SelectItem => schemes.tx),
		
		namespaces::Msg::SelectItem => {
			let scheme = scheme.borrow();
			let scheme::Scheme { data, namespace_id, theme_id, .. }
			  = scheme.as_ref().unwrap().borrow();
			
			(colors.refresh) (&data.sets);
			
			let (namespace, bin) = cache.namespace(&namespace_id)
				.log(|_| log::critical, log::cache_error, (), &tags, true)?;
			
			let theme = namespace.theme(&theme_id, bin)
				.log(|_| log::critical, log::namespace_error, &namespace_id, &tags, true)?;
			
			for row in &option_rows { option_group.remove(row); }
			option_rows.clear();
			
			for (id, option) in &theme.options {
				let row = option_row(id, option);
				option_group.add(&row);
				option_rows.push(row);
			}
		}
	});
	
	rx.attach(None, move |msg| { update(msg); glib::ControlFlow::Continue });
	
	Template { root, buttons }
}

#[view {
	adw::EntryRow root !{
		title: match value {
			Value::Boolean (_) => i18n("Boolean"),
			Value::Integer (_) => i18n("Integer"),
			Value::Float   (_) => i18n("Decimal number"),
			Value::String  (_) => i18n("Text"),
			Value::Set    {..} => i18n("Color Set"),
			Value::Role   {..} => i18n("Color Role"),
			Value::Binding (_) | Value::Bind(_) => unreachable!()
		}
		~text: id
		
		gtk::Box #add_suffix(&#) {
			if let Value::Boolean(..) = value
				{ set_spacing: 6 } else { add_css_class: "linked" }
			
			gtk::Button #append(&#) !{
				if let Value::Boolean(..) = value { add_css_class: "flat" }
				icon_name: icons::USER_TRASH
				valign: gtk::Align::Center
			}
			
			match value {
				Value::Boolean(value) => gtk::Switch #append(&#) !{
					active: *value
					valign: gtk::Align::Center
				}
				Value::Integer(value) => gtk::SpinButton #append(&#) !{
					climb_rate: 1.0
					valign: gtk::Align::Center
					value: *value as f64
					width_chars: 4
					
					gtk::Adjustment #adjustment(&#) !{
						lower: rhai::INT::MIN as f64
						upper: rhai::INT::MAX as f64
						step_increment: 1.0
					}
				}
				Value::Float(value) => gtk::SpinButton #append(&#) !{
					climb_rate: 1.0
					digits: 2
					valign: gtk::Align::Center
					value: *value as f64
					width_chars: 6
					
					gtk::Adjustment #adjustment(&#) !{
						lower: rhai::FLOAT::MIN as f64
						upper: rhai::FLOAT::MAX as f64
						step_increment: 1.0
					}
				}
				Value::String(value) => gtk::Button #append(&#) !{
					valign: gtk::Align::Center
					
					gtk::Label #child(&#) !{
						ellipsize: pango::EllipsizeMode::End
						label: value.as_str()
						max_width_chars: 11
						single_line_mode: true
						
						pango::AttrList #attributes(&#) {
							pango::FontDescription mut {
								#insert(pango::AttrFontDesc::new(&#))
								set_weight: pango::Weight::Book
							}
						}
					}
				}
				Value::Set { set } => gtk::DropDown #append(&#) !{
					selected: *set as u32
					valign: gtk::Align::Center
					@with_list(&#, &SETS)
				}
				Value::Role { role } => gtk::DropDown #append(&#) !{
					selected: *role as u32
					valign: gtk::Align::Center
					@with_list(&#, &ROLES)
				}
				Value::Binding(_) | Value::Bind(_) => { }
			}
		}
	}
}]

fn option_row(id: &str, value: &Value) -> adw::EntryRow {
	expand_view_here! { }
	root
}

thread_local! {
	static SETS: gtk::StringList = gtk::StringList::new(&[
		&i18n("Lower" ), &i18n("Upper"  ), &i18n("Red" ),
		&i18n("Yellow"), &i18n("Green"  ), &i18n("Cyan"),
		&i18n("Blue"  ), &i18n("Magenta"), &i18n("Any" ),
	]);
	static ROLES: gtk::StringList = gtk::StringList::new(&[
		&i18n("Like"), &i18n("Area"), &i18n("Text"),
	]);
}

fn with_list(drop_down: &gtk::DropDown, list: &'static LocalKey<gtk::StringList>) {
	list.with(|list| drop_down.set_model(Some(list)));
}
