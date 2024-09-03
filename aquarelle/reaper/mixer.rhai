/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main     = main;
const lower_bg = lower_bg;

private fn env(icon, set, i) {
	const role = if set == "lower" { "text" } else { "like" };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${["68 34", "98 50", "134 66"][i]}">
		<path fill="magenta" d="M0,0V1H${[`2V0Zm66,33v1h2`, `2V0Zm96,49v1h2`, `3V0Zm131,65v1h3`][i]}v-1z"/>
		<g transform="translate(${[`0, 0`, `-0.45, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, `1.45, 1.5`, 2][i]})">
				<path fill=${global::main.lower.like.shadow(1)} d="M5,1A3,3 0 0 0 2,4v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 19,1Zm22,0a3,3 0 0 0-3,3v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 41,1Zm22,0a3,3 0 0 0-3,3v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 63,1ZM5,2h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H5A2,2 0 0 1 3,18V4A2,2 0 0 1 5,2Zm22,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H27A2,2 0 0 1 25,18V4a2,2 0 0 1 2,-2zm22,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H49A2,2 0 0 1 47,18V4a2,2 0 0 1 2,-2z"/>
				
				<path fill=${global::main[set][role].fade(0.2).out()} d="M5,2A2,2 0 0 0 3,4v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 19,2Z"/>
				<path fill=${global::main.lower.like.shadow(0.5)} d="m3,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H5A2,2 0 0 1 3,18Z"/>
				
				<path fill=${global::main[set][role].fade(0.3).out()} d="m27,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 41,2Z"/>
				<path fill=${global::main.lower.like.shadow(0.75)} d="m25,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H27a2,2 0 0 1-2,-2z"/>
				
				<path fill=${global::main[set][role].fade(0.4).out()} d="m49,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 63,2Z"/>
				<path fill=${global::main.lower.like.shadow(1)} d="m47,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H49a2,2 0 0 1-2,-2z"/>
				
				<path fill=${global::main[set][role].out()} d="m12,7a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm-39,4a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zM7,12a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0-2,-2zm-37.5,-3-1,1 3,3 1,-1zm22,0-1,1 3,3 1,-1zm22,0-1,1 3,3 1,-1zm-47,0.5-3,3 1,1 3,-3zm22,0-3,3 1,1 3,-3zm22,0-3,3 1,1 3,-3z"/>
				<path fill=${global::main.lower.text.out()} d="${switch icon {
					"latch" => `m1,25v8H2 4V32H2v-7zm6,0a2,2 0 0 0-2,2v6h1v-3h2v3H9V27A2,2 0 0 0 7,25Zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1 1 2v-1h-2v-7h-1-1v4h-2v-4zm10,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1 1 2v-1h-2v-7h-1-1v4h-2v-4zm10,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v1h2v7h1v-7h1v-1zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1v-8h-1v4H64V25ZM7,26a1,1 0 0 1 1,1v2H6v-2a1,1 0 0 1 1,-1zm22,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm22,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1z`,
					"preview" => `m2,25v8H3V30H4A2,2 0 0 0 6,28V27A2,2 0 0 0 4,25H3Zm5,0v8h1v-3h1a2,2 0 0 0 2,-2V27A2,2 0 0 0 9,25H8Zm6.5,0A1.5,1.5 0 0 0 12,26.5v5A1.5,1.5 0 0 0 13.5,33H15V32H13.5A0.5,0.5 0 0 1 13,31.5V30h2V29H13V26.5A0.5,0.5 0 0 1 13.5,26H15v-1zm2.5,0v6.5A1.5,1.5 0 0 0 17.5,33 1.5,1.5 0 0 0 19,31.5V25h-1v6.5A0.5,0.5 0 0 1 17.5,32 0.5,0.5 0 0 1 17,31.5V25Zm4,0v6.5h1V25Zm4,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 34,26.5v5A1.5,1.5 0 0 0 35.5,33H37V32H35.5A0.5,0.5 0 0 1 35,31.5V30h2V29H35V26.5A0.5,0.5 0 0 1 35.5,26H37v-1zm2.5,0v6.5A1.5,1.5 0 0 0 39.5,33 1.5,1.5 0 0 0 41,31.5V25h-1v6.5A0.5,0.5 0 0 1 39.5,32 0.5,0.5 0 0 1 39,31.5V25Zm4,0v6.5h1V25Zm4,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 56,26.5v5A1.5,1.5 0 0 0 57.5,33H59V32H57.5A0.5,0.5 0 0 1 57,31.5V30h2V29H57V26.5A0.5,0.5 0 0 1 57.5,26H59v-1zm2.5,0v6.5A1.5,1.5 0 0 0 61.5,33 1.5,1.5 0 0 0 63,31.5V25h-1v6.5A0.5,0.5 0 0 1 61.5,32 0.5,0.5 0 0 1 61,31.5V25Zm4,0v6.5h1V25ZM3,26h1a1,1 0 0 1 1,1v1A1,1 0 0 1 4,29H3Zm5,0h1a1,1 0 0 1 1,1v1A1,1 0 0 1 9,29H8Zm17,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm5,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm17,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm5,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1H52ZM8,29v0.75L10.25,33H11V32.25L8.75,29Zm22,0v0.75L32.25,33H33V32.25L30.75,29Zm22,0v0.75L54.25,33H55V32.25L52.75,29ZM18,31.5A1.5,1.5 0 0 0 19.5,33 1.5,1.5 0 0 0 21,31.5H20A0.5,0.5 0 0 1 19.5,32 0.5,0.5 0 0 1 19,31.5Zm22,0A1.5,1.5 0 0 0 41.5,33 1.5,1.5 0 0 0 43,31.5H42A0.5,0.5 0 0 1 41.5,32 0.5,0.5 0 0 1 41,31.5Zm22,0A1.5,1.5 0 0 0 63.5,33 1.5,1.5 0 0 0 65,31.5H64A0.5,0.5 0 0 1 63.5,32 0.5,0.5 0 0 1 63,31.5Z`,
					"read" => `m3,25v8H4V30H5A2,2 0 0 0 7,28V27A2,2 0 0 0 5,25H4Zm6.5,0A1.5,1.5 0 0 0 8,26.5v5A1.5,1.5 0 0 0 9.5,33H11V32H9.5A0.5,0.5 0 0 1 9,31.5V30h2V29H9V26.5A0.5,0.5 0 0 1 9.5,26H11v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm8,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 30,26.5v5A1.5,1.5 0 0 0 31.5,33H33V32H31.5A0.5,0.5 0 0 1 31,31.5V30h2V29H31V26.5A0.5,0.5 0 0 1 31.5,26H33v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2v-4a2,2 0 0 0-2,-2zm8,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6.5,0A1.5,1.5 0 0 0 52,26.5v5A1.5,1.5 0 0 0 53.5,33H55V32H53.5A0.5,0.5 0 0 1 53,31.5V30h2V29H53V26.5A0.5,0.5 0 0 1 53.5,26H55v-1zm4.5,0a2,2 0 0 0-2,2v6h1v-3h2v3h1v-6a2,2 0 0 0-2,-2zm3,0v8h2a2,2 0 0 0 2,-2V27A2,2 0 0 0 63,25ZM4,26h1a1,1 0 0 1 1,1v1A1,1 0 0 1 5,29H4Zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1h-1zm8,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1h-1zm8,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm10,0a1,1 0 0 1 1,1v2h-2v-2a1,1 0 0 1 1,-1zm4,0h1a1,1 0 0 1 1,1v4a1,1 0 0 1-1,1H62ZM4,29v0.75L6.25,33H7V32.25L4.75,29Zm22,0v0.75L28.25,33H29V32.25L26.75,29Zm22,0v0.75L50.25,33H51V32.25L48.75,29Z`,
					"touch" => `m1,25v1h1v7h1v-7h2v-1zm9,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V28.5 25h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V28.5 25Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1v-7h1v7h1v-7h2v-1h-4-1v4h-2v-4zm13,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V28.5 25h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V28.5 25Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1v-7h1v7h1v-7h2v-1h-4-1v4h-2v-4zm13,0v3.5 2.5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V28.5 25h-1v3.5 2.5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1V28.5 25Zm8,0a3,3 0 0 0-3,3v2a3,3 0 0 0 3,3v-1a2,2 0 0 1-2,-2v-2a2,2 0 0 1 2,-2zm1,0v8h1v-3h2v3h1v-7-1h-1v4H64V25ZM7,26a2,2 0 0 0-2,2v1 1 1a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V30 29 28A2,2 0 0 0 7,26Zm22,0a2,2 0 0 0-2,2v1 1 1a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-1-1-1a2,2 0 0 0-2,-2zm22,0a2,2 0 0 0-2,2v1 1 1a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V30 29 28A2,2 0 0 0 51,26ZM7,27a1,1 0 0 1 1,1v1 1 1A1,1 0 0 1 7,32 1,1 0 0 1 6,31v-1-1-1a1,1 0 0 1 1,-1zm22,0a1,1 0 0 1 1,1v1 1 1a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-1-1-1a1,1 0 0 1 1,-1zm22,0a1,1 0 0 1 1,1v1 1 1a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-1-1-1a1,1 0 0 1 1,-1z`,
					"trim" => `m3,25v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2V27A2,2 0 0 0 10,25H9Zm5,0v8h1v-8zm3.5,0A1.5,1.5 0 0 0 15,26.5V33h1V26.5A0.5,0.5 0 0 1 16.5,26 0.5,0.5 0 0 1 17,26.5V33h1V26.5A1.5,1.5 0 0 0 16.5,25Zm8.5,0v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm3.5,0A1.5,1.5 0 0 0 37,26.5V33h1V26.5A0.5,0.5 0 0 1 38.5,26 0.5,0.5 0 0 1 39,26.5V33h1V26.5A1.5,1.5 0 0 0 38.5,25Zm8.5,0v1h2v7h1v-7h1v-1zm5,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm5,0v8h1v-8zm3.5,0A1.5,1.5 0 0 0 59,26.5V33h1V26.5A0.5,0.5 0 0 1 60.5,26 0.5,0.5 0 0 1 61,26.5V33h1V26.5A1.5,1.5 0 0 0 60.5,25ZM9,26h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1H9Zm22,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm22,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1H53ZM19,26.5V33h1v-6.5zm22,0V33h1v-6.5zm22,0V33h1V26.5ZM18.5,25A1.5,1.5 0 0 0 17,26.5h1A0.5,0.5 0 0 1 18.5,26 0.5,0.5 0 0 1 19,26.5h1A1.5,1.5 0 0 0 18.5,25Zm22,0A1.5,1.5 0 0 0 39,26.5h1A0.5,0.5 0 0 1 40.5,26 0.5,0.5 0 0 1 41,26.5h1A1.5,1.5 0 0 0 40.5,25Zm22,0A1.5,1.5 0 0 0 61,26.5h1A0.5,0.5 0 0 1 62.5,26 0.5,0.5 0 0 1 63,26.5h1A1.5,1.5 0 0 0 62.5,25ZM9,29v0.75L11.25,33H12V32.25L9.75,29Zm22,0v0.75L33.25,33H34V32.25L31.75,29Zm22,0v0.75L55.25,33H56V32.25L53.75,29Z`,
					"write" => `m2,25v6.5A1.5,1.5 0 0 0 3.5,33 1.5,1.5 0 0 0 5,31.5V25H4v6.5A0.5,0.5 0 0 1 3.5,32 0.5,0.5 0 0 1 3,31.5V25Zm4,0v6.5H7V25Zm2,0v8h1v-3h1a2,2 0 0 0 2,-2V27A2,2 0 0 0 10,25H9Zm6,0v1h2v7h1v-7h1v-1zm6.5,0A1.5,1.5 0 0 0 19,26.5v5A1.5,1.5 0 0 0 20.5,33H22V32H20.5A0.5,0.5 0 0 1 20,31.5V30h2V29H20V26.5A0.5,0.5 0 0 1 20.5,26H22v-1zm3.5,0v6.5A1.5,1.5 0 0 0 25.5,33 1.5,1.5 0 0 0 27,31.5V25h-1v6.5A0.5,0.5 0 0 1 25.5,32 0.5,0.5 0 0 1 25,31.5V25Zm4,0v6.5h1V25Zm2,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6,0v1h2v7h1v-7h1v-1zm6.5,0A1.5,1.5 0 0 0 41,26.5v5A1.5,1.5 0 0 0 42.5,33H44V32H42.5A0.5,0.5 0 0 1 42,31.5V30h2V29H42V26.5A0.5,0.5 0 0 1 42.5,26H44v-1zm3.5,0v6.5A1.5,1.5 0 0 0 47.5,33 1.5,1.5 0 0 0 49,31.5V25h-1v6.5A0.5,0.5 0 0 1 47.5,32 0.5,0.5 0 0 1 47,31.5V25Zm4,0v6.5h1V25Zm2,0v8h1v-3h1a2,2 0 0 0 2,-2v-1a2,2 0 0 0-2,-2h-1zm6,0v1h2v7h1v-7h1v-1zm6.5,0A1.5,1.5 0 0 0 63,26.5v5A1.5,1.5 0 0 0 64.5,33H66V32H64.5A0.5,0.5 0 0 1 64,31.5V30h2V29H64V26.5A0.5,0.5 0 0 1 64.5,26H66V25ZM9,26h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1H9Zm22,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm22,0h1a1,1 0 0 1 1,1v1a1,1 0 0 1-1,1h-1zm-40,1v6h1v-6zm22,0v6h1v-6zm22,0v6h1V27ZM9,29v0.75L11.25,33H12V32.25L9.75,29Zm22,0v0.75L33.25,33H34V32.25L31.75,29Zm22,0v0.75L55.25,33H56V32.25L53.75,29ZM4,31.5A1.5,1.5 0 0 0 5.5,33 1.5,1.5 0 0 0 7,31.5H6A0.5,0.5 0 0 1 5.5,32 0.5,0.5 0 0 1 5,31.5Zm22,0A1.5,1.5 0 0 0 27.5,33 1.5,1.5 0 0 0 29,31.5H28A0.5,0.5 0 0 1 27.5,32 0.5,0.5 0 0 1 27,31.5Zm22,0A1.5,1.5 0 0 0 49.5,33 1.5,1.5 0 0 0 51,31.5H50A0.5,0.5 0 0 1 49.5,32 0.5,0.5 0 0 1 49,31.5Z`,
				}}"/>
			</g>
		</g>
	</svg>`
}

private fn fxlist(set, i) {
	const role = if set == "lower" { "text" } else { "like" };
	const c = if set == "cyan" { 1 } else { 0 };
	// xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`22 62`, `32 92`, `42 122`][i]}">
		<path fill="yellow" d="M0,0V1H1V0Zm${[`21,61v1h1v-1z`, `31,91v1h1v-1z`, `41,121v1h1v-1z`][i]}"/>
		<path fill="magenta" d="M1,0V1H${[`6V0ZM1,1H0v5h1zm20,56v4h1v-4zm0,4h-4v1h4`, `8V0ZM1,1H0v7h1zm30,84v6h1v-6zm0,6h-6v1h6`, `11V0ZM1,1H0v10h1zm40,112v8h1v-8zm0,8h-8v1h8`][i]}z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<rect fill=${global::main[set][role].fade([0.2, 0.0][c]).out()} x="1" y=" 2" width="20" height="18" rx="3" ry="3"/>
				<rect fill=${global::main[set][role].fade([0.3, 0.2][c]).out()} x="1" y="22" width="20" height="18" rx="3" ry="3"/>
				<rect fill=${global::main[set][role].fade([0.4, 0.3][c]).out()} x="1" y="42" width="20" height="18" rx="3" ry="3"/>
			</g>
		</g>
	</svg>`
}

