/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::prelude::{ActionRowExt, PreferencesGroupExt};
use aquarelle::scheme::Data;
use declarative::{construct, view};
use crate::{i18n, rgba};

#[view {
	gtk::ColorDialog dialog { }!
	
	pub struct Component<R> { pub refresh: R }
	
	adw::PreferencesGroup pub root {
		title: i18n("Scheme colors")
		~
		add: &_ @ adw::ActionRow {
			title: i18n("Lower")
			title_lines: 1
			subtitle: i18n("Surface color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.lower.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.lower.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.lower.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Upper")
			title_lines: 1
			subtitle: i18n("Surface color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.upper.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.upper.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.upper.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Red")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.red.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.red.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.red.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Yellow")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.yellow.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.yellow.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.yellow.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Green")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.green.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.green.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.green.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Cyan")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.cyan.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.cyan.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.cyan.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Blue")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.blue.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.blue.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.blue.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Magenta")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.magenta.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.magenta.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.magenta.text)
			}
		}
		add: &_ @ adw::ActionRow {
			title: i18n("Any")
			title_lines: 1
			subtitle: i18n("Accent color")
			subtitle_lines: 1
			~
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.any.like)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.any.area)
			}
			add_suffix: &_ @ gtk::ColorDialogButton {
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(scheme.any.text)
			}
		}
	}
}]

pub fn start() -> Component<impl Fn(&Data)> {
	expand_view_here! { }
	Component { root, refresh: move |scheme: &Data| bindings!() }
}
