/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { '#' + this.to_hex_rgb(true) }
fn shadow() { const L = this.luma(); 2 ** -L + 0.2 * L - 0.6 }

// animate_states = true
const CONFIG = `[%General]
author = Eduardo Javier Alvarado Aarón
blurring = true
comment = A theme from Aquarelle
composite = true
group_toolbar_buttons = ${cfg::option("group-toolbar-buttons")}
groupbox_top_label = true
reduce_window_opacity = ${cfg::option("reduce-window-opacity")}
scrollbar_in_view = true
transient_scrollbar = true
translucent_windows = true

[GeneralColors]
window.color = ${main.lower.like.out()}
base.color = ${main.upper.area.out()}
alt.base.color = ${main.lower.like.out()}
button.color = ${main.upper.like.out()}
light.color = ${lab::lighten_fixed(main.lower.like, 0.075).out()}
mid.light.color = ${lab::lighten_fixed(main.lower.like, 0.0375).out()}
dark.color = ${lab::darken_fixed(main.lower.like, 0.075).out()}
mid.color = ${lab::darken_fixed(main.lower.like, 0.0375).out()}
highlight.color = ${main[accent].area.out()}
inactive.highlight.color = #${main[accent].area.fade(1.0 / 3).to_hex_argb(true)}
tooltip.base.color = ${main.upper.like.out()}
text.color = ${main.lower.text.out()}
window.text.color = ${main.lower.text.out()}
button.text.color = ${main.lower.text.out()}
disabled.text.color = #${main.lower.text.fade(main.dim).to_hex_argb(true)}
tooltip.text.color = ${main.upper.text.out()}
highlight.text.color = ${main[accent].text.out()}
link.color = ${main[if accent == "blue" { "any" } else { "blue" }].like.out()}
link.visited.color = ${main[if accent == "magenta" { "any" } else { "magenta" }].like.out()}

[ComboBox]
inherits = PanelButtonCommand

[GenericFrame]
frame.element = generic
interior.element = generic
frame.bottom = 24
frame.left = 24
frame.right = 24
frame.top = 24
text.margin.bottom = 0
text.margin.left = 0
text.margin.right = 0
text.margin.top = 0

[GroupBox]
inherits = GenericFrame
interior.element = group
interior = true

[HeaderSection]
frame.element = header
interior.element = header
frame.top = 0
frame.left = 0
frame.bottom = 2
frame.right = 2
text.margin.bottom = 3
text.margin.left = 3
text.margin.right = 3
text.margin.top = 3

[LineEdit]
inherits = PanelButtonCommand

[MenuBar]
frame.element = menubar
interior.element = menubar
frame.bottom = 1
frame.left = 0
frame.right = 0
frame.top = 0

[PanelButtonCommand]
frame.bottom = 6
frame.left = 6
frame.right = 6
frame.top = 6
text.margin.bottom = 0
text.margin.left = 0
text.margin.right = 0
text.margin.top = 0

[PanelButtonTool]
inherits = PanelButtonCommand

[ScrollbarSlider]
frame.bottom = 5
frame.left = 5
frame.right = 5
frame.top = 5

[Tab]
frame.bottom = 12
frame.left = 15
frame.right = 15
frame.top = 18
text.margin.bottom = 0
text.margin.left = 0
text.margin.right = 0
text.margin.top = 0

[TabFrame]
frame.element = tabframe
inherits = GenericFrame
interior.element = tabframe

[TabBarFrame]
frame.element = tabframe
inherits = GenericFrame
interior.element = tabframe

[Toolbar]
frame.bottom = 7
frame.left = 0
frame.right = 0
frame.top = 6

[ToolbarComboBox]
inherits = PanelButtonCommand
`;

