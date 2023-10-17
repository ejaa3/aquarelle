/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

const SCROLLBAR = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 204 238">
	<path fill=${main.lower.like.out()} d="M0 0L0 35L168 35L168 100L111 100L111 238L168 238L204 238L204 35L204 0L0 0z"/>
	<path fill="magenta" d="m0,35v1h25v-1zm180,0v1h24v-1zm-12,2v29h1V37ZM0,89v1h13v-1zm83,0v1h2v-1zm70,0v1h14V89ZM52,91v6h1v-6zm0,73v2h1v-2zm116,45v29h1V209ZM52,231v7h1v-7z"/>
	
	<rect fill=${main.lower.text.fade(1.0 / 3).out()} x="3" y="40" width="161" height="11" rx="5.5" ry="5.5"/>
	<circle fill=${main.lower.area.out()} cx="8.5" cy="45.5" r="2.5"/>
	<circle fill=${main.lower.area.out()} cx="158.5" cy="45.5" r="2.5"/>
	
	<rect fill=${main.lower.text.fade(2.0 / 3).out()} x="3" y="57" width="161" height="11" rx="5.5" ry="5.5"/>
	<circle fill=${main.lower.area.out()} cx="8.5" cy="62.5" r="2.5"/>
	<circle fill=${main.lower.area.out()} cx="158.5" cy="62.5" r="2.5"/>
	
	<rect fill=${main[accent].area.out()} x="3" y="74" width="161" height="11" rx="5.5" ry="5.5"/>
	<circle fill=${main[accent].text.out()} cx="8.5" cy="79.5" r="2.5"/>
	<circle fill=${main[accent].text.out()} cx="158.5" cy="79.5" r="2.5"/>
	
	<rect fill=${main.lower.text.fade(1.0 / 3).out()} x="3" y="94" width="11" height="141" rx="5.5" ry="5.5"/>
	<rect fill=${main.lower.text.fade(2.0 / 3).out()} x="20" y="94" width="11" height="141" rx="5.5" ry="5.5"/>
	<rect fill=${main[accent].area.out()} x="37" y="94" width="11" height="141" rx="5.5" ry="5.5"/>
	
	<path fill=${main.lower.area.out()} d="M83 42L83 49L85 49L85 42L83 42zM83 59L83 66L85 66L85 59L83 59zM5 164L5 166L12 166L12 164L5 164zM22 164L22 166L29 166L29 164L22 164z"/>
	<path fill=${main[accent].text.out()} d="M83 76L83 83L85 83L85 76L83 76zM39 164L39 166L46 166L46 164L39 164z"/>
	
	<path fill=${main.lower.area.shadow(1)} d="M164 105L164 114L166 114L166 105L164 105zM147 115L147 117L156 117L156 115L147 115z"/>
	
	<circle fill=${main.lower("lower", "like", 0.5).out()} cx="124.5" cy="129.5" r="5.5"/>
	<circle fill=${main.lower.text.fade(0.2).out()} cx="141.5" cy="129.5" r="5.5"/>
	<circle fill=${main[accent].area.out()} cx="158.5" cy="129.5" r="5.5"/>
	
	<circle fill=${main.lower("lower", "like", 0.5).out()} cx="124.5" cy="149.5" r="5.5"/>
	<circle fill=${main.lower.text.fade(0.2).out()} cx="141.5" cy="149.5" r="5.5"/>
	<circle fill=${main[accent].area.out()} cx="158.5" cy="149.5" r="5.5"/>
	
	<circle fill=${main.lower("lower", "like", 0.5).out()} cx="124.5" cy="169.5" r="5.5"/>
	<circle fill=${main.lower.text.fade(0.2).out()} cx="141.5" cy="169.5" r="5.5"/>
	<circle fill=${main[accent].area.out()} cx="158.5" cy="169.5" r="5.5"/>
	
	<circle fill=${main.lower("lower", "like", 0.5).out()} cx="124.5" cy="189.5" r="5.5"/>
	<circle fill=${main.lower.text.fade(0.2).out()} cx="141.5" cy="189.5" r="5.5"/>
	<circle fill=${main[accent].area.out()} cx="158.5" cy="189.5" r="5.5"/>
	
	<path fill=${main.lower.text.fade(main.dim).out()} d="M123 205L123 208L120 208L120 211L123 211L123 214L126 214L126 211L129 211L129 208L126 208L126 205L123 205zM120 228L120 231L129 231L129 228L120 228z"/>
	<path fill=${main[accent].like.out()} d="M157 205L157 208L154 208L154 211L157 211L157 214L160 214L160 211L163 211L163 208L160 208L160 205L157 205zM154 228L154 231L163 231L163 228L154 228z"/>
	
	<path fill=${main.lower.text.out()} d="M124.5 127L122 131L127 131L124.5 127zM141.5 127L139 131L144 131L141.5 127zM126 147L122 149.5L126 152L126 147zM143 147L139 149.5L143 152L143 147zM123 167L123 172L127 169.5L123 167zM140 167L140 172L144 169.5L140 167zM122 188L124.5 192L127 188L122 188zM139 188L141.5 192L144 188L139 188zM140 205L140 208L137 208L137 211L140 211L140 214L143 214L143 211L146 211L146 208L143 208L143 205L140 205zM137 228L137 231L146 231L146 228L137 228z"/>
	<path fill=${main[accent].text.out()} d="M158.5 127L156 131L161 131L158.5 127zM160 147L156 149.5L160 152L160 147zM157 167L157 172L161 169.5L157 167zM156 188L158.5 192L161 188L156 188z"/>
