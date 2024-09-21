<!--
	SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Themes and schemes

A theme is a collection of color schemes that can be generated from parameters, or manually determined color by color. Each scheme contains 27 colors that are classified into roles and role sets.

The color roles are 3 keys:
- `area`: is the background color of an area.
- `text`: is the color of a text over the area, that is, the foreground.
- `like`: is a color like the area, but can be background or foreground.

The main color sets are 2 keys:
- `lower`: predominant or basic colors.
- `upper`: colors that sit on the lower ones.

<!-- i18n:comment: Do not translate `text in backticks`, although you could leave the translation in parentheses next to each one. For example, in Spanish “`red`” would be “`red` _(rojo)_”. -->
The accent color sets are 7 keys: `red`, `yellow`, `green`, `cyan`, `blue`, `magenta` and `any`. In total there are 9 sets; multiplied by the number of roles (3) results in the 27 colors of a scheme.

## Creation and structure

<!-- i18n:comment: Do not translate `text in backticks`. -->
A theme can be created by [indexing](namespaces.md#creation) its TOML manifest into the namespace,[^alt] whose contents consist primarily of the `schemes` table, whose keys identify the theme's schemes, and whose values ​​consist of the `name` key for the scheme name, plus the 9 color set keys.

The set value is the 3 color role keys, and the role value is an integer that is interpreted as a color in the sRGB space.

<!-- i18n:comment: Do not translate `text in backticks`. -->
For example, let's look at the file structure of the _[Gruvbox](https://github.com/morhetz/gruvbox)_ theme from the `aquarelle` namespace:

<!-- i18n:skip -->
~~~ toml
name  = 'Gruvbox'
about = 'Retro groove color scheme for Vim.'

[schemes.'dark']
name    = 'Gruvbox Dark'
lower   = { like = 0x282828FF, area = 0x1D2021FF, text = 0xD5C4A1FF }
upper   = { like = 0x32302FFF, area = 0x3C3836FF, text = 0xEBDBB2FF }
red     = { like = 0xFB4934FF, area = 0xCC241DFF, text = 0x282828FF }
yellow  = { like = 0xFABD2FFF, area = 0xD79921FF, text = 0x282828FF }
green   = { like = 0xB8BB26FF, area = 0x98971AFF, text = 0x282828FF }
cyan    = { like = 0x8EC07CFF, area = 0x689D6AFF, text = 0x282828FF }
blue    = { like = 0x83A598FF, area = 0x458588FF, text = 0x282828FF }
magenta = { like = 0xD3869BFF, area = 0xB16286FF, text = 0x282828FF }
any     = { like = 0xFE8019FF, area = 0xD65D0EFF, text = 0x282828FF }

[schemes.'light']
name    = 'Gruvbox Light'
lower   = { like = 0xF2E5BCFF, area = 0xFBF1C7FF, text = 0x3C3836FF }
upper   = { like = 0xEBDBB2FF, area = 0xFBF1C7FF, text = 0x504945FF }
red     = { like = 0x9D0006FF, area = 0xCC241DFF, text = 0xF2E5BCFF }
yellow  = { like = 0xB57614FF, area = 0xD79921FF, text = 0xF2E5BCFF }
green   = { like = 0x79740EFF, area = 0x98971AFF, text = 0xF2E5BCFF }
cyan    = { like = 0x427B58FF, area = 0x689D6AFF, text = 0xF2E5BCFF }
blue    = { like = 0x076678FF, area = 0x458588FF, text = 0xF2E5BCFF }
magenta = { like = 0x8F3F71FF, area = 0xB16286FF, text = 0xF2E5BCFF }
any     = { like = 0xAF3A03FF, area = 0xD65D0EFF, text = 0xF2E5BCFF }
~~~

<sup>__NOTE:__ Keys in quotes indicate IDs. You decide how to identify an item.</sup>

<!-- i18n:comment: Do not translate `text in backticks`. -->
In this case, the `gruvbox` theme has two schemes (one light and one dark), and as you can see, it is ideal to write the colors in hexadecimal notation (from 0x00000000 to 0xFFFFFFFF) since every two digits represent the amount of red, green, blue, and alpha or opacity (0xRRGGBBAA), although the normal thing is that they are opaque (AA = FF).

<!-- i18n:comment: Do not translate `text in backticks`. -->
To display the above schemes, run `aquarelle print`:

<!-- i18n:skip -->
~~~ sh
aquarelle print -f aquarelle -t gruvbox dark light
~~~

<!-- i18n:comment: Do not translate `text in backticks`. -->
- `-f` or `--from` to identify the `aquarelle` namespace.
- `-t` or `--theme` to identify the `gruvbox` theme.
- `dark` and `light` identify two schemes to display.[^bg]
- It is currently not possible to simulate the display of transparent schemes in terminals.

## Using parametric schemes

<!-- i18n:comment: Do not translate `text in backticks`. -->
Unlike the previous schemes, Aquarelle also supports automatically generated schemes when requesting parametric schemes. To do this, the value of the scheme to be generated (identified in the `schemes` table) consists of the keys `request` (required) and `options`.

The value of `request` consists of the key `scheme` (required) which identifies the parametric scheme, and the key `from` which identifies its namespace. If `from` is not present, the requested scheme is assumed to be in the namespace of the requesting theme.

For example, let's look at a structure similar to the `neon-cake` theme, identified as such in the `aquarelle` namespace, which uses a parametric color scheme with the same ID to generate its schemes:

<!-- i18n:skip -->
~~~ toml
name = 'Neon Cake Examples'
about = 'Using a parametric scheme'

[schemes.'dark']
request = { scheme = 'neon-cake', from = 'aquarelle' }

[schemes.'light']
request = { scheme = 'neon-cake' } # `from` is implicitly `aquarelle`

[schemes.'light'.options] # `options` table
name = 'Neon Cake Light'
overall-chroma    = 64.0
overall-luminance = 42.5
surface-luminance = 82.5
   text-luminance = 35.0
~~~

<sup>__NOTE:__ Keys in quotes indicate IDs. You decide how to identify an item.</sup>

About the `options` table, see the [options](options.md#modifying) chapter. Themes also support [presets](options.md#presets). Display the schemes with:

<!-- i18n:skip -->
~~~ sh
aquarelle print -f aquarelle -t neon-cake dark light
~~~

---

[^alt]: Can also be created directly according to a [footnote](namespaces.md#value).

[^bg]: You can add `-b` or `--bg` plus a number to change the background color of accent-colored texts in the display. The numbers are:
1. `lower.area`: the greatest contrast should be seen.
2. `lower.like`: default value.
3. `upper.like`: the least contrast in light schemes.
4. `upper.area`: the least contrast in dark schemes.
