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
			"auto" => `M8.5 5L5.5 14L7.5 14L8.5 12L11.5 12L12.5 14L14.5 14L11.5 5L8.5 5zM28.5 5L25.5 14L27.5 14L28.5 12L31.5 12L32.5 14L34.5 14L31.5 5L28.5 5zM48.5 5L45.5 14L47.5 14L48.5 12L51.5 12L52.5 14L54.5 14L51.5 5L48.5 5zM10 7L11 10L9 10L10 7zM30 7L31 10L29 10L30 7zM50 7L51 10L49 10L50 7z`,
			     _ => `M10 5A5 5 0 0 0 5 10A5 5 0 0 0 10 15A5 5 0 0 0 15 10A5 5 0 0 0 10 5zM30 5A5 5 0 0 0 25 10A5 5 0 0 0 30 15A5 5 0 0 0 35 10A5 5 0 0 0 30 5zM50 5A5 5 0 0 0 45 10A5 5 0 0 0 50 15A5 5 0 0 0 55 10A5 5 0 0 0 50 5zM10 7A3 3 0 0 1 13 10A3 3 0 0 1 10 13A3 3 0 0 1 7 10A3 3 0 0 1 10 7zM30 7A3 3 0 0 1 33 10A3 3 0 0 1 30 13A3 3 0 0 1 27 10A3 3 0 0 1 30 7zM50 7A3 3 0 0 1 53 10A3 3 0 0 1 50 13A3 3 0 0 1 47 10A3 3 0 0 1 50 7z`
		}}"/>
	</svg>`
}

export const arm_OL = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 68 26">
	<path fill="magenta" d="M0 0L0 2L1 2L1 1L2 1L2 0L0 0zM67 22L67 25L66 25L66 26L68 26L68 22L67 22z"/>
	<path fill=${tcp_name_area.out()} d="M12 1A11 11 0 0 0 1 12A11 11 0 0 0 12 23L23 23L23 12L23 1L12 1zM23 12A11 11 0 0 0 34 23L45 23L45 12L45 1L34 1A11 11 0 0 0 23 12zM45 12A11 11 0 0 0 56 23L67 23L67 12L67 1L56 1A11 11 0 0 0 45 12zM12 2A10 10 0 0 1 22 12A10 10 0 0 1 12 22A10 10 0 0 1 2 12A10 10 0 0 1 12 2zM34 2A10 10 0 0 1 44 12A10 10 0 0 1 34 22A10 10 0 0 1 24 12A10 10 0 0 1 34 2zM56 2A10 10 0 0 1 66 12A10 10 0 0 1 56 22A10 10 0 0 1 46 12A10 10 0 0 1 56 2z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="M2 12L2 15A10 10 0 0 0 12 25A10 10 0 0 0 22 15L22 12A10 10 0 0 1 12 22A10 10 0 0 1 2 12z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m24,12v3A10,10 0 0 0 34,25 10,10 0 0 0 44,15V12A10,10 0 0 1 34,22 10,10 0 0 1 24,12Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m47,12v3A10,10 0 0 0 57,25 10,10 0 0 0 67,15V12A10,10 0 0 1 57,22 10,10 0 0 1 47,12Z"/>
</svg>`;

export const arm_OL_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 98 37">
	<path fill="magenta" d="M0 0L0 2L1 2L1 1L2 1L2 0L0 0zM97 32L97 36L96 36L96 37L98 37L98 32L97 32z"/>
	<path fill=${tcp_name_area.out()} d="M17 1A16 16 0 0 0 1 17A16 16 0 0 0 17 33L33 33L33 17L33 1L17 1zM33 17A16 16 0 0 0 49 33L65 33L65 17L65 1L49 1A16 16 0 0 0 33 17zM65 17A16 16 0 0 0 81 33L97 33L97 17L97 1L81 1A16 16 0 0 0 65 17zM17 2A15 15 0 0 1 32 17A15 15 0 0 1 17 32A15 15 0 0 1 2 17A15 15 0 0 1 17 2zM49 2A15 15 0 0 1 64 17A15 15 0 0 1 49 32A15 15 0 0 1 34 17A15 15 0 0 1 49 2zM81 2A15 15 0 0 1 96 17A15 15 0 0 1 81 32A15 15 0 0 1 66 17A15 15 0 0 1 81 2z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="M2 17L2 21A15 15 0 0 0 17 36A15 15 0 0 0 32 21L32 17A15 15 0 0 1 17 32A15 15 0 0 1 2 17z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m34,17v4A15,15 0 0 0 49,36 15,15 0 0 0 64,21V17A15,15 0 0 1 49,32 15,15 0 0 1 34,17Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m66,17v4A15,15 0 0 0 81,36 15,15 0 0 0 96,21V17A15,15 0 0 1 81,32 15,15 0 0 1 66,17Z"/>
