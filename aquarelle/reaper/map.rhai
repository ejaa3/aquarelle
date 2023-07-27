/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import "colors" as colors;
import "control_panel" as cp;
import "transport" as transport;

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { `"#${this.to_hex_rgba(true)}"` }

fn shadow(factor) {
	const x = this.luma();
	rgb(0.0, 0.0, 0.0, (2 ** -x + 0.2 * x - 0.6) * factor).out()
}

fn is_dark() { this.lower.text.luma() > this.lower.like.luma() }

fn raise(set, role, bias) {
	switch this.is_dark() {
		true => lab::lighten(this[set][role], bias),
		   _ => lab::darken (this[set][role], bias)
	}
}

fn lower(set, role, bias) {
	switch this.is_dark() {
		true => lab::darken (this[set][role], bias),
		   _ => lab::lighten(this[set][role], bias)
	}
}

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

fn rectangle(color, width, height) {
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${width} ${height}">
		<rect fill=${color.out()} width="${width}" height="${height}"/>
	</svg>`
}

#{
	colors: colors::TEXT,
	
	envcp_arm_off: cp::arm("env", "off", 1),
	envcp_arm_off_150: cp::arm("env", "off", 1.5),
	envcp_arm_off_200: cp::arm("env", "off", 2),
	envcp_arm_off_OL: cp::arm_OL,
	envcp_arm_off_ol_150: cp::arm_OL_150,
	envcp_arm_off_OL_200: cp::arm_OL_200,
	envcp_arm_on: cp::arm("env", "on", 1),
	envcp_arm_on_150: cp::arm("env", "on", 1.5),
	envcp_arm_on_200: cp::arm("env", "on", 2),
	envcp_arm_on_OL: cp::arm_OL,
	envcp_arm_on_ol_150: cp::arm_OL_150,
	envcp_arm_on_OL_200: cp::arm_OL_200,
	
	envcp_bg: cp::tcp_bg(main.lower.like, 1, 46),
	envcp_bgsel: cp::tcp_bg(main.raise("lower", "like", 0.05), 1, 46),
	envcp_bypass_off: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_off_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_off_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_off_ol: cp::envcp_bypass(true),
	envcp_bypass_off_ol_150: cp::envcp_bypass_150(true),
	envcp_bypass_off_ol_200: cp::envcp_bypass_200(true),
	envcp_bypass_on: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_on_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_on_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	envcp_bypass_on_ol: cp::envcp_bypass(false),
	envcp_bypass_on_ol_150: cp::envcp_bypass_150(false),
	envcp_bypass_on_ol_200: cp::envcp_bypass_200(false),
	envcp_hide: cp::envcp_hide(1),
	envcp_hide_150: cp::envcp_hide(1.5), // WARNING not pixel perfect
	envcp_hide_200: cp::envcp_hide(2),
	envcp_knob_small: cp::knob_small(false),
	envcp_knob_small_150: cp::knob_small_150(false),
	envcp_knob_small_200: cp::knob_small_200(false),
	
	gen_panbg_horz: rectangle(main.lower.area, 14, 14),
	gen_panbg_horz_dark: rectangle(main.red.area, 14, 14),
	gen_panthumb_horz: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 19 29">
		<path fill="magenta" d="M 0 28 L 0 29 L 1 29 L 1 28 L 0 28 z M 24 28 L 24 29 L 25 29 L 25 28 L 24 28 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 7.5 6 A 4.5 4.5 0 0 0 3 10.5 L 3 17.5 A 4.5 4.5 0 0 0 7.5 22 L 12 22 L 12 17.5 L 12 10.5 L 12 6 L 7.5 6 z M 13 6 L 13 10.5 L 13 17.5 L 13 22 L 17.5 22 A 4.5 4.5 0 0 0 22 17.5 L 22 10.5 A 4.5 4.5 0 0 0 17.5 6 L 13 6 z "/>
		<path fill=${main.lower.like.shadow(0.5)} d="M 3 17.5 L 3 22.5 A 4.5 4.5 0 0 0 7.5 27 L 12 27 L 12 22.5 L 12 22 L 7.5 22 A 4.5 4.5 0 0 1 3 17.5 z M 22 17.5 A 4.5 4.5 0 0 1 17.5 22 L 13 22 L 13 22.5 L 13 27 L 17.5 27 A 4.5 4.5 0 0 0 22 22.5 L 22 17.5 z "/>
	</svg>`,
	gen_volbg_horz: rectangle(main.lower.area, 14, 14),
	gen_volbg_horz_dark: rectangle(main.red.area, 14, 14),
	gen_volbg_vert: rectangle(main.lower.area, 14, 14),
	gen_volbg_vert_dark: rectangle(main.red.area, 14, 14),
	gen_volthumb_horz: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 25 29">
		<path fill="magenta" d="M 0 28 L 0 29 L 1 29 L 1 28 L 0 28 z M 24 28 L 24 29 L 25 29 L 25 28 L 24 28 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 7.5 6 A 4.5 4.5 0 0 0 3 10.5 L 3 17.5 A 4.5 4.5 0 0 0 7.5 22 L 12 22 L 12 17.5 L 12 10.5 L 12 6 L 7.5 6 z M 13 6 L 13 10.5 L 13 17.5 L 13 22 L 17.5 22 A 4.5 4.5 0 0 0 22 17.5 L 22 10.5 A 4.5 4.5 0 0 0 17.5 6 L 13 6 z "/>
		<path fill=${main.lower.like.shadow(0.5)} d="M 3 17.5 L 3 22.5 A 4.5 4.5 0 0 0 7.5 27 L 12 27 L 12 22.5 L 12 22 L 7.5 22 A 4.5 4.5 0 0 1 3 17.5 z M 22 17.5 A 4.5 4.5 0 0 1 17.5 22 L 13 22 L 13 22.5 L 13 27 L 17.5 27 A 4.5 4.5 0 0 0 22 22.5 L 22 17.5 z "/>
	</svg>`,
	gen_volthumb_horz_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 37 43">
		<path fill="magenta" d="M 0 42 L 0 43 L 1 43 L 1 42 L 0 42 z M 36 42 L 36 43 L 37 43 L 37 42 L 36 42 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 16.5 9 A 11.5 11.5 0 0 0 5 20.5 A 11.5 11.5 0 0 0 16.5 32 L 18 32 L 18 9 L 16.5 9 z M 19 9 L 19 32 L 20.5 32 A 11.5 11.5 0 0 0 32 20.5 A 11.5 11.5 0 0 0 20.5 9 L 19 9 z "/>
		<path fill=${main.lower.like.shadow(0.5)} d="M 5 20.5 L 5 28.5 A 11.5 11.5 0 0 0 16.5 40 L 18 40 L 18 32 L 16.5 32 A 11.5 11.5 0 0 1 5 20.5 z M 32 20.5 A 11.5 11.5 0 0 1 20.5 32 L 19 32 L 19 40 L 20.5 40 A 11.5 11.5 0 0 0 32 28.5 L 32 20.5 z "/>
	</svg>`,
	gen_volthumb_horz_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 57">
		<path fill="magenta" d="M 0 56 L 0 57 L 1 57 L 1 56 L 0 56 z M 47 56 L 47 57 L 48 57 L 48 56 L 47 56 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 21 12 A 16 16 0 0 0 5 28 A 16 16 0 0 0 21 44 L 23 44 L 23 12 L 21 12 z M 25 12 L 25 44 L 27 44 A 16 16 0 0 0 43 28 A 16 16 0 0 0 27 12 L 25 12 z "/>
		<path fill=${main.lower.like.shadow(0.5)} d="m 5,28 v 9 a 16,16 0 0 0 16,16 h 2 V 44 H 21 A 16,16 0 0 1 5,28 Z m 38,0 A 16,16 0 0 1 27,44 h -2 v 9 h 2 A 16,16 0 0 0 43,37 Z"/>
	</svg>`,
	gen_volthumb_vert: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 21 31">
		<path fill="magenta" d="M 20 0 L 20 5 L 21 5 L 21 0 L 20 0 z M 20 26 L 20 31 L 21 31 L 21 26 L 20 26 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 18,10.5 A 4.5,4.5 0 0 0 13.5,6 h -7 A 4.5,4.5 0 0 0 2,10.5 V 15 h 4.5 7 4.5 z M 18,16 H 13.5 6.5 2 v 4.5 A 4.5,4.5 0 0 0 6.5,25 h 7 A 4.5,4.5 0 0 0 18,20.5 Z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="M 2 20.5 L 2 24.5 A 4.5 4.5 0 0 0 6.5 29 L 13.5 29 A 4.5 4.5 0 0 0 18 24.5 L 18 20.5 A 4.5 4.5 0 0 1 13.5 25 L 6.5 25 A 4.5 4.5 0 0 1 2 20.5 z "/>
	</svg>`,
	gen_volthumb_vert_150: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 31 47">
		<path fill="magenta" d="M 30 0 L 30 8 L 31 8 L 31 0 L 30 0 z M 30 39 L 30 47 L 31 47 L 31 39 L 30 39 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 15 9 A 12 12 0 0 0 3 21 L 3 23 L 27 23 L 27 21 A 12 12 0 0 0 15 9 z M 3 24 L 3 26 A 12 12 0 0 0 15 38 A 12 12 0 0 0 27 26 L 27 24 L 3 24 z "/>
		<path fill=${main.lower.like.shadow(0.5)} d="m 3,26 v 2 2.5 2.5 A 12,12 0 0 0 15,45 12,12 0 0 0 27,33 V 30.5 28 26 A 12,12 0 0 1 15,38 12,12 0 0 1 3,26 Z"/>
	</svg>`,
	gen_volthumb_vert_200: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 41 54">
		<path fill="magenta" d="M 40 0 L 40 6 L 41 6 L 41 0 L 40 0 z M 40 48 L 40 54 L 41 54 L 41 48 L 40 48 z "/>
		<path fill=${main.lower.text.fade(main.dim).out()} d="M 36,24 A 16,16 0 0 0 20,8 16,16 0 0 0 4,24 v 2 h 32 z m 0,4 H 4 v 2 A 16,16 0 0 0 20,46 16,16 0 0 0 36,30 Z"/>
		<path fill=${main.lower.like.shadow(0.5)} d="m 4,30 v 1 2 2 2 A 16,16 0 0 0 20,53 16,16 0 0 0 36,37 V 35 33 31 30 A 16,16 0 0 1 20,46 16,16 0 0 1 4,30 Z"/>
	</svg>`,
	
	mcp_mainbg: rectangle(main.lower.like, 22, 9),
	mcp_mainbgsel: rectangle(main.raise("lower", "like", 0.05), 22, 9),
	mcp_master_volbg: cp::mcp_master_volbg,
	mcp_master_volbg_150: cp::mcp_master_volbg_150,
	mcp_master_volbg_200: cp::mcp_master_volbg_200,
	mcp_volbg: cp::mcp_volbg,
	mcp_volbg_150: cp::mcp_volbg_150,
	mcp_volbg_200: cp::mcp_volbg_200,
	
	scrollbar: SCROLLBAR,
	scrollbar_3: SCROLLBAR,
	
	piano_black_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${if main.is_dark() { main.lower.area.out() } else { lab::mix(main.lower.like, main.lower.text, main.dim).out() }} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(0.5) } else { lab::mix(main.lower.like, main.lower.text, main.dim).shadow(0.5) }} x="1" y="6" width="6" height="3"/>
	</svg>`,
	
	piano_black_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="yellow" d="M0 0L0 1L1 1L1 0L0 0zM8 5L8 10L9 10L9 5L8 5z"/>
		<path fill="magenta" d="M1 0L1 1L2 1L2 0L1 0zM1 1L0 1L0 2L1 2L1 1zM8 4L8 5L9 5L9 4L8 4zM6 9L6 10L8 10L8 9L6 9z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="5"/>
		<rect fill=${if main.is_dark() { main.lower.area.shadow(1) } else { lab::mix(main.lower.like, main.lower.text, main.dim).shadow(1) }} x="1" y="6" width="6" height="3"/>
	</svg>`,
	
	piano_white_key: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).shadow(1.5) } else { main.lower.like.shadow(1.5) }} x="1" y="8" width="7" height="1"/>
	</svg>`,
	
	piano_white_key_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 9 10">
		<path fill="magenta" d="M0 0L0 1L0 2L1 2L1 1L2 1L2 0L0 0zM8 8L8 9L7 9L7 10L8 10L9 10L9 8L8 8z"/>
		<rect fill=${main[accent].area.out()} x="1" y="1" width="7" height="7"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).out() } else { main.lower.like.out() }} x="1" y="8" width="7" height="1"/>
		<rect fill=${if main.is_dark() { lab::mix(main.lower.area, main.lower.text, main.dim).shadow(2) } else { main.lower.like.shadow(2) }} x="1" y="8" width="7" height="1"/>
	</svg>`,
	
	tcp_bg: cp::tcp_bg(main.raise("lower", "like", 0.05), 0, 47),
	tcp_bgsel: cp::tcp_bg(main.raise("lower", "like", 0.1), 0, 47),
	tcp_main_namebg_sel: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 3 3"/>`,
	tcp_mainbg: rectangle(main.lower.like, 22, 9),
	tcp_mainbgsel: rectangle(main.raise("lower", "like", 0.05), 22, 9),
	tcp_namebg: cp::tcp_namebg,
	tcp_namebg_200: cp::tcp_namebg_200,
	tcp_volbg: cp::tcp_volbg,
	tcp_volbg_150: cp::tcp_volbg_150,
	tcp_volbg_200: cp::tcp_volbg_200,
	tcp_vol_knob_small: cp::knob_small(true),
	tcp_vol_knob_small_150: cp::knob_small_150(true),
	tcp_vol_knob_small_200: cp::knob_small_200(true),
	
	track_recarm_auto: cp::arm("auto", "off", 1),
	track_recarm_auto_150: cp::arm("auto", "off", 1.5),
	track_recarm_auto_200: cp::arm("auto", "off", 2),
	track_recarm_auto_norec: cp::arm("auto", "disabled", 1),
	track_recarm_auto_norec_150: cp::arm("auto", "disabled", 1.5),
	track_recarm_auto_norec_200: cp::arm("auto", "disabled", 2),
	track_recarm_auto_norec_ol: cp::arm_OL,
	track_recarm_auto_norec_ol_150: cp::arm_OL_150,
	track_recarm_auto_norec_ol_200: cp::arm_OL_200,
	track_recarm_auto_ol: cp::arm_OL,
	track_recarm_auto_ol_150: cp::arm_OL_150,
	track_recarm_auto_ol_200: cp::arm_OL_200,
	track_recarm_auto_on: cp::arm("auto", "on", 1),
	track_recarm_auto_on_150: cp::arm("auto", "on", 1.5),
	track_recarm_auto_on_200: cp::arm("auto", "on", 2),
	track_recarm_auto_on_ol: cp::arm_OL,
	track_recarm_auto_on_ol_150: cp::arm_OL_150,
	track_recarm_auto_on_ol_200: cp::arm_OL_200,
	track_recarm_norec: cp::arm("rec", "disabled", 1),
	track_recarm_norec_150: cp::arm("rec", "disabled", 1.5),
	track_recarm_norec_200: cp::arm("rec", "disabled", 2),
	track_recarm_norec_ol: cp::arm_OL,
	track_recarm_norec_ol_150: cp::arm_OL_150,
	track_recarm_norec_ol_200: cp::arm_OL_200,
	track_recarm_off: cp::arm("rec", "off", 1),
	track_recarm_off_150: cp::arm("rec", "off", 1.5),
	track_recarm_off_200: cp::arm("rec", "off", 2),
	track_recarm_off_ol: cp::arm_OL,
	track_recarm_off_ol_150: cp::arm_OL_150,
	track_recarm_off_ol_200: cp::arm_OL_200,
	track_recarm_on: cp::arm("rec", "on", 1),
	track_recarm_on_150: cp::arm("rec", "on", 1.5),
	track_recarm_on_200: cp::arm("rec", "on", 2),
	track_recarm_on_ol: cp::arm_OL,
	track_recarm_on_ol_150: cp::arm_OL_150,
	track_recarm_on_ol_200: cp::arm_OL_200,
	
	transport_bg: rectangle(main.lower.like, 6, 5),
	transport_bpm: rectangle(main.lower.like, 6, 10),
	transport_bpm_bg: rectangle(main.lower.like, 6, 10),
	transport_end: transport::right(true, 1),
	transport_end_150: transport::right_150(true),
	transport_end_200: transport::right(true, 2),
	transport_home: transport::left(true, 1),
	transport_home_150: transport::left_150(true),
	transport_home_200: transport::left(true, 2),
	transport_knob_bg_large: transport::knob_bg_large,
	transport_knob_bg_large_150: transport::knob_bg_large_150,
	transport_knob_bg_large_200: transport::knob_bg_large_200,
	transport_next: transport::right(false, 1),
	transport_next_150: transport::right_150(false),
	transport_next_200: transport::right(false, 2),
	transport_pause: transport::pause(false, 1),
	transport_pause_on: transport::pause(true, 1),
	transport_pause_150: transport::pause_150(false),
	transport_pause_on_150: transport::pause_150(true),
	transport_pause_200: transport::pause(false, 2),
	transport_pause_on_200: transport::pause(true, 2),
	transport_play: transport::play(false, false, 1),
	transport_play_on: transport::play(false, true, 1),
	transport_play_sync: transport::play(true, false, 1),
	transport_play_sync_on: transport::play(true, true, 1),
	transport_play_150: transport::play_150(false, false),
	transport_play_on_150: transport::play_150(false, true),
	transport_play_sync_150: transport::play_150(true, false),
	transport_play_sync_on_150: transport::play_150(true, true),
	transport_play_200: transport::play(false, false, 2),
	transport_play_on_200: transport::play(false, true, 2),
	transport_play_sync_200: transport::play(true, false, 2),
	transport_play_sync_on_200: transport::play(true, true, 2),
	transport_playspeedbg: rectangle(main.lower.like, 6, 10),
	transport_previous: transport::left(false, 1),
	transport_previous_150: transport::left_150(false),
	transport_previous_200: transport::left(false, 2),
	transport_record: transport::record("none", false, 1),
	transport_record_on: transport::record("none", true, 1),
	transport_record_item: transport::record("item", false, 1),
	transport_record_item_on: transport::record("item", true, 1),
	transport_record_loop: transport::record("loop", false, 1),
	transport_record_loop_on: transport::record("loop", true, 1),
	transport_record_150: transport::record("none", false, 1.5), // WARNING not pixel perfect
	transport_record_on_150: transport::record("none", true, 1.5), // WARNING not pixel perfect
	transport_record_item_150: transport::record("item", false, 1.5), // WARNING not pixel perfect
	transport_record_item_on_150: transport::record("item", true, 1.5), // WARNING not pixel perfect
	transport_record_loop_150: transport::record("loop", false, 1.5), // WARNING not pixel perfect
	transport_record_loop_on_150: transport::record("loop", true, 1.5), // WARNING not pixel perfect
	transport_record_200: transport::record("none", false, 2),
	transport_record_on_200: transport::record("none", true, 2),
	transport_record_item_200: transport::record("item", false, 2),
	transport_record_item_on_200: transport::record("item", true, 2),
	transport_record_loop_200: transport::record("loop", false, 2),
	transport_record_loop_on_200: transport::record("loop", true, 2),
	transport_repeat_off: transport::repeat(false, 1),
	transport_repeat_on: transport::repeat(true, 1),
	transport_repeat_off_150: transport::repeat_150(false),
	transport_repeat_on_150: transport::repeat_150(true),
	transport_repeat_off_200: transport::repeat(false, 2),
	transport_repeat_on_200: transport::repeat(true, 2),
	transport_status_bg: rectangle(main.lower.like, 6, 10),
	transport_status_bg_err: rectangle(main.red.like.fade(0.2), 6, 10),
	transport_stop: transport::stop(1),
	transport_stop_150: transport::stop_150,
	transport_stop_200: transport::stop(2),
}

/* ANCHOR regex to remove spaces from path data (replace with $1)
\s?([a-zA-Z])\s?
*/
