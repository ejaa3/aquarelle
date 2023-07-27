/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const       main = cfg::scheme("main");
const     accent = cfg::option("accent");
const exclusions = cfg::option("exclusions");
const inclusions = cfg::option("inclusions");

fn out() { '#' + this.to_hex_rgb(true) }

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
	"selectionColor": "${main[accent].area.out()}",
	"styleSystemControls": false,
	"lightColorScheme": "Default",
	"darkColorScheme": "Default",
	"immediateModify": false
},

"presets": [],
"customThemes": [],

"siteList": [${exclusions}],

"siteListEnabled": [${inclusions}],

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
