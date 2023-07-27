/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main = cfg::scheme("main");

const  normal = if cfg::option("bold") { "like" } else { "area" };
const intense = if cfg::option("bold") { "area" } else { "like" };

const base = if cfg::option("embedded") { main.lower.like } else { main.lower.area };

fn out() { '#' + this.to_hex_rgb(true) }

fn faint(set) {
	lab::mix(global::base, global::main[set].like, global::main.dim).out()
}

`
[General]
Description = ${cfg::display}
Blur = ${cfg::option("blur")}
Opacity = ${cfg::option("opacity")}

[Foreground]
Color = ${main.lower.text.out()}

[ForegroundIntense]
Color = ${main.any[intense].out()}

[ForegroundFaint]
Color = ${lab::mix(base, main.lower.text, main.dim).out()}

[Background]
Color = ${base.out()}

[BackgroundIntense]
Color = ${main.upper.area.out()}

[BackgroundFaint]
Color = ${lab::mix(base, main.lower.text, main.border).out()}

[Color0]
Color = ${ // HACK better solarized
	if main.lower.like.luma() != main.lower.area.luma()
		{ main.lower.like.out() } else { main.upper.area.out() }
}

[Color0Intense]
Color = ${lab::mix(main.lower.text, base, main.dim).out()}

[Color0Faint]
Color = ${faint("any")}

[Color1]
Color = ${main.red[normal].out()}

[Color1Intense]
Color = ${main.red[intense].out()}

[Color1Faint]
Color = ${faint("red")}

[Color2]
Color = ${main.green[normal].out()}

[Color2Intense]
Color = ${main.green[intense].out()}

[Color2Faint]
Color = ${faint("green")}

[Color3]
Color = ${main.yellow[normal].out()}

[Color3Intense]
Color = ${main.yellow[intense].out()}

[Color3Faint]
Color = ${faint("yellow")}

[Color4]
Color = ${main.blue[normal].out()}

[Color4Intense]
Color = ${main.blue[intense].out()}

[Color4Faint]
Color = ${faint("blue")}

[Color5]
Color = ${main.magenta[normal].out()}

[Color5Intense]
Color = ${main.magenta[intense].out()}

[Color5Faint]
Color = ${faint("magenta")}

[Color6]
Color = ${main.cyan[normal].out()}

[Color6Intense]
Color = ${main.cyan[intense].out()}

[Color6Faint]
Color = ${faint("cyan")}

[Color7]
Color = ${main.any[normal].out()}

[Color7Intense]
Color = ${main.upper.text.out()}

[Color7Faint]
Color = ${lab::mix(base, main.upper.text, main.dim).out()}
`
