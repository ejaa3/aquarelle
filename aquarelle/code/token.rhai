/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const editor = cfg::scheme("editor");

fn out() { `"#${this.to_hex_rgba(true)}"` }

export const colors = `[
	{
		"scope": [
			"meta.delimiter.comma", // .rhai
			"meta.interpolation", // .rust
			"punctuation.separator.namespace", // .xml
		],
		"settings": { "foreground": ${editor.lower.text.out()} }
	},
	
	{
		"scope": "markup.bold", // .markdown
		"settings": { "foreground": ${editor.lower.text.out()}, "fontStyle": "bold" }
	},
	
	{
		"scope": "markup.italic", // .markdown
		"settings": { "fontStyle": "italic" }
	},
	
	{
		"scope": "markup.strikethrough", // .markdown
		"settings": { "foreground": ${editor.lower.text.out()}, "fontStyle": "strikethrough" }
	},
	
	{
		"scope": [
			"comment",
			
			"entity.name.footnote.latex",
			"punctuation.definition.arguments.begin.latex",
			"punctuation.definition.arguments.end.latex",
			"punctuation.definition.arguments.optional.begin.latex",
			"punctuation.definition.arguments.optional.end.latex",
			
			"punctuation.definition.bold", // .markdown
			"punctuation.definition.italic", // .markdown
			"punctuation.definition.link", // .title.begin.markdown
			"punctuation.definition.markdown",
			"punctuation.definition.metadata", // .markdown
			"punctuation.definition.raw", // .markdown
			"punctuation.definition.strikethrough", // .markdown
			
			"punctuation.math.begin.bracket.curly.tex",
			"punctuation.math.end.bracket.curly.tex",
		],
		"settings": { "foreground": ${editor.lower.text.fade(editor.dim).out()}, "fontStyle": "" }
	},
	
	{
		"scope": [
			"constant.character.entity", // .xml
			"entity.name.section.latex",
			"fenced_code", // .block.language.markdown
			"keyword.operator",
			"punctuation.brackets.attribute", // .rust
			"punctuation.brackets.square", // .rust
			"punctuation.comma", // .rust
			"punctuation.definition.attribute", // .rust
			"punctuation.definition.list", // .begin.markdown
			"punctuation.math.operator.tex",
			"punctuation.section.interpolation", // .end.rhai
			"punctuation.semi", // .rust
			"punctuation.separator.dot", // .toml
			"storage.modifier", // .mut.rust
			"string.quoted.single.basic", // .line.toml
			"variable.other.metavariable.name", // .rust
		],
		"settings": { "foreground": ${editor.any.like.out()} }
	},
	
	{
		"scope": [
			"entity.name.function.macro.rules", // .rust
			"keyword.other",
			"punctuation.definition.quote", // .begin.markdown
			"punctuation.definition.table", // .toml
			"storage.type.function", // .rhai
			"storage", // .type.rust
		],
		"settings": { "foreground": ${editor.red.like.out()}, "fontStyle": "" }
	},
	
	{
		"scope": [
			"keyword.control", // .rust
			"punctuation.brackets.angle", // .rust
		],
		"settings": { "foreground": ${editor.red.like.out()}, "fontStyle": "italic" }
	},
	
	{
		"scope": [
			"markup.inline.raw", // .string.markdown
			"punctuation.definition.emph.begin.latex",
			"punctuation.definition.emph.end.latex",
			"punctuation.definition.textbf.begin.latex",
			"punctuation.definition.textbf.end.latex",
			"string",
			"support.function.emph.latex",
			"support.function.textbf.latex",
		],
		"settings": { "foreground": ${editor.yellow.like.out()} }
	},
	
	{
		"scope": [
			"entity.name.function.macro", // .rust
			"entity.name.type.lifetime", // .rust
			"punctuation.definition.lifetime", // .rust
			"punctuation.definition.string.begin.tex",
			"punctuation.definition.string.end.tex",
			"storage.modifier.lifetime", // .rust
			"string.interpolated", // .rhai
			"string.quoted.single.literal", // line.toml
			"string.unquoted.cdata", // .xml
			"support.variable", // .meson
			"variable.language.self.rust",
			"variable.other.constant", // .rhai
			// "markup.fenced_code", // .block.markdown
		],
		"settings": { "foreground": ${editor.green.like.out()} }
	},
	
	{
		"scope": [
			"entity.name.section", // .markdown
			"entity.name.tag.namespace", // .xml
			"entity.name.type", // .rust
			"entity.other.attribute-name.namespace", // .xml
			"meta.function-call", // .method.with-arguments.rhai
			"support.function", // .builtin.meson
			"support.type.property-name.table", // .toml
			"variable.other.metavariable.specifier", // .rust
		],
		"settings": { "foreground": ${editor.cyan.like.out()} }
	},
	
	{
		"scope": "punctuation.definition.heading", // .markdown,
		"settings": { "foreground": ${editor.cyan.area.out()} }
	},
	
	{
		"scope": [
			"constant.other.general.math.tex",
			"entity.name.function", // .rust
			"entity.name.tag", // .localname.xml
			"punctuation.definition.interpolation", // .rust
			"string.other.link", // .title.markdown
			"support.type.property-name", // .toml
			"variable.language", // .this.rhai
			"variable.other.object", // .rhai
			"variable.parameter.function.keyword", // .meson
		],
		"settings": { "foreground": ${editor.blue.like.out()} }
	},
	
	{
		"scope": [
			"punctuation.definition.footnote.begin.latex",
			"punctuation.definition.footnote.end.latex",
			"support.function.footnote.latex",
			
			"markup.underline.link", // .markdown
			"meta.tag", // .xml
		],
		"settings": { "foreground": ${editor.blue.area.out()} }
	},
	
	{
		"scope": [
			"constant",
			"entity.name.namespace", // .rust
			"entity.other", // .attribute-name.localname.xml
			"keyword.other.crate", // .rust
			"markup.quote", // .markdown
			"meta.group.braces.square", // (rhai)
			"variable.parameter.function.latex",
		],
		"settings": { "foreground": ${editor.magenta.like.out()} }
	},
	
	{
		"scope": "punctuation.definition.tag", // .xml
		"settings": { "foreground": ${editor.magenta.area.out()} }
	}
]`;

