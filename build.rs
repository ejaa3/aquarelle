/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Unlicense
 */

fn main() {
	#[cfg(feature = "gui")]
	glib_build_tools::compile_resources(
		&["data"],
		"data/resources.gresource.xml",
		"resources.gresource",
	);
}
