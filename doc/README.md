<!--
	SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Introduction

Aquarelle is a color scheme processor focused on customization, extensibility and easy maintenance of themes or visual styles. It uses [TOML] format for configuration and [Rhai] language for scripting.

[TOML]: https://toml.io
[Rhai]: https://rhai.rs/book/ref/index.html

<!-- i18n:comment: Do not translate `text in backticks`. -->
Run `aquarelle` in your terminal with [truecolor support] to see its usage.

[truecolor support]: https://github.com/termstandard/colors?tab=readme-ov-file#truecolor-support-in-output-devices

## Background

There are applications and even documents that allow you to set their appearance using configuration files, but their formats are usually incompatible. So if a theme developer wanted to implement 10 color palettes across 5 different apps, they would end up maintaining about 50 incompatible configurations (10 × 5).

Aquarelle aims to abstract primarily, but not exclusively, color palettes from incompatible application configurations to avoid unnecessary maintenance, so that in the example above the developer would only have to maintain about 15 general configurations (10 + 5) from which the 50 specific configurations would be automatically derived.

For the above purpose, Aquarelle divides the work into the following items:

- __[Theme](themes.md):__ is a collection of color schemes.
- __Scheme:__ is a parametric color scheme.
- __Map:__ is a configuration that prescribes how to apply a scheme.
- __Arrangement:__ is a choice of schemes to apply and the maps that apply them.
- __[Namespace](namespace.md):__ is a collection of all of the above.

## Extensibility { #extensibility }

The above items are simple manifest files that extend Aquarelle, and they all share the following [keys](https://toml.io/en/v1.0.0#keyvalue-pair):

<!-- i18n:comment: Do not translate `text in backticks`. -->
- `name`: short text that could be displayed in a user interface to refer to the item. It should look like the item ID, which is the directory name for a namespace, or a key defined in the namespace manifest for other items.

<!-- i18n:comment: Do not translate `text in backticks`. -->
- `about`: short description that could be displayed in a user interface as additional information. If documentation should be read before using the item, it should be referenced with a hyperlink here.

The following chapters show the specific keys for each element.
