/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main     = main;
const accent   = accent;
const lower_bg = lower_bg;

private fn dropdownBg(v, i) {
	const sizes = [[30, 22], [44, 32], [58, 42]];
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${sizes[i][v]} ${sizes[i][abs(v - 1)]}">
		<path fill="magenta" d="M0,0${[
			[`V1H4V0Zm10,21v1h20v`, `H1V4H0Zm21,10h1v20h`],
			[`V1H5V0Zm15,31v1h29v`, `H1V5H0Zm31,15h1v29h`],
			[`V1H7V0Zm19,41v1h39v`, `H1V7H0Zm41,19h1v39h`],
		][i][v]}-1z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<path fill=${global::main.lower.like.shadow(1)} d="${[
				`M4,1A3,3 0 0 0 1,4v14a3,3 0 0 0 3,3H19A10,10 0 0 0 29,11 10,10 0 0 0 19,1Zm15,2a8,8 0 0 1 8,8 8,8 0 0 1-8,8 8,8 0 0 1-8,-8 8,8 0 0 1 8,-8z`,
				`M4 1A3 3 0 0 0 1 4L1 19A10 10 0 0 0 11 29A10 10 0 0 0 21 19L21 4A3 3 0 0 0 18 1L4 1zM11 11A8 8 0 0 1 19 19A8 8 0 0 1 11 27A8 8 0 0 1 3 19A8 8 0 0 1 11 11z`,
			][v]}" transform="scale(${[1, 1.5, 2][i]})"/>
		</g>
	</svg>`
}

private fn envcp_arm(on, i) {
	const factor = i / 2.0 + 1;
	const colors = switchable("lower", on == 1);
	const not    = abs(on - 1);
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${on} ${on} ${60 * factor + 2 * not} ${20 * factor + (4 + i) * not}">
		<path fill="magenta" d="M0,0V1H1V0Zm${[`61,21v3h1v-3`, `91,31v4h1v-4`, `121,41v5h1v-5`][i]}z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::lower_bg.fade(0.75).out()} d="M 11,1 A 10,10 0 0 0 1,11 10,10 0 0 0 11,21 10,10 0 0 0 21,11 10,10 0 0 0 11,1 Z M 21,11 A 10,10 0 0 0 31,21 10,10 0 0 0 41,11 10,10 0 0 0 31,1 10,10 0 0 0 21,11 Z m 20,0 A 10,10 0 0 0 51,21 10,10 0 0 0 61,11 10,10 0 0 0 51,1 10,10 0 0 0 41,11 Z"/>
				<circle fill=${colors[0].out()} cx="11" cy="11" r="10"/>
				<circle fill=${colors[1].out()} cx="31" cy="11" r="10"/>
				<circle fill=${colors[2].out()} cx="51" cy="11" r="10"/>
				
				${if on == 0 { // xml
					`<path fill=${global::main.lower.like.shadow(0.5)} d="m1,11v2A10,10 0 0 0 11,23 10,10 0 0 0 21,13V11A10,10 0 0 1 11,21 10,10 0 0 1 1,11Z"/>
					 <path fill=${global::main.lower.like.shadow(0.75)} d="m21,11v2A10,10 0 0 0 31,23 10,10 0 0 0 41,13V11A10,10 0 0 1 31,21 10,10 0 0 1 21,11Z"/>
					 <path fill=${global::main.lower.like.shadow(1)} d="m41,11v2A10,10 0 0 0 51,23 10,10 0 0 0 61,13V11A10,10 0 0 1 51,21 10,10 0 0 1 41,11Z"/>`
				}}
				
				<path fill=${colors[3].out()} d="m11,5a6,6 0 0 0-6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6zm20,0a6,6 0 0 0-6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6zm20,0a6,6 0 0 0-6,6 6,6 0 0 0 6,6 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6zM11,7a4,4 0 0 1 4,4 4,4 0 0 1-4,4 4,4 0 0 1-4,-4 4,4 0 0 1 4,-4zm20,0a4,4 0 0 1 4,4 4,4 0 0 1-4,4 4,4 0 0 1-4,-4 4,4 0 0 1 4,-4zm20,0a4,4 0 0 1 4,4 4,4 0 0 1-4,4 4,4 0 0 1-4,-4 4,4 0 0 1 4,-4z"/>
			</g>
		</g>
	</svg>`
}

