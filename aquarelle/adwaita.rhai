/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

// https://gnome.pages.gitlab.gnome.org/libadwaita/doc/1-latest/named-colors.html

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const  bad = if accent == "red" { "magenta" } else { "red" };
const good = if accent == "green" { "blue" } else { "green" };
const warn = if accent == "yellow" { "any" } else { "yellow" };

const dark = main.lower.text.luma() > main.upper.area.luma();

const view = if !dark || main.lower.area.luma() < main.lower.like.luma()
	{ main.lower.area } else { main.upper.area }; // HACK better solarized

fn shadow() { const L = this.luma(); 2 ** -L + 0.2 * L - 0.6 }

fn out() { '#' + this.to_hex_rgb(true) }

`
@define-color accent_color ${main[accent].like.out()};
@define-color accent_bg_color ${main[accent].area.out()};
@define-color accent_fg_color ${main[accent].text.out()};

@define-color destructive_color ${main[bad].like.out()};
@define-color destructive_bg_color ${main[bad].area.out()};
@define-color destructive_fg_color ${main[bad].text.out()};

@define-color success_color ${main[good].like.out()};
@define-color success_bg_color ${main[good].area.out()};
@define-color success_fg_color ${main[good].text.out()};

@define-color warning_color ${main[warn].like.out()};
@define-color warning_bg_color ${main[warn].area.out()};
@define-color warning_fg_color ${main[warn].text.out()};

@define-color error_color ${main[bad].like.out()};
@define-color error_bg_color ${main[bad].area.out()};
@define-color error_fg_color ${main[bad].text.out()};

@define-color window_bg_color ${main.lower.like.out()};
@define-color window_fg_color ${main.lower.text.out()};

@define-color view_bg_color ${view.out()};
@define-color view_fg_color ${ // HACK better solarized
	if main.lower.area.luma() < main.upper.like.luma()
		{ main.lower.text.out() } else { main.upper.text.out() }
};

@define-color headerbar_bg_color ${main.upper.area.out()};
@define-color headerbar_fg_color ${main.lower.text.out()};
@define-color headerbar_border_color ${main.lower.text.out()};
@define-color headerbar_backdrop_color ${
	if cfg::option("dim-header") { main.lower.like.out() } else { main.upper.area.out() }
};
@define-color headerbar_shade_color alpha(black, ${view.shadow()});

@define-color card_bg_color ${main.upper.like.out()};
@define-color card_fg_color ${main.upper.text.out()};
@define-color card_shade_color alpha(black, ${main.upper.like.shadow()});

@define-color dialog_bg_color ${main.upper.like.out()};
@define-color dialog_fg_color ${main.upper.text.out()};

@define-color popover_bg_color ${main.upper.like.out()};
@define-color popover_fg_color ${main.upper.text.out()};

@define-color shade_color alpha(black, ${main.lower.like.shadow()});
@define-color scrollbar_outline_color ${
	if dark { "alpha(black, 0.5)" } else { "#FFFFFF" } // FIXME
};

${cfg::option("custom-css")}
`
