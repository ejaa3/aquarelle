/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main   = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { '#' + this.to_hex_rgba(true) } // css

fn shadow() {
	let L = this.luma();
	lab::mix(this, 0xFF, 2 ** -L + 0.2 * L - 0.6).out()
}

// WATCH https://github.com/zotero/zotero/blob/5dc17be46cc2cee1b9493fa59e23d09ec34165f4/scss/themes/_dark.scss

`:root {
	--accent-azure: ${main.any.area.out()} !important;
	--accent-blue: ${main.blue.area.out()} !important;
	--accent-blue10: ${main.blue.area.fade(0.25).out()} !important;
	--accent-blue30: ${main.blue.area.fade(0.50).out()} !important;
	--accent-blue50: ${main.blue.area.fade(0.75).out()} !important;
	--accent-gold: ${lab::mix(main.red.area, main.yellow.area, 0.75).out()} !important;
	--accent-green: ${main.green.area.out()} !important;
	--accent-orange: ${lab::mix(main.red.area, main.yellow.area, 0.5).out()} !important;
	--accent-red: ${main.red.area.out()} !important;
	--accent-teal: ${main.cyan.area.out()} !important;
	--accent-white: ${main[accent].text.out()} !important;
	--accent-wood-dark: ${lab::mix(main.blue.area, main.magenta.area, 0.5).out()} !important;
	--accent-wood: ${main.magenta.area.out()} !important;
	--accent-yellow: ${main.yellow.area.out()} !important;
	--accent-highlight: ${main.yellow.area.fade(0.25).out()} !important;
	
	--fill-primary: ${main.lower.text.out()} !important;
	--fill-secondary: ${main.lower.text.fade(0.75).out()} !important;
	--fill-tertiary: ${main.lower.text.fade(0.5).out()} !important;
	--fill-quarternary: ${main.lower.area.shadow()} !important;
	--fill-quinary: ${main.lower.text.fade(0.25).out()} !important;
	--fill-senary: #00f !important;
	
	--color-background: ${main.lower.area.out()} !important;
	--color-background50: #00f !important;
	--color-background70: #f00 !important;
	--color-border: #0ff !important;
	--color-border50: #0f0 !important;
	--color-button: ${main.lower.text.fade(0.15).out()} !important;
	--color-control: #ccc !important;
	--color-menu: #00f !important;
	--color-panedivider: ${main.lower.area.shadow()} !important;
	--color-sidepane: ${main.lower.like.out()} !important;
	--color-tabbar: ${main.upper.like.out()} !important;
	--color-toolbar: ${main.lower.like.out()} !important;
	--color-scrollbar: ${main.lower.text.fade(0.25)} !important;
	--color-scrollbar-hover: ${main.lower.text.fade(0.5)} !important;
	--color-scrollbar-background: transparent !important;
	--color-stripe: #f0f !important;
	
	--tag-blue: ${main.cyan.area.out()} !important;
	--tag-gray: ${main.any.area.out()} !important;
	--tag-green: ${main.green.area.out()} !important;
	--tag-indigo: ${main.blue.area.out()} !important;
	--tag-magenta: ${main.magenta.area.out()} !important;
	--tag-orange: ${lab::mix(main.red.area, main.yellow.area, 0.5).out()} !important;
	--tag-plum: ${lab::mix(main.magenta.area, main.red.area, 0.5).out()} !important;
	--tag-purple: ${lab::mix(main.blue.area, main.magenta.area, 0.5).out()} !important;
	--tag-red: ${main.red.area.out()} !important;
	--tag-teal: ${lab::mix(main.green.area, main.cyan.area, 0.5).out()} !important;
	--tag-yellow: ${main.yellow.area.out()} !important;
}`