private fn envcp_bypass(on, scale) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 20" width="${42 * scale}" height="${20 * scale}">
		<path fill=${global::lower_bg.fade(0.5).out()} d="M6.5,4A6.5,6.5 0 0 0-4.463e-8,10.5 6.5,6.5 0 0 0 6.5,17 6.5,6.5 0 0 0 13,10.5 6.5,6.5 0 0 0 6.5,4Zm14,0A6.5,6.5 0 0 0 14,10.5 6.5,6.5 0 0 0 20.5,17 6.5,6.5 0 0 0 27,10.5 6.5,6.5 0 0 0 20.5,4Zm14,0A6.5,6.5 0 0 0 28,10.5 6.5,6.5 0 0 0 34.5,17 6.5,6.5 0 0 0 41,10.5 6.5,6.5 0 0 0 34.5,4Z"/>
		<path fill=${if on { global::main.lower.text.fade(0.625).out() } else { global::main[global::accent].like.out() }} d="m6,6v4H7V6Zm14,0v4h1V6Zm14,0v4h1V6ZM5,7.3A3.5,3.5 0 0 0 3,10.5 3.5,3.5 0 0 0 6.5,14 3.5,3.5 0 0 0 10,10.5 3.5,3.5 0 0 0 8,7.3v1.2a2.5,2.5 0 0 1 1,2A2.5,2.5 0 0 1 6.5,13 2.5,2.5 0 0 1 4,10.5 2.5,2.5 0 0 1 5,8.5Zm14,0A3.5,3.5 0 0 0 17,10.5 3.5,3.5 0 0 0 20.5,14 3.5,3.5 0 0 0 24,10.5 3.5,3.5 0 0 0 22,7.3v1.2a2.5,2.5 0 0 1 1,2 2.5,2.5 0 0 1-2.5,2.5 2.5,2.5 0 0 1-2.5,-2.5 2.5,2.5 0 0 1 1,-2zm14,0A3.5,3.5 0 0 0 31,10.5 3.5,3.5 0 0 0 34.5,14 3.5,3.5 0 0 0 38,10.5 3.5,3.5 0 0 0 36,7.3v1.2a2.5,2.5 0 0 1 1,2 2.5,2.5 0 0 1-2.5,2.5 2.5,2.5 0 0 1-2.5,-2.5 2.5,2.5 0 0 1 1,-2z"/>
	</svg>`
}

private fn envcp_fader(i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`29 29`, `42 43`, `56 57`][i]}">
		<path fill="magenta" d="m0,${[`28v1h1v-1zm28`, `42v1h1v-1zm41`, `56v1h1v-1zm55`][i]},0v1h1v-1z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::main.lower.like.shadow(1)} d="M 14 4 A 10 10 0 0 0 4 14 A 10 10 0 0 0 14 24 L 14 23 A 9 9 0 0 1 5 14 A 9 9 0 0 1 14 5 L 14 4 z M 15 4 L 15 5 A 9 9 0 0 1 24 14 A 9 9 0 0 1 15 23 L 15 24 A 10 10 0 0 0 25 14 A 10 10 0 0 0 15 4 z "/>
				<path fill=${lab::mix(global::lower_bg, global::main[global::accent].like, 0.75).fade(0.75).out()} d="M 14 5 A 9 9 0 0 0 5 14 A 9 9 0 0 0 14 23 L 14 5 z M 15 5 L 15 23 A 9 9 0 0 0 24 14 A 9 9 0 0 0 15 5 z "/>
				<path fill=${global::main.lower.like.shadow(0.5)} d="M 5 14 L 5 19 A 9 9 0 0 0 14 28 L 14 23 A 9 9 0 0 1 5 14 z M 24 14 A 9 9 0 0 1 15 23 L 15 28 A 9 9 0 0 0 24 19 L 24 14 z "/>
			</g>
		</g>
	</svg>`
}

