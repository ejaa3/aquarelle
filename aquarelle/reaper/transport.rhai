/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main   = main;
const accent = accent;

private fn global(icon, set, scale) {
	const role = if set == "lower" { "text" } else { "like" };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 174 36" width="${174 * scale}" height="${36 * scale}">
		<path fill=${global::main.lower.like.shadow(0.75)} d="M6,0A6,6 0 0 0 0,6v24a6,6 0 0 0 6,6h46a6,6 0 0 0 6,-6 6,6 0 0 0 6,6h46a6,6 0 0 0 6,-6 6,6 0 0 0 6,6h46a6,6 0 0 0 6,-6V6a6,6 0 0 0-6,-6h-46a6,6 0 0 0-6,6 6,6 0 0 0-6,-6H64A6,6 0 0 0 58,6 6,6 0 0 0 52,0Zm6,17h34a7,7 0 0 1 7,7 7,7 0 0 1-7,7H12a7,7 0 0 1-7,-7 7,7 0 0 1 7,-7zm58,0h34a7,7 0 0 1 7,7 7,7 0 0 1-7,7H70a7,7 0 0 1-7,-7 7,7 0 0 1 7,-7zm58,0h34a7,7 0 0 1 7,7 7,7 0 0 1-7,7h-34a7,7 0 0 1-7,-7 7,7 0 0 1 7,-7z"/>
		<path fill=${global::main[set][role].out()} d="m14,5a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zM18,9a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zM9,10a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zM13,7l-4,4 1,1 4,-4zm1,1 3,3 1,-1-3,-3zm57,-1-4,4 1,1 4,-4zm1,1 3,3 1,-1-3,-3zm57,-1-4,4 1,1 4,-4zm1,1 3,3 1,-1-3,-3z"/>
		<path fill=${global::main.lower.text.fade(5.0 / 6).out()} d="m25,6a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V10 9h-2v1h1v1a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1 1,1 0 0 1 1,1h1A2,2 0 0 0 25,6Zm3,0v7h1 2V12H29V6Zm6,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V8A2,2 0 0 0 34,6Zm3,0v7h1 1v-1h-1v-2h1A2,2 0 0 0 41,8 2,2 0 0 0 39,6h-1zm7,0a2,2 0 0 0-2,2v5h1v-3h2v3h1V8A2,2 0 0 0 44,6Zm3,0v7h1 2V12H48V6Zm36,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V10 9h-2v1h1v1a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1 1,1 0 0 1 1,1h1A2,2 0 0 0 83,6Zm3,0v7h1 2V12H87V6Zm6,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V8A2,2 0 0 0 92,6Zm3,0v7h1 1v-1h-1v-2h1A2,2 0 0 0 99,8 2,2 0 0 0 97,6h-1zm7,0a2,2 0 0 0-2,2v5h1v-3h2v3h1V8a2,2 0 0 0-2,-2zm3,0v7h1 2v-1h-2V6Zm36,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V10 9h-2v1h1v1a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1 1,1 0 0 1 1,1h1a2,2 0 0 0-2,-2zm3,0v7h1 2v-1h-2V6Zm6,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V8a2,2 0 0 0-2,-2zm3,0v7h1 1v-1h-1v-2h1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2h-1zm7,0a2,2 0 0 0-2,2v5h1v-3h2v3h1V8a2,2 0 0 0-2,-2zm3,0v7h1 2v-1h-2V6ZM34,7a1,1 0 0 1 1,1v3a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1V9H43V8a1,1 0 0 1 1,-1zm48,0a1,1 0 0 1 1,1v3a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v1h-2V8a1,1 0 0 1 1,-1zm48,0a1,1 0 0 1 1,1v3a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V8a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v1h-2V8a1,1 0 0 1 1,-1zM39,9v1a1,1 0 0 1 1,1 1,1 0 0 1-1,1v1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0v1a1,1 0 0 1 1,1 1,1 0 0 1-1,1v1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm58,0v1a1,1 0 0 1 1,1 1,1 0 0 1-1,1v1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2z"/>
		
		<circle fill=${global::main.lower.text.fade(0.2).out()} cx="46" cy="24" r="6"/>
		<path fill=${global::main.lower.text.fade(0.8).out()} d="m42,22h8l-4,5z"/>
		<circle fill=${global::main.lower.text.fade(0.3).out()} cx="104" cy="24" r="6"/>
		<path fill=${global::main.lower.text.fade(0.9).out()} d="m100,22h8l-4,5z"/>
		<circle fill=${global::main.lower.text.fade(0.4).out()} cx="162" cy="24" r="6"/>
		<path fill=${global::main.lower.text.out()} d="m158,22h8l-4,5z"/>
		
		<path fill=${global::main[set][role].out()} d="${switch icon {
			"bypass" => `m11,20v8h1 1a2,2 0 0 0 2,-2h-1a1,1 0 0 1-1,1h-1v-2h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v3.5A1.5,1.5 0 0 0 17.5,25 1.5,1.5 0 0 0 19,23.5V20h-1v3.5A0.5,0.5 0 0 1 17.5,24 0.5,0.5 0 0 1 17,23.5V20Zm4,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25A1,1.25 0 0 1 32,27 1,1.25 0 0 1 31,25.75H30A2,2.25 0 0 0 32,28 2,2.25 0 0 0 34,25.75 2,2.25 0 0 0 32,23.5 1,1.25 0 0 1 31,22.25 1,1.25 0 0 1 32,21a1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 32,20Zm4.5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25 1,1.25 0 0 1-1,1.25 1,1.25 0 0 1-1,-1.25h-1a2,2.25 0 0 0 2,2.25 2,2.25 0 0 0 2,-2.25 2,2.25 0 0 0-2,-2.25 1,1.25 0 0 1-1,-1.25 1,1.25 0 0 1 1,-1.25 1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 36.5,20ZM69,20v8h1 1a2,2 0 0 0 2,-2h-1a1,1 0 0 1-1,1h-1v-2h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v3.5A1.5,1.5 0 0 0 75.5,25 1.5,1.5 0 0 0 77,23.5V20h-1v3.5A0.5,0.5 0 0 1 75.5,24 0.5,0.5 0 0 1 75,23.5V20Zm4,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25A1,1.25 0 0 1 90,27 1,1.25 0 0 1 89,25.75H88A2,2.25 0 0 0 90,28 2,2.25 0 0 0 92,25.75 2,2.25 0 0 0 90,23.5 1,1.25 0 0 1 89,22.25 1,1.25 0 0 1 90,21a1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 90,20Zm4.5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25 1,1.25 0 0 1-1,1.25 1,1.25 0 0 1-1,-1.25h-1a2,2.25 0 0 0 2,2.25 2,2.25 0 0 0 2,-2.25 2,2.25 0 0 0-2,-2.25 1,1.25 0 0 1-1,-1.25 1,1.25 0 0 1 1,-1.25 1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 94.5,20Zm32.5,0v8h1 1a2,2 0 0 0 2,-2h-1a1,1 0 0 1-1,1h-1v-2h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v3.5a1.5,1.5 0 0 0 1.5,1.5 1.5,1.5 0 0 0 1.5,-1.5V20h-1v3.5A0.5,0.5 0 0 1 133.5,24 0.5,0.5 0 0 1 133,23.5V20Zm4,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25 1,1.25 0 0 1-1,1.25 1,1.25 0 0 1-1,-1.25h-1a2,2.25 0 0 0 2,2.25 2,2.25 0 0 0 2,-2.25 2,2.25 0 0 0-2,-2.25 1,1.25 0 0 1-1,-1.25 1,1.25 0 0 1 1,-1.25 1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 148,20Zm4.5,0a2,2.25 0 0 0-2,2.25 2,2.25 0 0 0 2,2.25 1,1.25 0 0 1 1,1.25 1,1.25 0 0 1-1,1.25 1,1.25 0 0 1-1,-1.25h-1a2,2.25 0 0 0 2,2.25 2,2.25 0 0 0 2,-2.25 2,2.25 0 0 0-2,-2.25 1,1.25 0 0 1-1,-1.25 1,1.25 0 0 1 1,-1.25 1,1.25 0 0 1 1,1.25h1A2,2.25 0 0 0 152.5,20ZM12,21h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm9,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm43,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm9,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm43,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm9,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zM13,24v1a1,1 0 0 1 1,1h1a2,2 0 0 0-2,-2zm58,0v1a1,1 0 0 1 1,1h1a2,2 0 0 0-2,-2zm58,0v1a1,1 0 0 1 1,1h1a2,2 0 0 0-2,-2zM17,24.5V28h1v-3.5zm58,0V28h1v-3.5zm58,0V28h1v-3.5z`,
			"latch" => `m11,20v8h1 3v-1h-3v-7zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2v-4zm38,0v8h1 3v-1h-3v-7zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2v-4zm38,0v8h1 3v-1h-3v-7zm7,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2V20ZM18,21a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1z`,
			"off" => `m13,20a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm4.5,0A1.5,1.5 0 0 0 16,21.5v4.5 2h1v-2-1h2V24H17V21.5A0.5,0.5 0 0 1 17.5,21H19v-1zm4,0A1.5,1.5 0 0 0 20,21.5v4.5 2h1v-2-1h2V24H21V21.5A0.5,0.5 0 0 1 21.5,21H23V20ZM71,20a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm4.5,0A1.5,1.5 0 0 0 74,21.5v4.5 2h1v-2-1h2V24H75V21.5A0.5,0.5 0 0 1 75.5,21H77v-1zm4,0A1.5,1.5 0 0 0 78,21.5v4.5 2h1v-2-1h2V24H79V21.5A0.5,0.5 0 0 1 79.5,21H81v-1zm49.5,0a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm4.5,0a1.5,1.5 0 0 0-1.5,1.5v4.5 2h1v-2-1h2v-1h-2v-2.5a0.5,0.5 0 0 1 0.5,-0.5h1.5v-1zm4,0a1.5,1.5 0 0 0-1.5,1.5v4.5 2h1v-2-1h2v-1h-2V21.5A0.5,0.5 0 0 1 137.5,21H139V20ZM13,21a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1z`,
			"preview" => `m10,20v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 20,21.5v5A1.5,1.5 0 0 0 21.5,28H23V27H21.5A0.5,0.5 0 0 1 21,26.5V25h2V24H21V21.5A0.5,0.5 0 0 1 21.5,21H23v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H26A0.5,7 0 0 1 25.5,27 0.5,7 0 0 1 25,20Zm4,0v8h1v-8zm3.5,0A1.5,1.5 0 0 0 30,21.5v5A1.5,1.5 0 0 0 31.5,28H33V27H31.5A0.5,0.5 0 0 1 31,26.5V25h2V24H31V21.5A0.5,0.5 0 0 1 31.5,21H33v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H36A0.5,7 0 0 1 35.5,27 0.5,7 0 0 1 35,20Zm34,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 78,21.5v5A1.5,1.5 0 0 0 79.5,28H81V27H79.5A0.5,0.5 0 0 1 79,26.5V25h2V24H79V21.5A0.5,0.5 0 0 1 79.5,21H81v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H84A0.5,7 0 0 1 83.5,27 0.5,7 0 0 1 83,20Zm4,0v8h1v-8zm3.5,0A1.5,1.5 0 0 0 88,21.5v5A1.5,1.5 0 0 0 89.5,28H91V27H89.5A0.5,0.5 0 0 1 89,26.5V25h2V24H89V21.5A0.5,0.5 0 0 1 89.5,21H91v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H94A0.5,7 0 0 1 93.5,27 0.5,7 0 0 1 93,20Zm34,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0a1.5,1.5 0 0 0-1.5,1.5v5a1.5,1.5 0 0 0 1.5,1.5h1.5v-1h-1.5A0.5,0.5 0 0 1 137,26.5V25h2v-1h-2v-2.5a0.5,0.5 0 0 1 0.5,-0.5h1.5v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8h-1a0.5,7 0 0 1-0.5,7 0.5,7 0 0 1-0.5,-7zm4,0v8h1v-8zm3.5,0a1.5,1.5 0 0 0-1.5,1.5v5a1.5,1.5 0 0 0 1.5,1.5h1.5v-1h-1.5A0.5,0.5 0 0 1 147,26.5V25h2v-1h-2v-2.5a0.5,0.5 0 0 1 0.5,-0.5h1.5v-1zm2.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8h-1a0.5,7 0 0 1-0.5,7 0.5,7 0 0 1-0.5,-7zM11,21h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm5,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm53,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm5,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm53,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm5,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zM36,20a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H38A0.5,7 0 0 1 37.5,27 0.5,7 0 0 1 37,20Zm58,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H96A0.5,7 0 0 1 95.5,27 0.5,7 0 0 1 95,20Zm58,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8h-1a0.5,7 0 0 1-0.5,7 0.5,7 0 0 1-0.5,-7zM16,24v0.75L18.25,28H19V27.25L16.75,24Zm58,0v0.75L76.25,28H77V27.25L74.75,24Zm58,0v0.75L134.25,28H135V27.25L132.75,24Z`,
			"read" => `m11,20v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 16,21.5v5A1.5,1.5 0 0 0 17.5,28H19V27H17.5A0.5,0.5 0 0 1 17,26.5V25h2V24H17V21.5A0.5,0.5 0 0 1 17.5,21H19v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm44,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 74,21.5v5A1.5,1.5 0 0 0 75.5,28H77V27H75.5A0.5,0.5 0 0 1 75,26.5V25h2V24H75V21.5A0.5,0.5 0 0 1 75.5,21H77v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm44,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0a1.5,1.5 0 0 0-1.5,1.5v5a1.5,1.5 0 0 0 1.5,1.5h1.5v-1h-1.5A0.5,0.5 0 0 1 133,26.5V25h2v-1h-2v-2.5a0.5,0.5 0 0 1 0.5,-0.5h1.5v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zM12,21h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1h-1zm44,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1h-1zm44,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1h-1zM12,24v0.75L14.25,28H15V27.25L12.75,24Zm58,0v0.75L72.25,28H73V27.25L70.75,24Zm58,0v0.75L130.25,28H131V27.25L128.75,24Z`,
			"touch" => `m10,20v1h2v7h1v-7h1v-1zm7,0a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm3,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V23.5 20h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V23.5 20Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2v-4zm38,0v1h2v7h1v-7h1v-1zm7,0a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm3,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V23.5 20h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V23.5 20Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2v-4zm38,0v1h2v7h1v-7h1v-1zm7,0a2,2 0 0 0-2,2v4a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm3,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V23.5 20h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V23.5 20Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3h1v-1h-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2h1v-1zm2,0v8h1v-3h2v3h1v-8h-1v4h-2V20ZM17,21a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1zm58,0a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-4a1,1 0 0 1 1,-1z`,
			"trim" => `m10,20v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm3.5,0A1.5,8 0 0 0 22,28h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1A1.5,8 0 0 0 23.5,20ZM68,20v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm3.5,0A1.5,8 0 0 0 80,28h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1a1.5,8 0 0 0-1.5,-8zm44.5,0v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm3.5,0a1.5,8 0 0 0-1.5,8h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1a1.5,8 0 0 0-1.5,-8zM16,21h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm58,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm58,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zM25.5,20A1.5,8 0 0 0 24,28h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1a1.5,8 0 0 0-1.5,-8zm58,0A1.5,8 0 0 0 82,28h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1a1.5,8 0 0 0-1.5,-8zm58,0a1.5,8 0 0 0-1.5,8h1a0.5,7 0 0 1 0.5,-7 0.5,7 0 0 1 0.5,7h1a1.5,8 0 0 0-1.5,-8zM16,24v0.75L18.25,28H19V27.25L16.75,24Zm58,0v0.75L76.25,28H77V27.25L74.75,24Zm58,0v0.75L134.25,28H135V27.25L132.75,24Z`,
			"write" => `m10,20a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H12A0.5,7 0 0 1 11.5,27 0.5,7 0 0 1 11,20Zm6,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm2,0v1h2v7h1v-7h1v-1zm6.5,0A1.5,1.5 0 0 0 28,21.5v5A1.5,1.5 0 0 0 29.5,28H31V27H29.5A0.5,0.5 0 0 1 29,26.5V25h2V24H29V21.5A0.5,0.5 0 0 1 29.5,21H31V20ZM68,20a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H70A0.5,7 0 0 1 69.5,27 0.5,7 0 0 1 69,20Zm6,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm2,0v1h2v7h1v-7h1v-1zm6.5,0A1.5,1.5 0 0 0 86,21.5v5A1.5,1.5 0 0 0 87.5,28H89V27H87.5A0.5,0.5 0 0 1 87,26.5V25h2V24H87V21.5A0.5,0.5 0 0 1 87.5,21H89v-1zm38.5,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8h-1a0.5,7 0 0 1-0.5,7 0.5,7 0 0 1-0.5,-7zm6,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm2,0v1h2v7h1v-7h1v-1zm6.5,0a1.5,1.5 0 0 0-1.5,1.5v5a1.5,1.5 0 0 0 1.5,1.5h1.5v-1h-1.5A0.5,0.5 0 0 1 145,26.5V25h2v-1h-2V21.5A0.5,0.5 0 0 1 145.5,21H147V20ZM17,21h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm58,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm58,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zM12,20a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H14A0.5,7 0 0 1 13.5,27 0.5,7 0 0 1 13,20Zm58,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8H72A0.5,7 0 0 1 71.5,27 0.5,7 0 0 1 71,20Zm58,0a1.5,8 0 0 0 1.5,8 1.5,8 0 0 0 1.5,-8h-1a0.5,7 0 0 1-0.5,7 0.5,7 0 0 1-0.5,-7zM17,24v0.75L19.25,28H20V27.25L17.75,24Zm58,0v0.75L77.25,28H78V27.25L75.75,24Zm58,0v0.75L135.25,28H136V27.25L133.75,24Z`,
		}}"/>
	</svg>`
}

private fn section(i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`24 24`, `35 35`, `46 46`][i]}">
		<path fill="magenta" d="M0,0V${[`11H1V1H11V0Zm23,14v9H13v1H24V14`, `16H1V1H16V0ZM34,21V34H19v1H35V21`, `21H1V1H21V0ZM45,27V45H25v1H46V27`][i]}Z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<rect fill=${global::main.lower.like.shadow(0.75)} x="1" y="1" width="22" height="22" rx="6" ry="6" transform="scale(${[1, 1.5, 2][i]})"/>
		</g>
	</svg>`
}

