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

fn shadow() { const x = this.luma(); 0xFF.fade(2 ** -x + 0.2 * x - 0.6).out() }

`:root {
	/* Browser area before a page starts loading */
	--gnome-browser-before-load-background: ${main.lower.like.out()};
	
	/* Accent */
	--gnome-accent-bg: ${main[accent].area.out()};
	--gnome-accent: ${main[accent].like.out()};
	
	/* Toolbars */
	--gnome-toolbar-background: ${main.upper.area.out()};
	--gnome-toolbar-color: ${main.lower.text.out()};
	--gnome-toolbar-border-color: ${main.upper.area.shadow()};
	--gnome-toolbar-icon-fill: ${main.lower.text.fade(0.9).out()};
	--gnome-inactive-toolbar-color: ${main.lower.text.fade(if dim { main.dim } else { 1.0 }).out()};
	--gnome-inactive-toolbar-background: ${dim_header.out()};
	--gnome-inactive-toolbar-border-color: ${dim_header.shadow()};
	--gnome-inactive-toolbar-icon-fill: ${main.lower.text.fade(if dim { main.dim } else { 1.0 } * 0.9).out()};
	
	/* Sidebar */
	--gnome-sidebar-background: var(--gnome-toolbar-background);
	--gnome-inactive-sidebar-background: var(--gnome-inactive-toolbar-background);
	
	/* Menus */
	--gnome-menu-background: ${main.upper.like.out()};
	--gnome-menu-border-color: ${main.upper.like.shadow()};
	--gnome-menu-shadow: 0 1px 5px 1px rgba(0,0,0, .09), 0 2px 14px 3px rgba(0,0,0, .05);
	--gnome-menu-button-hover-background: var(--gnome-button-background);
	--gnome-menu-separator-color: ${main.upper.text.fade(main.border).out()};
	
	/* Header bar */
	--gnome-headerbar-background: var(--gnome-toolbar-background);
	--gnome-headerbar-border-color: var(--gnome-toolbar-border-color);
	--gnome-inactive-headerbar-background: var(--gnome-inactive-toolbar-background);
	--gnome-inactive-headerbar-border-color: var(--gnome-inactive-toolbar-border-color);
	
	/* Buttons */
	--gnome-button-background: ${main.lower.text.fade(0.1).out()};
	--gnome-button-hover-background: ${main.lower.text.fade(0.2).out()};
	--gnome-button-active-background: ${main.lower.text.fade(0.3).out()};
	--gnome-button-flat-hover-background: ${main.lower.text.fade(0.1).out()};
	--gnome-button-flat-active-background: ${main.lower.text.fade(0.2).out()};
	--gnome-button-suggested-action-background: var(--gnome-accent-bg);
	--gnome-button-destructive-action-background: ${main.red.area.out()};
	
	--gnome-button-close-background: var(--gnome-button-background);
	--gnome-button-hover-close-background:var(--gnome-button-hover-background);
	--gnome-button-active-close-background: var(--gnome-button-active-background);
	
	--gnome-toolbar-star-button: ${main.yellow.area.out()};
	
	/* Entries */
	--gnome-entry-background: ${main.lower.text.fade(0.1).out()};
	--gnome-entry-color: ${main.lower.text.out()};
	--gnome-inactive-entry-color: ${main.lower.text.fade(if dim { main.dim } else { 1.0 }).out()};
	--gnome-focused-urlbar-border-color: ${main[accent].like.fade(0.5).out()}; /* Same as --gnome-accent but with opacity*/
	
	/* Switch */
	--gnome-switch-background: ${main.lower.text.fade(0.2).out()};
	--gnome-switch-slider-background: ${main.lower.text.fade(main.dim).out()};
	--gnome-switch-active-background: var(--gnome-accent-bg);
	--gnome-switch-active-slider-background: ${main[accent].text.out()};
	
	/* Tabs */
	--gnome-tabbar-background: var(--gnome-headerbar-background);
	--gnome-tabbar-tab-separator-color: ${main.lower.text.fade(main.border).out()};
	--gnome-tabbar-tab-hover-background: ${lab::mix(main.upper.area, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background: ${lab::mix(main.upper.area, main.lower.text, 0.2).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-background-contrast: ${lab::mix(main.upper.area, main.lower.text, 0.4).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-active-hover-background: ${lab::mix(main.upper.area, main.lower.text, 0.3).out()}; /* Hardcoded color */
	--gnome-inactive-tabbar-background: var(--gnome-inactive-headerbar-background);
	--gnome-inactive-tabbar-tab-hover-background: ${lab::mix(dim_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-inactive-tabbar-tab-active-background: ${lab::mix(dim_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
	--gnome-tabbar-tab-identity-base-opacity: ${if dark { '0' } else { ".1" }};
	--gnome-tabbar-tab-needs-attetion: ${lab::mix(main[accent].area, main.upper.like, 0.5).out()};
}

/* Private window colors */
:root {
	--gnome-private-accent: ${main[priv].like.out()};
	
	/* Toolbars */
	--gnome-private-toolbar-background: ${priv_header.out()};
	--gnome-private-inactive-toolbar-background: ${priv_dim_header.out()};
	/* Menus */
	--gnome-private-menu-background: ${priv_header.out()};
	/* Header bar */
	--gnome-private-headerbar-background: ${priv_header};
	--gnome-private-inactive-headerbar-background: ${priv_dim_header.out()};
	/* Tabs */
	--gnome-private-tabbar-tab-hover-background: ${lab::mix(priv_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-private-tabbar-tab-active-background: ${lab::mix(priv_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
	--gnome-private-tabbar-tab-active-background-contrast: ${lab::mix(priv_header, main.lower.text, 0.4).out()}; /* Hardcoded color */
	--gnome-private-tabbar-tab-active-hover-background: ${lab::mix(priv_header, main.lower.text, 0.3).out()}; /* Hardcoded color */
	--gnome-private-inactive-tabbar-tab-hover-background: ${lab::mix(priv_dim_header, main.lower.text, 0.1).out()}; /* Hardcoded color */
	--gnome-private-inactive-tabbar-tab-active-background: ${lab::mix(priv_dim_header, main.lower.text, 0.2).out()}; /* Hardcoded color */
	
	/* Text color for Firefox Logo in new private tab */
	--gnome-private-wordmark: ${main.upper.text.out()};
	
	/* New private tab background */
	--gnome-private-in-content-page-background: ${priv_header.out()};
	
	/* Private browsing info box */
	--gnome-private-text-primary-color: ${main.upper.text.out()};
}

/* Hide tabs when Sidebery is shown (invisible character) */
#main-window[titlepreface*="­"] :is(#sidebar-header, #TabsToolbar) {
	display: none;
}`
