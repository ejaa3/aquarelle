<!--
	SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Options

Maps and parametric schemes can have optional values, meaning they can be modified in the arrangement or theme that requests them. Values ​​can be:

<!-- i18n:comment: Do not translate `text in backticks`. -->
- [Booleans](https://toml.io/en/v1.0.0#boolean), that is, `true` or `false`.
- [Integers](https://toml.io/en/v1.0.0#integer), such as `12` or `24`.
- [Floating-point numbers](https://toml.io/en/v1.0.0#float), such as `12.0` or `24.0`.
- [Text strings](https://toml.io/en/v1.0.0#string), such as `'this string'`.
- Accent colors, such as `{ accent = 'red' }`.

## Creation and structure

<!-- i18n:comment: Do not translate `text in backticks`. -->
You can define options in your map or parametric scheme by adding keys to an `options` table, whose values consist of a table with the keys `name` and `about` [as in the introduction](index.md#extensibility), and a `default` key whose value will not only be the default value of the option (without a default value, the option would not be optional), but also that the value determines its data type. For example:

<!-- i18n:skip -->
~~~ toml
[options]
'first'  = { name = 'An integer number', default = 12 }
'second' = { name = 'A floating-point number', default = 12.0 }

[options.'third']
name = 'A boolean option'
about = 'Can only be `true` or `false`'
default = false

[options.'text']
name = 'A string option'
default = 'Any text'

[options.'color']
name = 'An accent color option'
default = { accent = 'red' }
~~~

<sup>__NOTE:__ Keys in quotes indicate IDs. You decide how to identify an item.</sup>

You can get the optional values ​​in your script as follows:

<!-- i18n:skip -->
~~~ rust
let first  = cfg::option("first");
let second = cfg::option("second");
let third  = cfg::option("third");
let text   = cfg::option("text");
let accent = cfg::option("color");

print(first);  // 12
print(second); // 12.0
print(third);  // false
print(text);   // "Any text"
print(accent); // "red"
~~~

You can see that the accent color is just a string, so you can use it as an index:

<!-- i18n:skip -->
~~~ rust
let scheme = cfg::scheme("main");
let accent = cfg::option("color"); // "red"

let test = scheme[accent].area == scheme.red.area;

print(test) // true
~~~

## Modifying options { #modifying }

<!-- i18n:comment: Do not translate `text in backticks`. -->
Options are modified by an `options` table, whose keys identify the options defined in the map or parametric scheme, and whose values ​​modify them (they are of the option data type).

For example, to modify the above options:

<!-- i18n:skip -->
~~~ toml
[options]
first = 24
second = 24.0
third = true
text = 'Another text'
color = { accent = 'yellow' }
~~~

Since parametric schemes can only be requested by themes, their options can only be modified in themes. Likewise, since maps can only be requested by arrangements, their options can only be modified in arrangements.

## Preset values { #presets }

Arrangements and themes can have presets, which can be bound to options in different maps or parametric schemes, so that changing the preset changes the value of the bound options, which is useful for consistency.

<!-- i18n:comment: Do not translate `text in backticks`. -->
They are defined in the `presets` table, whose keys identify them and whose values ​​can be of any optional data type. For example, let's say you want to share the same accent color across multiple apps, as well as high contrast. The preset values ​​will be:

<!-- i18n:skip -->
~~~ toml
[presets]
'color' = { accent = 'blue' }
'high-contrast' = true
~~~

<sup>__NOTE:__ Keys in quotes indicate IDs. You decide how to identify an item.</sup>

<!-- i18n:comment: Do not translate `text in backticks`. -->
To bind to options, the option value must be a table with the key `bind` whose value is the key of a preset. For example:

<!-- i18n:skip -->
~~~ toml
['some-app'.options]
app-color = { bind = 'color' }
app-high-contrast = { bind = 'high-contrast' }
~~~

If the option key is the same as the preset value, you can leave the string empty:

<!-- i18n:skip -->
~~~ toml
['some-app'.options]
color = { bind = '' }
high-contrast = { bind = '' }
~~~

<!-- i18n:comment: Do not translate `text in backticks`. -->
TOML allows saving braces (e.g. `color.bind = ''`), which is ideal for inline tables:

<!-- i18n:skip -->
~~~ toml
['some-app']
options = { color.bind = '', high-contrast.bind = '' }
~~~
