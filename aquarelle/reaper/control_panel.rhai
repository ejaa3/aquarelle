/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const tcp_name_area = main.lower("lower", "like", 0.25);

fn arm(mode, state, scale) {
	const set = global::main[if mode != "env" { "red" } else if state == "on" { global::accent } else { "lower" }];
	const area = global::tcp_name_area;
	const text = global::main.lower.text;
	
	const colors = switch state {
		"on" => [set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2), set.text],
		"off" => if mode == "env" { [text.fade(0.2), text.fade(0.3), text.fade(0.4), text] }
			else { [set.like.fade(0.4), set.like.fade(0.5), set.like.fade(0.6), text] },
		"disabled" => [text, lab::mix(text, area, 0.1), lab::mix(text, area, 0.2), area],
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 60 20" width="${60 * scale}" height="${20 * scale}">
		<circle fill=${colors[0].out()} cx="10" cy="10" r="10"/>
		<circle fill=${colors[1].out()} cx="30" cy="10" r="10"/>
		<circle fill=${colors[2].out()} cx="50" cy="10" r="10"/>
		<path fill=${colors[3].out()} d="${switch mode {
			"auto" => `m8.5,5 -3,9h2l1,-2h3l1,2h2l-3,-9zm20,0 -3,9h2l1,-2h3l1,2h2l-3,-9zm20,0 -3,9h2l1,-2h3l1,2h2l-3,-9zM10,7 11,10H9Zm20,0 1,3h-2zm20,0 1,3h-2z`,
			     _ => `m10,5a5,5 0 0 0 -5,5 5,5 0 0 0 5,5 5,5 0 0 0 5,-5 5,5 0 0 0 -5,-5zm20,0a5,5 0 0 0 -5,5 5,5 0 0 0 5,5 5,5 0 0 0 5,-5 5,5 0 0 0 -5,-5zm20,0a5,5 0 0 0 -5,5 5,5 0 0 0 5,5 5,5 0 0 0 5,-5 5,5 0 0 0 -5,-5zM10,7a3,3 0 0 1 3,3 3,3 0 0 1 -3,3 3,3 0 0 1 -3,-3 3,3 0 0 1 3,-3zm20,0a3,3 0 0 1 3,3 3,3 0 0 1 -3,3 3,3 0 0 1 -3,-3 3,3 0 0 1 3,-3zm20,0a3,3 0 0 1 3,3 3,3 0 0 1 -3,3 3,3 0 0 1 -3,-3 3,3 0 0 1 3,-3z`
		}}"/>
	</svg>`
}

export const arm_OL = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 68 26">
	<path fill="magenta" d="M0,0V2H1V1H2V0Zm67,22v3h-1v1h2v-4z"/>
	<path fill=${tcp_name_area.out()} d="M12,1A11,11 0 0 0 1,12 11,11 0 0 0 12,23H23V12 1ZM23,12A11,11 0 0 0 34,23H45V12 1H34A11,11 0 0 0 23,12Zm22,0A11,11 0 0 0 56,23H67V12 1H56A11,11 0 0 0 45,12ZM12,2A10,10 0 0 1 22,12 10,10 0 0 1 12,22 10,10 0 0 1 2,12 10,10 0 0 1 12,2ZM34,2A10,10 0 0 1 44,12 10,10 0 0 1 34,22 10,10 0 0 1 24,12 10,10 0 0 1 34,2ZM56,2A10,10 0 0 1 66,12 10,10 0 0 1 56,22 10,10 0 0 1 46,12 10,10 0 0 1 56,2Z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m2,12v3A10,10 0 0 0 12,25 10,10 0 0 0 22,15V12A10,10 0 0 1 12,22 10,10 0 0 1 2,12Z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m24,12v3A10,10 0 0 0 34,25 10,10 0 0 0 44,15V12A10,10 0 0 1 34,22 10,10 0 0 1 24,12Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m47,12v3A10,10 0 0 0 57,25 10,10 0 0 0 67,15V12A10,10 0 0 1 57,22 10,10 0 0 1 47,12Z"/>
</svg>`;

export const arm_OL_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 98 37">
	<path fill="magenta" d="M0,0V2H1V1H2V0Zm97,32v4h-1v1h2v-5z"/>
	<path fill=${tcp_name_area.out()} d="M17,1A16,16 0 0 0 1,17 16,16 0 0 0 17,33H33V17 1ZM33,17A16,16 0 0 0 49,33H65V17 1H49A16,16 0 0 0 33,17Zm32,0A16,16 0 0 0 81,33H97V17 1H81A16,16 0 0 0 65,17ZM17,2A15,15 0 0 1 32,17 15,15 0 0 1 17,32 15,15 0 0 1 2,17 15,15 0 0 1 17,2ZM49,2A15,15 0 0 1 64,17 15,15 0 0 1 49,32 15,15 0 0 1 34,17 15,15 0 0 1 49,2ZM81,2A15,15 0 0 1 96,17 15,15 0 0 1 81,32 15,15 0 0 1 66,17 15,15 0 0 1 81,2Z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m2,17v4A15,15 0 0 0 17,36 15,15 0 0 0 32,21V17A15,15 0 0 1 17,32 15,15 0 0 1 2,17Z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m34,17v4A15,15 0 0 0 49,36 15,15 0 0 0 64,21V17A15,15 0 0 1 49,32 15,15 0 0 1 34,17Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m66,17v4A15,15 0 0 0 81,36 15,15 0 0 0 96,21V17A15,15 0 0 1 81,32 15,15 0 0 1 66,17Z"/>