private fn envcp_faderbg(i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`36 26`, `53 38`, `70 50`][i]}">
		<path fill="yellow" d="M0,0V1 ${[`3H1V1H3V0Zm35,23v2h-2v1h3v-1-2`, `4H1V1H4V0Zm52,34v3h-3v1h4v-1-3`, `5H1V1H5V0Zm69,45v4h-4v1h5v-1-4`][i]}z"/>
		<path fill="magenta" d="M${[`3,0V1H13V0ZM0,3V4H1V3Zm35,19v1h1v-1zm-12,3v1h10`, `4,0V1H19V0ZM0,4V5H1V4Zm52,29v1h1v-1zm-18,4v1h15`, `5,0V1H25V0ZM0,5V7H1V5Zm69,38v2h1v-2zm-24,6v1h20`][i]}v-1z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<rect fill=${global::lower_bg.out()} x="1" y="1" width="34" height="24" rx="12" ry="12"/>
				<rect fill=${global::main[global::accent].area.out()} x="12" y="12" width="12" height="2" rx="1" ry="1"/>
			</g>
		</g>
	</svg>`
}

private fn envcp_hide(scale) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 114 20" width="${114 * scale}" height="${20 * scale}">
		<path fill=${global::main.lower.like.shadow(1)} d="M3,0A3,3 0 0 0 0,3v14a3,3 0 0 0 3,3H28A10,10 0 0 0 38,10 10,10 0 0 0 28,0Zm35,10v7a3,3 0 0 0 3,3H66A10,10 0 0 0 76,10 10,10 0 0 0 66,0H41a3,3 0 0 0-3,3zm38,0v7a3,3 0 0 0 3,3h25A10,10 0 0 0 114,10 10,10 0 0 0 104,0H79A3,3 0 0 0 76,3ZM28,2a8,8 0 0 1 8,8 8,8 0 0 1-8,8 8,8 0 0 1-8,-8 8,8 0 0 1 8,-8zm38,0a8,8 0 0 1 8,8 8,8 0 0 1-8,8 8,8 0 0 1-8,-8 8,8 0 0 1 8,-8zm38,0a8,8 0 0 1 8,8 8,8 0 0 1-8,8 8,8 0 0 1-8,-8 8,8 0 0 1 8,-8z"/>
		<path fill=${global::main.lower.text.fade(0.7).out()} d="M9,4V6L8,6.5 6.5,5 5,6.5 6.5,8 6,9H4v2H6L6.5,12 5,13.5 6.5,15 8,13.5 9,14v2h2V14L12,13.5 13.5,15 15,13.5 13.5,12 14,11h2V9H14L13.5,8 15,6.5 13.5,5 12,6.5 11,6V4ZM47,4V6L46,6.5 44.5,5 43,6.5 44.5,8 44,9h-2v2h2l0.5,1-1.5,1.5 1.5,1.5 1.5,-1.5 1,0.5v2h2V14L50,13.5 51.5,15 53,13.5 51.5,12 52,11h2V9H52L51.5,8 53,6.5 51.5,5 50,6.5 49,6V4ZM85,4V6L84,6.5 82.5,5 81,6.5 82.5,8 82,9h-2v2h2l0.5,1-1.5,1.5 1.5,1.5 1.5,-1.5 1,0.5v2h2V14L88,13.5 89.5,15 91,13.5 89.5,12 90,11h2V9H90L89.5,8 91,6.5 89.5,5 88,6.5 87,6V4ZM10,8a2,2 0 0 1 2,2 2,2 0 0 1-2,2 2,2 0 0 1-2,-2 2,2 0 0 1 2,-2zm38,0a2,2 0 0 1 2,2 2,2 0 0 1-2,2 2,2 0 0 1-2,-2 2,2 0 0 1 2,-2zm38,0a2,2 0 0 1 2,2 2,2 0 0 1-2,2 2,2 0 0 1-2,-2 2,2 0 0 1 2,-2z"/>
		<path fill=${global::main.lower.text.fade(0.8).out()} d="m24,7.5h8l-4,6z"/>
		<circle fill=${global::main.lower.text.fade(0.1).out()} cx="66" cy="10" r="8"/>
		<path fill=${global::main.lower.text.fade(0.9).out()} d="m62,7.5h8l-4,6z"/>
		<circle fill=${global::main.lower.text.fade(0.2).out()} cx="104" cy="10" r="8"/>
		<path fill=${global::main.lower.text.fade(1.0).out()} d="m100,7.5h8l-4,6z"/>
	</svg>`
}

const B_LEARN = `m11,5a6,6 0 0 0-6,6 6,6 0 0 0 1,3l3,-3c2,-2 4,0 2,2l-3,3a6,6 0 0 0 3,1 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6zm20,0a6,6 0 0 0-6,6 6,6 0 0 0 1,3l3,-3c2,-2 4,0 2,2l-3,3a6,6 0 0 0 3,1 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6zm20,0a6,6 0 0 0-6,6 6,6 0 0 0 1,3l3,-3c2,-2 4,0 2,2l-3,3a6,6 0 0 0 3,1 6,6 0 0 0 6,-6 6,6 0 0 0-6,-6z`;
const B_PARAMMOD = `M8.25,5A3.25,6.5 0 0 0 5,11.5H6A2.25,5.5 0 0 1 8.25,6 2.25,5.5 0 0 1 10.5,11 3.25,6.5 0 0 0 13.75,17 3.25,6.5 0 0 0 17,10.5H16A2.25,5.5 0 0 1 13.75,16 2.25,5.5 0 0 1 11.5,11 3.25,6.5 0 0 0 8.25,5Zm20,0A3.25,6.5 0 0 0 25,11.5h1A2.25,5.5 0 0 1 28.25,6 2.25,5.5 0 0 1 30.5,11 3.25,6.5 0 0 0 33.75,17 3.25,6.5 0 0 0 37,10.5H36A2.25,5.5 0 0 1 33.75,16 2.25,5.5 0 0 1 31.5,11 3.25,6.5 0 0 0 28.25,5Zm20,0A3.25,6.5 0 0 0 45,11.5h1A2.25,5.5 0 0 1 48.25,6 2.25,5.5 0 0 1 50.5,11 3.25,6.5 0 0 0 53.75,17 3.25,6.5 0 0 0 57,10.5H56A2.25,5.5 0 0 1 53.75,16 2.25,5.5 0 0 1 51.5,11 3.25,6.5 0 0 0 48.25,5Z`;