fn tab(id) {
	const shadow = global::main.lower.like.shadow() / if id == "focused" { 1.0 } else { 2.0 };
	const color = global::main.upper.like.out();
	
	`<g id="tab-${id}-topleft">
		<path opacity="${shadow}" d="M 12 6 A 12 12 0 0 0 0 18 L 12 18 L 12 6 z "/>
		${if id == "toggled" {
			`<path fill="url(#tab-shadow)" d="m 0,0 v 18 h 6 a 6,6 0 0 1 6,-6 V 0 Z"/>
			<path fill="${color}" d="M 12 12 A 6 6 0 0 0 6 18 L 12 18 L 12 12 z"/>`
		} /* else { `<rect opacity="0" width="1" height="1"/>` } */}
		<rect opacity="0" width="1" height="1" x="-3"/>
	</g>
	<g id="tab-${id}-top">
		<rect opacity="${shadow}" width="1" height="12" x="12" y="6"/>
		${if id == "toggled" {
			`<rect fill="url(#tab-shadow)" width="1" height="12" x="12"/>
			<rect fill="${color}" width="1" height="6" x="12" y="12"/>`
		} else { `<rect opacity="0" width="1" height="1" x="12"/>` }}
	</g>
	<g id="tab-${id}-topright">
		<path opacity="${shadow}" d="M 25,18 A 12,12 0 0 0 13,6 v 12 z"/>
		${if id == "toggled" {
			`<path fill="url(#tab-shadow)" d="m 13,0 v 12 a 6,6 0 0 1 6,6 h 6 V 0 Z"/>
			<path fill="${color}" d="m 19,18 a 6,6 0 0 0 -6,-6 v 6 z"/>`
		} /* else { `<rect opacity="0" width="1" height="1" x="24"/>` } */}
		<rect opacity="0" width="1" height="1" x="27"/>
	</g>
	<g id="tab-${id}-right">
		<rect opacity="${shadow}" width="12" height="1" x="13" y="18"/>
		${if id == "toggled" {
			`<rect fill="url(#tab-shadow)" width="6" height="1" x="19" y="18"/>
			<rect fill="${color}" width="6" height="1" x="13" y="18"/>`
		}}
		<rect opacity="0" width="1" height="1" x="27" y="18"/>
	</g>
	<g id="tab-${id}-bottomright">
		<path opacity="${shadow}" d="M 13,31 A 12,12 0 0 0 25,19 H 13 Z"/>
		${if id == "toggled" {
			`<path fill="url(#tab-shadow)" d="m 19,19 a 6,6 0 0 1 -6,6 v 6 H 25 V 19 Z"/>
			<path fill="${color}" d="m 13,25 a 6,6 0 0 0 6,-6 h -6 z"/>`
		}}
		<rect opacity="0" width="1" height="1" x="27" y="30"/>
	</g>
	<g id="tab-${id}-bottom">
		<rect opacity="${shadow}" width="1" height="12" x="12" y="19"/>
		${if id == "toggled" {
			`<rect fill="url(#tab-shadow)" width="1" height="6" x="12" y="25"/>
			<rect fill="${color}" width="1" height="6" x="12" y="19"/>`
		}}
	</g>
	<g id="tab-${id}-bottomleft">
		<path opacity="${shadow}" d="M 0,19 A 12,12 0 0 0 12,31 V 19 Z"/>
		${if id == "toggled" {
			`<path fill="url(#tab-shadow)" d="M 0,19 V 31 H 12 V 25 A 6,6 0 0 1 6,19 Z"/>
			<path fill="${color}" d="m 6,19 a 6,6 0 0 0 6,6 v -6 z"/>`
		}}
		<rect opacity="0" width="1" height="1" x="-3" y="30"/>
	</g>
	<g id="tab-${id}-left">
		<rect opacity="${shadow}" width="12" height="1" y="18"/>
		${if id == "toggled" {
			`<rect fill="url(#tab-shadow)" width="6" height="1" y="18"/>
			<rect fill="${color}" width="6" height="1" x="6" y="18"/>`
		}}
		<rect opacity="0" width="1" height="1" x="-3" y="18"/>
	</g>
	<rect id="tab-${id}" width="1" height="1" x="12" y="18" ${
		if id == "toggled" { `fill="${color}"` } else { `opacity="${shadow}"` }
	}/>`
}