</svg>`;

export const arm_OL_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 134 50">
	<path fill="magenta" d="M0,0V1 3H1V1H3V0Zm133,43v6h-2v1h2 1v-7z"/>
	<path fill=${tcp_name_area.out()} d="M23,1A22,22 0 0 0 1,23 22,22 0 0 0 23,45H45V23 1ZM45,23A22,22 0 0 0 67,45H89V23 1H67A22,22 0 0 0 45,23Zm44,0a22,22 0 0 0 22,22h22V23 1H111A22,22 0 0 0 89,23ZM23,3A20,20 0 0 1 43,23 20,20 0 0 1 23,43 20,20 0 0 1 3,23 20,20 0 0 1 23,3ZM67,3A20,20 0 0 1 87,23 20,20 0 0 1 67,43 20,20 0 0 1 47,23 20,20 0 0 1 67,3Zm44,0A20,20 0 0 1 131,23 20,20 0 0 1 111,43 20,20 0 0 1 91,23 20,20 0 0 1 111,3Z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m3,23v6A20,20 0 0 0 23,49 20,20 0 0 0 43,29V23A20,20 0 0 1 23,43 20,20 0 0 1 3,23Z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m47,23v6A20,20 0 0 0 67,49 20,20 0 0 0 87,29V23A20,20 0 0 1 67,43 20,20 0 0 1 47,23Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m91,23v6a20,20 0 0 0 20,20 20,20 0 0 0 20,-20V23A20,20 0 0 1 111,43 20,20 0 0 1 91,23Z"/>
</svg>`;

fn envcp_bypass(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47 24">
		<rect fill=${global::main.lower.like.out()} width="47" height="24"/>
		<path fill="magenta" d="M0,0V2H1V0Zm46,22v2h1v-2z"/>
		<rect fill=${global::tcp_name_area.out()} x="1" y="1" width="45" height="22"/>
		
		<circle fill=${color.out()} cx="8.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="8.5" cy="12.5" r="4"/>
		
		<circle fill=${global::main.lower.text.out()} cx="23.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="23.5" cy="12.5" r="4"/>
		
		<circle fill=${color.out()} cx="38.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="38.5" cy="12.5" r="4"/>
		
		<path fill=${global::tcp_name_area.out()} d="M6,7 8.5,13 11,7Zm15,0 2.5,6 2.5,-6zm15,0 2.5,6 2.5,-6z"/>
		
		<rect fill=${color.out()} x="8" y="6" width="1" height="7"/>
		<rect fill=${global::main.lower.text.out()} x="23" y="6" width="1" height="7"/>
		<rect fill=${color.out()} x="38" y="6" width="1" height="7"/>
	</svg>`
}

fn envcp_bypass_150(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 71 34">
		<path fill="magenta" d="M0,0V2H1V0Zm70,32v2h1v-2z"/>
		<path fill=${global::tcp_name_area.out()} d="M2,1V33H24V1ZM25,1V33H47V1ZM48,1V33H70V1Z"/>
		
		<circle fill=${color.out()} cx="13" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="13" cy="17.5" r="6"/>
		
		<circle fill=${global::main.lower.text.out()} cx="36" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="36" cy="17.5" r="6"/>
		
		<circle fill=${color.out()} cx="59" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="59" cy="17.5" r="6"/>
		
		<path fill=${global::tcp_name_area.out()} d="m8.5,8.5 4.5,10 4.5,-10zm23,0 4.5,10 4.5,-10zm23,0 4.5,10 4.5,-10z"/>
		
		<rect fill=${color.out()} x="12.25" y="8.5" width="1.5" height="10"/>
		<rect fill=${global::main.lower.text.out()} x="35.25" y="8.5" width="1.5" height="10"/>
		<rect fill=${color.out()} x="58.25" y="8.5" width="1.5" height="10"/>
	</svg>`
}