private fn small(icon, on, d, scale) { // d is 0 (left) or 2 (right)
	const colors = switchable("lower", on);
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 84 30" width="${84 * scale}" height="${30 * scale}">
		<path fill=${global::main.lower.like.shadow(0.5)} d="${switch d {
			0 => `M15,0A15,15 0 0 0 0,15 15,15 0 0 0 15,30H28V15 0ZM28,15A15,15 0 0 0 43,30H56V15 0H43A15,15 0 0 0 28,15Zm28,0A15,15 0 0 0 71,30H84V0H71A15,15 0 0 0 56,15Z`,
			2 => `M69,0A15,15 0 0 1 84,15 15,15 0 0 1 69,30H56V15 0ZM56,15A15,15 0 0 1 41,30H28V15 0H41A15,15 0 0 1 56,15ZM28,15A15,15 0 0 1 13,30H0V0h13a15,15 0 0 1 15,15z`,
		}}"/>
		
		<circle fill=${colors[0].out()} cx="${15 - d}" cy="15" r="11"/>
		<circle fill=${colors[1].out()} cx="${43 - d}" cy="15" r="11"/>
		<circle fill=${colors[2].out()} cx="${71 - d}" cy="15" r="11"/>
		
		<path fill=${global::main.lower.like.shadow(1)} d="M${15 - d},3A12,12 0 0 0 ${3 - d},15 12,12 0 0 0 ${15 - d},27 12,12 0 0 0 ${27 - d},15 12,12 0 0 0 ${15 - d},3ZM${43 - d},3A12,12 0 0 0 ${31 - d},15 12,12 0 0 0 ${43 - d},27 12,12 0 0 0 ${55 - d},15 12,12 0 0 0 ${43 - d},3ZM${71 - d},3A12,12 0 0 0 ${59 - d},15 12,12 0 0 0 ${71 - d},27 12,12 0 0 0 ${83 - d},15 12,12 0 0 0 ${71 - d},3ZM${15 - d},4A11,11 0 0 1 ${26 - d},15 11,11 0 0 1 ${15 - d},26 11,11 0 0 1 ${4 - d},15 11,11 0 0 1 ${15 - d},4ZM${43 - d},4A11,11 0 0 1 ${54 - d},15 11,11 0 0 1 ${43 - d},26 11,11 0 0 1 ${32 - d},15 11,11 0 0 1 ${43 - d},4ZM${71 - d},4A11,11 0 0 1 ${82 - d},15 11,11 0 0 1 ${71 - d},26 11,11 0 0 1 ${60 - d},15 11,11 0 0 1 ${71 - d},4Z"/>
		
		<path fill=${global::main.lower.like.shadow(0.50)} d="m${ 4 - d},15v3A11,11 0 0 0 ${15 - d},29 11,11 0 0 0 ${26 - d},18V15A11,11 0 0 1 ${15 - d},26 11,11 0 0 1 ${ 4 - d},15Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m${32 - d},15v3A11,11 0 0 0 ${43 - d},29 11,11 0 0 0 ${54 - d},18V15A11,11 0 0 1 ${43 - d},26 11,11 0 0 1 ${32 - d},15Z"/>
		<path fill=${global::main.lower.like.shadow(1.00)} d="m${60 - d},15v3A11,11 0 0 0 ${71 - d},29 11,11 0 0 0 ${82 - d},18V15A11,11 0 0 1 ${71 - d},26 11,11 0 0 1 ${60 - d},15Z"/>
		
		<path fill=${colors[3].out()} d="${switch icon {
			"end" => `m73,11v8h-2v-4-4zm-2,4-6,4V11ZM45,11v8h-2v-4-4zm-2,4-6,4V11ZM17,11v8h-2v-4-4zm-2,4-6,4v-8z`,
			"home" => `m11,11v8h2v-4-4zm2,4 6,4v-8zm26,-4v8h2v-4-4zm2,4 6,4v-8zm26,-4v8h2v-4-4zm2,4 6,4v-8z`,
			"next" => `m9,11v8l5,-4zm5,0 2,4 2,-4zm23,0v8l5,-4zm5,0 2,4 2,-4zm23,0v8l5,-4zm5,0 2,4 2,-4zm-55,4v4h2v-4zm28,0v4h2v-4zm28,0v4h2v-4z`,
			"pause" => `m9,11v8h3v-8zm5,0v8h3v-8zm23,0v8h3v-8zm5,0v8h3v-8zm23,0v8h3v-8zm5,0v8h3v-8z`,
			"previous" => `m10,11 2,3.5 2,-3.5zm9,0-5,4 5,4zm19,0 2,3.5 2,-3.5zm9,0-5,4 5,4zm19,0 2,3.5 2,-3.5zm9,0-5,4 5,4zm-64,4v4h2v-4zm28,0v4h2v-4zm28,0v4h2v-4z`,
			"repeat" => `m6,8v2h2a7,7 0 0 0-2,5 7,7 0 0 0 7,7V20A5,5 0 0 1 8,15 5,5 0 0 1 10,11v3h2V10 8 8Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4v-3h-2v4 2 0h2 4v-2h-2a7,7 0 0 0 2,-5 7,7 0 0 0-7,-7zm21,0v2h2a7,7 0 0 0-2,5 7,7 0 0 0 7,7v-2a5,5 0 0 1-5,-5 5,5 0 0 1 2,-4v3h2V10 8 8Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4v-3h-2v4 2 0h2 4v-2h-2a7,7 0 0 0 2,-5 7,7 0 0 0-7,-7zm21,0v2h2a7,7 0 0 0-2,5 7,7 0 0 0 7,7v-2a5,5 0 0 1-5,-5 5,5 0 0 1 2,-4v3h2V10 8 8Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4v-3h-2v4 2 0h2 4v-2h-2a7,7 0 0 0 2,-5 7,7 0 0 0-7,-7z`,
			"stop" => `m11,11v8h8v-8zm28,0v8h8v-8zm28,0v8h8v-8z`,
		}}"/>
	</svg>`
}

private fn record(icon, on, i) {
	const red = global::main.red;
	const colors = switch on {
		1 => [red.area, lab::mix(red.area, red.text, 0.1), lab::mix(red.area, red.text, 0.2), red.text],
		0 => [red.like.fade(0.3), red.like.fade(0.4), red.like.fade(0.5), global::main.lower.text],
	}; // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${on} ${on} ${[[`92 34`, `90 30`], [`137 50`, `135 45`], [`182 66`, `180 60`]][i][on]}">
		<path fill="magenta" d="M0,0V1H1V0Zm${[`91,31v3h1v-3`, `136,46v4h1v-4`, `181,61v5h1v-5`][i]}z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::main.lower.like.shadow(0.5)} d="M16,1A15,15 0 0 0 1,16 15,15 0 0 0 16,31H31V16 1ZM31,16A15,15 0 0 0 46,31H61V16 1H46A15,15 0 0 0 31,16Zm30,0A15,15 0 0 0 76,31H91V16 1H76A15,15 0 0 0 61,16Z"/>
				
				<circle fill=${colors[0].out()} cx="16" cy="16" r="14"/>
				<circle fill=${colors[1].out()} cx="46" cy="16" r="14"/>
				<circle fill=${colors[2].out()} cx="76" cy="16" r="14"/>
				
				<path fill=${global::main.lower.like.shadow(1)} d="M16,1A15,15 0 0 0 1,16 15,15 0 0 0 16,31 15,15 0 0 0 31,16 15,15 0 0 0 16,1ZM31,16A15,15 0 0 0 46,31 15,15 0 0 0 61,16 15,15 0 0 0 46,1 15,15 0 0 0 31,16Zm30,0A15,15 0 0 0 76,31 15,15 0 0 0 91,16 15,15 0 0 0 76,1 15,15 0 0 0 61,16ZM16,2A14,14 0 0 1 30,16 14,14 0 0 1 16,30 14,14 0 0 1 2,16 14,14 0 0 1 16,2ZM46,2A14,14 0 0 1 60,16 14,14 0 0 1 46,30 14,14 0 0 1 32,16 14,14 0 0 1 46,2ZM76,2A14,14 0 0 1 90,16 14,14 0 0 1 76,30 14,14 0 0 1 62,16 14,14 0 0 1 76,2Z"/>
				
				${if on == 0 { // xml
					`<path fill=${global::main.lower.like.shadow(0.50)} d="m2,16v3A14,14 0 0 0 16,33 14,14 0 0 0 30,19V16A14,14 0 0 1 16,30 14,14 0 0 1 2,16Z"/>
					 <path fill=${global::main.lower.like.shadow(0.75)} d="m32,16v3A14,14 0 0 0 46,33 14,14 0 0 0 60,19V16A14,14 0 0 1 46,30 14,14 0 0 1 32,16Z"/>
					 <path fill=${global::main.lower.like.shadow(1.00)} d="m62,16v3A14,14 0 0 0 76,33 14,14 0 0 0 90,19V16A14,14 0 0 1 76,30 14,14 0 0 1 62,16Z"/>`
				}}
				
				<path fill=${colors[3].out()} d="${switch icon {
					"none" => `m16,9a7,7 0 0 0-7,7 7,7 0 0 0 7,7 7,7 0 0 0 7,-7 7,7 0 0 0-7,-7zm30,0a7,7 0 0 0-7,7 7,7 0 0 0 7,7 7,7 0 0 0 7,-7 7,7 0 0 0-7,-7zm30,0a7,7 0 0 0-7,7 7,7 0 0 0 7,7 7,7 0 0 0 7,-7 7,7 0 0 0-7,-7zm-60,2a5,5 0 0 1 5,5 5,5 0 0 1-5,5 5,5 0 0 1-5,-5 5,5 0 0 1 5,-5zm30,0a5,5 0 0 1 5,5 5,5 0 0 1-5,5 5,5 0 0 1-5,-5 5,5 0 0 1 5,-5zm30,0a5,5 0 0 1 5,5 5,5 0 0 1-5,5 5,5 0 0 1-5,-5 5,5 0 0 1 5,-5z`,
					"item" => `M8,11V21H24V11Zm30,0V21H54V11Zm30,0V21H84V11Zm-58,2h12v6H10Zm30,0h12v6H40Zm30,0h12v6H70Z`,
					"loop" => `m9,9v2h2A7,7 0 0 0 9,16a7,7 0 0 0 7,7v-2a5,5 0 0 1-5,-5 5,5 0 0 1 2,-4V15h2V11 9 9Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4V17H17V21 23 23h6V21H21A7,7 0 0 0 23,16 7,7 0 0 0 16,9Zm23,0v2h2A7,7 0 0 0 39,16a7,7 0 0 0 7,7v-2a5,5 0 0 1-5,-5 5,5 0 0 1 2,-4V15h2V11 9 9Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4V17H47V21 23 23h6V21H51A7,7 0 0 0 53,16 7,7 0 0 0 46,9Zm23,0v2h2A7,7 0 0 0 69,16a7,7 0 0 0 7,7v-2a5,5 0 0 1-5,-5 5,5 0 0 1 2,-4V15h2V11 9 9Zm7,0v2a5,5 0 0 1 5,5 5,5 0 0 1-2,4V17H77V21 21 23 23h6V21H81A7,7 0 0 0 83,16 7,7 0 0 0 76,9Z`,
				}}"/>
			</g>
		</g>
	</svg>`
}

