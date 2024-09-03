/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main     = cfg::scheme("main");
const accent   = cfg::option("accent");
const lower_bg = main.lower("lower", "like", 0.2);

const B_MUTE = `M9.25,7A2.25,8 0 0 0 7,15h1a1.25,7 0 0 1 1.25,-7 1.25,7 0 0 1 1.25,7h1A2.25,8 0 0 0 9.25,7Zm20,0A2.25,8 0 0 0 27,15h1a1.25,7 0 0 1 1.25,-7 1.25,7 0 0 1 1.25,7h1A2.25,8 0 0 0 29.25,7Zm20,0A2.25,8 0 0 0 47,15h1a1.25,7 0 0 1 1.25,-7 1.25,7 0 0 1 1.25,7h1A2.25,8 0 0 0 49.25,7Zm-36.5,0a2.25,8 0 0 0-2.25,8h1A1.25,7 0 0 1 12.75,8 1.25,7 0 0 1 14,15h1A2.25,8 0 0 0 12.75,7Zm20,0a2.25,8 0 0 0-2.25,8h1A1.25,7 0 0 1 32.75,8 1.25,7 0 0 1 34,15h1A2.25,8 0 0 0 32.75,7Zm20,0a2.25,8 0 0 0-2.25,8h1A1.25,7 0 0 1 52.75,8 1.25,7 0 0 1 54,15h1A2.25,8 0 0 0 52.75,7Z`;
const B_SOLO = `M11,7A3,2.25 0 0 0 8,9.25 3,2.25 0 0 0 11,11.5 2,1.25 0 0 1 13,12.75 2,1.25 0 0 1 11,14 2,1.25 0 0 1 9,12.75H8A3,2.25 0 0 0 11,15 3,2.25 0 0 0 14,12.75 3,2.25 0 0 0 11,10.5 2,1.25 0 0 1 9,9.25 2,1.25 0 0 1 11,8 2,1.25 0 0 1 13,9.25h1A3,2.25 0 0 0 11,7Zm20,0a3,2.25 0 0 0-3,2.25 3,2.25 0 0 0 3,2.25 2,1.25 0 0 1 2,1.25A2,1.25 0 0 1 31,14 2,1.25 0 0 1 29,12.75H28A3,2.25 0 0 0 31,15 3,2.25 0 0 0 34,12.75 3,2.25 0 0 0 31,10.5 2,1.25 0 0 1 29,9.25 2,1.25 0 0 1 31,8 2,1.25 0 0 1 33,9.25h1A3,2.25 0 0 0 31,7Zm20,0a3,2.25 0 0 0-3,2.25 3,2.25 0 0 0 3,2.25 2,1.25 0 0 1 2,1.25A2,1.25 0 0 1 51,14 2,1.25 0 0 1 49,12.75H48A3,2.25 0 0 0 51,15 3,2.25 0 0 0 54,12.75 3,2.25 0 0 0 51,10.5 2,1.25 0 0 1 49,9.25 2,1.25 0 0 1 51,8 2,1.25 0 0 1 53,9.25h1A3,2.25 0 0 0 51,7Z`;

import "color_theme" as color_theme;
import "general"     as general;
import "icons"       as icons;
import "mixer"       as mixer;
import "rtconfig"    as rtconfig;
import "swell"       as swell;
import "track"       as track;
import "transport"   as transport;

fn out() { '#' + this.to_hex_rgba(true) }

fn shadow_raw(factor) {
	const L = this.luma();
	rgb(0.0, 0.0, 0.0, (2 ** -L + 0.2 * L - 0.6) * factor)
}

fn shadow(factor) { this.shadow_raw(factor).out() }

fn is_dark() { this.lower.text.luma() > this.lower.like.luma() }

fn raise(set, role, bias) {
	switch this.is_dark() {
		true => lab::lighten(this[set][role], bias),
		_    => lab::darken (this[set][role], bias)
	}
}

fn lower(set, role, bias) {
	switch this.is_dark() {
		true => lab::darken (this[set][role], bias),
		_    => lab::lighten(this[set][role], bias)
	}
}

fn switchable(set, on) {
	if on {
		set = global::main[if set == "lower" { global::accent } else { set }];
		[set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2), set.text]
	} else {
		const color = global::main[set][if set == "lower" { "text" } else { "like" }];
		[color.fade(0.2), color.fade(0.3), color.fade(0.4), color]
	}
}

fn button(set, on, d, i, icon) {
	const colors = switchable(set, on);
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${d} ${d} ${[[`62 24`, `60 20`], [`92 35`, `90 30`], [`122 46`, `120 40`]][i][d]}">
		<path fill="magenta" d="M0,0V1H1V0Zm${[`61,21v3h1v-3`, `91,31v4h1v-4`, `121,41v5h1v-5`][i]}z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::main.lower.like.shadow(1)} d="M4,1A3,3 0 0 0 1,4v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3 3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3 3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 58,1H44A3,3 0 0 0 41,4 3,3 0 0 0 38,1H24A3,3 0 0 0 21,4 3,3 0 0 0 18,1Zm0,1h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H4A2,2 0 0 1 2,18V4A2,2 0 0 1 4,2Zm20,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H24A2,2 0 0 1 22,18V4a2,2 0 0 1 2,-2zm20,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H44A2,2 0 0 1 42,18V4a2,2 0 0 1 2,-2z"/>
				
				<path fill=${colors[0].out()} d="M4,2A2,2 0 0 0 2,4v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 18,2Z"/>
				<path fill=${colors[1].out()} d="m24,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 38,2Z"/>
				<path fill=${colors[2].out()} d="m44,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 58,2Z"/>
				
				${if d == 0 { // xml
					`<path fill=${global::main.lower.like.shadow(0.5)} d="m2,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H4A2,2 0 0 1 2,18Z"/>
					 <path fill=${global::main.lower.like.shadow(0.75)} d="m22,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H24a2,2 0 0 1-2,-2z"/>
					 <path fill=${global::main.lower.like.shadow(1)} d="m42,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H44a2,2 0 0 1-2,-2z"/>`
				}}
				
				<path fill=${colors[3].out()} d="${icon}"/>
			</g>
		</g>
	</svg>`
}

fn rectangle(color, width, height) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}">
		<rect fill=${color.out()} width="${width}" height="${height}"/>
	</svg>`
}

#{
	color_theme: color_theme::INI,
	swell_theme: swell::THEME,
	rtconfig: rtconfig::TEXT, // xml
	
	piano_black_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${if main.is_dark() { main.lower.area.out() } else { lab::mix(main.lower.like, main.lower.text, 0.625).out() }} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(0.5) } else { lab::mix(main.lower.like, main.lower.text, 0.625).shadow(0.5) }} x="1" y="6" width="6" height="3"/>
	</svg>`, // xml
	
	piano_black_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(1) } else { lab::mix(main.lower.like, main.lower.text, 0.625).shadow(1) }} x="1" y="6" width="6" height="3"/>
	</svg>`, // xml
	
	piano_white_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, 0.625).out() } else { main.lower.like.out() }} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, 0.625).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, 0.625).shadow(1.5) } else { main.lower.like.shadow(1.5) }} x="1" y="8" width="7" height="1"/>
	</svg>`, // xml
	
	piano_white_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, 0.625).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, 0.625).shadow(2) } else { main.lower.like.shadow(2) }} x="1" y="8" width="7" height="1"/>
	</svg>`,
} + general::map + icons::map + mixer::map + track::map + transport::map

/* ANCHOR regex to remove spaces from path data (replace with $1)
\s?([a-zA-Z\-])\s?
*/