fn envcp_bypass_200(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 92 46">
		<path fill="magenta" d="M0,0V3H1V0Zm91,43v3h1v-3z"/>
		<rect fill=${global::tcp_name_area.out()} x="1" y="1" width="90" height="44"/>
		
		<circle fill=${color.out()} cx="16" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="16" cy="24" r="8"/>
		
		<circle fill=${global::main.lower.text.out()} cx="46" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="46" cy="24" r="8"/>
		
		<circle fill=${color.out()} cx="76" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="76" cy="24" r="8"/>
		
		<path fill=${global::tcp_name_area.out()} d="m12,11v14h8V11Zm30,0v14h8V11Zm30,0v14h8V11Z"/>
		
		<rect fill=${color.out()} x="15" y="11" width="2" height="14"/>
		<rect fill=${global::main.lower.text.out()} x="45" y="11" width="2" height="14"/>
		<rect fill=${color.out()} x="75" y="11" width="2" height="14"/>
	</svg>`
}

fn envcp_hide(scale) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 20" width="${108 * scale}" height="${20 * scale}">
		<path fill=${global::main.lower.text.fade(0.375).out()} d="M0,0V20H26C36,20 36,10 36,10 36,10 36,0 26,0Zm1,1h25c9,0 9,9 9,9 0,0 0,9 -9,9H1ZM9,4V6L8,6.5 6.5,5 5,6.5 6.5,8 6,9H4v2H6L6.5,12 5,13.5 6.5,15 8,13.5 9,14v2h2V14L12,13.5 13.5,15 15,13.5 13.5,12 14,11h2V9H14L13.5,8 15,6.5 13.5,5 12,6.5 11,6V4Zm17,0a6,6 0 0 0 -6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0 -6,-6zM10,8a2,2 0 0 1 2,2 2,2 0 0 1 -2,2 2,2 0 0 1 -2,-2 2,2 0 0 1 2,-2zm13,0h6l-3,5z"/>
		
		<path fill=${global::main.lower.text.fade(0.125).out()} d="M36,0V20H62C72,20 72,10 72,10 72,10 72,0 62,0Z"/>
		<path fill=${global::main.lower.text.fade(0.5).out()} d="M36,0V20H62C72,20 72,10 72,10 72,10 72,0 62,0Zm1,1h25c9,0 9,9 9,9 0,0 0,9 -9,9H37Zm8,3V6L44,6.5 42.5,5 41,6.5 42.5,8 42,9h-2v2h2l0.5,1 -1.5,1.5 1.5,1.5 1.5,-1.5 1,0.5v2h2V14L48,13.5 49.5,15 51,13.5 49.5,12 50,11h2V9H50L49.5,8 51,6.5 49.5,5 48,6.5 47,6V4Zm17,0a6,6 0 0 0 -6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0 -6,-6zM46,8a2,2 0 0 1 2,2 2,2 0 0 1 -2,2 2,2 0 0 1 -2,-2 2,2 0 0 1 2,-2zm13,0h6l-3,5z"/>
		
		<path fill=${global::main.lower.text.fade(0.25).out()} d="m72,20h26c10,0 10,-10 10,-10 0,0 0,-10 -10,-10H72Z"/>
		<path fill=${global::main.lower.text.fade(0.625).out()} d="m72,0v20h26c10,0 10,-10 10,-10 0,0 0,-10 -10,-10zm1,1h25c9,0 9,9 9,9 0,0 0,9 -9,9H73Zm8,3V6L80,6.5 78.5,5 77,6.5 78.5,8 78,9h-2v2h2l0.5,1 -1.5,1.5 1.5,1.5 1.5,-1.5 1,0.5v2h2V14L84,13.5 85.5,15 87,13.5 85.5,12 86,11h2V9H86L85.5,8 87,6.5 85.5,5 84,6.5 83,6V4Zm17,0a6,6 0 0 0 -6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0 -6,-6zM82,8a2,2 0 0 1 2,2 2,2 0 0 1 -2,2 2,2 0 0 1 -2,-2 2,2 0 0 1 2,-2zm13,0h6l-3,5z"/>
	</svg>`
}

fn knob_small(vol) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 26">
		<path fill="yellow" d="M0 0L0 1L0 2L1 2L1 1L3 1L3 0L0 0zM24 22L24 25L23 25L23 26L24 26L25 26L25 22L24 22z"/>
		<path fill="magenta" d="M3 0L3 1L4 1L4 0L3 0zM0 2L0 3L1 3L1 2L0 2zM24 21L24 22L25 22L25 21L24 21zM22 25L22 26L23 26L23 25L22 25z"/>
		<path fill=${global::tcp_name_area.out()} d="M1 1L1 23L13 23A11 11 0 0 0 24 12A11 11 0 0 0 13 1L1 1z"/>
		<circle cx="13" cy="12" fill=${if vol { `${global::main.lower.text.fade(global::main.dim).out()} r="10"` }
			else { `${global::main.upper.like.out()} stroke=${lab::mix(global::main.upper.like, global::main.upper.text, global::main.border).out()} r="9.5"` }}/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M3 12L3 15A10 10 0 0 0 13 25A10 10 0 0 0 23 15L23 12A10 10 0 0 1 13 22A10 10 0 0 1 3 12z"/>
	</svg>`
}

fn knob_small_150(vol) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 37">
		<path fill="yellow" d="M0 0L0 1L0 2L1 2L1 1L4 1L4 0L0 0zM35 32L35 36L34 36L34 37L35 37L36 37L36 32L35 32z"/>
		<path fill="magenta" d="M4 0L4 1L5 1L5 0L4 0zM0 2L0 3L1 3L1 2L0 2zM35 31L35 32L36 32L36 31L35 31zM33 36L33 37L34 37L34 36L33 36z"/>
		<path fill=${global::tcp_name_area.out()} d="M1 1L1 33L19 33A16 16 0 0 0 35 17A16 16 0 0 0 19 1L1 1z"/>
		<circle cx="19" cy="17" fill=${if vol { `${global::main.lower.text.fade(global::main.dim).out()} r="15"` }
			else { `${global::main.upper.like.out()} stroke=${lab::mix(global::main.upper.like, global::main.upper.text, global::main.border).out()} r="14.5"` }}/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M4 17L4 21A15 15 0 0 0 19 36A15 15 0 0 0 34 21L34 17A15 15 0 0 1 19 32A15 15 0 0 1 4 17z"/>
	</svg>`
}

