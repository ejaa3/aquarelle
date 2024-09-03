/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

private fn out() { '#' + this.to_hex_rgb(true) }

private fn shadow(factor) {
	const L = this.luma();
	lab::mix(this, 0, (2 ** -L + 0.2 * L - 0.6) * factor).out()
}

export const THEME = `
default_font_face Noto Sans
default_font_size 13
menubar_height 20
menubar_font_size 12
menubar_spacing_width 16
menubar_margin_width 8
scrollbar_width 10
scrollbar_min_thumb_height 4
combo_height 20
_3dface ${main.lower.like.out()}
_3dshadow ${main.lower.like.shadow(1)}
_3dhilight ${lab::lighten(main.lower.like, if main.is_dark() { 0.075 } else { 0.25 }).out()}
_3ddkshadow #FF0000
button_bg ${lab::mix(main.lower.like, main.lower.text, 0.1).out()} ; defaults to _3dface
button_text ${main.lower.text.out()}
button_text_disabled ${lab::mix(main.lower.like, main.lower.text, 0.625).out()}
button_shadow ${main.lower.like.shadow(1)}
button_hilight ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
checkbox_text ${main.lower.text.out()}
checkbox_text_disabled ${lab::mix(main.lower.like, main.lower.text, 0.625).out()}
checkbox_fg ${main.lower.text.out()}
checkbox_inter #00FF00
checkbox_bg ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
scrollbar #FF00FF
scrollbar_fg ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
scrollbar_bg ${main.lower.like.out()}
edit_cursor ${main.lower.text.out()}
edit_bg ${main.lower.area.out()}
edit_bg_disabled ${main.lower.like.out()}
edit_text ${main.lower.text.out()}
edit_text_disabled ${lab::mix(main.lower.area, main.lower.text, 0.625).out()}
edit_bg_sel ${main[accent].area.out()}
edit_text_sel ${main[accent].text.out()}
; edit_hilight #e0e0e0 ; defaults to _3dhilight
; edit_shadow #606060 ; defaults to _3dshadow
info_bk ${main.upper.area.out()}
info_text ${main.upper.text.out()}
menu_bg ${main.upper.like.out()} ; defaults to _3dface
menu_shadow ${main.upper.like.shadow(1)} ; defaults to _3dshadow
menu_hilight ${lab::mix(main.upper.like, main.lower.text, 0.2).out()} ; defaults to _3dhilight
menu_text ${main.lower.text.out()} ; defaults to button_text
menu_text_disabled ${lab::mix(main.upper.like, main.lower.text, 0.625).out()}
menu_bg_sel ${main[accent].area.out()} ; defaults to menu_text
menu_text_sel ${main[accent].text.out()} ; defaults to menu_bg
menu_scroll ${main[accent].area.out()}
menu_scroll_arrow ${main[accent].text.out()} ; defaults to _3dshadow
menu_submenu_arrow ${lab::mix(main.upper.like, main.lower.text, 5.0 / 6).out()}
; menubar_bg #000000 ; defaults to menu_bg
; menubar_text #000000 ; defaults to menu_text
menubar_text_disabled #808080
; menubar_bg_sel #000000 ; defaults to menu_bg_sel
; menubar_text_sel #000000 ; defaults to menu_text_sel
trackbar_track #e0e0e0
trackbar_mark #606060
trackbar_knob #303030
progress ${main[accent].area.out()}
; label_text #000000 ; defaults to button_text
; label_text_disabled #000000 ; defaults to button_text_disabled
; combo_text #000000 ; defaults to button_text
; combo_text_disabled #000000 ; defaults to button_text_disabled
combo_bg ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
combo_bg2 ${lab::mix(main.lower.like, main.lower.text, 0.1).out()} ; editable
combo_shadow ${main.lower.like.shadow(1)}
combo_hilight ${lab::mix(main.lower.like, main.lower.text, 0.2).out()} ; defaults to _3dhilight
combo_arrow ${lab::mix(main.lower.like, main.lower.text, 5.0 / 6).out()}
combo_arrow_press ${main.lower.text.out()} ; defaults to _3dhilight
listview_bg ${main.lower.area.out()}
listview_bg_sel ${main[accent].area.out()}
listview_text ${main.lower.text.out()}
listview_text_sel ${main[accent].text.out()}
listview_bg_sel_inactive ${lab::mix(main.lower.area, main[accent].area, 0.2).out()}
listview_text_sel_inactive ${main[accent].like.out()}
listview_grid ${lab::mix(main.upper.like, main.lower.text, 0.25)} ; defaults to _3dhilight
listview_hdr_arrow ${lab::mix(main.upper.like, main.lower.text, 5.0 / 6).out()}
listview_hdr_shadow ${main.lower.area.shadow(1)} ; defaults to _3dshadow
listview_hdr_hilight ${lab::lighten(main.upper.area, if main.is_dark() { 0.075 } else { 0.25 }).out()} ; defaults to _3dhilight
listview_hdr_bg ${main.upper.like.out()} ; defaults to _3dface
listview_hdr_text ${main.lower.text.out()} ; defaults to button_text
treeview_text ${main.lower.text.out()}
treeview_bg ${main.lower.area.out()}
treeview_bg_sel ${main[accent].area.out()}
treeview_text_sel ${main[accent].text.out()}
treeview_bg_sel_inactive ${lab::mix(main.lower.area, main[accent].area, 0.2).out()}
treeview_text_sel_inactive ${main[accent].like.out()}
treeview_arrow ${lab::mix(main.lower.area, main.lower.text, 5.0 / 6).out()}
tab_shadow ${main.lower.like.shadow(1)}
tab_hilight ${lab::lighten(main.lower.like, if main.is_dark() { 0.075 } else { 0.25 }).out()}
tab_text ${main.lower.text.out()}
focusrect #0000FF
group_text ${main.lower.text.out()}
; group_shadow #606060 ; defaults to _3dshadow
; group_hilight #e0e0e0 ; defaults to _3dhilight
focus_hilight ${lab::mix(main.lower.like, main[accent].area, 0.5).out()}
`