private fn transport(button, on, scale) {
	const colors = switchable("lower", on);
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 72 24" width="${72 * scale}" height="${24 * scale}">
		<rect fill=${colors[0].out()} width="20" height="20" x="2" y="2" rx="5" ry="5"/>
		<rect fill=${colors[1].out()} width="20" height="20" x="26" y="2" rx="5" ry="5"/>
		<rect fill=${colors[2].out()} width="20" height="20" x="50" y="2" rx="5" ry="5"/>
		<path fill=${colors[3].out()} d="${switch button {
			"end" => `m65,8-2,3-2,-3zm-10,0 6,4-6,4zM41,8 39,11 37,8Zm-10,0 6,4-6,4zM17,8 15,11 13,8Zm-10,0 6,4-6,4zm57,4v4h-2v-4zm-24,0v4h-2v-4zm-24,0v4h-2v-4z`,
			"home" => `m7,8 2,3 2,-3zm10,0-6,4 6,4zm14,0 2,3 2,-3zm10,0-6,4 6,4zm14,0 2,3 2,-3zm10,0-6,4 6,4zM8,12v4h2v-4zm24,0v4h2v-4zm24,0v4h2v-4z`,
			"pause" => `m8,8v8h3V8Zm5,0v8h3V8Zm19,0v8h3V8Zm5,0v8h3V8Zm19,0v8h3V8Zm5,0v8h3V8Z`,
			"play" => `m9,8v8l8,-4zm24,0v8l8,-4zm24,0v8l8,-4z`,
			"repeat" => `M6,6V8H7.5A6,6 0 0 0 6,12 6,6 0 0 0 11,18V16A4,4 0 0 1 8,12 4,4 0 0 1 10,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1-2,3.6V13h-2v3 2h2 4V16H16.5A6,6 0 0 0 18,12 6,6 0 0 0 13,6Zm17,0v2h1.5a6,6 0 0 0-1.5,4 6,6 0 0 0 5,6V16A4,4 0 0 1 32,12 4,4 0 0 1 34,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1-2,3.6V13h-2v3 2h2 4V16H40.5A6,6 0 0 0 42,12 6,6 0 0 0 37,6Zm17,0v2h1.5a6,6 0 0 0-1.5,4 6,6 0 0 0 5,6V16A4,4 0 0 1 56,12 4,4 0 0 1 58,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1-2,3.6V13h-2v3 2h2 4V16H64.5A6,6 0 0 0 66,12 6,6 0 0 0 61,6Z`,
			"stop" => `m8,8v8h8V8Zm24,0v8h8V8Zm24,0v8h8V8Z`,
		}}"/>
	</svg>`
} // xml

const BG_HORZ = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 22">
	<path fill="magenta" d="M0,0V1 2H1V1H11V0Zm23,20v1H13v1h11v-1-1z"/>
	<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="22" height="20" rx="10" ry="10"/>
	<rect fill=${main.lower.text.fade(0.25).out()} x="9" y="9" width="6" height="4" rx="2" ry="2"/>
</svg>`; // xml

const BG_HORZ_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 35 32">
	<path fill="magenta" d="M0,0V1 2H1V1H16V0Zm34,30v1H19v1h16v-1-1z"/>
	<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="33" height="30" rx="15" ry="15"/>
	<rect fill=${main.lower.text.fade(0.25).out()} x="13" y="13" width="9" height="6" rx="3" ry="3"/>
</svg>`; // xml

const BG_HORZ_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 46 42">
	<path fill="magenta" d="M0,0V1 3H1V1H21V0Zm45,39v2H25v1h21v-1-2z"/>
	<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="44" height="40" rx="20" ry="20"/>
	<rect fill=${main.lower.text.fade(0.25).out()} x="17" y="17" width="12" height="8" rx="4" ry="4"/>
</svg>`; // xml

