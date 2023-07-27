/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::RefCell, rc::Rc};
use adw::{glib, prelude::*};
use aquarelle::cache;
use compact_str::CompactString;
use declarative::{builder_mode, clone, view};
use crate::{log, log::Log, utils, send};

pub type SharedSelection = Rc<RefCell<Selection>>;

pub enum Msg { Select, SelectItem }

#[derive(Default)]
pub struct Selection {
	pub namespace: CompactString,
	pub     group: CompactString,
	pub     local: bool,
}

#[view {
	pub struct Pane { }
	
	gtk::ScrolledWindow pub root: !{
		'bind set_width_request: utils::resize(window.allocated_width(), 324.0, 0.2)
		
		adw::Clamp #child(&#) !{
			margin_bottom: 12
			margin_end: 12
			margin_start: 12
			margin_top: 12
			maximum_size: 324
			
			gtk::Box pub vbox: #child(&#) !{
				orientation: gtk::Orientation::Vertical
				spacing: 12
			}
		}
	}
	ref window {
		connect_default_width_notify: @{ clone![root]; move |window| bindings!() }
	}
}]

pub fn pane(window: &adw::ApplicationWindow) -> Pane {
	expand_view_here! { }
	Pane { root, vbox }
}

#[view {
	adw::ExpanderRow root !{
		title: format!("{name}<span face='monospace' size='90%' alpha='55%'>: {id}</span>")
		title_lines: 1
		subtitle: about
		~subtitle_lines: 1
		
		gtk::CheckButton #add_prefix(&#) !{
			group: radio
			~valign: gtk::Align::Center
			
			connect_toggled: clone![tx; move |this|
				if this.is_active() { send!(true => tx) }]
		}
	}
}]

fn namespace(
	    about: & str,
	container: & adw::PreferencesGroup,
	       id:   CompactString,
	    local:   bool,
	     name: & str,
	   parent:   glib::Sender<Msg>,
	    radio: & gtk::CheckButton,
	selection:   SharedSelection,
) -> (adw::ExpanderRow, glib::Sender<bool>) {
	let (tx, rx) = glib::MainContext::channel(glib::PRIORITY_DEFAULT);
	expand_view_here! { }
	container.add(&root);
	
	rx.attach(None, move |no_group| {
		let mut selected = selection.borrow_mut();
		selected.namespace.clone_from(&id);
		selected.local = local;
		
		if no_group { selected.group.clear(); }
		
		send!(Msg::Select => parent);
		glib::Continue(true)
	});
	
	(root, tx)
}

#[view {
	adw::ActionRow root !{
		title: format!("{name}<span face='monospace' size='90%' alpha='55%'>: {id}</span>")
		title_lines: 1
		subtitle: about
		subtitle_lines: 1
		~activatable_widget: &prefix
		
		gtk::CheckButton prefix #add_prefix(&#) !{
			group: radio
			~valign: gtk::Align::Center
			
			connect_toggled: move |this| if this.is_active() {
				let mut selected = selection.borrow_mut();
				selected.group.clone_from(&id);
				send!(false => tx)
			}
		}
	}
}]

fn group(
	    about: & str,
	 expander: & adw::ExpanderRow,
	       id:   CompactString,
	     name: & str,
	    radio: & gtk::CheckButton,
	selection:   SharedSelection,
	       tx:   glib::Sender<bool>,
) {
	expand_view_here! { }
	expander.add_row(&root)
}

pub fn populate(
	    radio: & gtk::CheckButton,
	     tags: & utils::Tags,
	    cache: & cache::Cache,
	container: & adw::PreferencesGroup,
	selection: & SharedSelection,
	       tx: & glib::Sender<Msg>,
) {
	for (id, bin) in &cache.namespaces {
		let Some(namespace) = bin.get(id).log(|error| match **error {
			cache::Error::Io(..) => log::warning, _ => log::error
		}, log::cache_error, (), tags, true) else { continue };
		
		let (expander, tx) = self::namespace(
			&namespace.about, container, id.clone(), bin.local,
			&namespace.name, tx.clone(), &radio, selection.clone()
		);
		
		let mut expand = false;
		
		for (id, theme) in &namespace.themes {
			let Some(theme) = theme.get(id, bin).log(
				|_| log::error, log::namespace_error, &id, tags, true
			) else { continue };
			
			self::group(
				&theme.about, &expander, id.clone(), &theme.name,
				&radio, Rc::clone(selection), tx.clone()
			);
			
			expand = true;
		}
		
		expander.set_enable_expansion(expand);
	}
}
