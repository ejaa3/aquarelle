/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::RefCell, rc::Rc};
use adw::{gdk, gio, glib, prelude::*};
use aquarelle::{cache, config, Value};
use compact_str::CompactString;
use declarative::{clone, construct, view};
use palette::{rgb::channels::Rgba, Desaturate, FromColor};
use vte::TerminalExtManual;
use crate::{namespaces, scheme, themes, Log, i18n, rgba, send};

const SKIN: &str = "skin";

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

#[derive(Clone, Copy)]
pub enum Msg {
	SelectItem,
	UseDefaultAppearance,
	UseSelectedSchemeForAppearance,
	DoNotChangeAppearance,
	SelectScheme,
	Shutdown,
}

pub struct Schemes<'a> {
	pub     cache: Rc<RefCell<cache::Cache>>,
	pub    scheme: themes::SelectedScheme,
	pub selection: namespaces::SharedSelection,
	pub  settings: gio::Settings,
	pub    themes: async_channel::Sender<namespaces::Msg>,
	pub    window: &'a adw::ApplicationWindow,
}

impl Schemes<'_> {
	pub fn start(self) -> Template { start(self) }
}

#[view {
	pub struct Template { pub tx: async_channel::Sender<Msg> }
	
	adw::ToolbarView pub root {
		set_content: Some(&_) @ gtk::ScrolledWindow {
			vexpand: true
			
			child: &_ @ adw::ClampScrollable {
				maximum_size: 5 * (scheme::SVG_WIDTH + 2 * 18) // 2 = left / right, 18 = padding
				
				child: &_ @ gtk::GridView {
					name: "thumbnail-grid"
					max_columns: 5
					
					model: &_ @ gtk::SingleSelection single {
						autoselect: false
						
						model: &_ @ gtk::FilterListModel {
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
										model: &get_schemes(&cache.borrow(), &root.display())
										
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
							'consume update_filters = move |selected: &namespaces::Selection| bindings!()
						} ~
						connect_selected_item_notify: clone![tx; move |_| send!(Msg::SelectScheme => tx)]
					}
					factory: &_ @ gtk::SignalListItemFactory {
						connect_setup: scheme::factory_setup
					}!
				}
			}
		}
		add_bottom_bar: &_ @ gtk::SearchBar {
			key_capture_widget: window
			
			child: &_ @ gtk::SearchEntry {
				placeholder_text: i18n("Search")
				~
				connect_search_changed: clone![name_filter; move |this| {
					let text = this.text();
					name_filter.set_search(if text.is_empty() { None } else { Some(&text) });
				}]
			}
		}
	}!
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

pub fn start(Schemes { cache, scheme, selection, settings, themes, window }: Schemes) -> Template {
	let (tx, rx) = async_channel::bounded(1);
	
	expand_view_here! { }
	
	let (namespace, theme, scheme_id): (String, String, String) = settings.get(SKIN);
	let mut appearance = get_scheme(&cache, &namespace, &theme, &scheme_id);
	let mut is_selected = settings.string(appearance::SETTING) == "Selected";
	let css = gtk::CssProvider::new();
	
	gtk::style_context_add_provider_for_display(
		&root.display(), &css, gtk::STYLE_PROVIDER_PRIORITY_USER
	);
	
	set_appearance(&appearance, &cache, &css);
	
	#[allow(clippy::unit_arg)]
	let mut update_state = move |msg| Some(match msg {
		Msg::SelectItem => update_filters(&selection.borrow()),
		Msg::UseDefaultAppearance => {
			is_selected = false;
			appearance = get_scheme(&cache, config::APP, "neon-cake", "dark");
			set_appearance(&appearance, &cache, &css);
		}
		Msg::UseSelectedSchemeForAppearance => {
			is_selected = true;
			let scheme = single.selected_item()?;
			appearance = Some(scheme.downcast().unwrap());
			set_appearance(&appearance, &cache, &css);
		}
		Msg::DoNotChangeAppearance => is_selected = false,
		Msg::SelectScheme => {
			let selected = single.selected_item()?;
			let selected: scheme::Object = selected.downcast().unwrap();
			
			*scheme.borrow_mut() = Some(selected.clone());
			send!(namespaces::Msg::SelectItem => themes);
			
			if is_selected {
				appearance = Some(selected);
				set_appearance(&appearance, &cache, &css);
			}
		}
		Msg::Shutdown => if let Some(ref scheme) = appearance {
			settings.set(SKIN, scheme.borrow().location()).unwrap_or_else(
				|error| crate::critical!("Failed to save {SKIN} setting: {error}")
			);
		}
	});
	
	glib::spawn_future_local(async move {
		while let Ok(msg) = rx.recv().await { update_state(msg); }
	});
	
	Template { root, tx }
}