const THUMB_HORZ = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 25">
	<path fill="magenta" d="m0,24v1h1v-1zm24,0v1h1v-1z"/>
	<path fill=${main.lower.text.fade(0.625).out()} d="m12,4a8,8 0 0 0-8,8 8,8 0 0 0 8,8zm1,0v16a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m4,12v4a8,8 0 0 0 8,8V20A8,8 0 0 1 4,12Zm17,0a8,8 0 0 1-8,8v4a8,8 0 0 0 8,-8z"/>
</svg>`; // xml

const THUMB_HORZ_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 37">
	<path fill="magenta" d="m0,36v1h1v-1zm35,0v1h1v-1z"/>
	<path fill=${main.lower.text.fade(0.625).out()} d="M17,6A12,12 0 0 0 5,18 12,12 0 0 0 17,30Zm2,0V30A12,12 0 0 0 31,18 12,12 0 0 0 19,6Z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m5,18v6A12,12 0 0 0 17,36V30A12,12 0 0 1 5,18Zm26,0A12,12 0 0 1 19,30v6A12,12 0 0 0 31,24Z"/>
</svg>`; // xml

const THUMB_HORZ_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 49">
	<path fill="magenta" d="m0,48v1h1v-1zm47,0v1h1v-1z"/>
	<path fill=${main.lower.text.fade(0.625).out()} d="M23,8A16,16 0 0 0 7,24 16,16 0 0 0 23,40Zm2,0V40A16,16 0 0 0 41,24 16,16 0 0 0 25,8Z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m7,24v8A16,16 0 0 0 23,48V40A16,16 0 0 1 7,24Zm34,0A16,16 0 0 1 25,40v8A16,16 0 0 0 41,32Z"/>
</svg>`; // xml

const SCROLLBAR = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 204 238">
	<path fill=${main.lower.like.out()} d="m0,0v35h168v65h-57v138h57 36V35 0Z"/>
	<path fill="magenta" d="m0,35v1h25v-1zm180,0v1h24v-1zm-12,2v29h1V37ZM0,89v1h13v-1zm83,0v1h2v-1zm70,0v1h14V89ZM52,91v6h1v-6zm0,73v2h1v-2zm116,45v29h1V209ZM52,231v7h1v-7z"/>
	
	<path fill=${main.lower.text.fade(1.0 / 3).out()} d="M8.5,40A5.5,5.5 0 0 0 3,45.5 5.5,5.5 0 0 0 8.5,51h150A5.5,5.5 0 0 0 164,45.5 5.5,5.5 0 0 0 158.5,40ZM83,42h2v7H83ZM8.5,43A2.5,2.5 0 0 1 11,45.5 2.5,2.5 0 0 1 8.5,48 2.5,2.5 0 0 1 6,45.5 2.5,2.5 0 0 1 8.5,43Zm150,0A2.5,2.5 0 0 1 161,45.5 2.5,2.5 0 0 1 158.5,48 2.5,2.5 0 0 1 156,45.5 2.5,2.5 0 0 1 158.5,43ZM8.5,94A5.5,5.5 0 0 0 3,99.5v130A5.5,5.5 0 0 0 8.5,235 5.5,5.5 0 0 0 14,229.5V99.5A5.5,5.5 0 0 0 8.5,94ZM5,164h7v2H5Z"/>
	<path fill=${main.lower.text.fade(2.0 / 3).out()} d="M8.5,57A5.5,5.5 0 0 0 3,62.5 5.5,5.5 0 0 0 8.5,68h150A5.5,5.5 0 0 0 164,62.5 5.5,5.5 0 0 0 158.5,57ZM83,59h2v7H83ZM8.5,60A2.5,2.5 0 0 1 11,62.5 2.5,2.5 0 0 1 8.5,65 2.5,2.5 0 0 1 6,62.5 2.5,2.5 0 0 1 8.5,60Zm150,0A2.5,2.5 0 0 1 161,62.5 2.5,2.5 0 0 1 158.5,65 2.5,2.5 0 0 1 156,62.5 2.5,2.5 0 0 1 158.5,60ZM25.5,94A5.5,5.5 0 0 0 20,99.5v130a5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5V99.5A5.5,5.5 0 0 0 25.5,94ZM22,164h7v2h-7z"/>
	<path fill=${main[accent].area.out()} d="M8.5,74A5.5,5.5 0 0 0 3,79.5 5.5,5.5 0 0 0 8.5,85h150A5.5,5.5 0 0 0 164,79.5 5.5,5.5 0 0 0 158.5,74ZM83,76h2v7H83ZM8.5,77A2.5,2.5 0 0 1 11,79.5 2.5,2.5 0 0 1 8.5,82 2.5,2.5 0 0 1 6,79.5 2.5,2.5 0 0 1 8.5,77Zm150,0A2.5,2.5 0 0 1 161,79.5 2.5,2.5 0 0 1 158.5,82 2.5,2.5 0 0 1 156,79.5 2.5,2.5 0 0 1 158.5,77ZM42.5,94A5.5,5.5 0 0 0 37,99.5v130a5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5V99.5A5.5,5.5 0 0 0 42.5,94ZM39,164h7v2h-7z"/>
	
	<path fill=${main.lower.area.shadow(1)} d="m164,105v9h2v-9zm-17,10v2h9v-2z"/>
	
	<path fill=${main.lower("lower", "like", 0.5).out()} d="m124.5,124a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5z"/>
	<path fill=${main.lower.text.fade(0.2).out()} d="m141.5,124a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5z"/>
	<path fill=${main[accent].area.out()} d="m158.5,124a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5zm0,20a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5 5.5,5.5 0 0 0 5.5,-5.5 5.5,5.5 0 0 0-5.5,-5.5z"/>
	
	<path fill=${main.lower.text.fade(0.625).out()} d="m123,205v3h-3v3h3v3h3v-3h3v-3h-3v-3zm-3,23v3h9v-3z"/>
	<path fill=${main[accent].like.out()} d="m157,205v3h-3v3h3v3h3v-3h3v-3h-3v-3zm-3,23v3h9v-3z"/>
	
	<path fill=${main.lower.text.out()} d="m124.5,127-2.5,4h5zm17,0-2.5,4h5zm-15.5,20-4,2.5 4,2.5zm17,0-4,2.5 4,2.5zm-20,20v5l4,-2.5zm17,0v5l4,-2.5zm-18,21 2.5,4 2.5,-4zm17,0 2.5,4 2.5,-4zm1,17v3h-3v3h3v3h3v-3h3v-3h-3v-3zm-3,23v3h9v-3z"/>
	<path fill=${main[accent].text.out()} d="m158.5,127-2.5,4h5zm1.5,20-4,2.5 4,2.5zm-3,20v5l4,-2.5zm-1,21 2.5,4 2.5,-4z"/>
</svg>`;

