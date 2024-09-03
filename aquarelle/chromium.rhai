/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main = cfg::scheme("main");

fn out() { let rgb = rgb::coords(this); `[${rgb.red}, ${rgb.green}, ${rgb.blue}]` }

// WATCH https://source.chromium.org/chromium/chromium/src/+/main:chrome/browser/themes/browser_theme_pack.cc;l=221

#{ manifest: /* JSON */ `{
	"manifest_version": 3,
	"version": "2.6",
	"name": "Aquarelle Theme",
	"theme": {
		"colors": {
			"background_tab_inactive": ${main.lower.like.out()},
			"background_tab_incognito_inactive": ${lab::mix(main.lower.like, main.magenta.area, 0.2).out()},
			"background_tab_incognito": ${lab::mix(main.lower.area, main.magenta.area, 0.2).out()},
			"background_tab": ${main.lower.area.out()},
			"bookmark_text": ${main.upper.text.out()},
			"button_background": [0, 255, 0],
			"frame_inactive": ${main.lower.like.out()},
			"frame_incognito_inactive": ${lab::mix(main.lower.like, main.magenta.area, 0.2).out()},
			"frame_incognito": ${lab::mix(main.lower.area, main.magenta.area, 0.2).out()},
			"frame": ${main.lower.area.out()},
			"ntp_background": ${main.lower.like.out()},
			"ntp_header": [255, 0, 0],
			"ntp_link": [0, 0, 255],
			"ntp_text": ${main.lower.text.out()},
			"omnibox_background": ${main.lower.like.out()},
			"omnibox_text": ${main.lower.text.out()},
			"tab_background_text_inactive": ${lab::mix(main.upper.like, main.upper.text, 0.625).out()},
			"tab_background_text_incognito_inactive": ${lab::mix(main.upper.like, main.upper.text, 0.625).out()},
			"tab_background_text_incognito": ${main.upper.text.out()},
			"tab_background_text": ${main.upper.text.out()},
			"tab_text": ${main.upper.text.out()},
			"toolbar_button_icon": ${main.upper.text.out()},
			"toolbar_text": ${main.upper.text.out()},
			"toolbar": ${main.upper.area.out()}
		}
	}
}` }
