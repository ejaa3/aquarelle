/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn left(home, scale) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 87 29" width="${87 * scale}" height="${29 * scale}">
		<path fill=${global::main.lower.text.fade(0.2).out()} d="M13,2C1,2 1,13.5 1,13.5 1,13.5 1,25 13,25H28V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M1,13.5C1,13.5 1,25 13,25h15v4H13C1,29 1,13.5 1,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.3).out()} d="M42,2C30,2 30,13.5 30,13.5c0,0 0,11.5 12,11.5H57V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m30,13.5c0,0 0,11.5 12,11.5h15v4H42C30,29 30,13.5 30,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.4).out()} d="M71,2C59,2 59,13.5 59,13.5c0,0 0,11.5 12,11.5H86V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m59,13.5c0,0 0,11.5 12,11.5h15v4H71C59,29 59,13.5 59,13.5Z"/>
		
		<path fill=${global::main.lower.text.out()} d="${switch home {
			true => `M11 9L11 18L13 18L13 9L11 9zM21 9L14 13.5L21 18L21 9zM40 9L40 18L42 18L42 9L40 9zM50 9L43 13.5L50 18L50 9zM69 9L69 18L71 18L71 9L69 9zM79 9L72 13.5L79 18L79 9z`,
			   _ => `M10 9L12 12L14 9L10 9zM21 9L14 13.5L21 18L21 9zM39 9L41 12L43 9L39 9zM50 9L43 13.5L50 18L50 9zM68 9L70 12L72 9L68 9zM79 9L72 13.5L79 18L79 9zM11 13L11 18L13 18L13 13L11 13zM40 13L40 18L42 18L42 13L40 13zM69 13L69 18L71 18L71 13L69 13z`
		}}"/>
	</svg>`
}

fn left_150(home) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 132 44">
		<path fill=${global::main.lower.text.fade(0.2).out()} d="M18.5 2A17.5 17.5 0 0 0 1 19.5A17.5 17.5 0 0 0 18.5 37L43 37L43 2L18.5 2z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M1 19.5L1 25.5A17.5 17.5 0 0 0 18.5 43L43 43L43 37L18.5 37A17.5 17.5 0 0 1 1 19.5z"/>
		
		<path fill=${global::main.lower.text.fade(0.3).out()} d="M62.5,2A17.5,17.5 0 0 0 45,19.5 17.5,17.5 0 0 0 62.5,37H87V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m45,19.5v6A17.5,17.5 0 0 0 62.5,43H87V37H62.5A17.5,17.5 0 0 1 45,19.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.4).out()} d="M106.5,2A17.5,17.5 0 0 0 89,19.5 17.5,17.5 0 0 0 106.5,37H131V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m89,19.5v6A17.5,17.5 0 0 0 106.5,43H131V37H106.5A17.5,17.5 0 0 1 89,19.5Z"/>
		
		<path fill=${global::main.lower.text.out()} d="${switch home {
			true => `m17,13v13h3V13Zm15,0 -10,6.5 10,6.5zm29,0v13h3V13Zm15,0 -10,6.5 10,6.5zm29,0v13h3V13Zm15,0 -10,6.5 10,6.5z`,
			   _ => `m16,13 2.5,5 2.5,-5zm16,0 -10,6.5 10,6.5zm28,0 2.5,5 2.5,-5zm16,0 -10,6.5 10,6.5zm28,0 2.5,5 2.5,-5zm16,0 -10,6.5 10,6.5zM17,19v7h3v-7zm44,0v7h3v-7zm44,0v7h3v-7z`
		}}"/>
	</svg>`
}