private fn play(synk, on, i) {
	const low    = global::main.lower;
	const acc    = global::main[global::accent];
	const colors = switch on {
		1 => [acc.area, lab::mix(acc.area, acc.text, 0.1), lab::mix(acc.area, acc.text, 0.2), acc.text],
		0 => [low.text.fade(0.7), low.text.fade(0.8), low.text.fade(0.9), low.like],
	}; // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="${on} ${on} ${[[`98 34`, `96 30`], [`146 50`, `144 45`], [`194 66`, `192 60`]][i][on]}">
		<path fill="magenta" d="M0,0V1H1V0Zm${[`97,31v3h1v-3z`, `145,46v4h1v-4z`, `193,61v5h1v-5z`][i]}"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::main.lower.like.shadow(0.5)} d="M3,1V31H33V1ZM35,1V31H65V1ZM67,1V31H97V1Z"/>
				
				<circle fill=${colors[0].out()} cx="18" cy="16" r="14"/>
				<circle fill=${colors[1].out()} cx="50" cy="16" r="14"/>
				<circle fill=${colors[2].out()} cx="82" cy="16" r="14"/>
				
				<path fill=${global::main.lower.like.shadow(1)} d="M18,1A15,15 0 0 0 3,16 15,15 0 0 0 18,31 15,15 0 0 0 33,16 15,15 0 0 0 18,1ZM50,1A15,15 0 0 0 35,16 15,15 0 0 0 50,31 15,15 0 0 0 65,16 15,15 0 0 0 50,1ZM82,1A15,15 0 0 0 67,16 15,15 0 0 0 82,31 15,15 0 0 0 97,16 15,15 0 0 0 82,1ZM18,2A14,14 0 0 1 32,16 14,14 0 0 1 18,30 14,14 0 0 1 4,16 14,14 0 0 1 18,2ZM50,2A14,14 0 0 1 64,16 14,14 0 0 1 50,30 14,14 0 0 1 36,16 14,14 0 0 1 50,2ZM82,2A14,14 0 0 1 96,16 14,14 0 0 1 82,30 14,14 0 0 1 68,16 14,14 0 0 1 82,2Z"/>
				
				${if on == 0 { // xml
					`<path fill=${global::main.lower.like.shadow(0.50)} d="m4,16v3A14,14 0 0 0 18,33 14,14 0 0 0 32,19V16A14,14 0 0 1 18,30 14,14 0 0 1 4,16Z"/>
					 <path fill=${global::main.lower.like.shadow(0.75)} d="m36,16v3A14,14 0 0 0 50,33 14,14 0 0 0 64,19V16A14,14 0 0 1 50,30 14,14 0 0 1 36,16Z"/>
					 <path fill=${global::main.lower.like.shadow(1.00)} d="m68,16v3A14,14 0 0 0 82,33 14,14 0 0 0 96,19V16A14,14 0 0 1 82,30 14,14 0 0 1 68,16Z"/>`
				}}
				
				<path fill=${colors[3].out()} d="${switch synk {
					true => `m18,11v10l10,-5zm32,0v10l10,-5zm32,0V21L92,16ZM12.5,12A2.5,2.5 0 0 0 10,14.5V16H9v4h7V16H15V14.5A2.5,2.5 0 0 0 12.5,12Zm32,0A2.5,2.5 0 0 0 42,14.5V16h-1v4h7V16H47V14.5A2.5,2.5 0 0 0 44.5,12Zm32,0A2.5,2.5 0 0 0 74,14.5V16h-1v4h7V16H79V14.5A2.5,2.5 0 0 0 76.5,12Zm-64,1A1.5,1.5 0 0 1 14,14.5V16H11V14.5A1.5,1.5 0 0 1 12.5,13Zm32,0A1.5,1.5 0 0 1 46,14.5V16H43V14.5A1.5,1.5 0 0 1 44.5,13Zm32,0A1.5,1.5 0 0 1 78,14.5V16H75V14.5A1.5,1.5 0 0 1 76.5,13Z`,
					_    => `m14,11v10l10,-5zm32,0v10l10,-5zm32,0v10l10,-5z`,
				}}"/>
			</g>
		</g>
	</svg>`
}

export const map = #{
	global_bypass: global("bypass", "red", 1),
	global_bypass_150: global("bypass", "red", 1.5),
	global_bypass_200: global("bypass", "red", 2),
	global_latch: global("latch", "magenta", 1),
	global_latch_150: global("latch", "magenta", 1.5),
	global_latch_200: global("latch", "magenta", 2),
	global_off: global("off", "lower", 1),
	global_off_150: global("off", "lower", 1.5),
	global_off_200: global("off", "lower", 2),
	global_preview: global("preview", "blue", 1),
	global_preview_150: global("preview", "blue", 1.5),
	global_preview_200: global("preview", "blue", 2),
	global_read: global("read", "green", 1),
	global_read_150: global("read", "green", 1.5),
	global_read_200: global("read", "green", 2),
	global_touch: global("touch", "yellow", 1),
	global_touch_150: global("touch", "yellow", 1.5),
	global_touch_200: global("touch", "yellow", 2),
	global_trim: global("trim", "any", 1),
	global_trim_150: global("trim", "any", 1.5),
	global_trim_200: global("trim", "any", 2),
	global_write: global("write", "cyan", 1),
	global_write_150: global("write", "cyan", 1.5),
	global_write_200: global("write", "cyan", 2),
	
	transport_bpm_bg: rectangle(0, 4, 4),
	transport_end: small("end", false, 2, 1),
	transport_end_150: small("end", false, 2, 1.5),
	transport_end_200: small("end", false, 2, 2),
	transport_group_bg: rectangle(0, 4, 4),
	transport_home: small("home", false, 0, 1),
	transport_home_150: small("home", false, 0, 1.5),
	transport_home_200: small("home", false, 0, 2),
	transport_next: small("next", false, 2, 1),
	transport_next_150: small("next", false, 2, 1.5),
	transport_next_200: small("next", false, 2, 2),
	transport_pause: small("pause", false, 2, 1),
	transport_pause_150: small("pause", false, 2, 1.5),
	transport_pause_200: small("pause", false, 2, 2),
	transport_pause_on: small("pause", true, 2, 1),
	transport_pause_on_150: small("pause", true, 2, 1.5),
	transport_pause_on_200: small("pause", true, 2, 2),
	transport_play: rectangle(0, 10, 10),
	transport_play_150: rectangle(0, 10, 10),
	transport_play_200: rectangle(0, 10, 10),
	transport_play_ol: play(false, 0, 0),
	transport_play_ol_150: play(false, 0, 1),
	transport_play_ol_200: play(false, 0, 2),
	transport_play_on: play(false, 1, 0),
	transport_play_on_150: play(false, 1, 1),
	transport_play_on_200: play(false, 1, 2),
	transport_play_sync: rectangle(0, 10, 10),
	transport_play_sync_150: rectangle(0, 10, 10),
	transport_play_sync_200: rectangle(0, 10, 10),
	transport_play_sync_ol: play(true, 0, 0),
	transport_play_sync_ol_150: play(true, 0, 1),
	transport_play_sync_ol_200: play(true, 0, 2),
	transport_play_sync_on: play(true, 1, 0),
	transport_play_sync_on_150: play(true, 1, 1),
	transport_play_sync_on_200: play(true, 1, 2),
	transport_previous: small("previous", false, 0, 1),
	transport_previous_150: small("previous", false, 0, 1.5),
	transport_previous_200: small("previous", false, 0, 2),
	transport_record: rectangle(0, 10, 10),
	transport_record_150: rectangle(0, 10, 10),
	transport_record_200: rectangle(0, 10, 10),
	transport_record_on: record("none", 1, 0),
	transport_record_on_150: record("none", 1, 1),
	transport_record_on_200: record("none", 1, 2),
	transport_record_ol: record("none", 0, 0),
	transport_record_ol_150: record("none", 0, 1),
	transport_record_ol_200: record("none", 0, 2),
	transport_record_item: rectangle(0, 10, 10),
	transport_record_item_150: rectangle(0, 10, 10),
	transport_record_item_200: rectangle(0, 10, 10),
	transport_record_item_on: record("item", 1, 0),
	transport_record_item_on_150: record("item", 1, 1),
	transport_record_item_on_200: record("item", 1, 2),
	transport_record_item_ol: record("item", 0, 0),
	transport_record_item_ol_150: record("item", 0, 1),
	transport_record_item_ol_200: record("item", 0, 2),
	transport_record_loop: rectangle(0, 10, 10),
	transport_record_loop_150: rectangle(0, 10, 10),
	transport_record_loop_200: rectangle(0, 10, 10),
	transport_record_loop_on: record("loop", 1, 0),
	transport_record_loop_on_150: record("loop", 1, 1),
	transport_record_loop_on_200: record("loop", 1, 2),
	transport_record_loop_ol: record("loop", 0, 0),
	transport_record_loop_ol_150: record("loop", 0, 1),
	transport_record_loop_ol_200: record("loop", 0, 2),
	transport_repeat_off: small("repeat", false, 2, 1),
	transport_repeat_off_150: small("repeat", false, 2, 1.5),
	transport_repeat_off_200: small("repeat", false, 2, 2),
	transport_repeat_on: small("repeat", true, 2, 1),
	transport_repeat_on_150: small("repeat", true, 2, 1.5),
	transport_repeat_on_200: small("repeat", true, 2, 2),
	transport_stop: small("stop", false, 0, 1),
	transport_stop_150: small("stop", false, 0, 1.5),
	transport_stop_200: small("stop", false, 0, 2), // xml
	
	transport_knob_bg_small: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 38 38">
		<path fill="yellow" d="M0,0V1H1V0Zm37,37v1h1v-1z"/>
		<path fill="magenta" d="M1,0V1H2V0ZM1,1H0v1h1zm36,35v1h1v-1zm0,1h-1v1h1z"/>
		<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, 1.0 / 3).out()} cx="19" cy="19" r="15.5"/>
	</svg>`, // xml
	
	transport_knob_bg_small_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 56 56">
		<path fill="yellow" d="m-2e-7,-2e-7v1h1v-1zM55,55v1h1v-1z"/>
		<path fill="magenta" d="m1,-2e-7v1h1v-1zm0,1h-1v1h1zM55,54v1h1v-1zm0,1h-1v1h1z"/>
		<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, 1.0 / 3).out()} stroke-width="1.5" cx="28" cy="28" r="23.25"/>
	</svg>`, // xml
	
	transport_knob_bg_small_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 74 74">
		<path fill="yellow" d="M0,0V1H1V0Zm73,73v1h1v-1z"/>
		<path fill="magenta" d="M1,0V1H3V0ZM1,1H0v2h1zm72,70v2h1v-2zm0,2h-2v1h2z"/>
		<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, 1.0 / 3).out()} stroke-width="2" cx="37" cy="37" r="31"/>
	</svg>`,
	
	transSectionBg: section(0),
	transSectionBg_150: section(1),
	transSectionBg_200: section(2),
}
