# SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0

project('aquarelle', 'rust',
	version: '0.1.0',
	license: 'AGPL-3.0-only',
	meson_version: '>= 1.2.0',
	default_options: [ 'warning_level=2', 'werror=false' ],
)

gnome = import('gnome', required: true)
i18n = import('i18n', required: true)

dependency('glib-2.0', version: '>= 2.76')
dependency('gio-2.0', version: '>= 2.76')
dependency('pango', version: '>= 1.50')
dependency('cairo', version: '>= 1.16')
dependency('gdk-pixbuf-2.0', version: '>= 2.42')
dependency('gtk4', version: '>= 4.10')
# dependency('gtksourceview-5', version: '>= 5.8')
dependency('libadwaita-1', version: '>= 1.4')

base_id = 'io.github.ejaa3.Aquarelle'
app_id = get_option('profile') == 'dev' ? f'@base_id@.Devel' : base_id

cargo = find_program('cargo')

shuf = find_program('shuf', required: false)

random = shuf.found() ? ''.join(run_command(
	shuf, '-n16', '-re', # '-',
	'a', 'A', 'b', 'B', 'c', 'C', 'd', 'D', 'e', 'E', 'f', 'F', 'g', 'G', 'h', 'H',
	'i', 'I', 'j', 'J', 'k', 'K', 'l', 'L', 'm', 'M', 'n', 'N', 'o', 'O', 'p', 'P',
	'q', 'Q', 'r', 'R', 's', 'S', 't', 'T', 'u', 'U', 'v', 'V', 'w', 'W', 'x', 'X',
	'y', 'Y', 'z', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '_',
	check: true
).stdout().split()) : app_id

symlink = '.cargo' / 'config.toml'
run_command('mkdir', '-p', '.cargo', check: true)
run_command('test', '!', '-e', symlink, '-o', '-L', symlink, check: true)
run_command('ln', '-fsr', configure_file(
	input: 'config.toml.in',
	output: '@BASENAME@',
	configuration: { 'TARGET_DIR': meson.project_build_root() / 'target' },
), symlink, check: true)

find_program('glib-compile-resources')

subdir('data')
subdir('po')
subdir('src')

install_subdir(meson.project_name(),
	install_dir: get_option('prefix') / get_option('datadir') / meson.project_name(),
)

find_program('glib-compile-schemas')
find_program('gtk-update-icon-cache')
find_program('update-desktop-database')

gnome.post_install(
	glib_compile_schemas: true,
	gtk_update_icon_cache: true,
	update_desktop_database: true,
)
