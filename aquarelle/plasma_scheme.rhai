/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main  = cfg::scheme("main");
const compl = cfg::scheme("complementary");

const accent  = cfg::option("accent");
const lightly = cfg::option("lightly");

fn select(set) { if global::accent == set { "any" } else { set } }

const active   = select("cyan");
const link     = select("blue");
const visited  = select("magenta");
const negative = select("red");
const neutral  = select("yellow");
const positive = select("green");

const dark = main.lower.text.luma() > main.lower.like.luma();

const heading = if lightly { main.lower.like } else { main.upper.like }
	.fade(cfg::option("opacity")).out();

fn out() { '#' + this.to_hex_argb(true) }

fn raise() {
	if global::dark { lab::lighten(this, 0.04).out() }
	else { lab::darken(this, 0.04).out() }
}

const button = if lightly {
	if dark { main.upper.like } else { main.lower.area }
} else { main.upper.area };

/* INI */ `
[ColorEffects:Inactive]
ChangeSelectionColor = ${cfg::option("dim-selection")}
Enable = false

[Colors:Button]
BackgroundAlternate = ${button.raise()}
BackgroundNormal = ${button.out()}
DecorationFocus = ${main[accent].area.out()}
DecorationHover = ${main[accent].like.out()}
ForegroundActive = ${main[active].like.out()}
ForegroundInactive = ${main.upper.text.fade(0.625).out()}
ForegroundLink = ${main[link].like.out()}
ForegroundNegative = ${main[negative].like.out()}
ForegroundNeutral = ${main[neutral].like.out()}
ForegroundNormal = ${main.upper.text.out()}
ForegroundPositive = ${main[positive].like.out()}
ForegroundVisited = ${main[visited].like.out()}

[Colors:Complementary]
BackgroundAlternate = ${compl.upper.like.out()}
BackgroundNormal = ${compl.upper.area.out()}
DecorationFocus = ${compl[accent].area.out()}
DecorationHover = ${compl[accent].like.out()}
ForegroundActive = ${compl[active].like.out()}
ForegroundInactive = ${compl.upper.text.fade(0.625).out()}
ForegroundLink = ${compl[link].like.out()}
ForegroundNegative = ${compl[negative].like.out()}
ForegroundNeutral = ${compl[neutral].like.out()}
ForegroundNormal = ${compl.upper.text.out()}
ForegroundPositive = ${compl[positive].like.out()}
ForegroundVisited = ${compl[visited].like.out()}

${if !cfg::option("lightly") { /* INI */ `
	[Colors:Header]
	BackgroundAlternate = ${main.upper.like.raise()}
	BackgroundNormal = ${main.upper.like.out()}
	DecorationFocus = ${main[accent].area.out()}
	DecorationHover = ${main[accent].like.out()}
	ForegroundActive = ${main[active].like.out()}
	ForegroundInactive = ${main.lower.text.fade(0.625).out()}
	ForegroundLink = ${main[link].like.out()}
	ForegroundNegative = ${main[negative].like.out()}
	ForegroundNeutral = ${main[neutral].like.out()}
	ForegroundNormal = ${main.lower.text.out()}
	ForegroundPositive = ${main[positive].like.out()}
	ForegroundVisited = ${main[visited].like.out()}
	
	${if cfg::option("dim-header") { /* INI */ `
		[Colors:Header][Inactive]
		BackgroundAlternate = ${main.lower.like.raise()}
		BackgroundNormal = ${main.lower.like.out()}
		DecorationFocus = ${main[accent].area.fade(0.625).out()}
		DecorationHover = ${main[accent].like.fade(0.625).out()}
		ForegroundActive = ${main[active].like.fade(0.625).out()}
		ForegroundInactive = ${main.lower.text.fade(0.625 * 0.625).out()}
		ForegroundLink = ${main[link].like.fade(0.625).out()}
		ForegroundNegative = ${main[negative].like.fade(0.625).out()}
		ForegroundNeutral = ${main[neutral].like.fade(0.625).out()}
		ForegroundNormal = ${main.lower.text.fade(0.625).out()}
		ForegroundPositive = ${main[positive].like.fade(0.625).out()}
		ForegroundVisited = ${main[visited].like.fade(0.625).out()}
	`}}
`}}

[Colors:Selection]
BackgroundAlternate = ${main[accent].like.out()}
BackgroundNormal = ${main[accent].area.out()}
DecorationFocus = ${main[accent].text.out()}
DecorationHover = ${main[accent].text.out()}
ForegroundActive = ${main[active].text.out()}
ForegroundInactive = ${main[accent].text.fade(0.625).out()}
ForegroundLink = ${main[link].text.out()}
ForegroundNegative = ${main[negative].text.out()}
ForegroundNeutral = ${main[neutral].text.out()}
ForegroundNormal = ${main[accent].text.out()}
ForegroundPositive = ${main[positive].text.out()}
ForegroundVisited = ${main[visited].text.out()}

[Colors:Tooltip]
BackgroundAlternate = ${main.upper.area.raise()}
BackgroundNormal = ${main.upper.area.out()}
DecorationFocus = ${main[accent].area.out()}
DecorationHover = ${main[accent].like.out()}
ForegroundActive = ${main[active].like.out()}
ForegroundInactive = ${main.upper.text.fade(0.625).out()}
ForegroundLink = ${main[link].like.out()}
ForegroundNegative = ${main[negative].like.out()}
ForegroundNeutral = ${main[neutral].like.out()}
ForegroundNormal = ${main.upper.text.out()}
ForegroundPositive = ${main[positive].like.out()}
ForegroundVisited = ${main[visited].like.out()}

[Colors:View]
BackgroundAlternate = ${if lightly && dark { main.lower.like.out() } else { main.lower.area.raise() }}
BackgroundNormal = ${if lightly && dark { main.upper.like.out() } else { main.lower.area.out() }}
DecorationFocus = ${main[accent].area.out()}
DecorationHover = ${main[accent].like.out()}
ForegroundActive = ${main[active].like.out()}
ForegroundInactive = ${main.lower.text.fade(0.625).out()}
ForegroundLink = ${main[link].like.out()}
ForegroundNegative = ${main[negative].like.out()}
ForegroundNeutral = ${main[neutral].like.out()}
ForegroundNormal = ${main.lower.text.out()}
ForegroundPositive = ${main[positive].like.out()}
ForegroundVisited = ${main[visited].like.out()}

[Colors:Window]
BackgroundAlternate = ${main.lower.like.raise()}
BackgroundNormal = ${main.lower.like.out()}
DecorationFocus = ${main[accent].area.out()}
DecorationHover = ${main[accent].like.out()}
ForegroundActive = ${main[active].like.out()}
ForegroundInactive = ${main.lower.text.fade(0.625).out()}
ForegroundLink = ${main[link].like.out()}
ForegroundNegative = ${main[negative].like.out()}
ForegroundNeutral = ${main[neutral].like.out()}
ForegroundNormal = ${main.lower.text.out()}
ForegroundPositive = ${main[positive].like.out()}
ForegroundVisited = ${main[visited].like.out()}

[General]
ColorScheme = ${cfg::name}
Name = ${cfg::display}

[WM]
activeBackground = ${heading}
activeForeground = ${main.lower.text.out()}
inactiveBackground = ${heading}
inactiveForeground = ${main.lower.text.fade(
	if cfg::option("dim-header") { 0.625 } else { 1.0 }
).out()}
`
