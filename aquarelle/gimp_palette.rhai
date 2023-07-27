/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main = cfg::scheme("main");

const    text = main.lower.text;
const     red = main.red.area;
const  yellow = main.yellow.area;
const   green = main.green.area;
const    cyan = main.cyan.area;
const    blue = main.blue.area;
const magenta = main.magenta.area;
const     any = main.any.area;

fn pad() {
	if this <  10 { "  " + this } else
	if this < 100 { " "  + this } else { this }
}

fn out() {
	let rgb = rgb::coords(this);
	`${rgb.red.pad()} ${rgb.green.pad()} ${rgb.blue.pad()}${'\n'}`
}

let palette = `GIMP Palette
Name: ${cfg::display}
Columns: 6
#
`;

for i in 0..10 {
	i /= 10.0;
	for role in [main.lower.area, main.lower.like, main.upper.area] {
		palette +=
			lab::mix(role,    text, i).out() +
			lab::mix(role,     red, i).out() +
			lab::mix(role,  yellow, i).out() +
			lab::mix(role,   green, i).out() +
			lab::mix(role,    cyan, i).out() +
			lab::mix(role,    blue, i).out() +
			lab::mix(role, magenta, i).out() +
			lab::mix(role,     any, i).out() ;
	}
}

palette