fn knob_small_200(vol) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 50">
		<path fill="yellow" d="M0 0L0 1L0 3L1 3L1 1L5 1L5 0L0 0zM47 43L47 49L45 49L45 50L47 50L48 50L48 43L47 43z"/>
		<path fill="magenta" d="M5 0L5 1L7 1L7 0L5 0zM0 3L0 5L1 5L1 3L0 3zM47 41L47 43L48 43L48 41L47 41zM43 49L43 50L45 50L45 49L43 49z"/>
		<path fill=${global::tcp_name_area.out()} d="M1 1L1 45L25 45A22 22 0 0 0 47 23A22 22 0 0 0 25 1L1 1z"/>
		<circle cx="25" cy="23" fill=${if vol { `${global::main.lower.text.fade(global::main.dim).out()} r="20"` }
			else { `${global::main.upper.like.out()} stroke=${lab::mix(global::main.upper.like, global::main.upper.text, global::main.border).out()} stroke-width="2" r="19"` }}/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M5 23L5 29A20 20 0 0 0 25 49A20 20 0 0 0 45 29L45 23A20 20 0 0 1 25 43A20 20 0 0 1 5 23z"/>
	</svg>`
}

fn tcp_bg(color, x, width) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 12">
		${if x == 1 { `<rect fill=${global::main.lower.like.out()} width="48" height="12"/>` }}
		<path fill="magenta" d="M0 0L0 1L1 1L1 0L0 0zM47 10L47 11L15 11L15 12L48 12L48 11L48 10L47 10z"/>
		<rect fill=${global::main.lower.like.shadow(1)} x="${x}" y="10" width="${width}" height="1"/>
		<rect fill=${color.out()} x="1" y="1" width="46" height="9"/>
	</svg>`
}

export const tcp_idxbg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 23 6">
	<path fill="yellow" d="M0,0V1H1V0Zm19,5v1h4V5Z"/>
	<path fill="magenta" d="M0,1V2H1V1Zm22,2v2h1V3ZM2,5V6H19V5Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V5H2V1Zm17,0v3h4V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,1V4H18V1Z"/>
</svg>`;

export const tcp_idxbg_sel = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 23 6">
	<path fill="yellow" d="M0,0V1H1V0Zm19,5v1h4V5Z"/>
	<path fill="magenta" d="M0,1V2H1V1Zm22,2v2h1V3ZM2,5V6H19V5Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V5H2V1Zm17,0v3h1V1Zm3,0v3h1V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,1V4H18V1Zm17,0v3h2V1Z"/>
</svg>`;

export const tcp_idxbg_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 7">
	<path fill="yellow" d="M0,0V1H1V0Zm28,6v1h6V6Z"/>
	<path fill="magenta" d="M0,1V2H1V1Zm33,4v1h1V5ZM2,6V7H28V6Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V6H2V1Zm27,0v4h5V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,1V5H28V1Z"/>
</svg>`;

export const tcp_idxbg_sel_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 7">
	<path fill="yellow" d="M0,0V1H1V0Zm28,6v1h6V6Z"/>
	<path fill="magenta" d="M0,1V2H1V1Zm33,4v1h1V5ZM2,6V7H28V6Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V6H2V1Zm27,0v4h1V1Zm4,0v4h1V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,1V5H28V1Zm27,0v4h3V1Z"/>
</svg>`;

export const tcp_idxbg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44 10">
	<path fill="yellow" d="M0,0V1H1V0Zm37,9v1h7V9Z"/>
	<path fill="magenta" d="M0,1V3H1V1Zm43,4v4h1V5ZM3,9v1H37V9Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V9H3V1Zm34,0v6h8V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M3,1V7H35V1Z"/>
</svg>`;

export const tcp_idxbg_sel_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44 10">
	<path fill="yellow" d="M0,0V1H1V0Zm37,9v1h7V9Z"/>
	<path fill="magenta" d="M0,1V3H1V1Zm43,4v4h1V5ZM3,9v1H37V9Z"/>
	<path fill=${main.lower.like.shadow(1)} d="M1,1V9H3V1Zm34,0v6h2V1Zm6,0v6h2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M3,1V7H35V1Zm34,0v6h4V1Z"/>
</svg>`;

