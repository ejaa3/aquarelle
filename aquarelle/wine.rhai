/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main   = cfg::scheme("main");
const dark   = main.lower.text.luma() > main.lower.like.luma();
const accent = cfg::option("accent");

fn out() {
	let rgb = rgb::coords(this);
	`"${rgb.red} ${rgb.green} ${rgb.blue}"`
}

fn shadow(alpha) {
	const L = this.luma();
	lab::mix(this, 0, (2 ** -L + 0.2 * L - 0.6) * alpha).out()
}

/* INI */ `
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Control Panel\Colors]
"ActiveBorder" = ${
	if dark { lab::mix(main.lower.like, main.blue.area, 0.625).out() }
	else { main.blue.area.out() }
}
"ActiveTitle" = ${main.upper.like.out()}
"AppWorkSpace" = "255 0 0"
"Background" = ${lab::mix(main.lower.area, main[accent].area, 0.2).out() /* TODO test */}
"ButtonAlternateFace" = "0 255 255"
"ButtonDkShadow" = ${main.lower.like.shadow(0.5)}
"ButtonFace" = ${main.lower.like.out()}
"ButtonHilight" = ${main.lower.like.shadow(1.0)}
"ButtonLight" = ${lab::lighten(main.lower.like, if dark { 0.075 } else { 0.25 }).out()}
"ButtonShadow" = ${main.lower.like.shadow(1.0)}
"ButtonText" = ${lab::mix(main.lower.text, main[accent].like, 0.5).out()}
"GradientActiveTitle" = ${lab::mix(main.upper.like, main[accent].like, 0.25).out()}
"GradientInactiveTitle" = ${lab::mix(main.lower.area, main.lower.text, 0.125).out()}
"GrayText" = ${lab::mix(main.lower.area, main.lower.text, 0.625).out()}
"Hilight" = ${main[accent].area.out()}
"HilightText" = ${main[accent].text.out()}
"HotTrackingColor" = "0 255 0"
"InactiveBorder" = ${
	if dark { lab::mix(main.lower.like, main.lower.text, 0.25).out() }
	else { lab::mix(main.lower.like, main.lower.text, 0.5).out() }
}
"InactiveTitle" = ${main.lower.like.out()}
"InactiveTitleText" = ${lab::mix(main.lower.area, main.lower.text, 0.625).out()}
"InfoText" = ${main.upper.text.out()}
"InfoWindow" = ${main.upper.area.out()}
"Menu" = ${main.upper.like.out()}
"MenuBar" = "0 0 255"
"MenuHilight" = "255 0 0"
"MenuText" = ${main.lower.text.out()}
"Scrollbar" = ${main.upper.like.out()}
"TitleText" = ${main.lower.text.out()}
"Window" = ${main.lower.area.out()}
"WindowFrame" = ${lab::mix(main.upper.like, main.lower.text, 0.25).out()}
"WindowText" = ${main.lower.text.out()}
`
