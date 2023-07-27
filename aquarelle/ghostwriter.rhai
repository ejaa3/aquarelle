/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const  dark = cfg::scheme("dark");
const light = cfg::scheme("light");

fn out() { `"#${this.to_hex_rgb(true)}"` }

`{
	"dark": {
		"accent": ${dark.any.area.out()},
		"background": ${dark.upper.area.out()},
		"block": ${dark.yellow.like.out()},
		"cursor": ${dark.lower.text.out()},
		"emphasis": ${dark.magenta.like.out()},
		"error": ${dark.red.like.out()},
		"foreground": ${dark.lower.text.out()},
		"heading": ${dark.cyan.like.out()},
		"link": ${dark.blue.like.out()},
		"markup": ${dark.lower.text.fade(dark.dim / 1.5).out()},
		"selection": ${dark.lower.text.fade(0.15).out()}
	},
	"light": {
		"accent": ${light.any.area.out()},
		"background": ${light.upper.area.out()},
		"block": ${light.yellow.like.out()},
		"cursor": ${light.lower.text.out()},
		"emphasis": ${light.magenta.like.out()},
		"error": ${light.red.like.out()},
		"foreground": ${light.lower.text.out()},
		"heading": ${light.cyan.like.out()},
		"link": ${light.blue.like.out()},
		"markup": ${light.lower.text.fade(light.dim / 1.5).out()},
		"selection": ${light.lower.text.fade(0.15).out()}
	}
}`