fn right(end, scale) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 84 29" width="${84 * scale}" height="${29 * scale}">
		<path fill=${global::main.lower.text.fade(0.2).out()} d="m15,2c12,0 12,11.5 12,11.5 0,0 0,11.5 -12,11.5H0V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M27,13.5C27,13.5 27,25 15,25H0v4H15C27,29 27,13.5 27,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.3).out()} d="m43,2c12,0 12,11.5 12,11.5 0,0 0,11.5 -12,11.5H28V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="M55,13.5C55,13.5 55,25 43,25H28v4H43C55,29 55,13.5 55,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.4).out()} d="M71,2C83,2 83,13.5 83,13.5 83,13.5 83,25 71,25H56V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="M83,13.5C83,13.5 83,25 71,25H56v4H71C83,29 83,13.5 83,13.5Z"/>
		
		<path fill=${global::main.lower.text.out()} d="${switch end {
			true => `M7 9L7 18L14 13.5L7 9zM15 9L15 18L17 18L17 9L15 9zM35 9L35 18L42 13.5L35 9zM43 9L43 18L45 18L45 9L43 9zM63 9L63 18L70 13.5L63 9zM71 9L71 18L73 18L73 9L71 9z`,
			   _ => `M74,9 72,12 70,9ZM63,9 70,13.5 63,18ZM46,9 44,12 42,9ZM35,9 42,13.5 35,18ZM18,9 16,12 14,9ZM7,9 14,13.5 7,18Zm66,4v5h-2v-5zm-28,0v5h-2v-5zm-28,0v5h-2v-5z`
		}}"/>
	</svg>`
}

fn right_150(end) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 126 44">
		<path fill=${global::main.lower.text.fade(0.2).out()} d="M24.5,2A17.5,17.5 0 0 1 42,19.5 17.5,17.5 0 0 1 24.5,37H0V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m42,19.5v6A17.5,17.5 0 0 1 24.5,43H0V37H24.5A17.5,17.5 0 0 0 42,19.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.3).out()} d="M66.5,2A17.5,17.5 0 0 1 84,19.5 17.5,17.5 0 0 1 66.5,37H42V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m84,19.5v6A17.5,17.5 0 0 1 66.5,43H42V37H66.5A17.5,17.5 0 0 0 84,19.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.4).out()} d="M108.5,2A17.5,17.5 0 0 1 126,19.5 17.5,17.5 0 0 1 108.5,37H84V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m126,19.5v6A17.5,17.5 0 0 1 108.5,43H84v-6h24.5A17.5,17.5 0 0 0 126,19.5Z"/>
		
		<path fill=${global::main.lower.text.out()} d="${switch end {
			true => `m110,13v13h-3V13ZM95,13 105,19.5 95,26ZM68,13V26H65V13ZM53,13 63,19.5 53,26ZM26,13V26H23V13ZM11,13 21,19.5 11,26Z`,
			   _ => `m111,13 -2.5,5 -2.5,-5zM95,13 105,19.5 95,26ZM69,13 66.5,18 64,13ZM53,13 63,19.5 53,26ZM27,13 24.5,18 22,13ZM11,13 21,19.5 11,26Zm99,6v7h-3v-7zm-42,0v7h-3v-7zm-42,0v7h-3v-7z`
		}}"/>
	</svg>`
}

export const knob_bg_large = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 34">
	<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM31 31L31 34L32 34L32 31L31 31z"/>
	<path fill="magenta" d="M1 0L1 1L3 1L3 0L1 0zM1 1L0 1L0 3L1 3L1 1zM31 29L31 31L32 31L32 29L31 29zM29 33L29 34L31 34L31 33L29 33z"/>
	<circle fill=${main.lower.like.shadow(0.5)} cx="16" cy="18" r="15"/>
	<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, main.border).out()} cx="16" cy="16" r="14.5"/>
</svg>`;

export const knob_bg_large_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47 50">
	<path fill="yellow" d="M0,0V1H1V0Zm46,46v4h1v-4z"/>
	<path fill="magenta" d="M1,0V1H5V0ZM1,1H0v4h1zm45,41v4h1v-4zm-4,7v1h4v-1z"/>
	<circle fill=${main.lower.like.shadow(0.5)} cx="23.5" cy="26.5" r="22.5"/>
	<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, main.border).out()} cx="23.5" cy="23.5" r="22"/>
</svg>`;

