/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main   = main;
const accent = accent;
const yellow = if accent == "yellow"  { "any" } else { "yellow" };
const pink   = if accent == "mangeta" { "any" } else { "magenta" };
const red    = if accent == "red"     { "any" } else { "red" };

private fn item(name, set, scale) {
	const color = if set == () { global::main.lower.text } else { global::main[set].like };
	const on = if set == () { 0.0 } else { 0.1 };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 42 14" width="${42 * scale}" height="${14 * scale}">
		<path fill=${color.fade(0.2 + on).out()} d="M0,1V13H13V1Z"/>
		<path fill=${color.fade(0.3 + on).out()} d="M14,1V13H27V1Z"/>
		<path fill=${color.fade(0.4 + on).out()} d="M28,1V13H41V1Z"/>
		<path fill=${color.out()} d="${switch name {
			"env" => `M5,3V6H8V3Zm14,0v3h3V3Zm14,0v3h3V3ZM9,6v3h3V6Zm14,0v3h3V6Zm14,0v3h3V6ZM1,8v3H4V8Zm14,0v3h3V8Zm14,0v3h3V8ZM3,9.75 6.75,5 6,4.25 2.25,9ZM10.75,7 7,4.25 6.25,5 10,7.75ZM17,9.75 20.75,5 20,4.25 16.25,9ZM24.75,7 21,4.25 20.25,5 24,7.75ZM31,9.75 34.75,5 34,4.25 30.25,9ZM38.75,7 35,4.25 34.25,5 38,7.75Z`,
			"fx" => `m2,3v1 7H3V8H5V7H3V4H5V3ZM6,3V3.88L7.81,7 6,10.12V11H6.88L8.5,8.19 10.12,11H11V10.12L9.19,7 11,3.88V3H10.12L8.5,5.81 6.88,3Zm10,0v1 7h1V8h2V7H17V4h2V3Zm4,0V3.88L21.81,7 20,10.12V11h0.88L22.5,8.19 24.12,11H25V10.12L23.19,7 25,3.88V3H24.12L22.5,5.81 20.88,3Zm10,0v1 7h1V8h2V7H31V4h2V3Zm4,0V3.88L35.81,7 34,10.12V11h0.88L36.5,8.19 38.12,11H39V10.12L37.19,7 39,3.88V3H38.12L36.5,5.81 34.88,3Z`,
			"group" => `M4.5,2A3.5,2.5 0 0 0 1,4.5 3.5,2.5 0 0 0 4.5,7V6A2.5,1.5 0 0 1 2,4.5 2.5,1.5 0 0 1 4.5,3 2.5,1.5 0 0 1 7,4.5H8A3.5,2.5 0 0 0 4.5,2Zm14,0A3.5,2.5 0 0 0 15,4.5 3.5,2.5 0 0 0 18.5,7V6A2.5,1.5 0 0 1 16,4.5 2.5,1.5 0 0 1 18.5,3 2.5,1.5 0 0 1 21,4.5h1A3.5,2.5 0 0 0 18.5,2Zm14,0A3.5,2.5 0 0 0 29,4.5 3.5,2.5 0 0 0 32.5,7V6A2.5,1.5 0 0 1 30,4.5 2.5,1.5 0 0 1 32.5,3 2.5,1.5 0 0 1 35,4.5h1A3.5,2.5 0 0 0 32.5,2ZM4.75,4 4,4.75 9,8.5 9.75,7.75Zm14,0L18,4.75 23,8.5 23.75,7.75Zm14,0L32,4.75 37,8.5 37.75,7.75ZM9.5,5V6A1.5,2.5 0 0 1 11,8.5 1.5,2.5 0 0 1 9.5,11 1.5,2.5 0 0 1 8,8.5H7A2.5,3.5 0 0 0 9.5,12 2.5,3.5 0 0 0 12,8.5 2.5,3.5 0 0 0 9.5,5Zm14,0V6A1.5,2.5 0 0 1 25,8.5 1.5,2.5 0 0 1 23.5,11 1.5,2.5 0 0 1 22,8.5H21A2.5,3.5 0 0 0 23.5,12 2.5,3.5 0 0 0 26,8.5 2.5,3.5 0 0 0 23.5,5Zm14,0V6A1.5,2.5 0 0 1 39,8.5 1.5,2.5 0 0 1 37.5,11 1.5,2.5 0 0 1 36,8.5H35A2.5,3.5 0 0 0 37.5,12 2.5,3.5 0 0 0 40,8.5 2.5,3.5 0 0 0 37.5,5Z`,
			"lock" => `M6.5,3A2.5,2.5 0 0 0 4,5.5V7H3v4h7V7H9V5.5A2.5,2.5 0 0 0 6.5,3Zm14,0A2.5,2.5 0 0 0 18,5.5V7h-1v4h7V7H23V5.5A2.5,2.5 0 0 0 20.5,3Zm14,0A2.5,2.5 0 0 0 32,5.5V7h-1v4h7V7H37V5.5A2.5,2.5 0 0 0 34.5,3ZM6.5,4A1.5,1.5 0 0 1 8,5.5V7H5V5.5A1.5,1.5 0 0 1 6.5,4Zm14,0A1.5,1.5 0 0 1 22,5.5V7H19V5.5A1.5,1.5 0 0 1 20.5,4Zm14,0A1.5,1.5 0 0 1 36,5.5V7H33V5.5A1.5,1.5 0 0 1 34.5,4Z`,
			"mute" => `M3,3 2,11H3L3.75,5 6,11H7L9.25,5 10,11h1L10,3H9L6.5,9.25 4,3Zm14,0-1,8h1L17.75,5 20,11h1L23.25,5 24,11h1L24,3H23L20.5,9.25 18,3Zm14,0-1,8h1L31.75,5 34,11h1L37.25,5 38,11h1L38,3H37L34.5,9.25 32,3Z`,
			"note" => `M6.5,3A4.5,3 0 0 0 2,6 4.5,3 0 0 0 6.5,9 4.5,3 0 0 0 11,6 4.5,3 0 0 0 6.5,3Zm14,0A4.5,3 0 0 0 16,6 4.5,3 0 0 0 20.5,9 4.5,3 0 0 0 25,6 4.5,3 0 0 0 20.5,3Zm14,0A4.5,3 0 0 0 30,6 4.5,3 0 0 0 34.5,9 4.5,3 0 0 0 39,6 4.5,3 0 0 0 34.5,3ZM4,8.25V11L6,9V8.25Zm14,0V11L20,9V8.25Zm14,0V11L34,9V8.25Z`,
			"pooled" => `M5,3V5H2v6H8V9h2 1V4 3H6Zm14,0v2h-3v6h6V9h2 1V4 3h-5zm14,0v2h-3v6h6V9h2 1V4 3H34ZM6,4h4V8H8V5H6Zm14,0h4V8H22V5h-2zm14,0h4V8H36V5h-2z`,
			"props" => `M6,3V4H8V3Zm14,0v1h2V3Zm14,0v1h2V3ZM4,5v1h2v4H4v1H9V10H7V6 5Zm14,0v1h2v4h-2v1h5V10H21V6 5Zm14,0v1h2v4h-2v1h5V10H35V6 5Z`,
		}}"/>
	</svg>`
}

private fn toolbar(name, on, scale) {
	const color = if on { global::main[global::accent].like } else { global::main.lower.text };
	const on = if on { 0.2 } else { 0.0 };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 30" width="${90 * scale}" height="${30 * scale}">
		${if name == "blank" { `<rect fill=${global::main.lower.like.out()} width="90" height="30"/>` }}
		<rect fill=${color.fade(0.0 + on).out()} width="28" height="28" x="1" y="1" rx="3" ry="3"/>
		<rect fill=${color.fade(0.1 + on).out()} width="28" height="28" x="31" y="1" rx="3" ry="3"/>
		<rect fill=${color.fade(0.2 + on).out()} width="28" height="28" x="61" y="1" rx="3" ry="3"/>
		${if name == "dock" { // xml
			`<path fill=${color.fade(0.2).out()} d="M5,6V19H25V6ZM35,6V19H55V6ZM65,6V19H85V6Z"/>
			 <path fill=${global::main.lower.like.shadow(1)} d="m9,7v3H6.5v1l6,7.5 6,-7.5V10H16V7Zm30,0v3h-2.5v1l6,7.5 6,-7.5V10H46V7Zm30,0v3h-2.5v1l6,7.5 6,-7.5V10H76V7ZM10,8h5v3h2L12.5,17 8,11h2zm30,0h5v3h2L42.5,17 38,11h2zm30,0h5v3h2L72.5,17 68,11h2z"/>`
		}}
		<path fill=${color.out()} d="${switch name {
			"dock" => `m10,8v3H8l4.5,6 4.5,-6H15V8Zm30,0v3h-2l4.5,6 4.5,-6H45V8Zm30,0v3h-2l4.5,6 4.5,-6H75V8ZM5,19v1l4,5h7.5l4,-5H25v-1zm30,0v1l4,5h7.5l4,-5H55v-1zm30,0v1l4,5h7.5l4,-5H85v-1z`,
			"envitem" => `M14,6V8.25L11.25,11H9v3h3V11.75L14.75,9h1.5L18,10.75V13h3V10H18.75L17,8.25V6ZM44,6V8.25L41.25,11H39v3h3V11.75L44.75,9h1.5L48,10.75V13h3V10H48.75L47,8.25V6ZM74,6V8.25L71.25,11H69v3h3V11.75L74.75,9h1.5L78,10.75V13h3V10H78.75L77,8.25V6ZM9.5,18A3.5,3.5 0 0 0 6,21.5 3.5,3.5 0 0 0 9.5,25H13V24H9.5A2.5,2.5 0 0 1 7,21.5 2.5,2.5 0 0 1 9.5,19H13v-1zm7.5,0v1h3.5A2.5,2.5 0 0 1 23,21.5 2.5,2.5 0 0 1 20.5,24H17v1h3.5A3.5,3.5 0 0 0 24,21.5 3.5,3.5 0 0 0 20.5,18Zm22.5,0A3.5,3.5 0 0 0 36,21.5 3.5,3.5 0 0 0 39.5,25H43V24H39.5A2.5,2.5 0 0 1 37,21.5 2.5,2.5 0 0 1 39.5,19H43v-1zm7.5,0v1h3.5A2.5,2.5 0 0 1 53,21.5 2.5,2.5 0 0 1 50.5,24H47v1h3.5A3.5,3.5 0 0 0 54,21.5 3.5,3.5 0 0 0 50.5,18Zm22.5,0A3.5,3.5 0 0 0 66,21.5 3.5,3.5 0 0 0 69.5,25H73V24H69.5A2.5,2.5 0 0 1 67,21.5 2.5,2.5 0 0 1 69.5,19H73v-1zm7.5,0v1h3.5A2.5,2.5 0 0 1 83,21.5 2.5,2.5 0 0 1 80.5,24H77v1h3.5A3.5,3.5 0 0 0 84,21.5 3.5,3.5 0 0 0 80.5,18Zm-66,3v1h8v-1zm30,0v1h8v-1zm30,0v1h8v-1z`,
			"filter" => `m6,7v1l7,7v6l4,4V15L24,8V7Zm30,0v1l7,7v6l4,4V15L54,8V7Zm30,0v1l7,7v6l4,4V15L84,8V7ZM8,8h14l-6,6v8l-2,-2v-6zm30,0h14l-6,6v8l-2,-2v-6zm30,0h14l-6,6v8l-2,-2v-6z`,
			"grid" => `m7,7v4H8V7Zm5,0v4h1V7Zm5,0v4h1V7Zm5,0v4h1V7Zm15,0v4h1V7Zm5,0v4h1V7Zm5,0v4h1V7Zm5,0v4h1V7Zm15,0v4h1V7Zm5,0v4h1V7Zm5,0v4h1V7Zm5,0v4h1V7ZM7,13v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm15,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm15,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1V13ZM7,19v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm15,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm15,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4zm5,0v4h1v-4z`,
			"group" => `M8.5,11A4.5,4.5 0 0 0 4,15.5 4.5,4.5 0 0 0 8.5,20H13V19H8.5A3.5,3.5 0 0 1 5,15.5 3.5,3.5 0 0 1 8.5,12H13v-1zm8.5,0v1h4.5A3.5,3.5 0 0 1 25,15.5 3.5,3.5 0 0 1 21.5,19H17v1h4.5A4.5,4.5 0 0 0 26,15.5 4.5,4.5 0 0 0 21.5,11Zm21.5,0A4.5,4.5 0 0 0 34,15.5 4.5,4.5 0 0 0 38.5,20H43V19H38.5A3.5,3.5 0 0 1 35,15.5 3.5,3.5 0 0 1 38.5,12H43v-1zm8.5,0v1h4.5A3.5,3.5 0 0 1 55,15.5 3.5,3.5 0 0 1 51.5,19H47v1h4.5A4.5,4.5 0 0 0 56,15.5 4.5,4.5 0 0 0 51.5,11Zm21.5,0A4.5,4.5 0 0 0 64,15.5 4.5,4.5 0 0 0 68.5,20H73V19H68.5A3.5,3.5 0 0 1 65,15.5 3.5,3.5 0 0 1 68.5,12H73v-1zm8.5,0v1h4.5A3.5,3.5 0 0 1 85,15.5 3.5,3.5 0 0 1 81.5,19H77v1h4.5A4.5,4.5 0 0 0 86,15.5 4.5,4.5 0 0 0 81.5,11Zm-67,4v1h10v-1zm30,0v1h10v-1zm30,0v1h10v-1z`,
			"load" => `m8,7v16h5V22H9V8h8v4h4v3h1V11L18,7Zm30,0v16h5V22H39V8h8v4h4v3h1V11L48,7Zm30,0v16h5V22H69V8h8v4h4v3h1V11L78,7Zm-54,9v7h8v-6h-3l-1,-1zm30,0v7h8v-6h-3l-1,-1zm30,0v7h8v-6h-3l-1,-1zm-57,2h4v4h-6v-3h1zm30,0h4v4h-6v-3h1zm30,0h4v4h-6v-3h1z`,
			"lock" => `m15,7a5,5 0 0 0-5,5v3H8v8H22V15H20V12A5,5 0 0 0 15,7Zm30,0a5,5 0 0 0-5,5v3h-2v8H52V15H50V12A5,5 0 0 0 45,7Zm30,0a5,5 0 0 0-5,5v3h-2v8H82V15H80V12A5,5 0 0 0 75,7ZM15,9a3,3 0 0 1 3,3v3h-6v-3a3,3 0 0 1 3,-3zm30,0a3,3 0 0 1 3,3v3h-6v-3a3,3 0 0 1 3,-3zm30,0a3,3 0 0 1 3,3v3h-6v-3a3,3 0 0 1 3,-3z`,
			"metro" => `M12,6 8,24h14l-1.78,-8h-1.25l0.66,3h-9.25L13,7h4l0.88,4h1.24L18,6Zm30,0-4,18h14l-1.78,-8h-1.25l0.66,3h-9.25L43,7h4l0.88,4h1.24L48,6Zm30,0-4,18h14l-1.78,-8h-1.25l0.66,3h-9.25L73,7h4l0.88,4h1.24L78,6ZM14,9v1h2V9ZM22.75,9 14.5,17.25 15.25,18 23.5,9.75ZM44,9v1h2V9ZM52.75,9 44.5,17.25 45.25,18 53.5,9.75ZM74,9v1h2V9ZM82.75,9 74.5,17.25 75.25,18 83.5,9.75ZM14,11v1h2v-1zm30,0v1h2v-1zm30,0v1h2v-1zm-60,2v1h2v-1zm30,0v1h2v-1zm30,0v1h2v-1zm-63.84,7h9.69L20.5,23h-11zm30,0h9.69L50.5,23h-11zm30,0h9.69L80.5,23h-11z`,
			"midi_itemsel" => `M4,6V7H5V6ZM6,6V7H7V6ZM8,6V7H9V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm8,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm8,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6Zm2,0v1h1V6ZM6,10v3h14v-3zm30,0v3h14v-3zm30,0v3H80V10ZM7,11h12v1H7Zm30,0h12v1H37Zm30,0h12v1H67Zm-57,4v3h14v-3zm30,0v3h14v-3zm30,0v3H84V15ZM7,20v3h17v-3zm30,0v3h17v-3zm30,0v3H84V20ZM8,21h15v1H8Zm30,0h15v1H38Zm30,0h15v1H68Z`,
			"midi_tracksel" => `M5,6V25H25V6ZM35,6V25H55V6ZM65,6V25H85V6ZM6,7H24V24H6ZM36,7H54V24H36ZM66,7H84V24H66ZM18,8v1h5V8Zm30,0v1h5V8Zm30,0v1h5V8Zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1zm-60,2v1h5v-1zm30,0v1h5v-1zm30,0v1h5v-1z`,
			"new" => `m8,7v16h9V22H9V8h8v4h4v6h1V11L18,7Zm30,0v16h9V22H39V8h8v4h4v6h1V11L48,7Zm30,0v16h9V22H69V8h8v4h4v6h1V11L78,7ZM19,18v2h-2v1h2v2h1v-2h2v-1h-2v-2zm30,0v2h-2v1h2v2h1v-2h2v-1h-2v-2zm30,0v2h-2v1h2v2h1v-2h2v-1h-2v-2z`,
			"projprop" => `M14.5,6A9.5,9.5 0 0 0 5,15.5 9.5,9.5 0 0 0 14.5,25 9.5,9.5 0 0 0 24,15.5 9.5,9.5 0 0 0 14.5,6Zm30,0A9.5,9.5 0 0 0 35,15.5 9.5,9.5 0 0 0 44.5,25 9.5,9.5 0 0 0 54,15.5 9.5,9.5 0 0 0 44.5,6Zm30,0A9.5,9.5 0 0 0 65,15.5 9.5,9.5 0 0 0 74.5,25 9.5,9.5 0 0 0 84,15.5 9.5,9.5 0 0 0 74.5,6Zm-60,1A8.5,8.5 0 0 1 23,15.5 8.5,8.5 0 0 1 14.5,24 8.5,8.5 0 0 1 6,15.5 8.5,8.5 0 0 1 14.5,7Zm30,0A8.5,8.5 0 0 1 53,15.5 8.5,8.5 0 0 1 44.5,24 8.5,8.5 0 0 1 36,15.5 8.5,8.5 0 0 1 44.5,7Zm30,0A8.5,8.5 0 0 1 83,15.5 8.5,8.5 0 0 1 74.5,24 8.5,8.5 0 0 1 66,15.5 8.5,8.5 0 0 1 74.5,7ZM14,10v2h2v-2zm30,0v2h2v-2zm30,0v2h2v-2zm-62,3v1h2v5h-2v1h6v-1h-2v-5-1zm30,0v1h2v5h-2v1h6v-1h-2v-5-1zm30,0v1h2v5h-2v1h6v-1h-2v-5-1z`,
			"redo" => `m77.75,7 3.5,3.5L77.75,14 77,13.25 79.25,11H75.5A5.5,5.5 0 0 0 70,16.5 5.5,5.5 0 0 0 75.5,22H77v1H75.5A6.5,6.5 0 0 1 69,16.5 6.5,6.5 0 0 1 75.5,10h3.75L77,7.75Zm-30,0 3.5,3.5L47.75,14 47,13.25 49.25,11H45.5A5.5,5.5 0 0 0 40,16.5 5.5,5.5 0 0 0 45.5,22H47v1H45.5A6.5,6.5 0 0 1 39,16.5 6.5,6.5 0 0 1 45.5,10h3.75L47,7.75Zm-30,0 3.5,3.5L17.75,14 17,13.25 19.25,11H15.5A5.5,5.5 0 0 0 10,16.5 5.5,5.5 0 0 0 15.5,22H17v1H15.5A6.5,6.5 0 0 1 9,16.5 6.5,6.5 0 0 1 15.5,10h3.75L17,7.75Z`,
			"relsnap" => `M5,7V9H7V7Zm13,0v2h2.5A3.5,3.5 0 0 1 24,12.5 3.5,3.5 0 0 1 20.5,16H18v2h2.5A5.5,5.5 0 0 0 26,12.5 5.5,5.5 0 0 0 20.5,7Zm17,0v2h2V7Zm13,0v2h2.5A3.5,3.5 0 0 1 54,12.5 3.5,3.5 0 0 1 50.5,16H48v2h2.5A5.5,5.5 0 0 0 56,12.5 5.5,5.5 0 0 0 50.5,7Zm17,0v2h2V7Zm13,0v2h2.5A3.5,3.5 0 0 1 84,12.5 3.5,3.5 0 0 1 80.5,16H78v2h2.5A5.5,5.5 0 0 0 86,12.5 5.5,5.5 0 0 0 80.5,7ZM5,16v2h2v-2zm30,0v2h2v-2zm30,0v2h2v-2zm-55,4-4,2.5 4,2.5v-2h5v2L19,22.5 15,20v2h-5zm30,0-4,2.5 4,2.5v-2h5v2L49,22.5 45,20v2h-5zm30,0-4,2.5 4,2.5v-2h5v2L79,22.5 75,20v2h-5z`,
			"ripple_all" => `m6,7v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7ZM7,8h3v2H7Zm30,0h3v2h-3zm30,0h3v2H67ZM6,13v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V13ZM7,14h3v2H7Zm30,0h3v2h-3zm30,0h3v2H67ZM6,19v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V19ZM7,20h3v2H7Zm30,0h3v2h-3zm30,0h3v2h-3z`,
			"ripple_off" => `m6,7v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7ZM7,8h3v2H7Zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2H81ZM6,13v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V13ZM7,14h3v2H7Zm14,0h3v2h-3zm16,0h3v2h-3zm14,0h3v2h-3zm16,0h3v2h-3zm14,0h3v2H81ZM6,19v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V19ZM7,20h3v2H7Zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3z`,
			"ripple_one" => `m6,7v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7Zm16,0v4h5V7Zm7,0v4h5V7Zm7,0v4h5V7ZM7,8h3v2H7Zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2H81ZM6,13v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V13ZM7,14h3v2H7Zm30,0h3v2h-3zm30,0h3v2H67ZM6,19v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5v-4zm16,0v4h5v-4zm7,0v4h5v-4zm7,0v4h5V19ZM7,20h3v2H7Zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3zm16,0h3v2h-3zm7,0h3v2h-3zm7,0h3v2h-3z`,
			"save" => `M7,7V23H23V22 10.3L19.7,7H19ZM37,7V23H53V22 10.3L49.7,7H49ZM67,7V23H83V22 10.3L79.7,7H79ZM8,8h3v5h8V8h0.3L22,10.7V22H20V15H10v7H8Zm4,0h4v4h-4zm26,0h3v5h8V8h0.3L52,10.7V22H50V15H40v7h-2zm4,0h4v4h-4zm26,0h3v5h8V8h0.3L82,10.7V22H80V15H70v7h-2zm4,0h4v4h-4zm-61,8h8v6h-8zm30,0h8v6h-8zm30,0h8v6h-8z`,
			"snap" => `m7,7v3H9V7Zm4,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8zm26,0v3h2V7Zm4,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8zm26,0v3h2V7Zm4,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4A8,8 0 0 0 83,15 8,8 0 0 0 75,7ZM7,20v3h2v-3zm30,0v3h2v-3zm30,0v3h2v-3z`,
			"undo" => `M12.25,7 8.75,10.5 12.25,14 13,13.25 10.75,11H14.5A5.5,5.5 0 0 1 20,16.5 5.5,5.5 0 0 1 14.5,22H13v1h1.5A6.5,6.5 0 0 0 21,16.5 6.5,6.5 0 0 0 14.5,10H10.75L13,7.75Zm30,0-3.5,3.5 3.5,3.5L43,13.25 40.75,11H44.5A5.5,5.5 0 0 1 50,16.5 5.5,5.5 0 0 1 44.5,22H43v1h1.5A6.5,6.5 0 0 0 51,16.5 6.5,6.5 0 0 0 44.5,10H40.75L43,7.75Zm30,0-3.5,3.5 3.5,3.5L73,13.25 70.75,11H74.5A5.5,5.5 0 0 1 80,16.5 5.5,5.5 0 0 1 74.5,22H73v1h1.5A6.5,6.5 0 0 0 81,16.5 6.5,6.5 0 0 0 74.5,10H70.75L73,7.75Z`,
			"xfade" => `m4,7v1h7l2.25,4 0.5,-1L11.5,7ZM18.5,7 9.5,22.75 10.25,23.5 19,8h7V7ZM34,7v1h7l2.25,4 0.5,-1-2.25,-4zm14.5,0-9,15.75 0.75,0.75L49,8h7V7ZM64,7v1h7l2.25,4 0.5,-1-2.25,-4zm14.5,0-9,15.75 0.75,0.75L79,8h7V7Zm-61.5,9.5-0.5,1 3.25,6 0.75,-0.75zm30,0-0.5,1 3.25,6 0.75,-0.75zm30,0-0.5,1 3.25,6 0.75,-0.75z`,
		}}"/>
	</svg>`
}

