/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const  normal = if cfg::option("bold") { "like" } else { "area" };
const intense = if cfg::option("bold") { "area" } else { "like" };

fn out() { '#' + this.to_hex_rgb(true) } // json

`{
	"name": "${cfg::display}",
	"comment": "Scheme provided by Aquarelle",
	
	"use-badge-color": true,
	"badge-color": "${main[accent].like.out()}",
	
	"use-bold-color": true,
	"bold-color": "${main.any[intense].out()}",
	
	"use-cursor-color": true,
	"cursor-background-color": "${main.lower.text.out()}",
	"cursor-foreground-color": "${main.lower.area.out()}",
	
	"use-highlight-color": true,
	"highlight-background-color": "${main[accent].area.out()}",
	"highlight-foreground-color": "${main[accent].text.out()}",
	
	"use-theme-colors": false,
	"background-color": "${main.lower.area.out()}",
	"foreground-color": "${main.lower.text.out()}",
	
	"palette": [
		"${ // HACK better solarized
			if main.lower.like.luma() != main.lower.area.luma()
				{ main.lower.like.out() } else { main.upper.like.out() }
		}",
		"${main.red[normal].out()}",
		"${main.green[normal].out()}",
		"${main.yellow[normal].out()}",
		"${main.blue[normal].out()}",
		"${main.magenta[normal].out()}",
		"${main.cyan[normal].out()}",
		"${main.any[normal].out()}",
		"${lab::mix(main.lower.text, main.lower.area, 0.625).out()}",
		"${main.red[intense].out()}",
		"${main.green[intense].out()}",
		"${main.yellow[intense].out()}",
		"${main.blue[intense].out()}",
		"${main.magenta[intense].out()}",
		"${main.cyan[intense].out()}",
		"${main.upper.text.out()}"
	]
}`
