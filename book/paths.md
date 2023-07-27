<!--
	SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Paths

Aquarelle allows you to specify the location where to save the results according to the standard directories of the platform (or not) with the following syntax:

~~~ TOML
standard-way = { standard-directory = 'relative/path' }
absolute-way = '/absolute/path'
~~~

`standard-way` and `absolute-way` are simple unknown keys. In the standard way, the `standard-directory`` key must be replaced with one of the following:

<!-- FIXME coincidence with Aquarelle -->

|      Key       |                  Value on Linux/Redox                  | Value on Windows            |            Value on macOS           |
| :------------: | ------------------------------------------------------ | --------------------------- | ----------------------------------- |
| `home`         | `$HOME`                                                | `{FOLDERID_Profile}`        | `$HOME`                             |
| `cache`        | `$XDG_CACHE_HOME`       or `$HOME/.cache`              | `{FOLDERID_LocalAppData}`   | `$HOME/Library/Caches`              |
| `config`       | `$XDG_CONFIG_HOME`      or `$HOME/.config`             | `{FOLDERID_RoamingAppData}` | `$HOME/Library/Application Support` |
| `config_local` | `$XDG_CONFIG_HOME`      or `$HOME/.config`             | `{FOLDERID_LocalAppData}`   | `$HOME/Library/Application Support` |
| `data`         | `$XDG_DATA_HOME`        or `$HOME/.local/share`        | `{FOLDERID_RoamingAppData}` | `$HOME/Library/Application Support` |
| `data_local`   | `$XDG_DATA_HOME`        or `$HOME/.local/share`        | `{FOLDERID_LocalAppData}`   | `$HOME/Library/Application Support` |
| `executable`   | `$XDG_BIN_HOME`         or `$HOME/.local/bin`          |                             |                                     |
| `preference`   | `$XDG_CONFIG_HOME`      or `$HOME/.config`             | `{FOLDERID_RoamingAppData}` | `$HOME/Library/Preferences`         |
| `runtime`      | `$XDG_RUNTIME_DIR`      or not                         |                             |                                     |
| `state`        | `$XDG_STATE_HOME`       or `$HOME/.local/state`        |                             |                                     |
| `audio`        | `$XDG_MUSIC_DIR`        or not                         | `{FOLDERID_Music}`          | `$HOME/Music/`                      |
| `desktop`      | `$XDG_DESKTOP_DIR`      or not                         | `{FOLDERID_Desktop}`        | `$HOME/Desktop/`                    |
| `document`     | `$XDG_DOCUMENTS_DIR`    or not                         | `{FOLDERID_Documents}`      | `$HOME/Documents/`                  |
| `download`     | `$XDG_DOWNLOAD_DIR`     or not                         | `{FOLDERID_Downloads}`      | `$HOME/Downloads/`                  |
| `font`         | `$XDG_DATA_HOME/fonts/` or `$HOME/.local/share/fonts/` |                             | `$HOME/Library/Fonts/`              |
| `picture`      | `$XDG_PICTURES_DIR`     or not                         | `{FOLDERID_Pictures}`       | `$HOME/Pictures/`                   |
| `public`       | `$XDG_PUBLICSHARE_DIR`  or not                         | `{FOLDERID_Public}`         | `$HOME/Public/`                     |
| `template`     | `$XDG_TEMPLATES_DIR`    or not                         | `{FOLDERID_Templates}`      |                                     |
| `video`        | `$XDG_VIDEOS_DIR`       or not                         | `{FOLDERID_Videos}`         | `$HOME/Movies/`                     |
