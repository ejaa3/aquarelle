/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");
const   priv = cfg::option("private");
const    dim = cfg::option("dim-header");

const dark = main.lower.text.luma() > main.lower.like.luma();

const dim_header = if dim { main.lower.like } else { main.upper.area };
const priv_header = lab::mix(main.upper.like, main[priv].area, 0.2);
const priv_dim_header = lab::mix(dim_header, main[priv].area, 0.2);

fn out() { '#' + this.to_hex_rgba(true) }

fn shadow() { const L = this.luma(); 0xFF.fade(2 ** -L + 0.2 * L - 0.6).out() }

`:root {
	/* Accent */
	--gnome-accent-bg: ${main[accent].area.out()};
	--gnome-accent: ${main[accent].like.out()};
	
	--gnome-selection-bg: ${main[accent].area.fade(0.3).out()};
	--gnome-toolbar-star-button: ${main.yellow.area.out()};
	
	/* Window */
	--gnome-window-background: ${main.lower.like.out()};
	--gnome-window-color: ${main.lower.text.out()};
	--gnome-view-background: ${main.lower.area.out()};
	--gnome-view-color: ${main.lower.text.out()};
	
	/* Card */
	--gnome-card-background: ${main.upper.like.out()};
	--gnome-card-shade-color: ${main.upper.like.shadow()};
	
	/* Menu */
	--gnome-menu-background: ${main.upper.like.out()};
	--gnome-menu-color: ${main.upper.text.out()};
	--gnome-menu-border-color: ${main.upper.like.shadow()};
	/*** --gnome-menu-shadow ***/
	--gnome-menu-button-hover-background: var(--gnome-button-background);
	--gnome-menu-separator-color: ${main.upper.text.fade(main.border).out()};
	
	/* Header bar */
	--gnome-headerbar-background: ${main.upper.area.out()};
	--gnome-headerbar-shade-color: ${main.upper.area.shadow()};
	
	/* Toolbars */
	--gnome-toolbar-background: ${main.upper.area.out()};
	--gnome-toolbar-color: ${main.lower.text.out()};
	--gnome-toolbar-border-color: ${main.upper.area.shadow()};
	--gnome-toolbar-icon-fill: ${main.lower.text.fade(0.9).out()};
	
	/* Elements */
	--gnome-border-color: ${main.lower.like.shadow()};
	
	/* Buttons */
	--gnome-button-background: ${main.lower.text.fade(0.1).out()};
	--gnome-button-hover-background: ${main.lower.text.fade(0.2).out()};
	--gnome-button-active-background: ${main.lower.text.fade(0.3).out()};
	--gnome-button-suggested-action-background: ${main[accent].area.out()};
	--gnome-button-destructive-action-background: ${main[if accent == "red" { "magenta"} else { "red" }].area.out()};
	
	/* Entries */
	--gnome-entry-background: ${main.lower.text.fade(0.1).out()};
	--gnome-entry-color: ${main.lower.text.out()};
	--gnome-focused-urlbar-border-color: ${main[accent].like.fade(0.5).out()};
	
	/* Tabs */
	--gnome-tabbar-background: var(--gnome-headerbar-background);
	--gnome-tabbar-tab-separator-color: ${main.lower.text.fade(main.border).out()};
	--gnome-tabbar-tab-hover-background: ${lab::mix(main.upper.area, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background: ${lab::mix(main.upper.area, main.lower.text, 0.2).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background-contrast: ${lab::mix(main.upper.area, main.lower.text, 0.4).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-hover-background: ${lab::mix(main.upper.area, main.lower.text, 0.3).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-needs-attetion: ${main[accent].like.out()};
	
	--gnome-tabbar-identity-color-blue: ${main.blue.like.out()};
	--gnome-tabbar-identity-color-turquoise: ${main.cyan.like.out()};
	--gnome-tabbar-identity-color-green: ${main.green.like.out()};
	--gnome-tabbar-identity-color-yellow: ${main.yellow.like.out()};
	--gnome-tabbar-identity-color-orange: ${main.upper.text.out()};
	--gnome-tabbar-identity-color-red: ${main.red.like.out()};
	--gnome-tabbar-identity-color-pink: ${main.magenta.like.out()};
	--gnome-tabbar-identity-color-purple: ${main.any.like.out()};
		
	/* Text color for Firefox Logo in new private tab */
	--gnome-private-wordmark: ${main.upper.text.out()};
	/* New private tab background */
	--gnome-private-in-content-page-background: ${priv_header.out()};
	/* Private browsing info box */
	--gnome-private-text-primary-color: ${main.upper.text.out()};
}

/* Backdrop colors */
:root:-moz-window-inactive {
	--gnome-headerbar-background: ${dim_header.out()};
	--gnome-tabbar-tab-hover-background: ${lab::mix(dim_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background: ${lab::mix(dim_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
}

/* Private window colors */
:root[privatebrowsingmode="temporary"] {
	--gnome-accent-fg: ${main[priv].like.out()};
	/* Header bar */
	--gnome-headerbar-background: ${priv_header};
	/* Tabs */
	--gnome-tabbar-tab-hover-background: ${lab::mix(priv_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background: ${lab::mix(priv_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background-contrast: ${lab::mix(priv_header, main.lower.text, 0.4).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-hover-background: ${lab::mix(priv_header, main.lower.text, 0.3).out()}; /* Hardcoded color */
}

/* Private and backdrop colors */
:root[privatebrowsingmode="temporary"]:-moz-window-inactive {
	--gnome-headerbar-background: ${priv_dim_header.out()} !important;
	--gnome-tabbar-tab-hover-background: ${lab::mix(priv_dim_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background: ${lab::mix(priv_dim_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
}

/* Hide tabs when Sidebery is shown (invisible character) */
#main-window[titlepreface*="­"] :is(#sidebar-header, #TabsToolbar) {
	display: none;
}`
