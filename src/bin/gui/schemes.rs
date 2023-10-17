/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::Ref, rc::Rc};
use adw::{gdk, gio, glib, prelude::*};
use aquarelle::{cache, config, Value};
use compact_str::CompactString;
use declarative::{clone, construct, view};
use crate::{log, log::Log, namespaces, scheme, themes, utils, i18n, send};

const SCHEME: &str = "scheme";

pub mod appearance {
	pub const SETTING  : &str =     "appearance";
	pub const DEFAULT  : &str = "win.appearance::Default";
	pub const SELECTED : &str = "win.appearance::Selected";
	pub const NO_CHANGE: &str = "win.appearance::NoChange";
}

pub mod show {
	pub const SETTING: &str =     "show-schemes";
	pub const ALL    : &str = "win.show-schemes::All";
	pub const LIGHT  : &str = "win.show-schemes::Light";
	pub const DARK   : &str = "win.show-schemes::Dark";
}

#[derive(Clone, Copy, Debug)]
pub enum Msg {
	SelectItem,
	UseDefaultAppearance,
	UseSelectedSchemeForAppearance,
	DoNotChangeAppearance,
	SelectScheme,
	Shutdown,
}

pub struct Schemes<'a> {
	pub     cache: Rc<cache::Cache>,
	pub    scheme: themes::SelectedScheme,
	pub selection: namespaces::SharedSelection,
	pub  settings: gio::Settings,
	pub      tags: utils::Tags,
	pub    themes: glib::Sender<namespaces::Msg>,
	pub    window: &'a adw::ApplicationWindow,
}

impl Schemes<'_> {
	pub fn start(self) -> Template { start(self) }
}

#[view {
	pub struct Template { pub tx: glib::Sender<Msg> }
	
	gtk::Box pub root {
		hexpand: true
		orientation: gtk::Orientation::Vertical
		~/width_request: 324
		
		append: &_ @ gtk::SearchBar {
			key_capture_widget: window
			
			child: &_ @ gtk::SearchEntry {
				~placeholder_text: i18n("Search")
				
				connect_search_changed: clone![name_filter; move |this| {
					let text = this.text();
					name_filter.set_search(if text.is_empty() { None } else { Some(&text) });
				}]
			}
		}
		append: &_ @ gtk::ScrolledWindow {
			vexpand: true
			
			child: &_ @ adw::ClampScrollable {
				maximum_size: 5 * (scheme::SVG_WIDTH + 2 * 18) // 2 = left / right, 18 = padding
				
				child: &_ @ gtk::GridView {
					name: "thumbnail-grid"
					max_columns: 5
					
					model: &_ @ gtk::SingleSelection single {
						autoselect: false
						
						~model: &_ @ gtk::FilterListModel {
							filter: &_ @ gtk::StringFilter {
								'bind set_search: (!selected.namespace.is_empty()).then_some(&selected.namespace)
								
								expression: &gtk::ClosureExpression::new::<String>(
									gtk::Expression::NONE, glib::closure! {
										|scheme: scheme::Object| scheme.borrow().namespace_id.to_string()
									}
								)
							}
							model: &_ @ gtk::FilterListModel {
								filter: &_ @ gtk::StringFilter {
									'bind set_search: (!selected.group.is_empty()).then_some(&selected.group)
									
									expression: &gtk::ClosureExpression::new::<String>(
										gtk::Expression::NONE, glib::closure! {
											|scheme: scheme::Object| scheme.borrow().theme_id.to_string()
										}
									)
								}
								model: &_ @ gtk::FilterListModel show_model {
									model: &_ @ gtk::FilterListModel {
										model: &get_schemes(&cache, &tags, &root.display())
										
										filter: &_ @ gtk::StringFilter name_filter {
											ignore_case: true
											match_mode: gtk::StringFilterMatchMode::Substring
											
											expression: &gtk::ClosureExpression::new::<String>(
												gtk::Expression::NONE, glib::closure! {
													|scheme: scheme::Object| scheme.borrow().data.name.to_string()
												}
											)
										}
									}
								}
							}
							'consume update_filters = move |selected: Ref<namespaces::Selection>| bindings!()
						}
						connect_selected_item_notify: clone![tx; move |_| send!(Msg::SelectScheme => tx)]
					}
					factory: &_ @ gtk::SignalListItemFactory {
						connect_setup: scheme::factory_setup
					}!
				}
			}
		}
	}
	ref window {
		add_action: &_ @ settings.create_action(show::SETTING) {
			connect_state_notify: move |this| {
				let show = this.state().unwrap();
				let show = show.str().unwrap();
				
				if show == "All" {
					return show_model.set_filter(gtk::Filter::NONE)
				}
				
				let filter = gtk::BoolFilter::new(Some(
					gtk::ClosureExpression::new::<bool>(
						gtk::Expression::NONE, glib::closure! {
							|scheme: scheme::Object| scheme.borrow().dark
						}
					)
				));
				
				filter.set_invert(show != "Dark");
				
				show_model.set_filter(Some(&filter));
			}
			notify: "state"
		}
		connect_close_request: clone![tx; move |_| {
			send!(Msg::Shutdown => tx);
			glib::Propagation::Proceed
		}]
		add_action: &_ @ settings.create_action(appearance::SETTING) {
			connect_state_notify: clone![tx; move |this|
				match this.state().unwrap().str().unwrap() {
					"Default"  => send!(Msg::UseDefaultAppearance => tx),
					"Selected" => send!(Msg::UseSelectedSchemeForAppearance => tx),
					"NoChange" => send!(Msg::DoNotChangeAppearance => tx),
					_ => unreachable!()
				}]
		}
	}
}]

