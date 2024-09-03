/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main = cfg::scheme("main");

fn out() { '#' + this.to_hex_rgb(true) } // json

`{
	"enabled": true,
	"fetchNews": true,
	
	"theme": {
		"mode": ${if main.lower.text.luma() > main.lower.like.luma() { 1 } else { 0 }},
		"brightness": 100,
		"contrast": 100,
		"grayscale": 0,
		"sepia": 0,
		"useFont": false,
		"fontFamily": "Open Sans",
		"textStroke": 0,
		"engine": "dynamicTheme",
		"stylesheet": "",
		"darkSchemeBackgroundColor": "${main.lower.like.out()}",
		"darkSchemeTextColor": "${main.lower.text.out()}",
		"lightSchemeBackgroundColor": "${main.lower.area.out()}",
		"lightSchemeTextColor": "${main.lower.text.out()}",
		"scrollbarColor": "auto",
		"selectionColor": "${main[cfg::option("accent")].area.out()}",
		"styleSystemControls": false,
		"lightColorScheme": "Default",
		"darkColorScheme": "Default",
		"immediateModify": false
	},
	
	"presets": [],
	"customThemes": [],
	
	"siteList": [${cfg::option("exclusions")}],
	
	"siteListEnabled": [${cfg::option("inclusions")}],
	
	"applyToListedOnly": ${cfg::option("listed-only")},
	"changeBrowserTheme": ${cfg::option("theme")},
	"syncSettings": ${cfg::option("sync")},
	"syncSitesFixes": ${cfg::option("sync-fixed")},
	
	"automation": {
		"enabled": false,
		"mode": "",
		"behavior": "OnOff"
	},
	
	"time": {
		"activation": "18:00",
		"deactivation": "9:00"
	},
	
	"location": {
		"latitude": null,
		"longitude": null
	},
	
	"previewNewDesign": true,
	"enableForPDF": true,
	"enableForProtectedPages": false,
	"enableContextMenus": ${cfg::option("menus")},
	"detectDarkTheme": ${cfg::option("detection")},
	"automationBehaviour": "OnOff"
}`