fn button(color, id, alpha) {
	`<path fill="${color}" opacity="${alpha}" id="${id}-topleft" d="M 1 0 A 1 1 0 0 0 0 1 L 1 1 L 1 0 z "/>
	<rect fill="${color}" opacity="${alpha}" id="${id}-top" width="1" height="1" x="1"/>
	<path fill="${color}" opacity="${alpha}" id="${id}-topright" d="M 3,1 A 1,1 0 0 0 2,0 v 1 z"/>
	<rect fill="${color}" opacity="${alpha}" id="${id}-right" width="1" height="1" x="2" y="1"/>
	<path fill="${color}" opacity="${alpha}" id="${id}-bottomright" d="M 2,3 A 1,1 0 0 0 3,2 H 2 Z"/>
	<rect fill="${color}" opacity="${alpha}" id="${id}-bottom" width="1" height="1" x="1" y="2"/>
	<path fill="${color}" opacity="${alpha}" id="${id}-bottomleft" d="M 0,2 A 1,1 0 0 0 1,3 V 2 Z"/>
	<rect fill="${color}" opacity="${alpha}" id="${id}-left" width="1" height="1" y="1"/>
	<rect fill="${color}" opacity="${alpha}" id="${id}" width="1" height="1" x="1" y="1"/>`
}

fn card(id, color) {
	`<g id="${id}-normal-topleft">
		<path fill="url(#card-shadow)" d="M 0,0 V 24 H 12 A 12,12 0 0 1 24,12 V 0 Z"/>
		<path opacity="0.05" d="M 24,11 A 13,13 0 0 0 11,24 h 1 A 12,12 0 0 1 24,12 Z"/>
		<path fill="${color}" d="M 24,12 A 12,12 0 0 0 12,24 h 12 z"/>
	</g>
	<g id="${id}-normal-top">
		<rect fill="url(#card-shadow)" x="24" width="1" height="12"/>
		<rect opacity="0.05" x="24" y="11" width="1" height="1"/>
		<rect fill="${color}" x="24" y="12" width="1" height="12"/>
	</g>
	<g id="${id}-normal-topright">
		<path fill="url(#card-shadow)" d="M 49,0 V 24 H 37 A 12,12 0 0 0 25,12 V 0 Z"/>
		<path opacity="0.05" d="M 25,11 A 13,13 0 0 1 38,24 H 37 A 12,12 0 0 0 25,12 Z"/>
		<path fill="${color}" d="M 25,12 A 12,12 0 0 1 37,24 H 25 Z"/>
	</g>
	<g id="${id}-normal-right">
		<rect fill="url(#card-shadow)" x="37" y="24" width="12" height="1"/>
		<rect opacity="0.05" x="37" y="24" width="1" height="1"/>
		<rect fill="${color}" x="25" y="24" width="12" height="1"/>
	</g>
	<g id="${id}-normal-bottomright">
		<path fill="url(#card-shadow)" d="M 49,49 V 25 H 37 A 12,12 0 0 1 25,37 v 12 z"/>
		<path opacity="0.05" d="M 25,38 A 13,13 0 0 0 38,25 H 37 A 12,12 0 0 1 25,37 Z"/>
		<path fill="${color}" d="M 25,37 A 12,12 0 0 0 37,25 H 25 Z"/>
	</g>
	<g id="${id}-normal-bottom">
		<rect fill="url(#card-shadow)" x="24" y="37" width="1" height="12"/>
		<rect opacity="0.05" x="24" y="37" width="1" height="1"/>
		<rect fill="${color}" x="24" y="25" width="1" height="12"/>
	</g>
	<g id="${id}-normal-bottomleft">
		<path fill="url(#card-shadow)" d="M 0,49 V 25 h 12 a 12,12 0 0 0 12,12 v 12 z"/>
		<path opacity="0.05" d="M 24,38 A 13,13 0 0 1 11,25 h 1 a 12,12 0 0 0 12,12 z"/>
		<path fill="${color}" d="M 24,37 A 12,12 0 0 1 12,25 h 12 z"/>
	</g>
	<g id="${id}-normal-left">
		<rect fill="url(#card-shadow)" y="24" width="12" height="1"/>
		<rect opacity="0.05" x="11" y="24" width="1" height="1"/>
		<rect fill="${color}" x="12" y="24" width="12" height="1"/>
	</g>
	<rect id="${id}-normal" fill="${color}" x="24" y="24" width="1" height="1"/>`
}