</svg>`;

private fn transport(button, on, scale) {
	const data = switchable(on);
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 72 24" width="${72 * scale}" height="${24 * scale}">
		<rect fill=${data.colors[0].out()} width="20" height="20" x="2" y="2" rx="5" ry="5"/>
		<rect fill=${data.colors[1].out()} width="20" height="20" x="26" y="2" rx="5" ry="5"/>
		<rect fill=${data.colors[2].out()} width="20" height="20" x="50" y="2" rx="5" ry="5"/>
		<path fill=${data.set.text.out()} d="${switch button {
			"end"    => `m65,8 -2,3 -2,-3zm-10,0 6,4 -6,4zM41,8 39,11 37,8Zm-10,0 6,4 -6,4zM17,8 15,11 13,8Zm-10,0 6,4 -6,4zm57,4v4h-2v-4zm-24,0v4h-2v-4zm-24,0v4h-2v-4z`,
			"home"   => `m7,8 2,3 2,-3zm10,0 -6,4 6,4zm14,0 2,3 2,-3zm10,0 -6,4 6,4zm14,0 2,3 2,-3zm10,0 -6,4 6,4zM8,12v4h2v-4zm24,0v4h2v-4zm24,0v4h2v-4z`,
			"pause"  => `m8,8v8h3V8Zm5,0v8h3V8Zm19,0v8h3V8Zm5,0v8h3V8Zm19,0v8h3V8Zm5,0v8h3V8Z`,
			"play"   => `m9,8v8l8,-4zm24,0v8l8,-4zm24,0v8l8,-4z`,
			"repeat" => `M6,6V8H7.5A6,6 0 0 0 6,12 6,6 0 0 0 11,18V16A4,4 0 0 1 8,12 4,4 0 0 1 10,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1 -2,3.6V13h-2v3 2h2 4V16H16.5A6,6 0 0 0 18,12 6,6 0 0 0 13,6Zm17,0v2h1.5a6,6 0 0 0 -1.5,4 6,6 0 0 0 5,6V16A4,4 0 0 1 32,12 4,4 0 0 1 34,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1 -2,3.6V13h-2v3 2h2 4V16H40.5A6,6 0 0 0 42,12 6,6 0 0 0 37,6Zm17,0v2h1.5a6,6 0 0 0 -1.5,4 6,6 0 0 0 5,6V16A4,4 0 0 1 56,12 4,4 0 0 1 58,8.4V11h2V6Zm7,0v2a4,4 0 0 1 3,4 4,4 0 0 1 -2,3.6V13h-2v3 2h2 4V16H64.5A6,6 0 0 0 66,12 6,6 0 0 0 61,6Z`,
			"stop"   => `m8,8v8h8V8Zm24,0v8h8V8Zm24,0v8h8V8Z`,
		}}"/>
	</svg>`
}

