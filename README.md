<!--
	SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
	
	SPDX-License-Identifier: CC-BY-SA-4.0
-->

<img align="left" src="data/app-icons/io.github.ejaa3.Aquarelle.svg"/>

# Aquarelle

<a href="https://api.reuse.software/info/github.com/ejaa3/aquarelle">
	<img align="right" alt="REUSE status" src="https://api.reuse.software/badge/github.com/ejaa3/aquarelle">
</a>

Can be the following:

- An experimental environment for color schemes.
- A (pre)processor of themes in any format (if possible).
- A way to customize the appearance of software declaratively.
- My personal [rice] (the `aquarelle` namespace).

[rice]: https://www.quora.com/What-is-the-meaning-of-Linux-ricing

The current state is basically:
- Almost undocumented.
- The CLI is functional, the GUI is not.
- The API seems stable.
- Review is needed (memory layout, error handling, etc.).

## Development and testing

The following commands are assumed to be executed with bash in the project directory:

- First configure the project directory: `meson setup build --prefix ~/install_dir`

  Change `~/install_dir` to the directory of your choice, and now you can use `cargo` properly.

- Run the CLI version as follows: `cargo run --features cli`

  To use arguments, append: `-- <arg1> <arg2> <...>`

- Before running the GUI version, the settings schema must be compiled:

  ~~~ bash
  mkdir -p ~/.local/share/glib-2.0/schemas/
  ln -s $(pwd)/build/data/io.github.ejaa3.Aquarelle.Devel.gschema.xml \
          ~/.local/share/glib-2.0/schemas/ && \
      glib-compile-schemas ~/.local/share/glib-2.0/schemas/
  ~~~

  Now you can run the GUI version: `cargo run --features gui --bin gui`

- Installation: `meson install -C build`

- Book: `mdbook serve --open`