export const semantic_colors = `{
	"boolean": ${editor.green.like.out()},
	"builtinAttribute": ${editor.red.like.out()}, // .attribute .library
	"decorator.attribute": ${editor.magenta.like.out()}, // .library
	"decorator.defaultLibrary": ${editor.any.like.out()}, // .attribute .library
	"decorator.library": ${editor.any.like.out()}, // .attribute
	"deriveHelper": ${editor.magenta.like.out()}, // .attribute .library
	"enum": ${editor.cyan.like.out()}, // .public
	"enumMember": ${editor.magenta.like.out()}, // declaration
	"function": ${editor.blue.like.out()},
	"generic": ${editor.green.like.out()}, // .attribute
	"keyword": ${editor.red.like.out()},
	"lifetime": ${editor.green.like.out()},
	"macro": ${editor.green.like.out()}, // .library
	"method": ${editor.blue.like.out()},
	"namespace": ${editor.magenta.like.out()},
	"number": ${editor.green.like.out()},
	"parameter.reference": { "foreground": ${editor.lower.text.out()}, "italic": true },
	"parameter": ${editor.lower.text.out()}, // .declaration
	"tomlArrayKey": ${editor.blue.like.out()},
	"tomlTableKey": ${editor.blue.like.out()},
	"variable.callable": ${editor.any.like.out()},
	"variable.reference": { "foreground": ${editor.lower.text.out()}, "italic": true },
	"variable": ${editor.lower.text.out()},
}`;