fn header(id, color) {
	const shadow = lab::mix(global::main.upper.area, global::main.lower.text, global::main.border).out();
	
	`<g id="header-${id}-right">
		<rect fill="${color}" width="1" height="1" x="1"/>
		<rect fill="${shadow}" width="1" height="1" x="2"/>
	</g>
	<g id="header-${id}-bottomright">
		<rect fill="${color}" width="1" height="1" x="1" y="1"/>
		<path fill="${shadow}" d="M 2,1 V 2 H 1 V 3 H 2 3 V 2 1 Z"/>
	</g>
	<g id="header-${id}-bottom">
		<rect fill="${color}" width="1" height="1" y="1"/>
		<rect fill="${shadow}" width="1" height="1" y="2"/>
	</g>
	<rect id="header-${id}" fill="${color}" width="1" height="1"/>`
}

fn scrollbar_slider(id) {
	const color = global::main.lower.text.out();
	const shadow = global::main.lower.like.shadow();
	const alpha = if id == "focused" { 0.2 } else { 0.25 };
	
	`<g id="scrollbarslider-${id}-topleft">
		<path opacity="${shadow}" d="M 5,0 A 5,5 0 0 0 0,5 H 1 A 4,4 0 0 1 5,1 Z"/>
		<path fill="${color}" opacity="${alpha}" d="M 5,1 A 4,4 0 0 0 1,5 h 4 z"/>
	</g>
	<g id="scrollbarslider-${id}-top">
		<rect opacity="${shadow}" width="1" height="1" x="5"/>
		<rect fill="${color}" opacity="${alpha}" width="1" height="4" x="5" y="1"/>
	</g>
	<g id="scrollbarslider-${id}-topright">
		<path opacity="${shadow}" d="M 11,5 A 5,5 0 0 0 6,0 v 1 a 4,4 0 0 1 4,4 z"/>
		<path fill="${color}" opacity="${alpha}" d="M 10,5 A 4,4 0 0 0 6,1 v 4 z"/>
	</g>
	<g id="scrollbarslider-${id}-right">
		<rect opacity="${shadow}" width="1" height="1" x="10" y="5"/>
		<rect fill="${color}" opacity="${alpha}" width="4" height="1" x="6" y="5"/>
	</g>
	<g id="scrollbarslider-${id}-bottomright">
		<path opacity="${shadow}" d="M 6,11 A 5,5 0 0 0 11,6 H 10 A 4,4 0 0 1 6,10 Z"/>
		<path fill="${color}" opacity="${alpha}" d="M 6,10 A 4,4 0 0 0 10,6 H 6 Z"/>
	</g>
	<g id="scrollbarslider-${id}-bottom">
		<rect opacity="${shadow}" width="1" height="1" x="5" y="10"/>
		<rect fill="${color}" opacity="${alpha}" width="1" height="4" x="5" y="6"/>
	</g>
	<g id="scrollbarslider-${id}-bottomleft">
		<path opacity="${shadow}" d="m 0,6 a 5,5 0 0 0 5,5 V 10 A 4,4 0 0 1 1,6 Z"/>
		<path fill="${color}" opacity="${alpha}" d="m 1,6 a 4,4 0 0 0 4,4 V 6 Z"/>
	</g>
	<g id="scrollbarslider-${id}-left">
		<rect opacity="${shadow}" width="1" height="1" y="5"/>
		<rect fill="${color}" opacity="${alpha}" width="4" height="1" x="1" y="5"/>
	</g>
	<rect id="scrollbarslider-${id}" fill="${color}" opacity="${alpha}" width="1" height="1" x="5" y="5"/>`
}

