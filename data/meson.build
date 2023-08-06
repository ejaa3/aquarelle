# SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0

config = {
	'APP': meson.project_name(),
	'APP_ID': app_id,
	'APP_PATH': app_id.replace('.', '/'),
	'RANDOM': random,
	'LICENSE': meson.project_license().get(0),
}

install_data('app-icons' / f'@app_id@.svg',
	install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
)

install_data('app-icons' / f'@base_id@-symbolic.svg',
	install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
	rename: f'@app_id@-symbolic.svg',
)

desktop_file = i18n.merge_file(
	input: configure_file(
		input: f'@base_id@.desktop.in.in',
		output: '@BASENAME@',
		configuration: config,
	),
	output: f'@app_id@.desktop',
	type: 'desktop',
	po_dir: '../po',
	install: true,
	install_dir: get_option('datadir') / 'applications',
)

desktop_utils = find_program('desktop-file-validate', required: false)

if desktop_utils.found()
	test('validate-desktop', desktop_utils,
		args: [desktop_file],
		depends: desktop_file,
	)
endif

appstream_file = i18n.merge_file(
	input: configure_file(
		input: f'@base_id@.appdata.xml.in.in',
		output: '@BASENAME@',
		configuration: config,
	),
	output: f'@app_id@.appdata.xml',
	po_dir: '../po',
	install: true,
	install_dir: get_option('datadir') / 'appdata',
)

appstream_util = find_program('appstream-util', required: false)

if appstream_util.found()
	test('validate-appdata', appstream_util,
		args: ['validate', '--nonet', appstream_file],
		depends: appstream_file,
	)
endif

configure_file(
	input: f'@base_id@.gschema.xml.in',
	output: f'@app_id@.gschema.xml',
	configuration: config,
	install: true,
	install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
)

compile_schemas = find_program('glib-compile-schemas', required: false)

if compile_schemas.found()
	test('validate-gschema', compile_schemas,
		args: ['--strict', '--dry-run', meson.current_build_dir()],
	)
endif

symlink = 'resources.gresource.xml'
run_command('test', '!', '-e', symlink, '-o', '-L', symlink, check: true)
run_command('ln', '-frs', configure_file(
	input: 'resources.gresource.xml.in',
	output: '@BASENAME@',
	configuration: config,
), symlink, check: true)
