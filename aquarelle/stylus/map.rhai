/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const is_dark = main.lower.text.luma() > main.lower.like.luma();

fn out() { '#' + this.to_hex_rgba(true) }

fn shadow(factor) {
	const L = this.luma();
	rgb(0.0, 0.0, 0.0, (2 ** -L + 0.2 * L - 0.6) * factor).out()
}

`/* ==UserStyle==
@name           Aquarelle
@namespace      https://github.com/ejaa3/aquarelle
@version        1.0.0
@description    Aquarelle Style Sheet
@author         Eduardo Javier Alvarado Aarón (https://github.com/ejaa3/aquarelle)
@license        MIT
@preprocessor   less
==/UserStyle== */

@-moz-document domain("youtube.com") {
	* {
		--paper-checkbox-checked-color: ${main[accent].like.out()};
		--paper-checkbox-checked-ink-color: ${main[accent].area.out()};
		--paper-checkbox-label-color: ${main.lower.text.out()};
		--paper-checkbox-unchecked-color: ${main.lower.text.fade(main.dim).out()};
		--paper-checkbox-unchecked-ink-color: ${main.lower.text.fade(main.dim).out()};
		--paper-dialog-background-color: ${main.upper.like.out()};
		--paper-radio-button-checked-color: ${main[accent].like.out()};
		--paper-radio-button-unchecked-color: ${main.lower.text.fade(main.dim).out()};
		--yt-emoji-picker-category-background-color: ${main.lower.text.fade(0.1).out()};
		--yt-emoji-picker-category-button-color: ${main.lower.text.fade(main.dim).out()};
		--yt-emoji-picker-category-color: ${main.lower.text.out()};
		--yt-emoji-picker-search-background-color: ${main.lower.text.fade(0.1).out()};
		--yt-emoji-picker-search-color: ${main.lower.text.out()};
		--yt-live-chat-background-color: ${main.lower.area.out()};
		--yt-live-chat-header-background-color: ${main.upper.area.out()};
		--yt-live-chat-primary-text-color: ${main.lower.text.out()};
		--yt-live-chat-secondary-text-color: ${main[accent].like.out()};
		--yt-spec-10-percent-layer: ${main.lower.text.fade(0.1).out()};
		--yt-spec-additive-background: ${main.lower.text.fade(0.1).out()} !important;
		--yt-spec-base-background: ${main.lower.like.out()};
		--yt-spec-brand-background-primary: ${main.upper.like.out()};
		--yt-spec-brand-background-solid: ${main.upper.like.out()};
		--yt-spec-brand-icon-active: ${main.lower.text.out()};
		--yt-spec-brand-icon-inactive: ${main.lower.text.out()};
		--yt-spec-button-chip-background-hover: ${main.lower.text.fade(0.2).out()};
		--yt-spec-call-to-action: ${main[accent].like.out()};
		--yt-spec-commerce-filled-hover: ${main[accent].area.out()};
		--yt-spec-icon-active-other: ${main.lower.text.out()};
		--yt-spec-icon-inactive: ${main.lower.text.out()};
		--yt-spec-menu-background: ${main.upper.like.out()};
		--yt-spec-mono-filled-hover: ${lab::mix(main.lower.like, main.lower.text, 0.9).out()};
		--yt-spec-outline: ${main.lower.text.fade(main.border).out()} !important;
		--yt-spec-raised-background: ${main.upper.like.out()};
		--yt-spec-static-brand-red: ${main.red.like.out()};
		--yt-spec-static-brand-white: ${main.upper[if is_dark { "text" } else { "like" }].out()};
		--yt-spec-static-overlay-background-brand: ${main.red.area.fade(0.3).out()};
		--yt-spec-static-overlay-background-heavy: ${main.lower.like.shadow(2)};
		--yt-spec-static-overlay-button-secondary: ${main.lower.text.fade(0.1).out()};
		--yt-spec-static-overlay-text-primary: ${main.lower.text.out()};
		--yt-spec-suggested-action: ${main[accent].area.fade(0.2).out()};
		--yt-spec-text-disabled: ${main.lower.text.fade(main.dim).out()};
		--yt-spec-text-primary-inverse: ${main[accent].text.out()};
		--yt-spec-text-primary: ${main.lower.text.out()};
		--yt-spec-text-secondary: ${main.lower.text.fade(2.0 / 3).out()};
		--yt-spec-themed-blue: ${main.blue.area.out()};
		--yt-spec-touch-response: ${main.lower.text.out()};
		--ytd-searchbox-background: ${main.lower.text.fade(0.1).out()};
		--ytd-searchbox-legacy-border-color: #0000;
		--ytd-searchbox-legacy-button-border-color: #0000;
		--ytd-searchbox-legacy-button-color: ${main.lower.text.fade(0.1).out()};
		--ytd-searchbox-legacy-button-focus-color: ${main[accent].area.fade(0.2).out()};
		--ytd-searchbox-legacy-button-hover-border-color: #0000;
		--ytd-searchbox-legacy-button-hover-color: ${main.lower.text.fade(0.2).out()};
		--ytd-searchbox-text-color: ${main.lower.text.out()};
	}
	:root {
		background: ${main.lower.like.out()};
		scrollbar-color: ${main.lower.text.fade(2.0 / 3).out()} ${main.lower.like.out()} !important;
	}
	
	ytd-searchbox[has-focus] #container.ytd-searchbox
	{ border-color: ${main[accent].area.out()} }
	
	#cinematics canvas { display: none }
	#cinematics > div {
		background: radial-gradient(${lab::darken_fixed(main.lower.area, 0.2).out()}, ${main.lower.like.out()} 70%)
	}
	
	.yt-spec-icon-badge-shape, // notifications icon
	.yt-spec-icon-badge-shape--style-overlay .yt-spec-icon-badge-shape__icon,
	
	.yt-core-attributed-string--link-inherit-color // description text
	{ color: ${main.lower.text.out()} !important }
	
	.yt-core-attributed-string--link-inherit-color a // description link
	{ color: ${main.blue.like.out()} !important }
	
	.page-header-view-model-wiz__page-header-title // story header text
	{ color: ${main.lower.text.out()} }
}
@-moz-document domain("calendar.google.com") {
	:root {
		--primary: ${main[accent].like.out()};
		--primary-variant: ${main[accent].area.out()};
		--on-primary: ${main.lower.area.out()};
		
		--secondary: ${main[accent].like.fade(0.1).out()};
		--secondary-variant: ${main[accent].like.fade(0.2).out()};
		--on-secondary: ${main[accent].like.out()};
		--on-secondary-variant: ${main.lower.text.out()};
		
		--surface: ${main.lower.like.out()};
		--surface-transparent: ${main.lower.like.fade(0.0).out()};
		--on-surface: ${main.lower.text.out()};
		--on-surface-variant: #FFFF00; /* low.text */
		--on-surface-variant-agm: ${main.lower.text.fade(main.dim).out()};
		
		// --background: #fff;
		// --on-background: #202124;
		
		--textfield-surface: ${main.lower.text.fade(0.05).out()};
		--textfield-primary: var(--on-secondary);
		// --textfield-hairline: #80868b;
		// --textfield-error: #c5221f;
		--textfield-on-surface-variant: ${main.lower.text.fade(main.dim).out()};
		
		--hairline: ${main.lower.text.fade(main.border).out()};
		
		// --error: #d93025;
		// --on-error: #fff;
		
		${const shadow = if is_dark { rgb(0, 0, 0) } else { main.lower.text }; `
		--shadow-1: 0px 1px 2px 0px ${shadow.fade(0.302)}, 0px 1px 3px 1px ${shadow.fade(0.149).out()};
		--shadow-5: 0px 4px 4px 0px ${shadow.fade(0.302)}, 0px 8px 12px 6px ${shadow.fade(0.149).out()};`}
		
		--fab: ${main.upper.like.out()};
		--fab-hover: ${lab::lighten(main.upper.like, 0.1).out()};
		
		// --dimmed:rgba(32,33,36,0.38);
		
		--chip-hover: ${main.lower.text.fade(0.1).out()};
		
		--now: ${main.green.area.out()};
		
		// --bubble-tab-hover: #f8f9fa;
		
		// Events displayed at the bottom of the schedule view:
		
		--gm-colortextbutton-ink-color: ${main[accent].area.out()};
		--gm-colortextbutton-state-color: ${main[accent].like.out()};
		--gm-colortextbutton-ink-color--stateful: ${main[accent].like.out()};
		
		color: ${main.lower.text.out()}
	}
	
	// HACK header border
	#gb { background: ${main.upper.area.out()} !important }
	#gb:-moz-window-inactive { background: ${main.lower.like.out()} !important }
	
	// Header
	body[data-viewfamily="EVENT"] .SGWAac,
	body[data-viewfamily="SCHEDULE"] .SGWAac,
	body[data-viewfamily="SEARCH"] .SGWAac,
	body[data-viewfamily="SETTINGS"] .SGWAac,
	body[data-viewfamily="TRASH"] .SGWAac
	{ border-top-color: ${rgb(0.0, 0.0, 0.0, 0.4 - 0.3 * main.lower.like.luma()).out()}; }
	
	.gb_pa svg, .gb_Hc svg, .gb_3c .gb_5d, .gb_Sc .gb_5d, // Some SVG icons
	.NkK3Fc span[role="heading"], // Google Calendar title in header
	.xbo4ob:not(:disabled), .xbo4ob:not(:disabled):hover, // Today button text in header
	.xmVoP, // View button arrow in header
	.ULpymb .zHQkBf // Search people field in header
	{ color: var(--on-surface) }
	
	// Today button in header
	.VfPpkd-LgbsSe-OWXEXe-INsAgc .VfPpkd-Jh9lGc { border-color: ${lab::mix(
		lab::mix(main.lower.like, main.upper.area, 0.5), main.lower.text, main.border
	).out()} }
	
	// View button in header
	.Cd9hpd { border-color: var(--hairline) }
	
	.W0m3G:hover .r4nke, // Calendar circle hover in sidebar
	.yzYBvd:hover // Circle hover in calendar view
	{ background-color: var(--chip-hover) }
	
	// Calendar today circle hover in sidebar
	.TUH0Sd:hover .r4nke, .W0m3G.TUH0Sd.i8dSE:hover .r4nke
	{ background-color: var(--primary-variant) }
	
	// Calendar selected circle hover in sidebar
	.W0m3G.i8dSE:hover .r4nke { background-color: ${main[accent].like.fade(0.3).out()} }
	
	// Add calendar in sidebar
	.K2mXPb { color: #FFFF00; /* low.text */ }
	
	// Terms / privacy in sidebar
	.PTIB6e { color: var(--textfield-on-surface-variant) }
	
	// Menu
	.JPdR6b { background-color: ${main.upper.like.out()} }
	.z80M1 { color: ${main.upper.text.out()} }
	.z80M1.FwR7Pc { background-color: ${main.upper.text.fade(0.1).out()} }
}`
