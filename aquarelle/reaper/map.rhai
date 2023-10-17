/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import "color_theme" as color_theme;
import "control_panel" as cp;
import "general" as gen;
import "item" as item;
import "meter" as meter;
import "toolbar" as toolbar;
import "transport" as transport;

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { `"#${this.to_hex_rgba(true)}"` }

fn shadow(factor) {
	const L = this.luma();
	rgb(0.0, 0.0, 0.0, (2 ** -L + 0.2 * L - 0.6) * factor).out()
}

fn is_dark() { this.lower.text.luma() > this.lower.like.luma() }

fn raise(set, role, bias) {
	switch this.is_dark() {
		true => lab::lighten(this[set][role], bias),
		   _ => lab::darken (this[set][role], bias)
	}
}

fn lower(set, role, bias) {
	switch this.is_dark() {
		true => lab::darken (this[set][role], bias),
		   _ => lab::lighten(this[set][role], bias)
	}
}

fn switchable(on) {
	const SET = global::main[if on { global::accent } else { "lower" }];
	
	const COLORS = switch on {
		true => [SET.area, lab::mix(SET.area, SET.text, 0.1), lab::mix(SET.area, SET.text, 0.2)],
		   _ => [SET.text.fade(0.2), SET.text.fade(0.3), SET.text.fade(0.4)]
	};
	
	#{ set: SET, colors: COLORS }
}

fn rectangle(color, width, height) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}">
		<rect fill=${color.out()} width="${width}" height="${height}"/>
	</svg>`
}

#{
	color_theme: color_theme::INI,
	
	piano_black_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${if main.is_dark() { main.lower.area.out() } else { lab::mix(main.lower.like, main.lower.text, main.dim).out() }} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(0.5) } else { lab::mix(main.lower.like, main.lower.text, main.dim).shadow(0.5) }} x="1" y="6" width="6" height="3"/>
	</svg>`,
	piano_black_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(1) } else { lab::mix(main.lower.like, main.lower.text, main.dim).shadow(1) }} x="1" y="6" width="6" height="3"/>
	</svg>`,
	piano_white_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).shadow(1.5) } else { main.lower.like.shadow(1.5) }} x="1" y="8" width="7" height="1"/>
	</svg>`,
	piano_white_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).shadow(2) } else { main.lower.like.shadow(2) }} x="1" y="8" width="7" height="1"/>
	</svg>`,
} + cp::map + gen::map + item::map + meter::map + toolbar::map + transport::map

/* ANCHOR regex to remove spaces from path data (replace with $1)
\s?([a-zA-Z])\s?
*/