pub fn start(Schemes { cache, scheme, selection, settings, tags, themes, window }: Schemes) -> Template {
	let (tx, rx) = glib::MainContext::channel(glib::Priority::DEFAULT);
	
	expand_view_here! { }
	
	let (namespace, theme, scheme_id): (String, String, String) = settings.get(SCHEME);
	let mut appearance = get_scheme(&cache, &tags, log::warning, &namespace, &theme, &scheme_id);
	let mut is_selected = settings.string(appearance::SETTING) == "Selected";
	let css = gtk::CssProvider::new();
	
	gtk::style_context_add_provider_for_display(
		&root.display(), &css, gtk::STYLE_PROVIDER_PRIORITY_USER
	);
	
	set_appearance(&appearance, &cache, &tags, &css);
	
	let mut update_state = move |msg| Some(match msg {
		Msg::SelectItem => update_filters(selection.borrow()),
		Msg::UseDefaultAppearance => {
			is_selected = false;
			appearance = get_scheme(
				&cache, &tags, log::critical,
				config::APP, "everforest", "hard-dark"
			);
			set_appearance(&appearance, &cache, &tags, &css);
		}
		Msg::UseSelectedSchemeForAppearance => {
			is_selected = true;
			let scheme = single.selected_item()?;
			appearance = Some(scheme.downcast().unwrap());
			set_appearance(&appearance, &cache, &tags, &css);
		}
		Msg::DoNotChangeAppearance => is_selected = false,
		Msg::SelectScheme => {
			let selected = single.selected_item()?;
			let selected: scheme::Object = selected.downcast().unwrap();
			
			*scheme.borrow_mut() = Some(selected.clone());
			send!(namespaces::Msg::SelectItem => themes);
			
			if is_selected {
				appearance = Some(selected);
				set_appearance(&appearance, &cache, &tags, &css);
			}
		}
		Msg::Shutdown => if let Some(ref scheme) = appearance {
			settings.set(SCHEME, scheme.borrow().location()).unwrap_or_else(
				move |error| crate::critical!("Failed to save {SCHEME} setting: {error}")
			);
		}
	});
	
	rx.attach(None, move |msg| {
		update_state(msg);
		match msg { Msg::Shutdown => glib::ControlFlow::Break, _ => glib::ControlFlow::Continue }
	});
	
	Template { root, tx }
}