const SVG = `<svg xmlns="http://www.w3.org/2000/svg">
	<defs>
		<radialGradient id="card-shadow" cx="24.5" cy="26.445944" fx="24.5" fy="26.445944" r="12"
			gradientUnits="userSpaceOnUse" gradientTransform="matrix(1.5416669,0,0,1.5416667,-13.270845,-13.27083)">
			<stop stop-color="#000" stop-opacity="${main.lower.like.shadow()}" offset="0"/>
			<stop stop-color="#000" stop-opacity="0" offset="1"/>
		</radialGradient>
		<radialGradient id="tab-shadow" cx="12.5" cy="16.280701" fx="12.5" fy="16.280701" r="6"
			gradientUnits="userSpaceOnUse" gradientTransform="matrix(1.5833333,0,0,1.5833333,-7.2916689,-5.7777759)">
			<stop stop-color="#000" stop-opacity="${main.lower.like.shadow()}" offset="0"/>
			<stop stop-color="#000" stop-opacity="0" offset="1"/>
		</radialGradient>
	</defs>
	
	<rect id="menubar-normal" fill="${main.lower.like.out()}" opacity="${cfg::option("header-opacity")}" width="1" height="1"/>
	<rect id="menubar-normal-bottom" opacity="${main.lower.like.shadow()}" width="1" height="1"/>
	
	<rect id="toolbar-normal-top" fill="${main.lower.like.out()}" opacity="${cfg::option("header-opacity")}" width="1" height="6"/>
	<rect id="toolbar-normal" fill="${main.lower.like.out()}" opacity="${cfg::option("header-opacity")}" width="1" height="1"/>
	<g id="toolbar-normal-bottom">
		<rect fill="${main.lower.like.out()}" opacity="${cfg::option("header-opacity")}" width="1" height="6"/>
		<rect opacity="${main.lower.like.shadow()}" width="1" height="1" y="6"/>
	</g>
	
	${header("normal", main.upper.area.out())}
	${header("focused", lab::mix(main.upper.area, main.lower.text, 0.1).out())}
	${header("pressed", lab::mix(main.upper.area, main.lower.text, 0.2).out())}
	<g id="header-separator">
		<rect opacity="0" width="6" height="1"/>
		<rect fill="${main.lower.text.out()}" opacity="${main.dim}" x="3" width="1" height="1"/>
	</g>
	
	${button(main.lower.text.out(), "button-normal", 0.15)}
	${button(main.lower.text.out(), "button-focused", 0.2)}
	${button(main.lower.text.out(), "button-pressed", 0.25)}
	${button(main[accent].area.out(), "button-toggled", 0.25)}
	
	${button(main.lower.text.out(), "lineedit-normal", 0.15)}
	<g id="lineedit-focused-topleft">
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 6 0 A 6 6 0 0 0 0 6 L 6 6 L 6 0 z"/>
		<path fill="${main[accent].area.out()}" opacity="0.5" d="M 6,0 A 6,6 0 0 0 0,6 H 2 A 4,4 0 0 1 6,2 Z"/>
	</g>
	<g id="lineedit-focused-top">
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="6" x="6"/>
		<rect fill="${main[accent].area.out()}" opacity="0.5" width="1" height="2" x="6"/>
	</g>
	<g id="lineedit-focused-topright">
		<path fill="${main.lower.text.out()}" opacity="0.15" d="m 7,0 a 6,6 0 0 1 6,6 H 7 Z"/>
		<path fill="${main[accent].area.out()}" opacity="0.5" d="m 7,0 a 6,6 0 0 1 6,6 H 11 A 4,4 0 0 0 7,2 Z"/>
	</g>
	<g id="lineedit-focused-right">
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="6" height="1" x="7" y="6"/>
		<rect fill="${main[accent].area.out()}" opacity="0.5" width="2" height="1" x="11" y="6"/>
	</g>
	<g id="lineedit-focused-bottomright">
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 7,13 A 6,6 0 0 0 13,7 H 7 Z"/>
		<path fill="${main[accent].area.out()}" opacity="0.5" d="M 13,7 A 6,6 0 0 1 7,13 V 11 A 4,4 0 0 0 11,7 Z"/>
	</g>
	<g id="lineedit-focused-bottom">
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="6" x="6" y="7"/>
		<rect fill="${main[accent].area.out()}" opacity="0.5" width="1" height="2" x="6" y="11"/>
	</g>
	<g id="lineedit-focused-bottomleft">
		<path fill="${main.lower.text.out()}" opacity="0.15" d="m 0,7 a 6,6 0 0 0 6,6 V 7 Z"/>
		<path fill="${main[accent].area.out()}" opacity="0.5" d="M 6,13 A 6,6 0 0 1 0,7 h 2 a 4,4 0 0 0 4,4 z"/>
	</g>
	<g id="lineedit-focused-left">
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="6" height="1" y="6"/>
		<rect fill="${main[accent].area.out()}" opacity="0.5" width="2" height="1" y="6"/>
	</g>
	<rect id="lineedit-focused" fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="6" y="6"/>
	
	${card("generic", main.upper.area.out())}
	${card("tabframe", main.lower.like.out())}
	${card("group", main.upper.area.out())}
	
	<g id="scrollbarslider-normal-topleft">
		<path opacity="${main.lower.like.shadow()}" d="M 2,0 A 2,2 0 0 0 0,2 H 1 A 1,1 0 0 1 2,1 Z"/>
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 2,1 A 1,1 0 0 0 1,2 h 1 z"/>
		<rect opacity="0" width="1" height="1" x="-3" y="-3"/>
	</g>
	<g id="scrollbarslider-normal-top">
		<rect opacity="${main.lower.like.shadow()}" width="1" height="1" x="2"/>
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="2" y="1"/>
		<rect opacity="0" width="1" height="1" x="2" y="-3"/>
	</g>
	<g id="scrollbarslider-normal-topright">
		<path opacity="${main.lower.like.shadow()}" d="M 5,2 A 2,2 0 0 0 3,0 v 1 a 1,1 0 0 1 1,1 z"/>
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 4,2 A 1,1 0 0 0 3,1 v 1 z"/>
		<rect opacity="0" width="1" height="1" x="7" y="-3"/>
	</g>
	<g id="scrollbarslider-normal-right">
		<rect opacity="${main.lower.like.shadow()}" width="1" height="1" x="4" y="2"/>
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="3" y="2"/>
		<rect opacity="0" width="1" height="1" x="7" y="2"/>
	</g>
	<g id="scrollbarslider-normal-bottomright">
		<path opacity="${main.lower.like.shadow()}" d="M 3,5 A 2,2 0 0 0 5,3 H 4 A 1,1 0 0 1 3,4 Z"/>
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 3,4 A 1,1 0 0 0 4,3 H 3 Z"/>
		<rect opacity="0" width="1" height="1" x="7" y="7"/>
	</g>
	<g id="scrollbarslider-normal-bottom">
		<rect opacity="${main.lower.like.shadow()}" width="1" height="1" x="2" y="4"/>
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="2" y="3"/>
		<rect opacity="0" width="1" height="1" x="2" y="7"/>
	</g>
	<g id="scrollbarslider-normal-bottomleft">
		<path opacity="${main.lower.like.shadow()}" d="M 0,3 A 2,2 0 0 0 2,5 V 4 A 1,1 0 0 1 1,3 Z"/>
		<path fill="${main.lower.text.out()}" opacity="0.15" d="M 1,3 A 1,1 0 0 0 2,4 V 3 Z"/>
		<rect opacity="0" width="1" height="1" x="-3" y="7"/>
	</g>
	<g id="scrollbarslider-normal-left">
		<rect opacity="${main.lower.like.shadow()}" width="1" height="1" y="2"/>
		<rect fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="1" y="2"/>
		<rect opacity="0" width="1" height="1" x="-3" y="2"/>
	</g>
	<rect id="scrollbarslider-normal" fill="${main.lower.text.out()}" opacity="0.15" width="1" height="1" x="2" y="2"/>
	
	${scrollbar_slider("focused")}
	${scrollbar_slider("pressed")}
	
	${tab("normal")}
	${tab("focused")}
	${tab("toggled")}
</svg>`;

#{ config: CONFIG, svg: SVG }
