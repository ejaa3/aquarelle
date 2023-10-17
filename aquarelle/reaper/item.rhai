/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

private fn icon(name, on) {
	const color = if on { global::main[global::accent].like } else { global::main.lower.text };
	const on = if on { 0.1 } else { 0.0 };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 14">
		<path fill=${color.fade(0.2 + on).out()} d="M 0,1 V 13 H 13 V 1 Z"/>
		<path fill=${color.fade(0.3 + on).out()} d="M 14,1 V 13 H 27 V 1 Z"/>
		<path fill=${color.fade(0.4 + on).out()} d="M 28,1 V 13 H 41 V 1 Z"/>
		<path fill=${color.out()} d="${switch name {
			"pooled" => `M 5,3 V 4 5 H 2 v 1 4 1 H 7 8 V 9 h 2 1 V 4 3 Z m 14,0 v 1 1 h -3 v 1 4 1 h 5 1 V 9 h 2 1 V 4 3 Z m 14,0 v 1 1 h -3 v 1 4 1 h 5 1 V 9 h 2 1 V 4 3 Z M 6,4 h 4 V 8 H 8 V 6 5 H 6 Z m 14,0 h 4 V 8 H 22 V 6 5 h -2 z m 14,0 h 4 V 8 H 36 V 6 5 H 34 Z M 3,6 h 2 v 2 1 h 2 v 1 H 3 Z M 6,6 H 7 V 8 H 6 Z m 11,0 h 2 v 2 1 h 2 v 1 h -4 z m 3,0 h 1 v 2 h -1 z m 11,0 h 2 v 2 1 h 2 v 1 h -4 z m 3,0 h 1 v 2 h -1 z`,
			"lock" => `M 6.5,3 A 2.5,2.5 0 0 0 4,5.5 V 7 H 3 v 4 h 7 V 7 H 9 V 5.5 A 2.5,2.5 0 0 0 6.5,3 Z m 14,0 A 2.5,2.5 0 0 0 18,5.5 V 7 h -1 v 4 h 7 V 7 H 23 V 5.5 A 2.5,2.5 0 0 0 20.5,3 Z m 14,0 A 2.5,2.5 0 0 0 32,5.5 V 7 h -1 v 4 h 7 V 7 H 37 V 5.5 A 2.5,2.5 0 0 0 34.5,3 Z M 6.5,4 A 1.5,1.5 0 0 1 8,5.5 V 7 H 5 V 5.5 A 1.5,1.5 0 0 1 6.5,4 Z m 14,0 A 1.5,1.5 0 0 1 22,5.5 V 7 H 19 V 5.5 A 1.5,1.5 0 0 1 20.5,4 Z m 14,0 A 1.5,1.5 0 0 1 36,5.5 V 7 H 33 V 5.5 A 1.5,1.5 0 0 1 34.5,4 Z`,
		}}"/>
	</svg>`
}

export const map = #{
	item_bg: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 33">
		<path fill="yellow" d="M 0,0 V 2 H 1 V 0 Z m 18,31 v 1 h -1 v 1 h 2 v -1 -1 z"/>
		<path fill="magenta" d="M 1,0 V 1 H 5 V 0 Z M 0,2 V 6 H 1 V 2 Z m 18,26 v 3 h 1 v -3 z m -2,4 v 1 h 1 v -1 z"/>
		<path fill=${main.raise("upper", "area", 0.1).fade(2 / 3.0).out()} d="M 1,2 V 31 H 17 V 2 Z"/>
		<path fill=${main.lower.area.shadow(1)} d="M 1,1V 2H 17V 31H 1v 1h 16 1V 2 1Z"/>
	</svg>`,
	
	item_bg_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 33">
		<path fill="yellow" d="M 0,0V 2H 1V 0Zm 18,30v 2h -1v 1h 1 1v -3z"/>
		<path fill="magenta" d="M 1,0V 1H 5V 0ZM 0,2V 6H 1V 2Zm 18,26v 2h 1v -2zm -2,4v 1h 1v -1z"/>
		<path fill=${main[accent].area.out()} d="m 1,1v 2 27 2H 18V 30 3 1ZM 2,3H 17V 30H 2Z"/>
		<path fill=${main.lower("upper", "area", 1.0).fade(2 / 3.0).out()} d="M 2,3V 30H 17V 3Z"/>
	</svg>`,
	
	item_lock_off: icon("lock", true),
	item_lock_on: icon("lock", false),
	item_pooled_on: icon("pooled", true),
	item_pooled: icon("pooled", false),
}
