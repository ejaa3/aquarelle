/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

fn shadow(color) {
	const luma = color.luma();
	2 ** -luma + 0.2 * luma - 0.6
}

fn print_colors(colors, title) {
	print("\n[" + title + ']');
	for (color, i) in colors {
		print(`${if i < 10 {' '}}${i}: ${color.sgr_fg()} ${color.sgr_bg()}`);
	}
}