fn set_appearance(
	appearance: & Option<scheme::Object>,
	     cache: & RefCell<cache::Cache>,
	       css: & gtk::CssProvider,
) -> Option<()> {
	let scheme = appearance.as_ref()?.borrow();
	let (namespace_id, theme_id, scheme_id) = scheme.location();
	
	let cache = cache.borrow();
	let (mut namespace, mut bin) = cache.namespace(namespace_id).log()?;
	
	let theme = namespace.theme(theme_id, bin).log()?;
	
	let safety = Default::default(); // FIXME Safety
	
	let scheme = theme.scheme(scheme_id, (namespace, bin), &cache, &safety).log()?;
	
	if namespace_id != config::APP {
		(namespace, bin) = cache.namespace(config::APP).log()?;
	}
	
	let (id, map) = namespace.map("adwaita", bin).log()?;
	let src = &(namespace.source.as_ref().map(Rc::clone)?, Rc::clone(&bin.path));
	
	css.load_from_string(&aquarelle::mapping::Ready {
		map, src, id, map_id: id, options: [
			(CompactString::from("accent")    , Value::Acc { accent: aquarelle::Accent::Any }),
			(CompactString::from("dim-header"), Value::Bool(true)),
			(CompactString::from("custom-css"), Value::Str(Default::default())),
		].into(),
		   name: Default::default(),
		display: Default::default(),
		schemes: Rc::new([(CompactString::from("main"), scheme.clone())].into()),
		 safety: &Default::default(), // TODO Safety
		  paths: None,
		replica: Default::default(),
	}.perform().log()??);
	
	let mut rgb = palette::Srgba::from_u32::<Rgba>(scheme.red.like).into_format();
	let white = palette::Lch::from_color(rgb).desaturate(0.0);
	rgb = palette::Srgba::from_color(white);
	
	let white = gdk::RGBA::new(rgb.red, rgb.green, rgb.blue, rgb.alpha);
	
	crate::TERM.with(|term| term.set_colors(Some(&rgba(scheme.lower.text)), Some(&rgba(scheme.lower.area)), &[
		&rgba(scheme.upper.like), &rgba(scheme.red    .like), &rgba(scheme.green.like), &rgba(scheme.yellow.like),
		&rgba(scheme.blue .like), &rgba(scheme.magenta.like), &rgba(scheme.cyan .like), &rgba(scheme.any   .like),
		
		&rgba(scheme.upper.area), &rgba(scheme.red    .like), &rgba(scheme.green.like), &rgba(scheme.yellow.like),
		&rgba(scheme.blue .like), &rgba(scheme.magenta.like), &rgba(scheme.cyan .like), &white,
	]));
	
	None
}

fn get_schemes(cache: &cache::Cache, display: &gdk::Display) -> gio::ListStore {
	let mut list = gio::ListStore::new::<scheme::Object>();
	let safety = Default::default(); // FIXME Safety
	
	list.extend(cache.namespaces.iter().filter_map(|(at, bin)| {
		let namespace = bin.get().log()?;
		
		Some(namespace.themes.iter().filter_map(|(theme_id, item)| {
			let theme = item.get(theme_id, bin, namespace.source.as_ref().unwrap()).log()?;
			
			Some(theme.schemes.iter().filter_map(|(scheme_id, scheme)| {
				let data = theme.scheme(scheme_id.get_ref(), (namespace, bin), cache, &safety).log()?;
				
				let metadata = scheme::Object::new(
					Rc::clone(data), at.clone(), theme_id.get_ref().clone(), scheme_id.get_ref().clone(), display
				);
				scheme.metadata.set(Box::new(metadata.clone())).unwrap();
				Some(metadata)
			}))
		}))
	}).flatten().flatten());
	
	list
}

fn get_scheme(
	cache: &RefCell<cache::Cache>, namespace: &str, theme: &str, scheme: &str
) -> Option<scheme::Object> {
	let cache = cache.borrow();
	let (namespace, bin) = cache.namespace(namespace).log()?;
	let theme = namespace.theme(theme, bin).log()?;
	let scheme = theme.schemes.get(scheme as &str)?;
	
	Some(scheme.metadata.get()?.downcast_ref::<scheme::Object>().unwrap().clone())
}