fn tcp_knob_small(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 25">
		<path fill="yellow" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM23 22L23 24L22 24L22 25L23 25L24 25L24 22L23 22z"/>
		<path fill="magenta" d="M2 0L2 1L3 1L3 0L2 0zM0 2L0 3L1 3L1 2L0 2zM23 21L23 22L24 22L24 21L23 21zM21 24L21 25L22 25L22 24L21 24z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="12" cy="12" r="9"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m3,12v3a9,9 0 0 0 9,9 9,9 0 0 0 9,-9v-3a9,9 0 0 1 -9,9 9,9 0 0 1 -9,-9z"/>
	</svg>`
}

fn tcp_knob_small_150(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 37">
		<path fill="yellow" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM33 32L33 36L32 36L32 37L33 37L34 37L34 32L33 32z"/>
		<path fill="magenta" d="M2 0L2 1L3 1L3 0L2 0zM0 2L0 3L1 3L1 2L0 2zM33 31L33 32L34 32L34 31L33 31zM31 36L31 37L32 37L32 36L31 36z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="17" cy="17" r="14"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m3,17v5A14,14 0 0 0 17,36 14,14 0 0 0 31,22V17A14,14 0 0 1 17,31 14,14 0 0 1 3,17Z"/>
	</svg>`
}

fn tcp_knob_small_200(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 46 48">
		<path fill="yellow" d="M0 0L0 1L0 3L1 3L1 1L3 1L3 0L0 0zM45 43L45 47L43 47L43 48L45 48L46 48L46 43L45 43z"/>
		<path fill="magenta" d="M3 0L3 1L5 1L5 0L3 0zM0 3L0 5L1 5L1 3L0 3zM45 41L45 43L46 43L46 41L45 41zM41 47L41 48L43 48L43 47L41 47z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="23" cy="23" r="18"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m5,23v6A18,18 0 0 0 23,47 18,18 0 0 0 41,29V23A18,18 0 0 1 23,41 18,18 0 0 1 5,23Z"/>
	</svg>`
}

export const tcp_namebg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5 24">
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="4" height="22"/>
	<path fill="yellow" d="M0 0L0 2L1 2L1 0L0 0zM4 22L4 24L5 24L5 22L4 22z"/>
	<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM0 2L0 3L1 3L1 2L0 2zM4 21L4 22L5 22L5 21L4 21zM3 23L3 24L4 24L4 23L3 23z"/>
</svg>`;

export const tcp_namebg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 5 24">
	<path fill="yellow" d="M0 0L0 3L1 3L1 0L0 0zM4 21L4 24L5 24L5 21L4 21z"/>
	<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM0 3L0 4L1 4L1 3L0 3zM4 20L4 21L5 21L5 20L4 20zM3 23L3 24L4 24L4 23L3 23z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="3" height="22"/>
</svg>`;

export const tcp_volbg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 13 24">
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="11" height="22"/>
	<path fill="yellow" d="M0 0L0 2L1 2L1 0L0 0zM12 22L12 24L13 24L13 22L12 22z"/>
	<path fill="magenta" d="M1 0L1 1L6 1L6 0L1 0zM0 2L0 3L1 3L1 2L0 2zM12 21L12 22L13 22L13 21L12 21zM7 23L7 24L12 24L12 23L7 23z"/>
	<rect fill=${tcp_name_area.shadow(2)} x="6" y="11" width="1" height="2"/>
</svg>`;

export const tcp_volbg_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 34">
	<path fill="yellow" d="M0 0L0 3L1 3L1 0L0 0zM18 31L18 34L19 34L19 31L18 31z"/>
	<path fill="magenta" d="M1 0L1 1L9 1L9 0L1 0zM0 3L0 4L1 4L1 3L0 3zM18 30L18 31L19 31L19 30L18 30zM10 33L10 34L18 34L18 33L10 33z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="2" width="17" height="30"/>
	<rect fill=${tcp_name_area.shadow(2)} x="9" y="16" width="2" height="2"/>
</svg>`;

export const tcp_volbg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 46">
	<path fill="yellow" d="M0 0L0 3L1 3L1 0L0 0zM23 43L23 46L24 46L24 43L23 43z"/>
	<path fill="magenta" d="M1 0L1 1L11 1L11 0L1 0zM0 3L0 5L1 5L1 3L0 3zM23 41L23 43L24 43L24 41L23 41zM13 45L13 46L23 46L23 45L13 45z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="22" height="44"/>
	<rect fill=${tcp_name_area.shadow(2)} x="11" y="21" width="2" height="4"/>
</svg>`;

export const tcp_volthumb = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 23 29">
	<path fill="magenta" d="M0 28L0 29L1 29L1 28L0 28zM22 28L22 29L23 29L23 28L22 28z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M7 5A4 4 0 0 0 3 9L3 18A4 4 0 0 0 7 22L11 22L11 18L11 9L11 5L7 5zM12 5L12 9L12 18L12 22L16 22A4 4 0 0 0 20 18L20 9A4 4 0 0 0 16 5L12 5z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m3,18v6a4,4 0 0 0 4,4h4V24 22H7A4,4 0 0 1 3,18Zm17,0a4,4 0 0 1 -4,4h-4v2 4h4a4,4 0 0 0 4,-4z"/>
</svg>`;

export const tcp_volthumb_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 33 42">
	<path fill="magenta" d="M0 41L0 42L1 42L1 41L0 41zM32 41L32 42L33 42L33 41L32 41z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M10 7A6 6 0 0 0 4 13L4 26A6 6 0 0 0 10 32L16 32L16 26L16 13L16 7L10 7zM17 7L17 13L17 26L17 32L23 32A6 6 0 0 0 29 26L29 13A6 6 0 0 0 23 7L17 7z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m4,26v9a6,6 0 0 0 6,6h6V35 32H10A6,6 0 0 1 4,26Zm25,0a6,6 0 0 1 -6,6h-6v3 6h6a6,6 0 0 0 6,-6z"/>
</svg>`;

export const tcp_volthumb_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44 56">
	<path fill="magenta" d="M0 55L0 56L1 56L1 55L0 55zM43 55L43 56L44 56L44 55L43 55z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M13 9A8 8 0 0 0 5 17L5 35A8 8 0 0 0 13 43L21 43L21 17L21 9L13 9zM23 9L23 17L23 43L31 43A8 8 0 0 0 39 35L39 17A8 8 0 0 0 31 9L23 9z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m5,35v12a8,8 0 0 0 8,8h8V43H13A8,8 0 0 1 5,35Zm34,0a8,8 0 0 1 -8,8h-8v12h8a8,8 0 0 0 8,-8z"/>
</svg>`;

fn mcp_knob_small(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 22 24">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM21 21L21 24L22 24L22 21L21 21z"/>
		<path fill="magenta" d="M1 0L1 1L3 1L3 0L1 0zM1 1L0 1L0 3L1 3L1 1zM21 20L21 21L22 21L22 20L21 20zM20 23L20 24L21 24L21 23L20 23z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="11" cy="11" r="9"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M2,11.5V14 14.5H2A9,9 0 0 0 11,23 9,9 0 0 0 20,14.5h0V14 11.5h-0A9,9 0 0 1 11,20 9,9 0 0 1 2,11.5Z"/>
	</svg>`
}

