/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::traits::{ActionRowExt, PreferencesGroupExt};
use aquarelle::scheme::Sets;
use declarative::{construct, view};
use crate::{utils::rgba, i18n};

#[view {
	gtk::ColorDialog dialog { }!
	
	pub struct Component<R> { pub refresh: R }
	
	adw::PreferencesGroup pub root {
		~title: i18n("Scheme colors")
		
		add: &_ @ adw::ActionRow {
			title: i18n("Lower")
			title_lines: 1
			subtitle: i18n("Surface color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Upper")
			title_lines: 1
			subtitle: i18n("Surface color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Red")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Yellow")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Green")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Cyan")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Blue")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Magenta")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Any")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.any.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.any.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.any.text)
			}
		}
	}
}]

pub fn start() -> Component<impl Fn(&Sets)> {
	expand_view_here! { }
	Component { root, refresh: move |sets: &Sets| bindings!() }
}
