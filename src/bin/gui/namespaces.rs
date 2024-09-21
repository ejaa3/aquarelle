/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{cell::RefCell, rc::Rc};
use adw::{glib, prelude::*};
use compact_str::CompactString;
use declarative::{clone, construct, view};
use crate::{Log, send};

pub type SharedSelection = Rc<RefCell<Selection>>;

pub enum Msg { Select, SelectItem }

#[derive(Default)]
pub struct Selection {
	pub namespace: CompactString,
	pub     group: CompactString,
	pub      user: bool,
}

#[view {
	pub struct Pane { }
	
	gtk::ScrolledWindow pub root {
		child: &_ @ adw::Clamp {
			margin_bottom: 12
			margin_end: 12
			margin_start: 12
			margin_top: 12
			maximum_size: 324
			
			child: &_ @ gtk::Box pub vbox {
				orientation: gtk::Orientation::Vertical
				spacing: 12
			}
		}
	}
}]

pub fn pane() -> Pane {
	expand_view_here! { }
	Pane { root, vbox }
}

#[view[ adw::ExpanderRow root { // xml
	title: format!("{}<span face='monospace' size='90%' alpha='55%'>: {id}</span>", &namespace.name)
	title_lines: 1
	subtitle: &namespace.about as &str
	subtitle_lines: 1
	~
	add_prefix: &_ @ gtk::CheckButton {
		group: radio
		valign: gtk::Align::Center
		~
		connect_toggled: clone![tx; move |this|
			if this.is_active() { send!(true => tx) }]
	}
} ]]

fn namespace(
	namespace: & aquarelle::namespace::Namespace,
	    radio: & gtk::CheckButton,
	container: & adw::PreferencesGroup,
	selection:   SharedSelection,
	       id:   CompactString,
	     user:   bool,
	   parent:   async_channel::Sender<Msg>,
) -> (adw::ExpanderRow, async_channel::Sender<bool>) {
	let (tx, rx) = async_channel::bounded(1);
	expand_view_here! { }
	container.add(&root);
	
	glib::spawn_future_local(async move {
		while let Ok(no_group) = rx.recv().await {
			let mut selected = selection.borrow_mut();
			selected.namespace.clone_from(&id);
			selected.user = user;
			
			if no_group { selected.group.clear(); }
			
			send!(Msg::Select => parent);
		}
	});
	
	(root, tx)
}

#[view[ adw::ActionRow root { // xml
	title: format!("{name}<span face='monospace' size='90%' alpha='63%'>: {id}</span>")
	title_lines: 1
	subtitle: about.lines().next().unwrap_or("")
	subtitle_lines: 1
	tooltip_markup: about
	activatable_widget: &prefix
	~
	add_prefix: &_ @ gtk::CheckButton prefix {
		group: radio
		valign: gtk::Align::Center
		~
		connect_toggled: move |this| if this.is_active() {
			let mut selected = selection.borrow_mut();
			selected.group.clone_from(&id);
			send!(false => tx)
		}
	}
} ]]

fn group(about: & str,
      expander: & adw::ExpanderRow,
            id:   CompactString,
          name: & str,
         radio: & gtk::CheckButton,
     selection:   SharedSelection,
            tx:   async_channel::Sender<bool>,
) {
	expand_view_here! { }
	expander.add_row(&root)
}

pub fn populate(
	    radio: & gtk::CheckButton,
	    cache: & aquarelle::cache::Cache,
	container: & adw::PreferencesGroup,
	       tx: & async_channel::Sender<Msg>,
	selection: & SharedSelection,
) {
	for (id, bin) in &cache.namespaces {
		let Some(namespace) = bin.get().log() else { continue };
		
		let (expander, tx) = self::namespace(
			namespace, radio, container, selection.clone(),
			id.clone(), bin.user, tx.clone()
		);
		
		let mut expand = false;
		
		for (id, item) in &namespace.themes {
			let Some(theme) = item.get(id, bin, namespace.source.as_ref().unwrap()).log()
			else { continue };
			
			self::group(
				&theme.about, &expander, id.get_ref().clone(), &theme.name,
				radio, Rc::clone(selection), tx.clone()
			);
			
			expand = true;
		}
		
		expander.set_enable_expansion(expand);
	}
}