private fn toolbar_150(name, on) {
	const color = if on { global::main.lower.text } else { global::main[global::accent].like };
	const on = if on { 0.2 } else { 0.0 };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 135 45">
		${if name == "blank" { `<rect fill=${global::main.lower.like.out()} width="135" height="45"/>` }}
		<rect fill=${color.fade(0.0 + on).out()} width="43" height="43" x="1" y="1" rx="6" ry="6"/>
		<rect fill=${color.fade(0.1 + on).out()} width="43" height="43" x="46" y="1" rx="6" ry="6"/>
		<rect fill=${color.fade(0.2 + on).out()} width="43" height="43" x="91" y="1" rx="6" ry="6"/>
		${if name == "dock" { // xml
			`<path fill=${color.fade(0.2).out()} d="M7,9V29H38V9ZM52,9V29H83V9Zm45,0v20h31V9Z"/>
			 <path fill=${global::main.lower.like.shadow(1)} d="m13.5,10.5v5H9L18,28h2l9,-12.5h-4.5v-5zm45,0v5H54L63,28h2l9,-12.5h-4.5v-5zm45,0v5H99l9,12.5h2l9,-12.5h-4.5v-5zM15,12h8v5h3l-7,9-7,-9h3zm45,0h8v5h3l-7,9-7,-9h3zm45,0h8v5h3l-7,9-7,-9h3z"/>`
		}}
		<path fill=${color.out()} d="${switch name {
			"dock" => `m15,12v5h-3l7,9 7,-9h-3v-5zm45,0v5h-3l7,9 7,-9h-3v-5zm45,0v5h-3l7,9 7,-9h-3V12ZM7,29v1l6,7h11l6,-7h8v-1zm45,0v1l6,7h11l6,-7h8v-1zm45,0v1l6,7h11l6,-7h8v-1z`,
			"envitem" => `m21,9v4.2L17.2,16H13v5h5V16.8L21.8,14h3.4L27,15.8V20h5V15H27.8L26,13.2V9Zm45,0v4.2L62.2,16H58v5h5V16.8L66.8,14h3.4L72,15.8V20h5V15H72.8L71,13.2V9Zm45,0v4.2L107.2,16H103v5h5V16.8L111.8,14h3.4L117,15.8V20h5v-5h-4.2L116,13.2V9ZM14.5,26A5.5,5.5 0 0 0 9,31.5 5.5,5.5 0 0 0 14.5,37H20V36H14.5A4.5,4.5 0 0 1 10,31.5 4.5,4.5 0 0 1 14.5,27H20V26ZM26,26v1h4.5c2.5,0 4.5,2 4.5,4.5 0,2.5-2,4.5-4.5,4.5H26v1h4.5C33.5,37 36,34.5 36,31.5 36,28.5 33.5,26 30.5,26Zm33.5,0A5.5,5.5 0 0 0 54,31.5 5.5,5.5 0 0 0 59.5,37H65V36H59.5A4.5,4.5 0 0 1 55,31.5 4.5,4.5 0 0 1 59.5,27H65V26ZM71,26v1h4.5c2.5,0 4.5,2 4.5,4.5 0,2.5-2,4.5-4.5,4.5H71v1h4.5C78.5,37 81,34.5 81,31.5 81,28.5 78.5,26 75.5,26Zm33.5,0a5.5,5.5 0 0 0-5.5,5.5 5.5,5.5 0 0 0 5.5,5.5h5.5v-1h-5.5A4.5,4.5 0 0 1 100,31.5 4.5,4.5 0 0 1 104.5,27h5.5v-1zm11.5,0v1h4.5c2.5,0 4.5,2 4.5,4.5 0,2.5-2,4.5-4.5,4.5H116v1h4.5c3,0 5.5,-2.5 5.5,-5.5 0,-3-2.5,-5.5-5.5,-5.5zm-99,5v1h12v-1zm45,0v1h12v-1zm45,0v1h12v-1z`,
			"filter" => `m8,10v2l11,11v9l7,6V23L37,12v-2zm45,0v2l11,11v9l7,6V23L82,12v-2zm45,0v2l11,11v9l7,6V23L127,12V10ZM11,12H34L24,22V33.5L21,31v-9zm45,0H79L69,22V33.5L66,31v-9zm45,0h23L114,22V33.5L111,31v-9z`,
			"grid" => `m10,11v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1V11ZM10,20v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1V20ZM10,29v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm21,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6zm8,0v6h1v-6z`,
			"group" => `m13,16c-3.9,0-7,3.1-7,7 0,3.9 3.1,7 7,7h7v-2h-7c-2.7,0-4.9,-2.3-5,-5 0,-2.8 2.2,-5 5,-5h7v-2zm12,0v2h7c2.8,0 5,2.2 5,5-0.1,2.7-2.3,5-5,5h-7v2h7c3.9,0 7,-3.1 7,-7 0,-3.9-3.1,-7-7,-7zm33,0c-3.9,0-7,3.1-7,7 0,3.9 3.1,7 7,7h7v-2h-7c-2.7,0-4.9,-2.3-5,-5 0,-2.8 2.2,-5 5,-5h7v-2zm12,0v2h7c2.8,0 5,2.2 5,5-0.1,2.7-2.3,5-5,5h-7v2h7c3.9,0 7,-3.1 7,-7 0,-3.9-3.1,-7-7,-7zm33,0c-3.9,0-7,3.1-7,7 0,3.9 3.1,7 7,7h7v-2h-7c-2.7,0-4.9,-2.3-5,-5 0,-2.8 2.2,-5 5,-5h7v-2zm12,0v2h7c2.8,0 5,2.2 5,5-0.1,2.7-2.3,5-5,5h-7v2h7c3.9,0 7,-3.1 7,-7 0,-3.9-3.1,-7-7,-7zM15,22v2h15v-2zm45,0v2h15v-2zm45,0v2h15v-2z`,
			"load" => `m11,10v24h7V33H12V11h11v7h7v4h1v-5l-7,-7h-1zm45,0v24h7V33H57V11h11v7h7v4h1v-5l-7,-7h-1zm45,0v24h7v-1h-6V11h11v7h7v4h1v-5l-7,-7h-1zM19,22v11 1H31V24h-5l-2,-2zm45,0v11 1H76V24h-5l-2,-2zm45,0v11 1h12V24h-5l-2,-2zm-89,1h3.6l1,1H24l-2,2h-2zm45,0h3.6l1,1H69l-2,2h-2zm45,0h3.6l1,1H114l-2,2h-2zm-90,4h10v6H20Zm45,0h10v6H65Zm45,0h10v6h-10z`,
			"lock" => `M22.5,10A7.5,7.5 0 0 0 15,17.5V23H12V35H33V23H30V17.5A7.5,7.5 0 0 0 22.5,10Zm45,0A7.5,7.5 0 0 0 60,17.5V23H57V35H78V23H75V17.5A7.5,7.5 0 0 0 67.5,10Zm45,0A7.5,7.5 0 0 0 105,17.5V23h-3v12h21V23h-3V17.5A7.5,7.5 0 0 0 112.5,10Zm-90,3A4.5,4.5 0 0 1 27,17.5V23H18V17.5A4.5,4.5 0 0 1 22.5,13Zm45,0A4.5,4.5 0 0 1 72,17.5V23H63V17.5A4.5,4.5 0 0 1 67.5,13Zm45,0a4.5,4.5 0 0 1 4.5,4.5V23h-9v-5.5a4.5,4.5 0 0 1 4.5,-4.5z`,
			"metro" => `M18,9 12,36H33L30.11,23h-1.25l1.32,6H14.82L19,10h7l1.54,7h1.24L27,9ZM63,9 57,36H78L75.11,23h-1.25l1.32,6H59.82L64,10h7l1.54,7h1.24L72,9Zm45,0-6,27h21l-2.89,-13h-1.25l1.32,6H104.82L109,10h7l1.54,7h1.24L117,9ZM36.25,12 22,26.25 22.75,27 37,12.75Zm45,0L67,26.25 67.75,27 82,12.75Zm45,0L112,26.25 112.75,27 127,12.75ZM21,13v1h3v-1zm45,0v1h3v-1zm45,0v1h3v-1zm-90,3v1h3v-1zm45,0v1h3v-1zm45,0v1h3v-1zm-90,3v1h3v-1zm45,0v1h3v-1zm45,0v1h3V19ZM14.6,30H30.4L31.5,35h-18zm45,0H75.4L76.5,35h-18zm45,0h15.8L121.5,35h-18z`,
			"midi_itemsel" => `m6,9v1H7V9Zm2,0v1H9V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm11,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm11,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9Zm2,0v1h1V9ZM9,14v5h21v-5zm45,0v5h21v-5zm45,0v5h21v-5zm-89,1h19v3H10Zm45,0h19v3H55Zm45,0h19v3h-19zm-85,7v5h21v-5zm45,0v5h21v-5zm45,0v5h21v-5zm-95,8v5h26v-5zm45,0v5h26v-5zm45,0v5h26v-5zm-89,1h24v3H11Zm45,0h24v3H56Zm45,0h24v3h-24z`,
			"midi_tracksel" => `M8,8V37H37V8ZM53,8V37H82V8Zm45,0v29h29V8ZM9,9H36V36H9ZM54,9H81V36H54Zm45,0h27V36H99Zm-73,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1zm-90,2v1h8v-1zm45,0v1h8v-1zm45,0v1h8v-1z`,
			"new" => `m11,10v24h9V33H12V11h11v7h7v5h1v-6l-7,-7zm45,0v24h9V33H57V11h11v7h7v5h1v-6l-7,-7zm45,0v24h9v-1h-8V11h11v7h7v5h1v-6l-7,-7zM25,23v5h-5v1h5v5h1v-5h5v-1h-5v-5zm45,0v5h-5v1h5v5h1v-5h5v-1h-5v-5zm45,0v5h-5v1h5v5h1v-5h5v-1h-5v-5z`,
			"projprop" => `M21.5,9A14.5,14.5 0 0 0 7,23.5 14.5,14.5 0 0 0 21.5,38 14.5,14.5 0 0 0 36,23.5 14.5,14.5 0 0 0 21.5,9Zm45,0A14.5,14.5 0 0 0 52,23.5 14.5,14.5 0 0 0 66.5,38 14.5,14.5 0 0 0 81,23.5 14.5,14.5 0 0 0 66.5,9Zm45,0A14.5,14.5 0 0 0 97,23.5 14.5,14.5 0 0 0 111.5,38 14.5,14.5 0 0 0 126,23.5 14.5,14.5 0 0 0 111.5,9Zm-90,1.5a13,13 0 0 1 13,13 13,13 0 0 1-13,13 13,13 0 0 1-13,-13 13,13 0 0 1 13,-13zm45,0a13,13 0 0 1 13,13 13,13 0 0 1-13,13 13,13 0 0 1-13,-13 13,13 0 0 1 13,-13zm45,0a13,13 0 0 1 13,13 13,13 0 0 1-13,13 13,13 0 0 1-13,-13 13,13 0 0 1 13,-13zM20,15v3h3v-3zm45,0v3h3v-3zm45,0v3h3v-3zm-93,5v2h3v6h-3v2h9v-2h-3v-6-2zm45,0v2h3v6h-3v2h9v-2h-3v-6-2zm45,0v2h3v6h-3v2h9v-2h-3v-6-2z`,
			"redo" => `m116,9.5 5,5-5,5-0.75,-0.75L119,15h-8a9,9 0 0 0-9,9 9,9 0 0 0 9,9h1v1h-1A10,10 0 0 1 101,24 10,10 0 0 1 111,14h8l-3.75,-3.75zm-45,0 5,5-5,5L70.25,18.75 74,15h-8a9,9 0 0 0-9,9 9,9 0 0 0 9,9h1v1H66A10,10 0 0 1 56,24 10,10 0 0 1 66,14h8l-3.75,-3.75zm-45,0 5,5-5,5L25.25,18.75 29,15h-8a9,9 0 0 0-9,9 9,9 0 0 0 9,9h1v1H21A10,10 0 0 1 11,24 10,10 0 0 1 21,14h8l-3.75,-3.75z`,
			"relsnap" => `m7,11v3h3v-3zm20,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8zm25,0v3h3v-3zm20,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8zm25,0v3h3v-3zm20,0v3h4a5,5 0 0 1 5,5 5,5 0 0 1-5,5h-4v3h4a8,8 0 0 0 8,-8 8,8 0 0 0-8,-8zM7,24v3h3v-3zm45,0v3h3v-3zm45,0v3h3v-3zm-82,6-6,3.5 6,4.5v-3h7v3L28,33.5 22,30v3h-7zm45,0-6,3.5 6,4.5v-3h7v3L73,33.5 67,30v3h-7zm45,0-6,3.5 6,4.5v-3h7v3l6,-4.5-6,-3.5v3h-7z`,
			"ripple_all" => `m9,11v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V11ZM10,12h6v4h-6zm45,0h6v4h-6zm45,0h6v4h-6zM9,20v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V20ZM10,21h6v4h-6zm45,0h6v4h-6zm45,0h6v4h-6zM9,29v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V29ZM10,30h6v4h-6zm45,0h6v4h-6zm45,0h6v4h-6z`,
			"ripple_off" => `m9,11v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V11ZM10,12h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zM9,20v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V20ZM10,21h6v4h-6zm21,0h6v4h-6zm24,0h6v4h-6zm21,0h6v4h-6zm24,0h6v4h-6zm21,0h6v4h-6zM9,29v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V29ZM10,30h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6z`,
			"ripple_one" => `m9,11v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V11ZM10,12h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zM9,20v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V20ZM10,21h6v4h-6zm45,0h6v4h-6zm45,0h6v4h-6zM9,29v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8v-6zm24,0v6h8v-6zm10,0v6h8v-6zm11,0v6h8V29ZM10,30h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6zm24,0h6v4h-6zm10,0h6v4h-6zm11,0h6v4h-6z`,
			"save" => `M9,10V34H33V16l-6,-6zm45,0V34H78V16l-6,-6zm45,0v24h24V16l-6,-6zm-89,1h5v8h11v-8h0.6L32,16.4V33H28V25H14v8h-4zm6,0h6v7h-6zm39,0h5v8h11v-8h0.6L77,16.4V33H73V25H59v8h-4zm6,0h6v7h-6zm39,0h5v8h11v-8h0.6L122,16.4V33h-4v-8h-14v8h-4zm6,0h6v7h-6zM15,26h12v7H15Zm45,0h12v7H60Zm45,0h12v7h-12z`,
			"snap" => `m11,10v5h3v-5zm5,0v5h6c4.1,0 7.5,3.4 7.5,7.5 0,4.1-3.4,7.5-7.5,7.5h-6v5h6C28.9,35 34.5,29.4 34.5,22.5 34.5,15.6 28.9,10 22,10Zm40,0v5h3v-5zm5,0v5h6c4.1,0 7.5,3.4 7.5,7.5 0,4.1-3.4,7.5-7.5,7.5h-6v5h6C73.9,35 79.5,29.4 79.5,22.5 79.5,15.6 73.9,10 67,10Zm40,0v5h3v-5zm5,0v5h6c4.1,0 7.5,3.4 7.5,7.5 0,4.1-3.4,7.5-7.5,7.5h-6v5h6c6.9,0 12.5,-5.6 12.5,-12.5C124.5,15.6 118.9,10 112,10ZM11,30v5h3v-5zm45,0v5h3v-5zm45,0v5h3v-5z`,
			"undo" => `m16,9.5-5,5 5,5 0.75,-0.75L13,15h8a9,9 0 0 1 9,9 9,9 0 0 1-9,9h-1v1h1A10,10 0 0 0 31,24 10,10 0 0 0 21,14h-8l3.75,-3.75zm45,0-5,5 5,5 0.75,-0.75L58,15h8a9,9 0 0 1 9,9 9,9 0 0 1-9,9h-1v1h1A10,10 0 0 0 76,24 10,10 0 0 0 66,14h-8l3.75,-3.75zm45,0-5,5 5,5 0.75,-0.75L103,15h8a9,9 0 0 1 9,9 9,9 0 0 1-9,9h-1v1h1A10,10 0 0 0 121,24 10,10 0 0 0 111,14h-8l3.75,-3.75z`,
			"xfade" => `m6,10v2h10l3.5,5.9 1.6,-1.1L17,10Zm22,0-14,23.5 1.5,1.5L29,12h10v-2zm23,0v2h10l3.5,5.9 1.6,-1.1L62,10Zm22,0-14,23.5 1.5,1.5L74,12h10v-2zm23,0v2h10l3.5,5.9 1.6,-1.1L107,10Zm22,0-14,23.5 1.5,1.5L119,12h10V10ZM25.6,24.5 24,25.6l5.5,9.4 1.5,-1.5zm45,0L69,25.6l5.5,9.4 1.5,-1.5zm45,0-1.6,1.1 5.5,9.4 1.5,-1.5z`,
		}}"/>
	</svg>`
}

export const map = #{ // xml
	item_bg: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 33">
		<path fill="yellow" d="M0,0V2H1V0Zm18,31v1h-1v1h2v-1-1z"/>
		<path fill="magenta" d="M1,0V1H5V0ZM0,2V6H1V2Zm18,26v3h1v-3zm-2,4v1h1v-1z"/>
		<path fill=${main.raise("upper", "like", 0.1).fade(2 / 3.0).out()} d="M1,2V31H17V2Z"/>
		<path fill=${main.lower.area.shadow(1)} d="M1,1V2H17V31H1v1h16 1V2 1Z"/>
	</svg>`, // xml
	
	item_bg_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 33">
		<path fill="yellow" d="M0,0V2H1V0Zm18,30v2h-1v1h1 1v-3z"/>
		<path fill="magenta" d="M1,0V1H5V0ZM0,2V6H1V2Zm18,26v2h1v-2zm-2,4v1h1v-1z"/>
		<path fill=${main[accent].area.out()} d="m1,1v2 27 2H18V30 3 1ZM2,3H17V30H2Z"/>
		<path fill=${main.lower("upper", "like", 1.0).fade(2 / 3.0).out()} d="M2,3V30H17V3Z"/>
	</svg>`,
	
	item_env_off: item("env", (), 1),
	item_env_off_200: item("env", (), 2),
	item_env_off_hidpi: item("env", (), 2),
	item_env_on: item("env", accent, 1),
	item_env_on_200: item("env", accent, 2),
	item_env_on_hidpi: item("env", accent, 2),
	item_fx_off: item("fx", (), 1),
	item_fx_off_200: item("fx", (), 2),
	item_fx_off_hidpi: item("fx", (), 2),
	item_fx_on: item("fx", accent, 1),
	item_fx_on_200: item("fx", accent, 2),
	item_fx_on_hidpi: item("fx", accent, 2),
	item_group: item("group", yellow, 1),
	item_group_hidpi: item("group", yellow, 2),
	item_group_hidpi_200: item("group", yellow, 2),
	item_group_sel: item("group", accent, 1),
	item_group_sel_hidpi: item("group", accent, 2),
	item_group_sel_hidpi_200: item("group", accent, 2),
	item_lock_off: item("lock", (), 1),
	item_lock_off_hidpi: item("lock", (), 2),
	item_lock_off_hidpi_200: item("lock", (), 2),
	item_lock_on: item("lock", pink, 1),
	item_lock_on_hidpi: item("lock", pink, 2),
	item_lock_on_hidpi_200: item("lock", pink, 2),
	item_mute_off: item("mute", (), 1),
	item_mute_off_hidpi: item("mute", (), 2),
	item_mute_off_hidpi_200: item("mute", (), 2),
	item_mute_on: item("mute", red, 1),
	item_mute_on_hidpi: item("mute", red, 2),
	item_mute_on_hidpi_200: item("mute", red, 2),
	item_note_off: item("note", (), 1),
	item_note_off_hidpi: item("note", (), 2),
	item_note_off_hidpi_200: item("note", (), 2),
	item_note_on: item("note", accent, 1),
	item_note_on_hidpi: item("note", accent, 2),
	item_note_on_hidpi_200: item("note", accent, 2),
	item_pooled: item("pooled", (), 1),
	item_pooled_hidpi: item("pooled", (), 2),
	item_pooled_hidpi_200: item("pooled", (), 2),
	item_pooled_on: item("pooled", accent, 1),
	item_pooled_on_hidpi: item("pooled", accent, 2),
	item_pooled_on_hidpi_200: item("pooled", accent, 2),
	item_props: item("props", (), 1),
	item_props_hidpi: item("props", (), 2),
	item_props_hidpi_200: item("props", (), 2),
	item_props_on: item("props", accent, 1),
	item_props_on_hidpi: item("props", accent, 2),
	item_props_on_hidpi_200: item("props", accent, 2),
	
	toolbar_blank: toolbar("blank", false, 1),
	toolbar_blank_150: toolbar_150("blank", false),
	toolbar_blank_200: toolbar("blank", false, 2),
	toolbar_dock_off: toolbar("dock", false, 1),
	toolbar_dock_off_150: toolbar_150("dock", false),
	toolbar_dock_off_200: toolbar("dock", false, 2),
	toolbar_dock_on: toolbar("dock", true, 1),
	toolbar_dock_on_150: toolbar_150("dock", true),
	toolbar_dock_on_200: toolbar("dock", true, 2),
	toolbar_envitem_off: toolbar("envitem", false, 1),
	toolbar_envitem_off_150: toolbar_150("envitem", false),
	toolbar_envitem_off_200: toolbar("envitem", false, 2),
	toolbar_envitem_on: toolbar("envitem", true, 1),
	toolbar_envitem_on_150: toolbar_150("envitem", true),
	toolbar_envitem_on_200: toolbar("envitem", true, 2),
	toolbar_filter_off: toolbar("filter", false, 1),
	toolbar_filter_off_150: toolbar_150("filter", false),
	toolbar_filter_off_200: toolbar("filter", false, 2),
	toolbar_filter_on: toolbar("filter", true, 1),
	toolbar_filter_on_150: toolbar_150("filter", true),
	toolbar_filter_on_200: toolbar("filter", true, 2),
	toolbar_grid_off: toolbar("grid", false, 1),
	toolbar_grid_off_150: toolbar_150("grid", false),
	toolbar_grid_off_200: toolbar("grid", false, 2),
	toolbar_grid_on: toolbar("grid", true, 1),
	toolbar_grid_on_150: toolbar_150("grid", true),
	toolbar_grid_on_200: toolbar("grid", true, 2),
	toolbar_group_off: toolbar("group", false, 1),
	toolbar_group_off_150: toolbar_150("group", false),
	toolbar_group_off_200: toolbar("group", false, 2),
	toolbar_group_on: toolbar("group", true, 1),
	toolbar_group_on_150: toolbar_150("group", true),
	toolbar_group_on_200: toolbar("group", true, 2),
	toolbar_load: toolbar("load", false, 1),
	toolbar_load_150: toolbar_150("load", false),
	toolbar_load_200: toolbar("load", false, 2),
	toolbar_lock_off: toolbar("lock", false, 1),
	toolbar_lock_off_150: toolbar_150("lock", false),
	toolbar_lock_off_200: toolbar("lock", false, 2),
	toolbar_lock_on: toolbar("lock", true, 1),
	toolbar_lock_on_150: toolbar_150("lock", true),
	toolbar_lock_on_200: toolbar("lock", true, 2),
	toolbar_metro_off: toolbar("metro", false, 1),
	toolbar_metro_off_150: toolbar_150("metro", false),
	toolbar_metro_off_200: toolbar("metro", false, 2),
	toolbar_metro_on: toolbar("metro", true, 1),
	toolbar_metro_on_150: toolbar_150("metro", true),
	toolbar_metro_on_200: toolbar("metro", true, 2),
	toolbar_midi_itemsel_off: toolbar("midi_itemsel", false, 1),
	toolbar_midi_itemsel_off_150: toolbar_150("midi_itemsel", false),
	toolbar_midi_itemsel_off_200: toolbar("midi_itemsel", false, 2),
	toolbar_midi_itemsel_on: toolbar("midi_itemsel", true, 1),
	toolbar_midi_itemsel_on_150: toolbar_150("midi_itemsel", true),
	toolbar_midi_itemsel_on_200: toolbar("midi_itemsel", true, 2),
	toolbar_midi_tracksel_off: toolbar("midi_tracksel", false, 1),
	toolbar_midi_tracksel_off_150: toolbar_150("midi_tracksel", false),
	toolbar_midi_tracksel_off_200: toolbar("midi_tracksel", false, 2),
	toolbar_midi_tracksel_on: toolbar("midi_tracksel", true, 1),
	toolbar_midi_tracksel_on_150: toolbar_150("midi_tracksel", true),
	toolbar_midi_tracksel_on_200: toolbar("midi_tracksel", true, 2),
	toolbar_new: toolbar("new", false, 1),
	toolbar_new_150: toolbar_150("new", false),
	toolbar_new_200: toolbar("new", false, 2),
	toolbar_projprop: toolbar("projprop", false, 1),
	toolbar_projprop_150: toolbar_150("projprop", false),
	toolbar_projprop_200: toolbar("projprop", false, 2),
	toolbar_redo: toolbar("redo", false, 1),
	toolbar_redo_150: toolbar_150("redo", false),
	toolbar_redo_200: toolbar("redo", false, 2),
	toolbar_relsnap_off: toolbar("relsnap", false, 1),
	toolbar_relsnap_off_150: toolbar_150("relsnap", false),
	toolbar_relsnap_off_200: toolbar("relsnap", false, 2),
	toolbar_relsnap_on: toolbar("relsnap", true, 1),
	toolbar_relsnap_on_150: toolbar_150("relsnap", true),
	toolbar_relsnap_on_200: toolbar("relsnap", true, 2),
	toolbar_ripple_all: toolbar("ripple_all", true, 1),
	toolbar_ripple_all_150: toolbar_150("ripple_all", true),
	toolbar_ripple_all_200: toolbar("ripple_all", true, 2),
	toolbar_ripple_off: toolbar("ripple_off", false, 1),
	toolbar_ripple_off_150: toolbar_150("ripple_off", false),
	toolbar_ripple_off_200: toolbar("ripple_off", false, 2),
	toolbar_ripple_one: toolbar("ripple_one", true, 1),
	toolbar_ripple_one_150: toolbar_150("ripple_one", true),
	toolbar_ripple_one_200: toolbar("ripple_one", true, 2),
	toolbar_save: toolbar("save", false, 1),
	toolbar_save_150: toolbar_150("save", false),
	toolbar_save_200: toolbar("save", false, 2),
	toolbar_snap_off: toolbar("snap", false, 1),
	toolbar_snap_off_150: toolbar_150("snap", false),
	toolbar_snap_off_200: toolbar("snap", false, 2),
	toolbar_snap_on: toolbar("snap", true, 1),
	toolbar_snap_on_150: toolbar_150("snap", true),
	toolbar_snap_on_200: toolbar("snap", true, 2),
	toolbar_undo: toolbar("undo", false, 1),
	toolbar_undo_150: toolbar_150("undo", false),
	toolbar_undo_200: toolbar("undo", false, 2),
	toolbar_xfade_off: toolbar("xfade", false, 1),
	toolbar_xfade_off_150: toolbar_150("xfade", false),
	toolbar_xfade_off_200: toolbar("xfade", false, 2),
	toolbar_xfade_on: toolbar("xfade", true, 1),
	toolbar_xfade_on_150: toolbar_150("xfade", true),
	toolbar_xfade_on_200: toolbar("xfade", true, 2),
}
