/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { '#' + this.to_hex_rgba(true) }

`
@-moz-document url("about:newtab"), url("about:home") {
	body {
		--newtab-background-color: ${main.lower.like.out()} !important;
		--newtab-background-color-secondary: ${main.upper.like.out()} !important;
		--newtab-text-primary-color: ${main.lower.text.out()} !important;
		--newtab-primary-action-background: ${main[accent].area.out()} !important;
		--newtab-primary-element-text-color: ${main[accent].text.out()} !important;
		--newtab-primary-action-background-pocket: ${main.cyan.area.out()} !important;
		--newtab-status-error: ${main.red.area.out()} !important;
		--newtab-status-success: ${main.green.area.out()} !important;
		--newtab-text-emphasis-background: ${main.yellow.area.out()} !important;
		--newtab-text-emphasis-text-color: ${main.yellow.text.out()} !important;
		--newtab-wordmark-color: ${main.lower.text.out()} !important;
	}
}
`
