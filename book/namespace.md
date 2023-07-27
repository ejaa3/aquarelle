<!--
	SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Namespaces

A namespace is a collection of arrangements, themes, schemes and maps. It is defined by creating a directory inside `<XDG_DATA_HOME>/aquarelle`, that is `<HOME>/.local/share/aquarelle` according to the [XDG Base Directory Specification], whose name must be Unicode text because it will be used as namespace identification.

[XDG Base Directory Specification]: https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html

It is also valid inside one of the `XDG_DATA_DIRS` locations plus `/aquarelle`. Directories created in this location define _system namespaces_ (ideal for distribution with package managers), while those created in the above define _local namespaces_ (ideal for personal use).

If there are two namespaces with the same identification, which is only possible if one is local and one is system, the local one will take precedence. Finally, the directory must have a file called `Aquarelle.toml` with the following content:

~~~ TOML
 name = 'My Namespace' # display name (required)
about = 'This is an example' # a description (optional)

# because arrangements, themes, palettes and maps are other files,
# they need to be localized using relative paths (strings)

[arrangements] # arrangement list (optional)

# example arrangement:
my-arrangement = 'my_arrangement.toml'
# `my-arrangement` identifies an arrangement located at `./my_arrangement.toml`

# the next one is located at `./path_to/another_arrangement.toml`:
another = 'path_to/another_arrangement.toml'

[maps] # map list (optional)

# example map:
my-map = { rhai = 'my_map.rhai', toml = 'my_map.toml' }
# a map locates two files: its settings (toml) and its mapping (rhai)

# another way to specify a map in TOML:
[maps.another-map] # identification is `another-map`
rhai = 'path_to/another_map.rhai'
toml = 'path_to/another_map.toml'

[themes] # theme list (optional)
my-theme = 'themes/my_theme.toml' # example theme

[scheme] # scheme list (optional)

[scheme.my-scheme] # example scheme, identified as `my-scheme`
rhai = 'schemes/my_scheme.rhai'
toml = 'schemes/my_scheme.toml'
~~~

Based on this setup, the namespace directory should contain the following:

~~~
.
├── Aquarelle.toml
├── my_arrangement.toml
├── my_map.rhai
├── my_map.toml
├── path_to/
│   ├── another_arrangement.toml
│   ├── another_map.rhai
│   └── another_map.toml
├── schemes/
│   ├── my_scheme.rhai
│   └── my_scheme.toml
└── themes/
    └── my_theme.toml
~~~

You can list everything by running: `aquarelle list`.

<!-- TODO: Print locations from CLI. -->