private fn io(wiring, i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${["68 34", "98 50", "134 66"][i]}">
		<path fill="magenta" d="M0,0V1H${[`2V0Zm66,33v1h2`, `2V0Zm96,49v1h2`, `3V0Zm131,65v1h3`][i]}v-1z"/>
		<g transform="translate(${[`0, 0`, `-0.45, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, `1.45, 1.5`, 2][i]})">
				<path fill=${global::main.lower.like.shadow(1)} d="M5,1A3,3 0 0 0 2,4v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 19,1Zm22,0a3,3 0 0 0-3,3v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 41,1Zm22,0a3,3 0 0 0-3,3v14a3,3 0 0 0 3,3h14a3,3 0 0 0 3,-3V4A3,3 0 0 0 63,1ZM5,2h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H5A2,2 0 0 1 3,18V4A2,2 0 0 1 5,2Zm22,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H27A2,2 0 0 1 25,18V4a2,2 0 0 1 2,-2zm22,0h14a2,2 0 0 1 2,2v14a2,2 0 0 1-2,2H49A2,2 0 0 1 47,18V4a2,2 0 0 1 2,-2z"/>
				
				<path fill=${global::main.lower.text.fade(0.2).out()} d="M5,2A2,2 0 0 0 3,4v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 19,2Z"/>
				<path fill=${global::main.lower.like.shadow(0.5)} d="m3,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H5A2,2 0 0 1 3,18Z"/>
				
				<path fill=${global::main.lower.text.fade(0.3).out()} d="m27,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 41,2Z"/>
				<path fill=${global::main.lower.like.shadow(0.75)} d="m25,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H27a2,2 0 0 1-2,-2z"/>
				
				<path fill=${global::main.lower.text.fade(0.4).out()} d="m49,2a2,2 0 0 0-2,2v14a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2V4A2,2 0 0 0 63,2Z"/>
				<path fill=${global::main.lower.like.shadow(1)} d="m47,18v3a2,2 0 0 0 2,2h14a2,2 0 0 0 2,-2v-3a2,2 0 0 1-2,2H49a2,2 0 0 1-2,-2z"/>
				
				<path fill=${global::main.green .area.fade((wiring & 0b100) >> 2 / 1.5 + 1 / 3.0).out()} d="M7,2 3,13v6c0.75,1.1875 2,1 2,1L11.5,2Zm22,0-4,11v6c0.75,1.1875 2,1 2,1L33.5,2Zm22,0-4,11v6c0.75,1.1875 2,1 2,1L55.5,2Z"/>
				<path fill=${global::main.yellow.area.fade((wiring & 0b010) >> 1 / 1.5 + 1 / 3.0).out()} d="M13,2 6.5,20H11L17.5,2ZM35,2 28.5,20H33L39.5,2ZM57,2 50.5,20H55L61.5,2Z"/>
				<path fill=${global::main.blue  .area.fade((wiring & 0b001)      / 1.5 + 1 / 3.0).out()} d="M19,2 12.5,20H17L21,9V4C21,2.875 20.125,2 19,2ZM41,2 34.5,20H39L43,9V4C43,2.875 42.125,2 41,2ZM63,2 56.5,20H61L65,9V4C65,2.875 64.125,2 63,2Z"/>
				
				<path fill=${global::main.lower.text.out()} d="m1,25v7H2V29H3A2,2 0 0 0 5,27 2,2 0 0 0 3,25H2Zm7,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2V27A2,2 0 0 0 8,25Zm3,0v5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-5h-1v5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-5zm5,0v1h1v6h1v-6h1v-1zm5.5,0A1.5,1.5 0 0 0 20,26.5v4a1.5,1.5 0 0 0 1.5,1.5h1.5 1v-3h1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2h-1-1zm8.5,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-3a2,2 0 0 0-2,-2zm3,0v5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-5h-1v5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-5zm5,0v1h1v6h1v-6h1v-1zm5.5,0A1.5,1.5 0 0 0 42,26.5v4a1.5,1.5 0 0 0 1.5,1.5h1.5 1v-3h1a2,2 0 0 0 2,-2 2,2 0 0 0-2,-2h-1-1zm8.5,0a2,2 0 0 0-2,2v3a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-3a2,2 0 0 0-2,-2zm3,0v5a2,2 0 0 0 2,2 2,2 0 0 0 2,-2v-5h-1v5a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-5zm5,0v1h1v6h1v-6h1v-1zm5.5,0A1.5,1.5 0 0 0 64,26.5v4A1.5,1.5 0 0 0 65.5,32H67V31H65.5A0.5,0.5 0 0 1 65,30.5V29h2V28H65V26.5A0.5,0.5 0 0 1 65.5,26H67V25ZM2,26h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1H2Zm6,0a1,1 0 0 1 1,1v3A1,1 0 0 1 8,31 1,1 0 0 1 7,30v-3a1,1 0 0 1 1,-1zm13.5,0H23v2H21V26.5A0.5,0.5 0 0 1 21.5,26Zm2.5,0h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v3a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-3a1,1 0 0 1 1,-1zm13.5,0H45v2H43V26.5A0.5,0.5 0 0 1 43.5,26Zm2.5,0h1a1,1 0 0 1 1,1 1,1 0 0 1-1,1h-1zm6,0a1,1 0 0 1 1,1v3a1,1 0 0 1-1,1 1,1 0 0 1-1,-1v-3a1,1 0 0 1 1,-1zm-31,3h2v2H21.5A0.5,0.5 0 0 1 21,30.5Zm22,0h2v2H43.5A0.5,0.5 0 0 1 43,30.5ZM2,28v0.75L4.25,32H5V31.25L2.75,28Zm22,0v0.75L26.25,32H27V31.25L24.75,28Zm22,0v0.75L48.25,32H49V31.25L46.75,28Z"/>
			</g>
		</g>
	</svg>`
}

private fn volbg(i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`26 22`, `38 32`, `50 42`][i]}">
		<path fill="magenta" d="M0,0V1${[`0H1V1H12V0Zm25,12v9H14v1H26V12`, `5H1V1H18V0ZM37,17V31H20v1H38V17`, `9H1V1H23V0ZM49,23V41H27v1H50V23`][i]}Z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::lower_bg.out()} d="M1,1V21H25V1Z"/>
				<path fill=${global::main.lower.text.fade(0.25).out()} d="m12,10v2h2v-2z"/>
			</g>
		</g>
	</svg>`
}