fn mcp_knob_small_150(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 35">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM31 31L31 35L32 35L32 31L31 31z"/>
		<path fill="magenta" d="M1 0L1 1L3 1L3 0L1 0zM1 1L0 1L0 3L1 3L1 1zM31 30L31 31L32 31L32 30L31 30zM30 34L30 35L31 35L31 34L30 34z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="16" cy="16" r="14"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m2,16v4A14,14 0 0 0 16,34 14,14 0 0 0 30,20V16A14,14 0 0 1 16,30 14,14 0 0 1 2,16Z"/>
	</svg>`
}

fn mcp_knob_small_200(pan) {
	const color = if pan { global::main.lower.text } else { global::main[global::accent].like };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 46">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM41 41L41 46L42 46L42 41L41 41z"/>
		<path fill="magenta" d="M1 0L1 1L3 1L3 0L1 0zM1 1L0 1L0 3L1 3L1 1zM41 40L41 41L42 41L42 40L41 40zM40 45L40 46L41 46L41 45L40 45z"/>
		<circle fill=${color.fade(global::main.dim).out()} cx="21" cy="21" r="19"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m2,21v5A19,19 0 0 0 21,45 19,19 0 0 0 40,26V21A19,19 0 0 1 21,40 19,19 0 0 1 2,21Z"/>
	</svg>`
}

fn mcp_bg(raise) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 6 38">
		<path fill="magenta" d="M0,0V1 34H1V1H2V0Zm5,37v1h1v-1z"/>
		<path fill=${global::main.raise("lower", "like", raise).out()} d="M1,1V33H5V1Z"/>
		<path fill=${global::tcp_name_area.shadow(1.5)} d="m1,33v1 3h1v-3h3v-1z"/>
		<path fill=${global::main.raise("lower", "like", 0.05 + raise).out()} d="m2,34v3h3v-3z"/>
	</svg>`
}

fn mcp_bg_150(raise) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 6 54">
		<path fill="magenta" d="M0,0V1 50H1V1H2V0Zm5,53v1h1v-1z"/>
		<path fill=${global::main.raise("lower", "like", raise).out()} d="M1,1V49H5V1Z"/>
		<path fill=${global::tcp_name_area.shadow(1.5)} d="m1,49v1 3h1v-3h3v-1z"/>
		<path fill=${global::main.raise("lower", "like", 0.05 + raise).out()} d="m2,50v3h3v-3z"/>
	</svg>`
}

