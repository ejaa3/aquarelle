/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   name = cfg::option("name");
const    hue = cfg::option("hue");
const rotate = cfg::option("rotate");

const sc = cfg::option("surface-chroma");
const sl = cfg::option("surface-luminance");
const tc = cfg::option("text-chroma");
const tl = cfg::option("text-luminance");
const oc = cfg::option("overall-chroma");
const ol = cfg::option("overall-luminance");

const N = if tl > sl {
	[ cfg::option("shading"), 4, tl,  10, cfg::option("shading")]
} else {
	[-cfg::option("shading"), 3, ol, -10, 0]
};

let colors = []; colors.pad(8, ());

for i in 0..4 { colors[i] = lch(
	sl + N[0] * (i % N[1]) / 3.0, sc, hue + i * rotate / 4
) }

colors[4] = lch(tl         , tc, hue + 180);
colors[5] = lch(tl   + N[4], tc, hue + 180 + rotate);
colors[6] = lch(N[2]       , tc, hue);
colors[7] = lch(N[2] - N[3], tc, hue);

let like = []; like.pad(6, ());
let area = []; area.pad(6, ());

for (degree, i) in [45, 90, 135, 225, 270, 315] {
	like[i] = lch(ol       , oc, hue + degree);
	area[i] = lch(ol - N[3], oc, hue + degree);
}

fn hue_diff(a, b) {
	to_int(hsv::coords(a).hue - hsv::coords(b).hue);
}

like.sort(hue_diff);
area.sort(hue_diff);

if hsv::coords(like[0]).hue > abs(hsv::coords(like[5]).hue - 360) {
	like.insert(0, like.pop());
}

if hsv::coords(area[0]).hue > abs(hsv::coords(area[5]).hue - 360) {
	area.insert(0, area.pop());
}

/* import "../lib" as lib;
lib::print_colors(colors, "colors");
lib::print_colors(like, "like");
lib::print_colors(area, "area"); */

`  name = '${if name.is_empty() { "Neon Cake" } else { name }}'
 border =  ${cfg::option("border")}
    dim =  ${cfg::option("dim")}
  lower = { like = ${colors[1]}, area = ${colors[0]}, text = ${colors[4]} }
  upper = { like = ${colors[3]}, area = ${colors[2]}, text = ${colors[5]} }
    red = { like = ${  like[0]}, area = ${  area[0]}, text = ${colors[0]} }
 yellow = { like = ${  like[1]}, area = ${  area[1]}, text = ${colors[0]} }
  green = { like = ${  like[2]}, area = ${  area[2]}, text = ${colors[0]} }
   cyan = { like = ${  like[3]}, area = ${  area[3]}, text = ${colors[0]} }
   blue = { like = ${  like[4]}, area = ${  area[4]}, text = ${colors[0]} }
magenta = { like = ${  like[5]}, area = ${  area[5]}, text = ${colors[0]} }
    any = { like = ${colors[6]}, area = ${colors[7]}, text = ${colors[0]} }
`
