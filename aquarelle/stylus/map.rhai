/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const shadow =
	if main.lower.text.luma() > main.lower.like.luma()
		{ rgb(0, 0, 0) } else { main.lower.text };

fn out() { '#' + this.to_hex_rgba(true) }

`/* ==UserStyle==
@name           Aquarelle
@namespace      https://github.com/ejaa3/aquarelle
@version        1.0.0
@description    Aquarelle Style Sheet
@author         Eduardo Javier Alvarado Aarón (https://github.com/ejaa3/aquarelle)
@license        MIT
@preprocessor   less
==/UserStyle== */

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
		--on-surface-variant: ${main.low.text.out()};
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
		
		--shadow-1: 0px 1px 2px 0px ${shadow.fade(0.302)}, 0px 1px 3px 1px ${shadow.fade(0.149).out()};
		--shadow-5: 0px 4px 4px 0px ${shadow.fade(0.302)}, 0px 8px 12px 6px ${shadow.fade(0.149).out()};
		
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
	.K2mXPb { color: ${main.low.text.out()}; }
	
	// Terms / privacy in sidebar
	.PTIB6e { color: var(--textfield-on-surface-variant) }
	
	// Menu
	.JPdR6b { background-color: ${main.upper.like.out()} }
	.z80M1 { color: ${main.upper.text.out()} }
	.z80M1.FwR7Pc { background-color: ${main.upper.text.fade(0.1).out()} }
}`