fn mcp_bg_200(raise) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 6 70">
		<path fill="magenta" d="M0,0V1 66H1V1H2V0Zm5,69v1h1v-1z"/>
		<path fill=${global::main.raise("lower", "like", raise).out()} d="M1,1V65H5V1Z"/>
		<path fill=${global::tcp_name_area.shadow(1.5)} d="m1,65v1 3h1v-3h3v-1z"/>
		<path fill=${global::main.raise("lower", "like", 0.05 + raise).out()} d="m2,66v3h3v-3z"/>
	</svg>`
}

fn mcp_extmixbg(raise) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 85 4">
		<rect fill=${global::main.raise("lower", "like", raise).out()} width="85" height="4"/>
		<path fill="yellow" d="M0,0V1H2V0Zm84,3v1h1V3Z"/>
		<path fill="magenta" d="M2,0V1H25V0Zm82,2v1h1V2Zm0,1H61v1h23z"/>
		<path fill=${global::tcp_name_area.shadow(1.5)} d="M1,1V3H2V1Z"/>
		<path fill=${global::main.lower.text.fade(global::main.border).out()} d="M25,2V3H61V2Z"/>
	</svg>`
}

export const mcp_fxlist_bg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 84 4">
	<path fill="magenta" d="M0,0V1H24V0ZM83,2V3H60V4H84V3 2Z"/>
	<path fill=${main.lower.text.fade(main.border).out()} d="M24,2V3H60V2Z"/>
</svg>`;

export const mcp_fxlist_byp = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 53">
	<path fill="magenta" d="M0,0V1 2H1V1H3V0Zm37,51v1h-1v1h2v-1 -1z"/>
	<path fill=${tcp_name_area.fade(2.0 / 3).out()} d="M2,2V17H37V2ZM2,35V52H37V35Z"/>
	<path fill=${main.raise("lower", "like", 0.1).out()} d="M2,19V34H37V19Z"/>
</svg>`;

export const mcp_fxlist_empty = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 53">
	<path fill="magenta" d="M0,0V1 2H1V1H3V0Zm37,51v1h-1v1h2v-1 -1z"/>
	<path fill=${tcp_name_area.fade(1.0 / 3).out()} d="M3,3V16H36V3ZM3,35V50H36V35Z"/>
	<path fill=${main.raise("lower", "like", 0.1).out()} d="M3,19V32H36V19Z"/>
</svg>`;

export const mcp_fxlist_norm = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 53">
	<path fill="magenta" d="M0,0V1 2H1V1H2V0Zm37,51v1h-1v1h2v-1 -1z"/>
	<path fill=${tcp_name_area.out()} d="M2,2V17H37V2ZM2,35V52H37V35Z"/>
	<path fill=${main.raise("lower", "like", 0.1).out()} d="M2,19V34H37V19Z"/>
</svg>`;