</svg>`;

export const arm_OL_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 134 50">
	<path fill="magenta" d="M0 0L0 1L0 3L1 3L1 1L3 1L3 0L0 0zM133 43L133 49L131 49L131 50L133 50L134 50L134 43L133 43z"/>
	<path fill=${tcp_name_area.out()} d="M23 1A22 22 0 0 0 1 23A22 22 0 0 0 23 45L45 45L45 23L45 1L23 1zM45 23A22 22 0 0 0 67 45L89 45L89 23L89 1L67 1A22 22 0 0 0 45 23zM89 23A22 22 0 0 0 111 45L133 45L133 23L133 1L111 1A22 22 0 0 0 89 23zM23 3A20 20 0 0 1 43 23A20 20 0 0 1 23 43A20 20 0 0 1 3 23A20 20 0 0 1 23 3zM67 3A20 20 0 0 1 87 23A20 20 0 0 1 67 43A20 20 0 0 1 47 23A20 20 0 0 1 67 3zM111 3A20 20 0 0 1 131 23A20 20 0 0 1 111 43A20 20 0 0 1 91 23A20 20 0 0 1 111 3z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="M3 23L3 29A20 20 0 0 0 23 49A20 20 0 0 0 43 29L43 23A20 20 0 0 1 23 43A20 20 0 0 1 3 23z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m47,23v6A20,20 0 0 0 67,49 20,20 0 0 0 87,29V23A20,20 0 0 1 67,43 20,20 0 0 1 47,23Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m91,23v6a20,20 0 0 0 20,20 20,20 0 0 0 20,-20V23A20,20 0 0 1 111,43 20,20 0 0 1 91,23Z"/>
</svg>`;

fn envcp_bypass(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47 24">
		<rect fill=${global::main.lower.like.out()} width="47" height="24"/>
		<path fill="magenta" d="M0 0L0 2L1 2L1 0L0 0zM46 22L46 24L47 24L47 22L46 22z"/>
		<rect fill=${global::tcp_name_area.out()} x="1" y="1" width="45" height="22"/>
		
		<circle fill=${color.out()} cx="8.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="8.5" cy="12.5" r="4"/>
		
		<circle fill=${global::main.lower.text.out()} cx="23.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="23.5" cy="12.5" r="4"/>
		
		<circle fill=${color.out()} cx="38.5" cy="12.5" r="5"/>
		<circle fill=${global::tcp_name_area.out()} cx="38.5" cy="12.5" r="4"/>
		
		<path fill=${global::tcp_name_area.out()} d="M6 7L8.5 13L11 7L6 7zM21 7L23.5 13L26 7L21 7zM36 7L38.5 13L41 7L36 7z"/>
		
		<rect fill=${color.out()} x="8" y="6" width="1" height="7"/>
		<rect fill=${global::main.lower.text.out()} x="23" y="6" width="1" height="7"/>
		<rect fill=${color.out()} x="38" y="6" width="1" height="7"/>
	</svg>`
}

fn envcp_bypass_150(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 71 34">
		<path fill="magenta" d="M0 0L0 2L1 2L1 0L0 0zM70 32L70 34L71 34L71 32L70 32z"/>
		<path fill=${global::tcp_name_area.out()} d="M2 1L2 33L24 33L24 1L2 1zM25 1L25 33L47 33L47 1L25 1zM48 1L48 33L70 33L70 1L48 1z"/>
		
		<circle fill=${color.out()} cx="13" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="13" cy="17.5" r="6"/>
		
		<circle fill=${global::main.lower.text.out()} cx="36" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="36" cy="17.5" r="6"/>
		
		<circle fill=${color.out()} cx="59" cy="17.5" r="7.5"/>
		<circle fill=${global::tcp_name_area.out()} cx="59" cy="17.5" r="6"/>
		
		<path fill=${global::tcp_name_area.out()} d="M8.5 8.5L13 18.5L17.5 8.5L8.5 8.5zM31.5 8.5L36 18.5L40.5 8.5L31.5 8.5zM54.5 8.5L59 18.5L63.5 8.5L54.5 8.5z"/>
		
		<rect fill=${color.out()} x="12.25" y="8.5" width="1.5" height="10"/>
		<rect fill=${global::main.lower.text.out()} x="35.25" y="8.5" width="1.5" height="10"/>
		<rect fill=${color.out()} x="58.25" y="8.5" width="1.5" height="10"/>
	</svg>`
}

