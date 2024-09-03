/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main   = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { '#' + this.to_hex_rgb(true) }

const DARK = lab::darken_fixed(main.lower.like, 0.075).out();
const LIGHT = lab::lighten_fixed(main.lower.like, 0.075).out();
const MID = lab::darken_fixed(main.lower.like, 0.0375).out();
const MIDLIGHT = lab::lighten_fixed(main.lower.like, 0.0375).out();
const SHADOW = lab::mix(main.lower.like, 0, { const x = main.lower.like.luma(); 2 ** -x + 0.2 * x - 0.6 }).out();

`[ColorThemes]
${cfg::name}\AlternateBase = ${main.lower.like.out()}, ${main.lower.like.out()}, ${main.lower.like.out()}
${cfg::name}\Base = ${main.upper.area.out()}, ${main.upper.area.out()}, ${main.upper.area.out()}
${cfg::name}\BrightText = #ffffff, #ffffff, #ffffff
${cfg::name}\Button = ${main.lower.area.out()}, ${main.lower.area.out()}, ${main.lower.area.out()}
${cfg::name}\ButtonText = ${main.lower.text.out()}, ${main.lower.text.out()}, ${main.lower.text.out()}
${cfg::name}\Dark = ${DARK}, ${DARK}, ${DARK}
${cfg::name}\Highlight = ${main[accent].area.out()}, ${main[accent].area.out()}, ${main[accent].area.out()}
${cfg::name}\HighlightedText = ${main[accent].text.out()}, ${main[accent].text.out()}, ${main[accent].text.out()}
${cfg::name}\Light = ${LIGHT}, ${LIGHT}, ${LIGHT}
${cfg::name}\Link = ${main.blue.like.out()}, ${main.blue.like.out()}, ${main.blue.like.out()}
${cfg::name}\LinkVisited = ${main.magenta.like.out()}, ${main.magenta.like.out()}, ${main.magenta.like.out()}
${cfg::name}\Mid = ${MID}, ${MID}, ${MID}
${cfg::name}\Midlight = ${MIDLIGHT}, ${MIDLIGHT}, ${MIDLIGHT}
${cfg::name}\NoRole = #000000, #000000, #000000
${cfg::name}\PlaceholderText = #${main.lower.text.fade(0.625).to_hex_argb(true)}
${cfg::name}\Shadow = ${SHADOW}, ${SHADOW}, ${SHADOW}
${cfg::name}\Text = ${main.upper.text.out()}, ${main.upper.text.out()}, ${main.upper.text.out()}
${cfg::name}\ToolTipBase = ${main.upper.like.out()}, ${main.upper.like.out()}, ${main.upper.like.out()}
${cfg::name}\ToolTipText = ${main.lower.text.out()}, ${main.lower.text.out()}, ${main.lower.text.out()}
${cfg::name}\Window = ${main.lower.like.out()}, ${main.lower.like.out()}, ${main.lower.like.out()}
${cfg::name}\WindowText = ${main.lower.text.out()}, ${main.lower.text.out()}, ${main.lower.text.out()}`