fn mcp_fxlist_200(alpha) {
	const H = if alpha == 2 { 5 } else { 3 };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 74 104">
		<path fill="magenta" d="M0,0V1 3H1V1H${H}V0Zm73,101v2h-2v1h2 1v-3z"/>
		<path fill=${global::tcp_name_area.fade(alpha / 3.0).out()} d="M3,3V33H73V3Zm0,64v34H73V67Z"/>
		<path fill=${global::main.raise("lower", "like", 0.1).out()} d="M3,35V65H73V35Z"/>
	</svg>`
}

export const mcp_idxbg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 6 46">
	<path fill="yellow" d="M0,0V5H1V0Zm5,45v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H2V0ZM0,5V25H1V5Zm5,39v1h1v-1zm0,1H4v1h1z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V45H5V25H2V5H4 5V4H4 2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,5V25H5V5Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V4H5V1Z"/>
</svg>`;

export const mcp_idxbg_sel = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 6 46">
	<path fill="yellow" d="M0,0V5H1V0Zm5,45v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H2V0ZM0,5V25H1V5Zm5,39v1h1v-1zm0,1H4v1h1z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V45H5V25H2V5H4 5V4H4 2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,2V4H5V2ZM2,5V25H5V5Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V2H5V1Z"/>
</svg>`;

export const mcp_idxbg_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 67">
	<path fill="yellow" d="M0,0V6H1V0Zm7,66v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H2V0ZM0,6V36H1V6Zm7,59v1h1v-1zm0,1H6v1h1z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V36 66H7V36H2V6H7V5H2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,6V36H7V6Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V5H7V1Z"/>
</svg>`;

export const mcp_idxbg_sel_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 67">
	<path fill="yellow" d="M0,0V6H1V0Zm7,66v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H2V0ZM0,6V36H1V6Zm7,59v1h1v-1zm0,1H6v1h1z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V36 66H7V36H2V6H7V5H2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,2V5H7V2ZM2,6V36H7V6Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V2H7V1Z"/>
</svg>`;

export const mcp_idxbg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 90">
	<path fill="yellow" d="M0,0V9H1V0Zm9,89v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H3V0ZM0,9V49H1V9Zm9,78v2h1v-2zm0,2H7v1h2z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V89H9V49H2V9H9V7H2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,9V49H9V9Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V7H9V1Z"/>
</svg>`;

export const mcp_idxbg_sel_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 10 90">
	<path fill="yellow" d="M0,0V9H1V0Zm9,89v1h1v-1z"/>
	<path fill="magenta" d="M1,0V1H3V0ZM0,9V49H1V9Zm9,78v2h1v-2zm0,2H7v1h2z"/>
	<path fill=${tcp_name_area.shadow(1.5)} d="M1,1V89H9V49H2V9H9V7H2V1Z"/>
	<path fill=${main.lower.text.fade(main.dim).out()} d="M2,3V7H9V3ZM2,9V49H9V9Z"/>
	<path fill=${tcp_name_area.out()} d="M2,1V3H9V1Z"/>
</svg>`;

export const mcp_master_volbg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 129 52">
	<rect fill=${main.lower.like.out()} width="129" height="52"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="127" height="50"/>
	<path fill="yellow" d="M0 0L0 1L70 1L70 0L0 0zM91 51L91 52L129 52L129 51L91 51z"/>
	<path fill="magenta" d="M70 0L70 1L71 1L71 0L70 0zM0 1L0 14L1 14L1 1L0 1zM128 23L128 51L129 51L129 23L128 23zM80 51L80 52L91 52L91 51L80 51z"/>
	<rect fill=${tcp_name_area.shadow(2)} x="79.75" y="14" width="1.5" height="24"/>
</svg>`;

export const mcp_master_volbg_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 193 77">
	<rect fill=${main.lower.like.out()} width="193" height="77"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="191" height="75"/>
	<path fill="yellow" d="M0 0L0 1L105 1L105 0L0 0zM137 76L137 77L193 77L193 76L137 76z"/>
	<path fill="magenta" d="M105 0L105 1L106 1L106 0L105 0zM0 1L0 20L1 20L1 1L0 1zM192 33L192 76L193 76L193 33L192 33zM120 76L120 77L137 77L137 76L120 76z"/>
	<rect fill=${tcp_name_area.shadow(2)} x="120" y="21" width="2" height="35"/>
</svg>`;

export const mcp_master_volbg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 256 102">
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="253" height="100"/>
	<path fill="yellow" d="M0 0L0 1L139 1L139 0L0 0zM181 101L181 102L256 102L256 101L181 101z"/>
	<path fill="magenta" d="M139 0L139 1L141 1L141 0L139 0zM0 1L0 27L1 27L1 1L0 1zM255 45L255 101L256 101L256 45L255 45zM159 101L159 102L181 102L181 101L159 101z"/>
	<rect fill=${tcp_name_area.shadow(2)} x="159" y="28" width="2" height="46"/>
</svg>`;

export const mcp_volbg = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 88 55">
	<path fill="yellow" d="M0 0L0 1L29 1L29 0L0 0zM50 54L50 55L88 55L88 54L50 54z"/>
	<path fill="magenta" d="M29 0L29 1L30 1L30 0L29 0zM0 1L0 16L1 16L1 1L0 1zM87 26L87 54L88 54L88 26L87 26zM39 54L39 55L50 55L50 54L39 54z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="86" height="53"/>
	<rect fill=${tcp_name_area.shadow(1.5)} x="1" y="1" width="1" height="53"/>
	<rect fill=${tcp_name_area.shadow(2)} x="38.75" y="14" width="1.5" height="27"/>
</svg>`;

export const mcp_volbg_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 131 56">
	<path fill="yellow" d="M0 0L0 1L42 1L42 0L0 0zM74 55L74 56L131 56L131 55L74 55z"/>
	<path fill="magenta" d="M42 0L42 1L43 1L43 0L42 0zM0 1L0 22L1 22L1 1L0 1zM130 27L130 55L131 55L131 27L130 27zM52 55L52 56L74 56L74 55L52 55z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="129" height="54"/>
	<rect fill=${tcp_name_area.shadow(1.5)} x="1" y="1" width="1" height="54"/>
	<rect fill=${tcp_name_area.shadow(2)} x="57" y="21" width="2" height="14"/>
</svg>`;

export const mcp_volbg_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 174 53">
	<path fill="yellow" d="M0 0L0 1L55 1L55 0L0 0zM97 52L97 53L174 53L174 52L97 52z"/>
	<path fill="magenta" d="M55 0L55 1L56 1L56 0L55 0zM0 1L0 23L1 23L1 1L0 1zM173 24L173 52L174 52L174 24L173 24zM65 52L65 53L97 53L97 52L65 52z"/>
	<rect fill=${tcp_name_area.out()} x="1" y="1" width="172" height="51"/>
	<rect fill=${tcp_name_area.shadow(1.5)} x="1" y="1" width="1" height="51"/>
	<rect fill=${tcp_name_area.shadow(2)} x="74.5" y="20.5" width="3" height="14" rx="1.5" ry="1.5"/>
</svg>`;
