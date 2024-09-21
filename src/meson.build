# SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0

# link `config.rs`:

run_command('test', '!', '-e', 'config.rs', '-o', '-L', 'config.rs', check: true)

run_command('ln', '-frs', configure_file(
	input: 'config.rs.in',
	output: '@BASENAME@',
	configuration: {
		'APP': meson.project_name(),
		'APP_ID': app_id,
		'VERSION': meson.project_version(),
		'PREFIX_DIR': get_option('prefix'),
		'LOCALE_DIR': get_option('localedir'),
		'DATA_DIR': get_option('datadir'),
		'RANDOM': random,
	},
), check: true)

# link `icons.rs`:

link = 'bin' / 'gui' / 'icons.rs'

run_command('test', '!', '-e', link, '-o', '-L', link, check: true)

run_command('ln', '-frs', configure_file(
	input: '@0@.in'.format(link),
	output: '@BASENAME@',
	configuration: { 'APP': meson.project_name(), 'RANDOM': random },
), link, check: true)

# build:

cargo_options = []

if get_option('profile') == 'dev'
	message('DEBUG MODE')
	rust_target = 'debug'
else
	message('RELEASE MODE')
	cargo_options += ['--release']
	rust_target = 'release'
endif

custom_target('cli',
	build_by_default: true,
	output: meson.project_name(),
	console: true,
	command: [
		cargo, 'build', '--features', 'cli', cargo_options,
		'&&',
		'ln', '-f', 'target' / rust_target / meson.project_name(), '@OUTPUT@',
	],
	install: true,
	install_dir: get_option('bindir'),
)

custom_target('gui',
	output: '@0@-gui'.format(meson.project_name()),
	console: true,
	command: [
		cargo, 'build', '--features', 'gui', '--bin', 'gui', cargo_options,
		'&&',
		'ln', '-f', 'target' / rust_target / 'gui', '@OUTPUT@',
	],
	install: true,
	install_dir: get_option('bindir'),
)