export const map = #{
	gen_end: transport(`end`, false, 1),
	gen_end_150: transport(`end`, false, 1.5),
	gen_end_200: transport(`end`, false, 2),
	gen_home: transport(`home`, false, 1),
	gen_home_150: transport(`home`, false, 1.5),
	gen_home_200: transport(`home`, false, 2),
	gen_panbg_horz: rectangle(main.lower.area, 14, 14),
	gen_panbg_horz_dark: rectangle(main.red.area, 14, 14),
	gen_panthumb_horz: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 29">
		<path fill="magenta" d="M0 28L0 29L1 29L1 28L0 28zM18 28L18 29L19 29L19 28L18 28z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M6 6A3 3 0 0 0 3 9L3 19A3 3 0 0 0 6 22L9 22L9 9L9 6L6 6zM10 6L10 9L10 22L13 22A3 3 0 0 0 16 19L16 9A3 3 0 0 0 13 6L10 6z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m3,19v5a3,3 0 0 0 3,3H9V22H6A3,3 0 0 1 3,19Zm13,0a3,3 0 0 1 -3,3h-3v5h3a3,3 0 0 0 3,-3z"/>
	</svg>`,
	gen_panthumb_horz_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 28 43">
		<path fill="magenta" d="M0 42L0 43L1 43L1 42L0 42zM27 42L27 43L28 43L28 42L27 42z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M9.5 9A4.5 4.5 0 0 0 5 13.5L5 28.5A4.5 4.5 0 0 0 9.5 33L14 33L14 28.5L14 9L9.5 9zM15 9L15 28.5L15 33L19.5 33A4.5 4.5 0 0 0 24 28.5L24 13.5A4.5 4.5 0 0 0 19.5 9L15 9z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m5,28.5v8A4.5,4.5 0 0 0 9.5,41H14V36.5 33H9.5A4.5,4.5 0 0 1 5,28.5Zm19,0A4.5,4.5 0 0 1 19.5,33H15v3.5 4.5h4.5A4.5,4.5 0 0 0 24,36.5Z"/>
	</svg>`,
	gen_panthumb_horz_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 36 57">
		<path fill="magenta" d="M0 56L0 57L1 57L1 56L0 56zM35 56L35 57L36 57L36 56L35 56z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M11 12A6 6 0 0 0 5 18L5 38A6 6 0 0 0 11 44L17 44L17 38L17 12L11 12zM19 12L19 38L19 44L25 44A6 6 0 0 0 31 38L31 18A6 6 0 0 0 25 12L19 12z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m5,38v9a6,6 0 0 0 6,6h6V47 44H11A6,6 0 0 1 5,38Zm26,0a6,6 0 0 1 -6,6h-6v3 6h6a6,6 0 0 0 6,-6z"/>
	</svg>`,
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
	gen_stop: transport(`stop`, false, 1),
	gen_stop_150: transport(`stop`, false, 1.5),
	gen_stop_200: transport(`stop`, false, 2),
	gen_volbg_horz: rectangle(main.lower.area, 14, 14),
	gen_volbg_horz_dark: rectangle(main.red.area, 14, 14),
	gen_volbg_vert: rectangle(main.lower.area, 14, 14),
	gen_volbg_vert_dark: rectangle(main.red.area, 14, 14),
	gen_volthumb_horz: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 29">
		<path fill="magenta" d="M0 28L0 29L1 29L1 28L0 28zM24 28L24 29L25 29L25 28L24 28z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M7.5 6A4.5 4.5 0 0 0 3 10.5L3 17.5A4.5 4.5 0 0 0 7.5 22L12 22L12 17.5L12 10.5L12 6L7.5 6zM13 6L13 10.5L13 17.5L13 22L17.5 22A4.5 4.5 0 0 0 22 17.5L22 10.5A4.5 4.5 0 0 0 17.5 6L13 6z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="M3 17.5L3 22.5A4.5 4.5 0 0 0 7.5 27L12 27L12 22.5L12 22L7.5 22A4.5 4.5 0 0 1 3 17.5zM22 17.5A4.5 4.5 0 0 1 17.5 22L13 22L13 22.5L13 27L17.5 27A4.5 4.5 0 0 0 22 22.5L22 17.5z"/>
	</svg>`,
	gen_volthumb_horz_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 37 43">
		<path fill="magenta" d="M0 42L0 43L1 43L1 42L0 42zM36 42L36 43L37 43L37 42L36 42z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M11.5 9A6.5 6.5 0 0 0 5 15.5L5 25.5A6.5 6.5 0 0 0 11.5 32L18 32L18 9L11.5 9zM19 9L19 32L25.5 32A6.5 6.5 0 0 0 32 25.5L32 15.5A6.5 6.5 0 0 0 25.5 9L19 9z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m5,25.5v8A6.5,6.5 0 0 0 11.5,40H18V32H11.5A6.5,6.5 0 0 1 5,25.5Zm27,0A6.5,6.5 0 0 1 25.5,32H19v8h6.5A6.5,6.5 0 0 0 32,33.5Z"/>
	</svg>`,
	gen_volthumb_horz_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 57">
		<path fill="magenta" d="M0 56L0 57L1 57L1 56L0 56zM47 56L47 57L48 57L48 56L47 56z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M14 12A9 9 0 0 0 5 21L5 35A9 9 0 0 0 14 44L23 44L23 35L23 12L14 12zM25 12L25 35L25 44L34 44A9 9 0 0 0 43 35L43 21A9 9 0 0 0 34 12L25 12z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m5,35v10a9,9 0 0 0 9,9h9V45 44H14A9,9 0 0 1 5,35Zm38,0a9,9 0 0 1 -9,9h-9v1 9h9a9,9 0 0 0 9,-9z"/>
	</svg>`,
	gen_volthumb_vert: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 21 31">
		<path fill="magenta" d="M20 0L20 5L21 5L21 0L20 0zM20 26L20 31L21 31L21 26L20 26z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M6.5 6A4.5 4.5 0 0 0 2 10.5L2 15L13.5 15L18 15L18 10.5A4.5 4.5 0 0 0 13.5 6L6.5 6zM2 16L2 20.5A4.5 4.5 0 0 0 6.5 25L13.5 25A4.5 4.5 0 0 0 18 20.5L18 16L13.5 16L2 16z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m2,20.5v4A4.5,4.5 0 0 0 6.5,29h7A4.5,4.5 0 0 0 18,24.5v-4A4.5,4.5 0 0 1 13.5,25h-7A4.5,4.5 0 0 1 2,20.5Z"/>
	</svg>`,
	gen_volthumb_vert_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 31 47">
		<path fill="magenta" d="M30 0L30 8L31 8L31 0L30 0zM30 39L30 47L31 47L31 39L30 39z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M10 9A7 7 0 0 0 3 16L3 23L20 23L27 23L27 16A7 7 0 0 0 20 9L10 9zM3 24L3 31A7 7 0 0 0 10 38L20 38A7 7 0 0 0 27 31L27 24L20 24L3 24z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m3,31v7a7,7 0 0 0 7,7h10a7,7 0 0 0 7,-7v-7a7,7 0 0 1 -7,7H10A7,7 0 0 1 3,31Z"/>
	</svg>`,
	gen_volthumb_vert_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 41 54">
		<path fill="magenta" d="M40 0L40 6L41 6L41 0L40 0zM40 48L40 54L41 54L41 48L40 48z"/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M13 8A9 9 0 0 0 4 17L4 26L27 26L36 26L36 17A9 9 0 0 0 27 8L13 8zM4 28L4 37A9 9 0 0 0 13 46L27 46A9 9 0 0 0 36 37L36 28L27 28L4 28z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m4,37v7a9,9 0 0 0 9,9h14a9,9 0 0 0 9,-9v-7a9,9 0 0 1 -9,9H13A9,9 0 0 1 4,37Z"/>
	</svg>`,
	
	scrollbar: SCROLLBAR,
	scrollbar_3: SCROLLBAR,
}