fn envcp_bypass_200(off) {
	const color = if off { global::main[global::accent].like } else { global::main.lower.text.fade(global::main.dim) };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 92 46">
		<path fill="magenta" d="M0 0L0 3L1 3L1 0L0 0zM91 43L91 46L92 46L92 43L91 43z"/>
		<rect fill=${global::tcp_name_area.out()} x="1" y="1" width="90" height="44"/>
		
		<circle fill=${color.out()} cx="16" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="16" cy="24" r="8"/>
		
		<circle fill=${global::main.lower.text.out()} cx="46" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="46" cy="24" r="8"/>
		
		<circle fill=${color.out()} cx="76" cy="24" r="10"/>
		<circle fill=${global::tcp_name_area.out()} cx="76" cy="24" r="8"/>
		
		<path fill=${global::tcp_name_area.out()} d="M12 11L12 25L20 25L20 11L12 11zM42 11L42 25L50 25L50 11L42 11zM72 11L72 25L80 25L80 11L72 11z"/>
		
		<rect fill=${color.out()} x="15" y="11" width="2" height="14"/>
		<rect fill=${global::main.lower.text.out()} x="45" y="11" width="2" height="14"/>
		<rect fill=${color.out()} x="75" y="11" width="2" height="14"/>
	</svg>`
}

fn envcp_hide(scale) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 108 20" width="${108 * scale}" height="${20 * scale}">
		<path fill=${global::main.lower.text.fade(0.375).out()} d="M0 0L0 20L26 20C36 20 36 10 36 10C36 10 36 0 26 0L0 0zM1 1L26 1C35 1 35 10 35 10C35 10 35 19 26 19L1 19L1 1zM9 4L9 6L8 6.5L6.5 5L5 6.5L6.5 8L6 9L4 9L4 11L6 11L6.5 12L5 13.5L6.5 15L8 13.5L9 14L9 16L11 16L11 14L12 13.5L13.5 15L15 13.5L13.5 12L14 11L16 11L16 9L14 9L13.5 8L15 6.5L13.5 5L12 6.5L11 6L11 4L9 4zM26 4A6 6 0 0 0 20 10A6 6 0 0 0 26 16A6 6 0 0 0 32 10A6 6 0 0 0 26 4zM10 8A2 2 0 0 1 12 10A2 2 0 0 1 10 12A2 2 0 0 1 8 10A2 2 0 0 1 10 8zM23 8L29 8L26 13L23 8z"/>
		
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
		<circle cx="13" cy="12" fill=${if vol { `${lab::mix(global::main.lower.like, global::main.lower.text, global::main.dim).out()} r="10"` }
			else { `${global::main.upper.like.out()} stroke=${lab::mix(global::main.upper.like, global::main.upper.text, global::main.border).out()} r="9.5"` }}/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M3 12L3 15A10 10 0 0 0 13 25A10 10 0 0 0 23 15L23 12A10 10 0 0 1 13 22A10 10 0 0 1 3 12z"/>
	</svg>`
}

fn knob_small_150(vol) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 37">
		<path fill="yellow" d="M0 0L0 1L0 2L1 2L1 1L4 1L4 0L0 0zM35 32L35 36L34 36L34 37L35 37L36 37L36 32L35 32z"/>
		<path fill="magenta" d="M4 0L4 1L5 1L5 0L4 0zM0 2L0 3L1 3L1 2L0 2zM35 31L35 32L36 32L36 31L35 31zM33 36L33 37L34 37L34 36L33 36z"/>
		<path fill=${global::tcp_name_area.out()} d="M1 1L1 33L19 33A16 16 0 0 0 35 17A16 16 0 0 0 19 1L1 1z"/>
		<circle cx="19" cy="17" fill=${if vol { `${lab::mix(global::main.lower.like, global::main.lower.text, global::main.dim).out()} r="15"` }
			else { `${global::main.upper.like.out()} stroke=${lab::mix(global::main.upper.like, global::main.upper.text, global::main.border).out()} r="14.5"` }}/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M4 17L4 21A15 15 0 0 0 19 36A15 15 0 0 0 34 21L34 17A15 15 0 0 1 19 32A15 15 0 0 1 4 17z"/>
	</svg>`
}

fn knob_small_200(vol) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 50">
		<path fill="yellow" d="M0 0L0 1L0 3L1 3L1 1L5 1L5 0L0 0zM47 43L47 49L45 49L45 50L47 50L48 50L48 43L47 43z"/>
		<path fill="magenta" d="M5 0L5 1L7 1L7 0L5 0zM0 3L0 5L1 5L1 3L0 3zM47 41L47 43L48 43L48 41L47 41zM43 49L43 50L45 50L45 49L43 49z"/>
		<path fill=${global::tcp_name_area.out()} d="M1 1L1 45L25 45A22 22 0 0 0 47 23A22 22 0 0 0 25 1L1 1z"/>
		<circle cx="25" cy="23" fill=${if vol { `${lab::mix(global::main.lower.like, global::main.lower.text, global::main.dim).out()} r="20"` }
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