export const map = #{
	dropdownBg_h: dropdownBg(0, 0),
	dropdownBg_h_150: dropdownBg(0, 1),
	dropdownBg_h_200: dropdownBg(0, 2),
	dropdownBg_v: dropdownBg(1, 0),
	dropdownBg_v_150: dropdownBg(1, 1),
	dropdownBg_v_200: dropdownBg(1, 2),
	
	envcp_arm_off: rectangle(0, 10, 10),
	envcp_arm_off_150: rectangle(0, 10, 10),
	envcp_arm_off_200: rectangle(0, 10, 10),
	envcp_arm_off_ol: envcp_arm(0, 0),
	envcp_arm_off_ol_150: envcp_arm(0, 1),
	envcp_arm_off_ol_200: envcp_arm(0, 2),
	envcp_arm_on: envcp_arm(1, 0),
	envcp_arm_on_150: envcp_arm(1, 1),
	envcp_arm_on_200: envcp_arm(1, 2),
	
	envcp_bypass_off: envcp_bypass(false, 1),
	envcp_bypass_off_150: envcp_bypass(false, 1.5),
	envcp_bypass_off_200: envcp_bypass(false, 2),
	envcp_bypass_on: envcp_bypass(true, 1),
	envcp_bypass_on_150: envcp_bypass(true, 1.5),
	envcp_bypass_on_200: envcp_bypass(true, 2),
	
	envcp_fader: envcp_fader(0),
	envcp_fader_150: envcp_fader(1),
	envcp_fader_200: envcp_fader(2),
	envcp_faderbg: envcp_faderbg(0),
	envcp_faderbg_150: envcp_faderbg(1),
	envcp_faderbg_200: envcp_faderbg(2),
	
	envcp_hide: envcp_hide(1),
	envcp_hide_150: envcp_hide(1.5),
	envcp_hide_200: envcp_hide(2),
	
	envcp_learn: rectangle(0, 10, 10),
	envcp_learn_150: rectangle(0, 10, 10),
	envcp_learn_200: rectangle(0, 10, 10),
	envcp_learn_ol: button("lower", false, 0, 0, B_LEARN),
	envcp_learn_ol_150: button("lower", false, 0, 1, B_LEARN),
	envcp_learn_ol_200: button("lower", false, 0, 2, B_LEARN),
	envcp_learn_on: button("lower", true, 1, 0, B_LEARN),
	envcp_learn_on_150: button("lower", true, 1, 1, B_LEARN),
	envcp_learn_on_200: button("lower", true, 1, 2, B_LEARN),
	
	envcp_parammod: rectangle(0, 10, 10),
	envcp_parammod_150: rectangle(0, 10, 10),
	envcp_parammod_200: rectangle(0, 10, 10),
	envcp_parammod_ol: button("lower", false, 0, 0, B_PARAMMOD),
	envcp_parammod_ol_150: button("lower", false, 0, 1, B_PARAMMOD),
	envcp_parammod_ol_200: button("lower", false, 0, 2, B_PARAMMOD),
	envcp_parammod_on: button("lower", true, 1, 0, B_PARAMMOD),
	envcp_parammod_on_150: button("lower", true, 1, 1, B_PARAMMOD),
	envcp_parammod_on_200: button("lower", true, 1, 2, B_PARAMMOD),
	
	gen_end: transport(`end`, false, 1),
	gen_end_150: transport(`end`, false, 1.5),
	gen_end_200: transport(`end`, false, 2),
	gen_home: transport(`home`, false, 1),
	gen_home_150: transport(`home`, false, 1.5),
	gen_home_200: transport(`home`, false, 2), // xml
	
	gen_knob_bg_small: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 18 20">
		<path fill="yellow" d="M0,0V1H1V0Zm17,17v3h1v-3z"/>
		<path fill="magenta" d="M1,0V1H2V0ZM1,1H0v1h1zm16,15v1h1v-1zm-1,3v1h1v-1z"/>
		<circle fill=${main.lower.area.out()} stroke=${main.lower.text.fade(0.25).out()} cx="9" cy="9" r="7.5"/>
		<path fill=${main.lower.like.shadow(0.75)} d="m1,9v2a8,8 0 0 0 8,8 8,8 0 0 0 8,-8V9A8,8 0 0 1 9,17 8,8 0 0 1 1,9Z"/>
	</svg>`, // xml
	
	gen_knob_bg_small_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 26 29">
		<path fill="yellow" d="M0,0V1H1V0Zm25,25v4h1v-4z"/>
		<path fill="magenta" d="M1,0V1H2V0ZM1,1H0v1h1zm24,23v1h1v-1zm-1,4v1h1v-1z"/>
		<circle fill=${main.lower.area.out()} stroke=${main.lower.text.fade(0.25).out()} stroke-width="1.5" cx="13" cy="13" r="11.25"/>
		<path fill=${main.lower.like.shadow(0.75)} d="m1,13v3A12,12 0 0 0 13,28 12,12 0 0 0 25,16V13A12,12 0 0 1 13,25 12,12 0 0 1 1,13Z"/>
	</svg>`, // xml
	
	gen_knob_bg_small_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 34 38">
		<path fill="yellow" d="M0,0V1H1V0Zm33,33v5h1v-5z"/>
		<path fill="magenta" d="M1,0V1H3V0ZM1,1H0v2h1zm32,30v2h1v-2zm-2,6v1h2v-1z"/>
		<circle fill=${main.lower.area.out()} stroke=${main.lower.text.fade(0.25).out()} stroke-width="2" cx="17" cy="17" r="15"/>
		<path fill=${main.lower.like.shadow(0.75)} d="m1,17v4A16,16 0 0 0 17,37 16,16 0 0 0 33,21V17A16,16 0 0 1 17,33 16,16 0 0 1 1,17Z"/>
	</svg>`,
	
	gen_mute_off: button("red", false, 1, 0, B_MUTE),
	gen_mute_off_150: button("red", false, 1, 1, B_MUTE),
	gen_mute_off_200: button("red", false, 1, 2, B_MUTE),
	gen_mute_on: button("red", true, 1, 0, B_MUTE),
	gen_mute_on_150: button("red", true, 1, 1, B_MUTE),
	gen_mute_on_200: button("red", true, 1, 2, B_MUTE),
	gen_panbg_horz: BG_HORZ,
	gen_panbg_horz_150: BG_HORZ_150,
	gen_panbg_horz_200: BG_HORZ_200,
	gen_panthumb_horz: THUMB_HORZ,
	gen_panthumb_horz_150: THUMB_HORZ_150,
	gen_panthumb_horz_200: THUMB_HORZ_200,
	gen_pause: transport(`pause`, false, 1),
	gen_pause_150: transport(`pause`, false, 1.5),
	gen_pause_200: transport(`pause`, false, 2),
	gen_pause_on: transport(`pause`, true, 1),
	gen_pause_on_150: transport(`pause`, true, 1.5),
	gen_pause_on_200: transport(`pause`, true, 2),
	gen_play: transport(`play`, false, 1),
	gen_play_150: transport(`play`, false, 1.5),
	gen_play_200: transport(`play`, false, 2),
	gen_play_on: transport(`play`, true, 1),
	gen_play_on_150: transport(`play`, true, 1.5),
	gen_play_on_200: transport(`play`, true, 2),
	gen_repeat: transport(`repeat`, false, 1),
	gen_repeat_150: transport(`repeat`, false, 1.5),
	gen_repeat_200: transport(`repeat`, false, 2),
	gen_repeat_on: transport(`repeat`, true, 1),
	gen_repeat_on_150: transport(`repeat`, true, 1.5),
	gen_repeat_on_200: transport(`repeat`, true, 2),
	gen_solo_off: button("yellow", false, 1, 0, B_SOLO),
	gen_solo_off_150: button("yellow", false, 1, 1, B_SOLO),
	gen_solo_off_200: button("yellow", false, 1, 2, B_SOLO),
	gen_solo_on: button("yellow", true, 1, 0, B_SOLO),
	gen_solo_on_150: button("yellow", true, 1, 1, B_SOLO),
	gen_solo_on_200: button("yellow", true, 1, 2, B_SOLO),
	gen_stop: transport(`stop`, false, 1),
	gen_stop_150: transport(`stop`, false, 1.5),
	gen_stop_200: transport(`stop`, false, 2),
	gen_volbg_horz: BG_HORZ,
	gen_volbg_horz_150: BG_HORZ_150,
	gen_volbg_horz_200: BG_HORZ_200, // xml
	
	gen_volbg_vert: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 22 24">
		<path fill="magenta" d="M0,0V1 11H1V1H2V0Zm21,13v10h-1v1h1 1V13Z"/>
		<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="20" height="22" rx="10" ry="10"/>
		<rect fill=${main.lower.text.fade(0.25).out()} x="9" y="9" width="4" height="6" rx="2" ry="2"/>
	</svg>`, // xml
	
	gen_volbg_vert_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 35">
		<path fill="magenta" d="M0,0V1 16H1V1H2V0Zm31,19v15h-1v1h2V34 19Z"/>
		<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="30" height="33" rx="15" ry="15"/>
		<rect fill=${main.lower.text.fade(0.25).out()} x="13" y="13" width="6" height="9" rx="3" ry="3"/>
	</svg>`, // xml
	
	gen_volbg_vert_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 46">
		<path fill="magenta" d="M0,0V1 21H1V1H3V0Zm41,25v20h-2v1h3V45 25Z"/>
		<rect fill=${main.lower.like.shadow(0.5)} x="1" y="1" width="40" height="44" rx="20" ry="20"/>
		<rect fill=${main.lower.text.fade(0.25).out()} x="17" y="17" width="8" height="12" rx="4" ry="4"/>
	</svg>`,
	
	gen_volthumb_horz: THUMB_HORZ,
	gen_volthumb_horz_150: THUMB_HORZ_150,
	gen_volthumb_horz_200: THUMB_HORZ_200, // xml
	
	gen_volthumb_vert: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 25">
		<path fill="magenta" d="m18,0v1h1V0Zm0,24v1h1v-1z"/>
		<path fill=${main.lower.text.fade(0.625).out()} d="m1,13a8,8 0 0 0 8,8 8,8 0 0 0 8,-8zM1,12H17A8,8 0 0 0 9,4 8,8 0 0 0 1,12Z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m1,13v3a8,8 0 0 0 8,8 8,8 0 0 0 8,-8V13A8,8 0 0 1 9,21 8,8 0 0 1 1,13Z"/>
	</svg>`, // xml
	
	gen_volthumb_vert_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 36">
		<path fill="magenta" d="m27,0v1h1V0Zm0,35v1h1v-1z"/>
		<path fill=${main.lower.text.fade(0.625).out()} d="M13.5,5.5A11.5,11.5 0 0 0 2,17H25A11.5,11.5 0 0 0 13.5,5.5ZM2,19A11.5,11.5 0 0 0 13.5,30.5 11.5,11.5 0 0 0 25,19Z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m2,19v4.5A11.5,11.5 0 0 0 13.5,35 11.5,11.5 0 0 0 25,23.5V19A11.5,11.5 0 0 1 13.5,30.5 11.5,11.5 0 0 1 2,19Z"/>
	</svg>`, // xml
	
	gen_volthumb_vert_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 37 48">
		<path fill="magenta" d="m36,0v1h1V0Zm0,47v1h1v-1z"/>
		<path fill=${main.lower.text.fade(0.625).out()} d="M2,25A16,16 0 0 0 18,41 16,16 0 0 0 34,25ZM2,23H34A16,16 0 0 0 18,7 16,16 0 0 0 2,23Z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m2,25v6A16,16 0 0 0 18,47 16,16 0 0 0 34,31V25A16,16 0 0 1 18,41 16,16 0 0 1 2,25Z"/>
	</svg>`,
	
	scrollbar: SCROLLBAR,
	scrollbar_3: SCROLLBAR,
}