export const knob_bg_large_200 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 62 66">
	<path fill="yellow" d="M0,0V1H1V0Zm61,61v5h1v-5z"/>
	<path fill="magenta" d="M1,0V1H5V0ZM1,1H0v4h1zm60,56v4h1v-4zm-4,8v1h4v-1z"/>
	<circle fill=${main.lower.like.shadow(0.5)} cx="31" cy="35" r="30"/>
	<circle fill=${main.lower.area.out()} stroke=${lab::mix(main.lower.like, main.lower.text, main.border).out()} cx="31" cy="31" r="29.5"/>
</svg>`;

fn pause(on, scale) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = switch on {
		true => [set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)],
		   _ => [set.text.fade(0.2), set.text.fade(0.3), set.text.fade(0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 87 29" width="${87 * scale}" height="${29 * scale}">
		<path fill=${colors[0].out()} d="M16,2C28,2 28,13.5 28,13.5 28,13.5 28,25 16,25H1V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M28,13.5C28,13.5 28,25 16,25H1v4H16C28,29 28,13.5 28,13.5Z"/>
		
		<path fill=${colors[1].out()} d="M45,2C57,2 57,13.5 57,13.5 57,13.5 57,25 45,25H30V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="M57,13.5C57,13.5 57,25 45,25H30v4H45C57,29 57,13.5 57,13.5Z"/>
		
		<path fill=${colors[2].out()} d="M74,2C86,2 86,13.5 86,13.5 86,13.5 86,25 74,25H59V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="M86,13.5C86,13.5 86,25 74,25H59v4H74C86,29 86,13.5 86,13.5Z"/>
		
		<path fill=${set.text.out()} d="M9 9L9 18L12 18L12 9L9 9zM15 9L15 18L18 18L18 9L15 9zM38 9L38 18L41 18L41 9L38 9zM44 9L44 18L47 18L47 9L44 9zM67 9L67 18L70 18L70 9L67 9zM73 9L73 18L76 18L76 9L73 9z"/>
	</svg>`
}

