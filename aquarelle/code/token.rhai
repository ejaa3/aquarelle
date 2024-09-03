/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const editor = cfg::scheme("editor");

fn out() { `"#${this.to_hex_rgba(true)}"` } // json

export const colors = `[
	{
		"scope": [
			"keyword.operator.namespace", // .rust
			"meta.interpolation", // .rust
			"punctuation.brackets.attribute", // .rust
			"punctuation.definition.entity", // .ini
			"punctuation.separator.key-value.ini",
			"punctuation.separator.namespace", // .{rhai,xml}
			"string.quoted.single.literal", // line.toml
			"string.quoted.triple.literal", // .block.toml
			"string.unquoted", // .plain.{out,in}.yaml
			"variable.parameter", // .function.rhai
		],
		"settings": { "foreground": ${editor.lower.text.out()} }
	},
	{
		"scope": [
			"markup.bold", // .markdown
			"punctuation.separator.dot", // .toml
		],
		"settings": { "foreground": ${editor.lower.text.out()}, "fontStyle": "bold" }
	},
	{
		"scope": "markup.strikethrough", // .markdown
		"settings": { "foreground": ${editor.lower.text.out()}, "fontStyle": "strikethrough" }
	},
	{
		"scope": [
			"comment.block",
			"comment.line",
			
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
		"settings": { "foreground": ${editor.lower.text.fade(0.625).out()}, "fontStyle": "" }
	},
	{
		"scope": [
			"entity.name.function.macro.rules", // .rust
			"invalid.illegal.tag-handle", // .yaml
			"keyword",
			"punctuation.definition.constant", // .xml
			"punctuation.definition.quote", // .begin.markdown
			"punctuation.eq", // .toml
			"punctuation.separator.key-value.rhai",
			"storage.type.function", // .rhai
			"storage",
		],
		"settings": { "foreground": ${editor.red.like.out()}, "fontStyle": "" }
	},
	{
		"scope": ["punctuation.definition.block"], // .sequence.item.yaml
		"settings": { "foreground": ${editor.cyan.like.out()}, "fontStyle": "bold" }
	},
	{
		"scope": [
			"meta.brace", // .{curly,round}.rhai
			"meta.function", // .rhai
			"punctuation.brackets", // .{curly,round}.rust
		],
		"settings": { "foreground": ${lch::desaturate(editor.red.like, 1.0).out()} }
	},
	{
		"scope": [
			"punctuation.definition.template-expression", // .{begin,end}.js
			"punctuation.section.interpolation", // .{begin,end}.rhai
		],
		"settings": { "foreground": ${lch::desaturate(editor.red.area, 1.0).out()} }
	},
	{
		"scope": ["keyword.control", "punctuation.brackets.angle"], // .rust
		"settings": { "foreground": ${editor.red.like.out()}, "fontStyle": "italic" }
	},
	{
		"scope": [
			"markup.inline.raw", // .string.markdown
			"punctuation.definition.attribute", // .rust
			"punctuation.definition.emph.begin.latex",
			"punctuation.definition.emph.end.latex",
			"punctuation.definition.textbf.begin.latex",
			"punctuation.definition.textbf.end.latex",
			"string.quoted",
			"support.function.emph.latex",
			"support.function.textbf.latex",
		],
		"settings": { "foreground": ${editor.yellow.like.out()} }
	},
	{
		"scope": ["punctuation.definition.string"],
		"settings": { "foreground": ${editor.yellow.area.out()} }
	},
	{
		"scope": [
			"entity.name.function.macro", // .rust
			"entity.name.tag.namespace", // .xml
			"entity.name.type.lifetime", // .rust
			"entity.other.attribute-name.namespace", // .xml
			"keyword.operator.access", // .dot.rust
			"meta.attribute", // .rust
			"punctuation.definition.lifetime", // .rust
			"punctuation.definition.mapping", // .{begin,end}.yaml
			"punctuation.definition.string.begin.tex",
			"punctuation.definition.string.end.tex",
			"punctuation.definition.table", // .inline.toml
			// "punctuation.separator.key-value.mapping", // .yaml
			"punctuation.separator.mapping", // .yaml
			"punctuation.separator.table", // .inline.toml
			"storage.modifier.lifetime", // .rust
			"string.interpolated", // .rhai
			"string.unquoted.cdata", // .xml
			"support.variable", // .meson
			"variable.language.self.rust",
		],
		"settings": { "foreground": ${editor.green.like.out()} }
	},
	{
		"scope": [
			"constant.character.entity", // .xml
			"entity.name.section", // .markdown
			"entity.name.type", // .rust
			"meta.brace.square", // .rhai
			"punctuation.definition.array", // .{table,}.toml
			"punctuation.definition.sequence", // .{begin,end}.yaml
			"punctuation.separator.array", // .toml
			"punctuation.separator.sequence", // .yaml
			"support.function", // .builtin.meson
			"variable.language", // .this.rhai
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
			"entity.name.tag", // .{localname,}.xml
			"keyword.other.definition", // .ini
			"meta.function-call.method.with-arguments", // .rhai
			"meta.group.braces.round.function", // .arguments.rhai.rhai
			"punctuation.definition.interpolation", // .rust
			"string.other.link", // .title.markdown
			"support.type.property-name", // .toml
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
			"punctuation.support.type.property-name", // .{begin,end}.json
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
			"meta.embedded.block.ini",
			"support.type.property-name.array", // .toml
			"support.type.property-name.table", // .toml
			"variable.parameter.function.latex",
		],
		"settings": { "foreground": ${editor.magenta.like.out()} }
	},
	{
		"scope": "punctuation.definition.tag", // .xml
		"settings": { "foreground": ${editor.magenta.area.out()} }
	},
	{
		"scope": [
			"constant.other", // .{caps.rust,time.datetime.offset.toml}
			"entity.name.section.latex",
			"entity.name.type.anchor", // .yaml
			"keyword.operator",
			"meta.delimiter.comma", // .rhai
			"punctuation.brackets.square", // .rust
			"punctuation.comma", // .rust
			"punctuation.definition.list", // .begin.markdown
			"punctuation.math.operator.tex",
			"punctuation.semi", // .rust
			"punctuation.separator.parameter", // .function.rhai
			"string.unquoted.cdata", // .xml
			"support.other", // .directive.reserved.yaml
			"variable.other.alias", // .yaml
			"variable.other.constant", // .rhai
			"variable.other.metavariable.name", // .rust
			"variable.other.object", // .rhai
		],
		"settings": { "foreground": ${editor.any.like.out()} }
	},
	{
		"scope": ["fenced_code"], // .block.language
		"settings": { "foreground": ${editor.any.area.out()} }
	},
	{
		"scope": "markup.italic", // .markdown
		"settings": { "foreground": ${editor.any.like.out()}, "fontStyle": "italic" }
	},
]`; // json

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
