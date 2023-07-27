# SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
#
# SPDX-License-Identifier: Apache-2.0

install_data('app' / f'@app_id@.svg',
	install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
)

install_data('app' / f'@base_id@-symbolic.svg',
	install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'symbolic' / 'apps',
	rename: f'@app_id@-symbolic.svg',
)