fn pause_150(on) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = switch on {
		true => [set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)],
		   _ => [set.text.fade(0.2), set.text.fade(0.3), set.text.fade(0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 132 44">
		<path fill=${colors[0].out()} d="M1 2L1 38L25 38A18 18 0 0 0 43 20A18 18 0 0 0 25 2L1 2z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M43,20A18,18 0 0 1 25,38H1v6H25A18,18 0 0 0 43,26Z"/>
		
		<path fill=${colors[1].out()} d="M45,2V38H69A18,18 0 0 0 87,20 18,18 0 0 0 69,2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="M87,20A18,18 0 0 1 69,38H45v6H69A18,18 0 0 0 87,26Z"/>
		
		<path fill=${colors[2].out()} d="m89,2v36h24A18,18 0 0 0 131,20 18,18 0 0 0 113,2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="M131,20A18,18 0 0 1 113,38H89v6h24a18,18 0 0 0 18,-18z"/>
		
		<path fill=${set.text.out()} d="M13 13L13 27L18 27L18 13L13 13zM22 13L22 27L27 27L27 13L22 13zM57 13L57 27L62 27L62 13L57 13zM66 13L66 27L71 27L71 13L66 13zM101 13L101 27L106 27L106 13L101 13zM110 13L110 27L115 27L115 13L110 13z"/>
	</svg>`
}

fn play(synk, on, scale) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = switch on {
		true => [set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)],
		   _ => [set.text.fade(0.2), set.text.fade(0.3), set.text.fade(0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 99 35" width="${99 * scale}" height="${35 * scale}">
		<circle fill=${colors[0].out()} cx="16.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M2 16.5L2 20.5A14.5 14.5 0 0 0 16.5 35A14.5 14.5 0 0 0 31 20.5L31 16.5A14.5 14.5 0 0 1 16.5 31A14.5 14.5 0 0 1 2 16.5z"/>
		
		<circle fill=${colors[1].out()} cx="49.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m35,16.5v4A14.5,14.5 0 0 0 49.5,35 14.5,14.5 0 0 0 64,20.5v-4A14.5,14.5 0 0 1 49.5,31 14.5,14.5 0 0 1 35,16.5Z"/>
		
		<circle fill=${colors[2].out()} cx="82.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m68,16.5v4A14.5,14.5 0 0 0 82.5,35 14.5,14.5 0 0 0 97,20.5v-4A14.5,14.5 0 0 1 82.5,31 14.5,14.5 0 0 1 68,16.5Z"/>
		
		<path fill=${set.text.out()} d="${
			if !synk { `M12 11L12 22L23 16.5L12 11zM45 11L45 22L56 16.5L45 11zM78 11L78 22L89 16.5L78 11z` }
			else { `M11.5 12C9 12 9 13 9 16L8 16L8 20L15 20L15 16L14 16C14 13 14 12 11.5 12zM17 12L17 21L26 16.5L17 12zM44.5 12C42 12 42 13 42 16L41 16L41 20L48 20L48 16L47 16C47 13 47 12 44.5 12zM50 12L50 21L59 16.5L50 12zM77.5 12C75 12 75 13 75 16L74 16L74 20L81 20L81 16L80 16C80 13 80 12 77.5 12zM83 12L83 21L92 16.5L83 12zM11.5 13C13 13 13 14 13 16L10 16C10 14 10 13 11.5 13zM44.5 13C46 13 46 15 46 16L43 16C43 14 43 13 44.5 13zM77.5 13C79 13 79 14 79 16L76 16C76 14 76 13 77.5 13z` }
		}"/>
	</svg>`
}

fn play_150(synk, on) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = switch on {
		true => [set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)],
		   _ => [set.text.fade(0.2), set.text.fade(0.3), set.text.fade(0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 150 53">
		<circle fill=${colors[0].out()} cx="25" cy="25" r="22"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m3,25v5A22,22 0 0 0 25,52 22,22 0 0 0 47,30V25A22,22 0 0 1 25,47 22,22 0 0 1 3,25Z"/>
		
		<circle fill=${colors[1].out()} cx="75" cy="25" r="22"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m53,25v5A22,22 0 0 0 75,52 22,22 0 0 0 97,30V25A22,22 0 0 1 75,47 22,22 0 0 1 53,25Z"/>
		
		<circle fill=${colors[2].out()} cx="125" cy="25" r="22"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m103,25v5a22,22 0 0 0 22,22 22,22 0 0 0 22,-22V25A22,22 0 0 1 125,47 22,22 0 0 1 103,25Z"/>
		
		<path fill=${set.text.out()} d="${
			if !synk { `M18 16L18 34L35 25L18 16zM68 16L68 34L85 25L68 16zM118 16L118 34L135 25L118 16z` }
			else { `M17.5 18C14 18 14 24 14 24L12 24L12 30L23 30L23 24L21 24C21 24 21 18 17.5 18zM26 18L26 32L39 25L26 18zM67.5 18C64 18 64 24 64 24L62 24L62 30L73 30L73 24L71 24C71 24 71 18 67.5 18zM76 18L76 32L89 25L76 18zM117.5 18C114 18 114 24 114 24L112 24L112 30L123 30L123 24L121 24C121 24 121 18 117.5 18zM126 18L126 32L139 25L126 18zM17.5 20C19 20 19 24 19 24L16 24C16 24 16 20 17.5 20zM67.5 20C69 20 69 24 69 24L66 24C66 24 66 20 67.5 20zM117.5 20C119 20 119 24 119 24L116 24C116 24 116 20 117.5 20z` }
		}"/>
	</svg>`
}

fn record(mode, on, scale) {
	const set = global::main[if on { "red" } else { "lower" }];
	
	const colors = if on {
		[set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)]
	} else {
		[lab::mix(global::main.lower.like, global::main.red.area, 0.4), // WARNING opaque
		 lab::mix(global::main.lower.like, global::main.red.area, 0.5),
		 lab::mix(global::main.lower.like, global::main.red.area, 0.6)]
	};
	
	const ring = |radius, hole| `
		<circle fill=${set.text.out()} cx="17.5" cy="16.5" r="${radius}"/>
		<circle fill=${set.text.out()} cx="51.5" cy="16.5" r="${radius}"/>
		<circle fill=${set.text.out()} cx="85.5" cy="16.5" r="${radius}"/>
		
		<circle fill=${colors[0].out()} cx="17.5" cy="16.5" r="${hole}"/>
		<circle fill=${colors[1].out()} cx="51.5" cy="16.5" r="${hole}"/>
		<circle fill=${colors[2].out()} cx="85.5" cy="16.5" r="${hole}"/>
	`;
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 102 35" width="${102 * scale}" height="${35 * scale}">
		<circle fill=${colors[0].out()} cx="17.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="m3,16.5v4A14.5,14.5 0 0 0 17.5,35 14.5,14.5 0 0 0 32,20.5v-4A14.5,14.5 0 0 1 17.5,31 14.5,14.5 0 0 1 3,16.5Z"/>
		
		<circle fill=${colors[1].out()} cx="51.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m37,16.5v4A14.5,14.5 0 0 0 51.5,35 14.5,14.5 0 0 0 66,20.5v-4A14.5,14.5 0 0 1 51.5,31 14.5,14.5 0 0 1 37,16.5Z"/>
		
		<circle fill=${colors[2].out()} cx="85.5" cy="16.5" r="14.5"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m71,16.5v4A14.5,14.5 0 0 0 85.5,35 14.5,14.5 0 0 0 100,20.5v-4A14.5,14.5 0 0 1 85.5,31 14.5,14.5 0 0 1 71,16.5Z"/>
		
		${switch mode {
			"none" => ring.call(7.5, 4.5),
			"item" => ring.call(6.5, 4.5) + `<path fill=${set.text.out()} d="M6 11L6 22L10 22L10 21L7 21L7 12L10 12L10 11L6 11zM25 11L25 12L28 12L28 21L25 21L25 22L29 22L29 11L25 11zM40 11L40 22L44 22L44 21L41 21L41 12L44 12L44 11L40 11zM59 11L59 12L62 12L62 21L59 21L59 22L63 22L63 11L59 11zM74 11L74 22L78 22L78 21L75 21L75 12L78 12L78 11L74 11zM93 11L93 12L96 12L96 21L93 21L93 22L97 22L97 11L93 11z"/>`,
			"loop" => ring.call(7.5, 5.5) + `
				<path fill=${set.text.out()} d="M10 9L10 11L14 11L14 15L16 15L16 9L10 9zM44 9L44 11L48 11L48 15L50 15L50 9L44 9zM78 9L78 11L82 11L82 15L84 15L84 9L78 9zM19 18L19 24L25 24L25 22L21 22L21 18L19 18zM53 18L53 24L59 24L59 22L55 22L55 18L53 18zM87 18L87 24L93 24L93 22L89 22L89 18L87 18z"/>
				<path fill=${colors[0].out()} d="M16 9L16 12L18 12L18 9L16 9zM17 21L17 24L19 24L19 21L17 21z"/>
				<path fill=${colors[1].out()} d="M50 9L50 12L52 12L52 9L50 9zM51 21L51 24L53 24L53 21L51 21z"/>
				<path fill=${colors[2].out()} d="M84 9L84 12L86 12L86 9L84 9zM85 21L85 24L87 24L87 21L85 21z"/>
			`
		}}
	</svg>`
}

fn repeat(on, scale) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = if on {
		[set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)]
	} else {
		[lab::mix(global::main.lower.like, set.text, 0.2),
		 lab::mix(global::main.lower.like, set.text, 0.3),
		 lab::mix(global::main.lower.like, set.text, 0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 81 29" width="${81 * scale}" height="${29 * scale}">
		<circle fill=${global::main.lower.like.shadow(0.5)} cx="13.5" cy="17.5" r="11.5"/>
		<circle fill=${colors[0].out()} cx="13.5" cy="13.5" r="11.5"/>
		<circle fill=${set.text.out()} cx="13.5" cy="13.5" r="5.5"/>
		<circle fill=${colors[0].out()} cx="13.5" cy="13.5" r="4"/>
		<path fill=${colors[0].out()} d="m13,8v2h1.5V8Zm-0.5,9v2H14v-2z"/>
		
		<circle fill=${global::main.lower.like.shadow(0.75)} cx="40.5" cy="17.5" r="11.5"/>
		<circle fill=${colors[1].out()} cx="40.5" cy="13.5" r="11.5"/>
		<circle fill=${set.text.out()} cx="40.5" cy="13.5" r="5.5"/>
		<circle fill=${colors[1].out()} cx="40.5" cy="13.5" r="4"/>
		<path fill=${colors[1].out()} d="m40,8v2h1.5V8Zm-0.5,9v2H41v-2z"/>
		
		<circle fill=${global::main.lower.like.shadow(1)} cx="67.5" cy="17.5" r="11.5"/>
		<circle fill=${colors[2].out()} cx="67.5" cy="13.5" r="11.5"/>
		<circle fill=${set.text.out()} cx="67.5" cy="13.5" r="5.5"/>
		<circle fill=${colors[2].out()} cx="67.5" cy="13.5" r="4"/>
		<path fill=${colors[2].out()} d="m67,8v2h1.5V8Zm-0.5,9v2H68v-2z"/>
		
		<path fill=${set.text.out()} d="M8 8L8 9L12 9L12 13L13 13L13 8L8 8zM35 8L35 9L39 9L39 13L40 13L40 8L35 8zM62 8L62 9L66 9L66 13L67 13L67 8L62 8zM14 14L14 19L19 19L19 18L15 18L15 14L14 14zM41 14L41 19L46 19L46 18L42 18L42 14L41 14zM68 14L68 19L73 19L73 18L69 18L69 14L68 14z"/>
	</svg>`
}

fn repeat_150(on) {
	const set = global::main[if on { global::accent } else { "lower" }];
	
	const colors = if on {
		[set.area, lab::mix(set.area, set.text, 0.1), lab::mix(set.area, set.text, 0.2)]
	} else {
		[lab::mix(global::main.lower.like, set.text, 0.2),
		 lab::mix(global::main.lower.like, set.text, 0.3),
		 lab::mix(global::main.lower.like, set.text, 0.4)]
	};
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 120 44">
		<circle fill=${global::main.lower.like.shadow(0.5)} cx="20.5" cy="26.5" r="17.5"/>
		<circle fill=${colors[0].out()} cx="20.5" cy="20.5" r="17.5"/>
		<circle fill=${set.text.out()} cx="20.5" cy="20.5" r="9.5"/>
		<circle fill=${colors[0].out()} cx="20.5" cy="20.5" r="6.5"/>
		<path fill=${colors[0].out()} d="M20 11L20 15L22 15L22 11L20 11zM19 26L19 30L21 30L21 26L19 26z"/>
		
		<circle fill=${global::main.lower.like.shadow(0.75)} cx="60.5" cy="26.5" r="17.5"/>
		<circle fill=${colors[1].out()} cx="60.5" cy="20.5" r="17.5"/>
		<circle fill=${set.text.out()} cx="60.5" cy="20.5" r="9.5"/>
		<circle fill=${colors[1].out()} cx="60.5" cy="20.5" r="6.5"/>
		<path fill=${colors[1].out()} d="m60,11v4h2v-4zm-1,15v4h2v-4z"/>
		
		<circle fill=${global::main.lower.like.shadow(1)} cx="100.5" cy="26.5" r="17.5"/>
		<circle fill=${colors[2].out()} cx="100.5" cy="20.5" r="17.5"/>
		<circle fill=${set.text.out()} cx="100.5" cy="20.5" r="9.5"/>
		<circle fill=${colors[2].out()} cx="100.5" cy="20.5" r="6.5"/>
		<path fill=${colors[2].out()} d="m100,11v4h2v-4zm-1,15v4h2v-4z"/>
		
		<path fill=${set.text.out()} d="M12 11L12 13L18 13L18 19L20 19L20 11L12 11zM52 11L52 13L58 13L58 19L60 19L60 11L52 11zM92 11L92 13L98 13L98 19L100 19L100 11L92 11zM21 22L21 28L21 30L23 30L29 30L29 28L23 28L23 22L21 22zM61 22L61 28L61 30L63 30L69 30L69 28L63 28L63 22L61 22zM101 22L101 28L101 30L103 30L109 30L109 28L103 28L103 22L101 22z"/>
	</svg>`
}

fn stop(scale) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 87 29" width="${87 * scale}" height="${29 * scale}">
		<path fill=${global::main.lower.text.fade(0.2).out()} d="M14,2C2,2 2,13.5 2,13.5 2,13.5 2,25 14,25H29V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.5)} d="M2,13.5C2,13.5 2,25 14,25h15v4H14C2,29 2,13.5 2,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.3).out()} d="M43,2C31,2 31,13.5 31,13.5 31,13.5 31,25 43,25H58V2Z"/>
		<path fill=${global::main.lower.like.shadow(0.75)} d="m31,13.5c0,0 0,11.5 12,11.5h15v4H43C31,29 31,13.5 31,13.5Z"/>
		
		<path fill=${global::main.lower.text.fade(0.4).out()} d="M72,2C60,2 60,13.5 60,13.5 60,13.5 60,25 72,25H87V2Z"/>
		<path fill=${global::main.lower.like.shadow(1)} d="m60,13.5c0,0 0,11.5 12,11.5h15v4H72C60,29 60,13.5 60,13.5Z"/>
		
		<path fill=${global::main.lower.text.out()} d="M12 9L12 18L21 18L21 9L12 9zM41 9L41 18L50 18L50 9L41 9zM70 9L70 18L79 18L79 9L70 9z"/>
	</svg>`
}

export const stop_150 = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 132 44">
	<path fill=${main.lower.text.fade(0.2).out()} d="M21 2A18 18 0 0 0 3 20A18 18 0 0 0 21 38L43 38L43 2L21 2z"/>
	<path fill=${main.lower.like.shadow(0.5)} d="m3,20v6A18,18 0 0 0 21,44H43V38H21A18,18 0 0 1 3,20Z"/>
	
	<path fill=${main.lower.text.fade(0.3).out()} d="M65,2A18,18 0 0 0 47,20 18,18 0 0 0 65,38H87V2Z"/>
	<path fill=${main.lower.like.shadow(0.75)} d="m47,20v6A18,18 0 0 0 65,44H87V38H65A18,18 0 0 1 47,20Z"/>
	
	<path fill=${main.lower.text.fade(0.4).out()} d="m109,2a18,18 0 0 0 -18,18 18,18 0 0 0 18,18h22V2Z"/>
	<path fill=${main.lower.like.shadow(1)} d="m91,20v6a18,18 0 0 0 18,18h22V38H109A18,18 0 0 1 91,20Z"/>
	
	<path fill=${main.lower.text.out()} d="M18 13L18 27L31 27L31 13L18 13zM62 13L62 27L75 27L75 13L62 13zM106 13L106 27L119 27L119 13L106 13z"/>
</svg>`;