private fn volthumb(i) { // xml
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${[`24 53`, `36 80`, `47 104`][i]}">
		<path fill="magenta" d="m${[`23,0v5h1V0Zm0,48v5h1v-5`, `35,0v8h1V0Zm0,72v8h1v-8`, `46,0v9h1V0Zm0,95v9h1v-9`][i]}z"/>
		<g transform="translate(${[`0, 0`, `-0.5, -0.5`, `-1, -1`][i]})">
			<g transform="scale(${[1, 1.5, 2][i]})">
				<path fill=${global::main.lower.like.shadow(1)} d="M11.5,5A10.5,10.5 0 0 0 1,15.5V23a3,3 0 0 0 3,3h15a3,3 0 0 0 3,-3V15.5A10.5,10.5 0 0 0 11.5,5Zm0,1A9.5,9.5 0 0 1 21,15.5V23a2,2 0 0 1-2,2H4A2,2 0 0 1 2,23V15.5A9.5,9.5 0 0 1 11.5,6ZM4,27a3,3 0 0 0-3,3v7.5A10.5,10.5 0 0 0 11.5,48 10.5,10.5 0 0 0 22,37.5V30a3,3 0 0 0-3,-3zm0,1h15a2,2 0 0 1 2,2v7.5A9.5,9.5 0 0 1 11.5,47 9.5,9.5 0 0 1 2,37.5V30a2,2 0 0 1 2,-2z"/>
				<path fill=${lab::mix(global::lower_bg, global::main.lower.text, 0.5).fade(0.75).out()} d="M11.5,6A9.5,9.5 0 0 0 2,15.5v0.5 6 1a2,2 0 0 0 2,2h1 14a2,2 0 0 0 2,-2V22 16 15.5A9.5,9.5 0 0 0 11.5,6ZM4,28a2,2 0 0 0-2,2v1 6 0.5A9.5,9.5 0 0 0 11.5,47 9.5,9.5 0 0 0 21,37.5V37 31 30A2,2 0 0 0 19,28H5Z"/>
				<path fill=${global::main.lower.like.shadow(0.5)} d="m2,37.5v5A9.5,9.5 0 0 0 11.5,52 9.5,9.5 0 0 0 21,42.5v-5A9.5,9.5 0 0 1 11.5,47 9.5,9.5 0 0 1 2,37.5Z"/>
			</g>
		</g>
	</svg>`
} // xml

const env = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 62 34">
	<path fill="magenta" d="M0,0V23H1V0Zm61,33v1h1v-1z"/>
</svg>`; // xml

const env_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 92 50">
	<path fill="magenta" d="M0,0V34H1V0Zm91,49v1h1v-1z"/>
</svg>`; // xml

const env_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 122 66">
	<path fill="magenta" d="M0,0V45H1V0Zm121,65v1h1v-1z"/>
</svg>`; // xml

export const map = #{
	tcp_fxlist_bg: rectangle(0, 10, 10),
	tcp_fxlist_byp: fxlist("yellow", 0),
	tcp_fxlist_byp_150: fxlist("yellow", 1),
	tcp_fxlist_byp_200: fxlist("yellow", 2),
	tcp_fxlist_empty: fxlist("cyan", 0),
	tcp_fxlist_empty_150: fxlist("cyan", 1),
	tcp_fxlist_empty_200: fxlist("cyan", 2),
	tcp_fxlist_norm: fxlist("lower", 0),
	tcp_fxlist_norm_150: fxlist("lower", 1),
	tcp_fxlist_norm_200: fxlist("lower", 2),
	tcp_fxlist_off: fxlist("red", 0),
	tcp_fxlist_off_150: fxlist("red", 1),
	tcp_fxlist_off_200: fxlist("red", 2),
	
	mcp_env_latch: env,
	mcp_env_latch_150: env_150,
	mcp_env_latch_200: env_200,
	mcp_env_latch_ol: env("latch", "magenta", 0),
	mcp_env_latch_ol_150: env("latch", "magenta", 1),
	mcp_env_latch_ol_200: env("latch", "magenta", 2),
	mcp_env_preview: env,
	mcp_env_preview_150: env_150,
	mcp_env_preview_200: env_200,
	mcp_env_preview_ol: env("preview", "blue", 0),
	mcp_env_preview_ol_150: env("preview", "blue", 1),
	mcp_env_preview_ol_200: env("preview", "blue", 2),
	mcp_env_read: env,
	mcp_env_read_150: env_150,
	mcp_env_read_200: env_200,
	mcp_env_read_ol: env("read", "green", 0),
	mcp_env_read_ol_150: env("read", "green", 1),
	mcp_env_read_ol_200: env("read", "green", 2),
	mcp_env_touch: env,
	mcp_env_touch_150: env_150,
	mcp_env_touch_200: env_200,
	mcp_env_touch_ol: env("touch", "yellow", 0),
	mcp_env_touch_ol_150: env("touch", "yellow", 1),
	mcp_env_touch_ol_200: env("touch", "yellow", 2),
	mcp_env: env,
	mcp_env_150: env_150,
	mcp_env_200: env_200,
	mcp_env_ol: env("trim", "lower", 0),
	mcp_env_ol_150: env("trim", "lower", 1),
	mcp_env_ol_200: env("trim", "lower", 2),
	mcp_env_write: env,
	mcp_env_write_150: env_150,
	mcp_env_write_200: env_200,
	mcp_env_write_ol: env("write", "cyan", 0),
	mcp_env_write_ol_150: env("write", "cyan", 1),
	mcp_env_write_ol_200: env("write", "cyan", 2), // xml
	
	mcp_extmixbg: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 7">
		<path fill="yellow" d="M0,0V1H3V0ZM7,6V7H8V6Z"/>
		<path fill="magenta" d="M3,0V1H4V0ZM0,1V2H1V1ZM7,5V6H8V5ZM7,6H6v1h1z"/>
		<path fill=${lower_bg.out()} d="M1 1L1 6L7 6L7 1L1 1z"/>
		<path fill=${lower_bg.shadow(1)} d="M1 1L1 6L2 6L2 1L1 1z"/>
	</svg>`, // xml
	
	mcp_fxlist_bg: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 84 4">
		<path fill="magenta" d="M0,0V1H24V0ZM83,2V3H60V4H84V3 2Z"/>
		<path fill=${main.lower.text.fade(0.25).out()} d="M24,2V3H60V2Z"/>
	</svg>`,
	
	mcp_fxlist_byp: fxlist("yellow", 0),
	mcp_fxlist_byp_150: fxlist("yellow", 1),
	mcp_fxlist_byp_200: fxlist("yellow", 2),
	mcp_fxlist_empty: fxlist("cyan", 0),
	mcp_fxlist_empty_150: fxlist("cyan", 1),
	mcp_fxlist_empty_200: fxlist("cyan", 2),
	mcp_fxlist_norm: fxlist("lower", 0),
	mcp_fxlist_norm_150: fxlist("lower", 1),
	mcp_fxlist_norm_200: fxlist("lower", 2),
	mcp_fxlist_off: fxlist("red", 0),
	mcp_fxlist_off_150: fxlist("red", 1),
	mcp_fxlist_off_200: fxlist("red", 2),
	
	mcp_io_dis_ol: io(0b000, 0),
	mcp_io_dis: env,
	mcp_io_ol: io(0b100, 0),
	mcp_io_r_dis_ol: io(0b001, 0),
	mcp_io_r_dis: env,
	mcp_io_r_ol: io(0b101, 0),
	mcp_io_r: env,
	mcp_io_s_dis_ol: io(0b010, 0),
	mcp_io_s_dis: env,
	mcp_io_s_ol: io(0b110, 0),
	mcp_io_s_r_dis_ol: io(0b011, 0),
	mcp_io_s_r_dis: env,
	mcp_io_s_r_ol: io(0b111, 0),
	mcp_io_s_r: env,
	mcp_io_s: env,
	mcp_io: env,
	
	mcp_io_dis_ol_150: io(0b000, 1),
	mcp_io_dis_150: env_150,
	mcp_io_ol_150: io(0b100, 1),
	mcp_io_r_dis_ol_150: io(0b001, 1),
	mcp_io_r_dis_150: env_150,
	mcp_io_r_ol_150: io(0b101, 1),
	mcp_io_r_150: env_150,
	mcp_io_s_dis_ol_150: io(0b010, 1),
	mcp_io_s_dis_150: env_150,
	mcp_io_s_ol_150: io(0b110, 1),
	mcp_io_s_r_dis_ol_150: io(0b011, 1),
	mcp_io_s_r_dis_150: env_150,
	mcp_io_s_r_ol_150: io(0b111, 1),
	mcp_io_s_r_150: env_150,
	mcp_io_s_150: env_150,
	mcp_io_150: env_150,
	
	mcp_io_dis_ol_200: io(0b000, 2),
	mcp_io_dis_200: env_200,
	mcp_io_ol_200: io(0b100, 2),
	mcp_io_r_dis_ol_200: io(0b001, 2),
	mcp_io_r_dis_200: env_200,
	mcp_io_r_ol_200: io(0b101, 2),
	mcp_io_r_200: env_200,
	mcp_io_s_dis_ol_200: io(0b010, 2),
	mcp_io_s_dis_200: env_200,
	mcp_io_s_ol_200: io(0b110, 2),
	mcp_io_s_r_dis_ol_200: io(0b011, 2),
	mcp_io_s_r_dis_200: env_200,
	mcp_io_s_r_ol_200: io(0b111, 2),
	mcp_io_s_r_200: env_200,
	mcp_io_s_200: env_200,
	mcp_io_200: env_200,
	
	mcp_volbg: volbg(0),
	mcp_volbg_150: volbg(1),
	mcp_volbg_200: volbg(2),
	
	mcp_volthumb: volthumb(0),
	mcp_volthumb_150: volthumb(1),
	mcp_volthumb_200: volthumb(2),
	
	meter_bg_h: rectangle(lower_bg, 6, 6),
	meter_bg_v: rectangle(lower_bg, 6, 6), // xml
	
	meter_clip_h: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 4">
		<rect fill=${lower_bg.out()} width="4" height="4"/>
		<rect fill=${main.red.area.out()} width="4" height="4" x="4"/>
	</svg>`, // xml
	
	meter_clip_v: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 8">
		<rect fill=${lower_bg.out()} width="4" height="4"/>
		<rect fill=${main.red.area.out()} width="4" height="4" y="4"/>
	</svg>`, // xml
	
	meter_clip_v_rms2: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 4">
		<rect fill=${lower_bg.out()} width="4" height="2"/>
		<rect fill=${main.green.area.out()} width="4" height="2" y="2"/>
	</svg>`, // xml
	
	meter_strip_h: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 16">
		<rect fill=${main.green.area.out()} width="4" height="2" y="2"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" y="4"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" y="6"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).fade(0.3).out()} width="4" height="2" y="8"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).out()} width="4" height="2" y="10"/>
		<rect fill=${main.magenta.area.fade(0.3).out()} width="4" height="2" y="12"/>
		<rect fill=${main.magenta.area.out()} width="4" height="2" y="14"/>
	</svg>`, // xml
	
	meter_strip_h_rms: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2 32">
		<rect fill=${main.green.area.fade(0.8).out()} width="2" height="4" y="4"/>
		<rect fill=${main.lower.text.fade(0.3).out()} width="2" height="4" y="8"/>
		<rect fill=${main.green.area.out()} width="2" height="4" y="12"/>
		<rect fill=${main.red.area.fade(2.0 / 3).out()} width="2" height="4" y="16"/>
		<rect fill=${main.any.area.out()} width="2" height="4" y="20"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="2" height="4" y="24"/>
		<rect fill=${main.yellow.area.out()} width="2" height="4" y="28"/>
	</svg>`, // xml
	
	meter_strip_v: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 2">
		<rect fill=${main.green.area.out()} width="4" height="2" x="4"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" x="8"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" x="12"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).fade(0.3).out()} width="4" height="2" x="16"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).out()} width="4" height="2" x="20"/>
		<rect fill=${main.magenta.area.fade(0.3).out()} width="4" height="2" x="24"/>
		<rect fill=${main.magenta.area.out()} width="4" height="2" x="28"/>
	</svg>`, // xml
	
	meter_strip_v_rms: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 2">
		<rect fill=${main.green.area.fade(0.8).out()} width="4" height="2" x="4"/>
		<rect fill=${main.lower.text.fade(0.3).out()} width="4" height="2" x="8"/>
		<rect fill=${main.green.area.out()} width="4" height="2" x="12"/>
		<rect fill=${main.red.area.fade(2.0 / 3).out()} width="4" height="2" x="16"/>
		<rect fill=${main.any.area.out()} width="4" height="2" x="20"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" x="24"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" x="28"/>
	</svg>`,
}
