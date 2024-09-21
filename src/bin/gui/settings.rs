/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::prelude::*;
use declarative::{construct, view};
use crate::{icons, i18n};

#[view[ ref row {
	add_suffix: &_ @ gtk::SpinButton spin {
		adjustment: &_ @ gtk::Adjustment {
			lower: 0.0
			upper: upper
			step_increment: 1.0
		}
		climb_rate: 1.0
		valign: gtk::Align::Center
		value: value
		width_chars: 4
	}
	add_prefix: &_ @ gtk::CheckButton {
		valign: gtk::Align::Center ~
		bind_property: "active", &spin, "sensitive" 'back { sync_create; }
	}
} ]]

fn rhai_max_value(row: &adw::ActionRow, value: f64, upper: f64) {
	expand_view_here! { }
}

#[view[ gtk::ScrolledWindow root {
	child: &_ @ adw::Clamp {
		margin_bottom: 12
		margin_end: 12
		margin_start: 12
		margin_top: 12
		maximum_size: 480
		tightening_threshold: 384
		
		child: &_ @ gtk::Box {
			orientation: gtk::Orientation::Vertical
			spacing: 12
			~
			append: &_ @ adw::PreferencesGroup {
				title: i18n("Maximum values for Rhai engine")
				description: i18n("Zero means “no limits”")
				
				header_suffix: &_ @ gtk::LinkButton {
					icon_name: icons::OPEN_BOOK
					tooltip_text: i18n("About this in the Rhai book")
					uri: "https://rhai.rs/book/safety/index.html"
					valign: gtk::Align::Center
				} ~
				add: &_ @ adw::ActionRow {
					title: i18n("Length of strings")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Size of arrays")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Size of object maps")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Number of operations")
					rhai_max_value: &_, 0.0, u64::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Number of modules")
					rhai_max_value: &_, 0.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Call stack depth")
					rhai_max_value: &_, 64.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Expression nesting depth")
					subtitle: i18n("At global level")
					rhai_max_value: &_, 64.0, usize::MAX as f64
				}
				add: &_ @ adw::ActionRow {
					title: i18n("Expression nesting depth")
					subtitle: i18n("Within function bodies")
					rhai_max_value: &_, 32.0 ,usize::MAX as f64
				}
			}
		}
	}
} ]]

pub fn start() -> gtk::ScrolledWindow {
	expand_view_here! { }
	root
}
