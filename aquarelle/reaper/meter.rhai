/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main = cfg::scheme("main");

private fn square(set, text) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 12">
		<path fill="magenta" d="M0,0V1 7H1V1H7V0Zm11,10v1h-1v1h2v-1 -1z"/>
		<rect fill=${global::main[set].area.out()} x="1" y="1" width="10" height="10"/>
		<text fill=${global::main[set].text.out()} x="6" y="9" text-anchor="middle"
			font-family="Cantarell" font-size="8.6px" font-weight="800">${text}</text>
	</svg>`
}

export const map = #{
	meter_bg_mcp: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 39 36">
		<path fill=${cp::lower_area.out()} d="M0,0V36H39V0Z"/>
		<path fill="yellow" d="M0,0V1 5H1V1H5V0ZM38,8V35H8v1h30 1V8Z"/>
		<path fill="magenta" d="M5,0V1H6V0ZM0,5V6H1V5Zm38,2v1h1V7ZM7,35v1h1v-1z"/>
		<path fill=${cp::lower_area.shadow(2)} d="M1,1V35H2V1Z"/>
	</svg>`,
	meter_bg_mcp_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 57 52">
		<path fill=${cp::lower_area.out()} d="M0,0V52H57V0Z"/>
		<path fill="yellow" d="M0,0V1 7H1V1H7V0ZM56,11V51H11v1h45 1V11Z"/>
		<path fill="magenta" d="M7,0V1H8V0ZM0,7V8H1V7Zm56,2v2h1V9ZM10,51v1h1v-1z"/>
		<path fill=${cp::lower_area.shadow(2)} d="M1,1V52H2V1Z"/>
	</svg>`,
	meter_bg_mcp_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 76 70">
		<path fill=${cp::lower_area.out()} d="M0,0V70H76V0Z"/>
		<path fill="yellow" d="M0,0V1 9H1V1H9V0ZM75,15V69H15v1H76V69 15Z"/>
		<path fill="magenta" d="m9,0v1h2V0ZM0,9v2H1V9Zm75,4v2h1V13ZM13,69v1h2v-1z"/>
		<path fill=${cp::lower_area.shadow(2)} d="M1,1V69H2V1Z"/>
	</svg>`,
	meter_bg_tcp: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 44 14">
		<path fill=${cp::lower_area.out()} d="M0,0V14H44V0Z"/>
		<path fill="yellow" d="M0,0V1 3H1V1H5V0Zm43,11v2H15v1h29v-1 -2z"/>
		<path fill="magenta" d="M5,0V1H6V0ZM0,3V4H1V3Zm43,7v1h1v-1zm-29,3v1h1v-1z"/>
	</svg>`,
	meter_bg_tcp_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 65 27">
		<path fill=${cp::lower_area.out()} d="M0,0V27H65V0Z"/>
		<path fill="yellow" d="M0,0V1 4H1V1H7V0Zm64,20v6H22v1h43v-1 -6z"/>
		<path fill="magenta" d="M7,0V1H8V0ZM0,4V5H1V4Zm64,15v1h1v-1zm-43,7v1h1v-1z"/>
	</svg>`,
	meter_bg_tcp_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 86 27">
		<path fill=${cp::lower_area.out()} d="M0,0V27H86V0Z"/>
		<path fill="yellow" d="M0,0V1 5H1V1H9V0Zm85,21v5H29v1h57v-1 -5z"/>
		<path fill="magenta" d="m9,0v1h2V0ZM0,5V7H1V5Zm85,14v2h1v-2zm-58,7v1h2v-1z"/>
	</svg>`,
	meter_bg_h: rectangle(cp::lower_area, 4, 4),
	meter_bg_v: rectangle(cp::lower_area, 4, 4),
	meter_clip_h: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 8 4">
		<rect fill=${cp::lower_area.out()} width="4" height="4"/>
		<rect fill=${main.red.area.out()} width="4" height="4" x="4"/>
	</svg>`,
	meter_clip_v: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 8">
		<rect fill=${cp::lower_area.out()} width="4" height="4"/>
		<rect fill=${main.red.area.out()} width="4" height="4" y="4"/>
	</svg>`,
	meter_clip_v_rms2: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 4">
		<rect fill=${cp::lower_area.out()} width="4" height="2"/>
		<rect fill=${main.green.area.out()} width="4" height="2" y="2"/>
	</svg>`,
	meter_foldermute: square("red", "F"),
	meter_mute: square("red", "M"),
	meter_solodim: square("magenta", "D"),
	meter_strip_h: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 4 16">
		<rect fill=${main.green.area.out()} width="4" height="2" y="2"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" y="4"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" y="6"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).fade(0.3).out()} width="4" height="2" y="8"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).out()} width="4" height="2" y="10"/>
		<rect fill=${main.magenta.area.fade(0.3).out()} width="4" height="2" y="12"/>
		<rect fill=${main.magenta.area.out()} width="4" height="2" y="14"/>
	</svg>`,
	meter_strip_h_rms: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2 32">
		<rect fill=${main.green.area.fade(0.8).out()} width="2" height="4" y="4"/>
		<rect fill=${main.lower.text.fade(0.3).out()} width="2" height="4" y="8"/>
		<rect fill=${main.green.area.out()} width="2" height="4" y="12"/>
		<rect fill=${main.red.area.fade(2.0 / 3).out()} width="2" height="4" y="16"/>
		<rect fill=${main.any.area.out()} width="2" height="4" y="20"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="2" height="4" y="24"/>
		<rect fill=${main.yellow.area.out()} width="2" height="4" y="28"/>
	</svg>`,
	meter_strip_v: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 2">
		<rect fill=${main.green.area.out()} width="4" height="2" x="4"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" x="8"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" x="12"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).fade(0.3).out()} width="4" height="2" x="16"/>
		<rect fill=${lab::mix(main.yellow.area, main.magenta.area, 0.5).out()} width="4" height="2" x="20"/>
		<rect fill=${main.magenta.area.fade(0.3).out()} width="4" height="2" x="24"/>
		<rect fill=${main.magenta.area.out()} width="4" height="2" x="28"/>
	</svg>`,
	meter_strip_v_rms: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 2">
		<rect fill=${main.green.area.fade(0.8).out()} width="4" height="2" x="4"/>
		<rect fill=${main.lower.text.fade(0.3).out()} width="4" height="2" x="8"/>
		<rect fill=${main.green.area.out()} width="4" height="2" x="12"/>
		<rect fill=${main.red.area.fade(2.0 / 3).out()} width="4" height="2" x="16"/>
		<rect fill=${main.any.area.out()} width="4" height="2" x="20"/>
		<rect fill=${main.yellow.area.fade(0.3).out()} width="4" height="2" x="24"/>
		<rect fill=${main.yellow.area.out()} width="4" height="2" x="28"/>
	</svg>`,
	meter_unsolo: square("yellow", "!S"),
}
