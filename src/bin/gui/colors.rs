/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use adw::traits::{ActionRowExt, PreferencesGroupExt};
use aquarelle::scheme::Sets;
use declarative::{builder_mode, view};
use crate::{utils::rgba, i18n};

#[view {
	gtk::ColorDialog dialog { }
	
	pub struct Component<R> { pub refresh: R }
	
	adw::PreferencesGroup pub root: !{
		~title: i18n("Scheme colors")
		
		adw::ActionRow #add(&#) !{
			title: i18n("Lower")
			title_lines: 1
			subtitle: i18n("Surface color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.lower.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Upper")
			title_lines: 1
			subtitle: i18n("Surface color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.upper.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Red")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.red.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Yellow")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.yellow.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Green")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.green.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Cyan")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.cyan.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Blue")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.blue.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Magenta")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.magenta.text)
			}
		}
		adw::ActionRow #add(&#) !{
			title: i18n("Any")
			title_lines: 1
			subtitle: i18n("Accent color")
			~subtitle_lines: 1
			
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.any.like)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
				dialog: &dialog
				valign: gtk::Align::Center
				'bind set_rgba: &rgba(sets.any.area)
			}
			gtk::ColorDialogButton #add_suffix(&#) !{
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
