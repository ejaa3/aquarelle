<!--
	SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Aquarelle

Aquarelle is a color scheme processor focused on customization and theme maintainability. For this purpose the following abstractions are used:

1. [__Namespace__](namespace.md)  
   Collection of arrangements, schemes, themes and maps.

2. [__Arrangement__](arrangement.md)  
   The choice of schemes to apply and the maps that apply it, among other options.

3. [__Theme__](theme.md)  
   A collection of dynamic or static (hard-coded) schemes.

4. [__Scheme__](scheme.md)  
   A color scheme generated from some parameters (dynamic scheme).

5. [__Map__](map.md)  
   Prescribes the application of schemes.

Aquarelle uses the [TOML](https://toml.io) format for configuration and the [Rhai](https://rhai.rs/book/ref/index.html) language for mapping, so it is ideal to become familiar with both.