fn set_appearance(
	appearance: & Option<scheme::Object>,
	     cache: & cache::Cache,
	      tags: & utils::Tags,
	       css: & gtk::CssProvider,
) -> Option<()> {
	let scheme = appearance.as_ref()?.borrow();
	let (namespace_id, theme_id, scheme_id) = scheme.location();
	
	let (namespace, bin) = cache.namespace(&namespace_id)
		.log(|_| log::critical, log::cache_error, (), &tags, true)?;
	
	let theme = namespace.theme(theme_id, bin)
		.log(|_| log::critical, log::namespace_error, namespace_id, &tags, true)?;
	
	let data = theme.scheme(scheme_id, "", &cache, Default::default()) // TODO Safety
		.log(|_| log::critical, log::theme_error, (), &tags, true)?;
	
	let (namespace, bin) = if namespace_id != config::APP {
		cache.namespace(config::APP)
			.log(|_| log::critical, log::cache_error, (), &tags, true)?
	} else { (namespace, bin) };
	
	let (map_id, map) = namespace.map("adwaita", bin)
		.log(|_| log::critical, log::namespace_error, namespace_id, &tags, true)?;
	
	const     ACCENT: CompactString = CompactString::new_inline("accent");
	const DIM_HEADER: CompactString = CompactString::new_inline("dim-header");
	const CUSTOM_CSS: CompactString = CompactString::new_inline("custom-css");
	const       MAIN: CompactString = CompactString::new_inline("main");
	
	let success = aquarelle::mapping::Ready {
		map, id: config::APP_ID, map_id,
		options: [
			(    ACCENT, Value::Set { set: aquarelle::Set::Any }),
			(DIM_HEADER, Value::Bool(true)),
			(CUSTOM_CSS, Value::String(Default::default())),
		].into(),
		   name: Default::default(),
		display: Default::default(),
		schemes: Rc::new([(MAIN, data.clone())].into()),
		 safety: Default::default(), // TODO Safety
		  paths: None,
		replica: (Default::default(), aquarelle::arrangement::Replica::Copy),
	}.perform().log(|_| log::critical, log::mapping_error, (), &tags, true)?;
	
	tags.refresh(&data.sets);
	css.load_from_data(&success.text.unwrap());
	None
}

fn get_schemes(cache: &cache::Cache, tags: &utils::Tags, display: &gdk::Display) -> gio::ListStore {
	let mut list = gio::ListStore::new::<scheme::Object>();
	
	list.extend(cache.namespaces.iter().filter_map(move |(at, bin)| {
		let namespace = bin.get(at).log(|error| match **error {
			cache::Error::Io(..) => log::warning, _ => log::error
		}, log::cache_error, (), &tags, true)?;
		
		Some(namespace.themes.iter().filter_map(move |(theme_id, item)| {
			let theme = item.get(theme_id, bin)
				.log(|_| log::error, log::namespace_error, at, &tags, true)?;
			
			Some(theme.schemes.iter().filter_map(move |(id, scheme)| {
				let static_scheme = scheme.data(at, &cache, &Default::default(), &theme.options) // TODO Safety
					.map_err(move |error| aquarelle::theme::Error::Scheme { id, error })
					.log(|_| log::error, log::theme_error, (), &tags, true)?;
				
				let metadata = scheme::Object::new(
					Rc::clone(static_scheme), at.clone(), theme_id.clone(), id.clone(), &display
				);
				scheme.metadata.set(Box::new(metadata.clone())).unwrap();
				Some(metadata)
			}))
		}))
	}).flatten().flatten());
	
	list
}

fn get_scheme(
	       cache: & cache::Cache,
	        tags: & utils::Tags,
	 log_variant:   fn(&utils::Tags, bool),
	namespace_id: & str,
	    theme_id: & str,
	   scheme_id: & str,
) -> Option<scheme::Object> {
	let Some((namespace, bin)) = cache.namespace(&namespace_id)
		.log(|_| log_variant, log::cache_error, (), &tags, true)
		else { return None };
	
	let Some(theme) = namespace.theme(&theme_id, bin)
		.log(|_| log_variant, log::namespace_error, &namespace_id, &tags, true)
		else { return None };
	
	let Some(scheme) = theme.schemes.get(&scheme_id as &str) else {
		log_variant(&tags, true);
		log::theme_error(&tags, aquarelle::theme::Error::NotFound { id: &scheme_id }, ());
		return None;
	};
	
	Some(scheme.metadata.get().unwrap()
		.downcast_ref::<scheme::Object>().unwrap().clone())
}
