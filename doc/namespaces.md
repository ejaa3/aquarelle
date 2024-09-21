<!--
	SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Namespaces

A namespace indexes a collection of themes, schemes, maps or arrangements. They are located in a user-modifiable path, or in an operating system path managed by a software manager.

To list available namespaces, as well as predefined user and system paths, run:

<!-- i18n:skip -->
~~~ sh
aquarelle list namespaces
~~~

## Creation and structure { #creation }

<!-- i18n:comment: Do not translate `text in backticks`. You could leave the translation aside in parentheses or something similar. For example, in Spanish it would be: `themes` (themes). -->
To define a new namespace you can create a directory in the user's path with a manifest file named `Aquarelle.toml`, whose structure consists of the following tables: `themes`, `schemes`, `maps` and `arrangements`.

In the contents of each table, keys identify new items and their values ​​can be relative paths to their manifest files.[^value] For example:

<!-- i18n:skip -->
~~~ toml
name = 'Personal test'
about = 'Testing Aquarelle'

[themes]
'my-theme' = 'my_theme.toml'
'another-theme' = 'another/theme.toml'

[schemes]
'my-scheme' = 'my_scheme.toml'
'another-scheme' = 'another/scheme.toml'

[maps]
'my-map' = 'my_map.toml'
'unstable-map' = 'unstable/map.toml'

[arrangements]
'my-arrangement' = 'my_arrangement.toml'
'unstable-arrangement' = 'unstable/arrangement.toml'
~~~

<sup>__NOTE:__ Keys in quotes indicate IDs. You decide how to identify an item.</sup>

<!-- i18n:comment: Do not translate `text in backticks`. -->
If the namespace directory is named `personal-test`, then according to that example manifest it should have the following contents:

<!-- i18n:skip -->
~~~
personal-test
├── Aquarelle.toml
├── my_theme.toml
├── my_scheme.toml
├── my_map.toml
├── my_arrangement.toml
├── another
│   ├── theme.toml
│   └── scheme.toml
└── unstable
    ├── map.toml
    └── arrangement.toml
~~~

<!-- i18n:comment: Do not translate `text in backticks`. -->
The namespace ID is its directory name. Aquarelle comes with its own namespace identified as `aquarelle`.

To check that your namespace is error-free, run the command at the beginning, but note that the command does not check that the indexed files exist.

---

<!-- i18n:comment: Do not translate `text in backticks`. -->
[^value]: Values ​​can also be manifest, so there is no need to specify paths to external manifest files, but they would be more verbose. E.g. a scheme name would be defined as `schemes.'my-scheme'.name = 'My Scheme'` instead of `name = 'My Scheme'` in an external file.
