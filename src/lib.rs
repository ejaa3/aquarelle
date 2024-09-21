/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::borrow::{Borrow, Cow};
use annotate_snippets::Message;
use serde::{Serialize, Deserialize};

pub mod arrangement;
pub mod cache;
pub mod config;
pub mod mapping;
pub mod namespace;
pub mod path;
pub mod pathing;
pub mod scheme;
pub mod script;
pub mod theme;

mod css_filter;
mod map;

#[derive(PartialEq, Eq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct Key<V = compact_str::CompactString>(Spanned<V>);

impl<V> std::ops::Deref for Key<V> {
	type Target = Spanned<V>;
	fn deref(&self) -> &Spanned<V> { &self.0 }
}

impl<V: AsRef<str>> Borrow<str> for Key<V> {
	fn borrow(&self) -> &str { self.get_ref().as_ref() }
}

type Src = (std::rc::Rc<Cow<'static, str>>, std::rc::Rc<std::path::PathBuf>);
pub type Spanned<T = compact_str::CompactString> = serde_spanned::Spanned<T>;

mod set {
	pub const   LOWER: &str = "lower";
	pub const   UPPER: &str = "upper";
	pub const     RED: &str = "red";
	pub const  YELLOW: &str = "yellow";
	pub const   GREEN: &str = "green";
	pub const    CYAN: &str = "cyan";
	pub const    BLUE: &str = "blue";
	pub const MAGENTA: &str = "magenta";
	pub const     ANY: &str = "any";
}

mod role {
	pub const LIKE: &str = "like";
	pub const AREA: &str = "area";
	pub const TEXT: &str = "text";
}

#[derive(Clone, Copy, Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Accent { Red, Yellow, Green, Cyan, Blue, Magenta, Any }

impl Accent {
	pub const fn to_str(self) -> &'static str {
		match self {
			Accent::Red     => set::RED,
			Accent::Yellow  => set::YELLOW,
			Accent::Green   => set::GREEN,
			Accent::Cyan    => set::CYAN,
			Accent::Blue    => set::BLUE,
			Accent::Magenta => set::MAGENTA,
			Accent::Any     => set::ANY,
		}
	}
}

#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Optional {
	pub name: compact_str::CompactString,
	
	#[serde(default, skip_serializing_if = "str::is_empty")]
	pub about: compact_str::CompactString,
	
	pub default: Value,
}

#[derive(Clone, Serialize, Deserialize)]
#[serde(untagged)]
pub enum Value {
	Bool  (bool),
	Int   (rhai::INT),
	Float (rhai::FLOAT),
	Str   (rhai::ImmutableString),
	Acc   { accent: Accent },
	Bind  { bind: compact_str::CompactString },
}

macro_rules! label {
	($self:ident, $left:literal) => (match $self {
		Value::Bool  (_) => concat!($left, "`boolean`"),
		Value::Int   (_) => concat!($left, "`integer`"),
		Value::Float (_) => concat!($left, "`float`"),
		Value::Str   (_) => concat!($left, "`string`"),
		Value::Acc  {..} => concat!($left, "`accent`"),
		Value::Bind {..} => concat!($left, "`binding`"),
	})
}

impl Value {
	const fn has_same_type(&self, other: &Value) -> bool {
		matches![(self, other),
			(Value::Bool  (_), Value::Bool  (_)) |
			(Value::Int   (_), Value::Int   (_)) |
			(Value::Float (_), Value::Float (_)) |
			(Value::Str   (_), Value::Str   (_)) |
			(Value::Acc  {..}, Value::Acc  {..}) ]
	}
	
	const fn original(&self) -> &'static str {
		label!(self, "the original option is of type ")
	}
	
	const fn other(&self) -> &'static str {
		label!(self, "the assigned value is of type ")
	}
}

#[derive(Serialize, Deserialize)]
#[serde(rename_all = "kebab-case")]
pub enum Script { Path(Spanned), Embedded(Spanned) }

pub trait Msg<'a, 'b, const N: usize> {
	fn msg(self, cows: [&'b mut Cow<'a, str>; N]) -> Message<'b>;
}

impl<'a, 'b, const N: usize, T: Msg<'a, 'b, N>> Msg<'a, 'b, N> for Box<T> {
	fn msg(self, cows: [&'b mut Cow<'a, str>; N]) -> Message<'b> {
		(*self).msg(cows)
	}
}

#[macro_export]
macro_rules! csi {{ $($arg:tt)+ } => { concat!($($crate::csi_impl!($arg),)+) }}
// https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_(Control_Sequence_Introducer)_sequences

#[macro_export]
macro_rules! csi_impl {
	(/) => ("\x1B["); // begin command
	
	// end commands:
	
	(U) => ('A'); // cursor up
	(D) => ('B'); // cursor down
	(F) => ('C'); // cursor forward
	(B) => ('D'); // cursor back
	(C) => ('J'); // clear
	(S) => ('s'); // save current cursor position
	(R) => ('u'); // restore saved cursor position
	(;) => ('m'); // SGR
	
	// SGR (Select Graphics Rendintion):
	
	(:) => (';'); // format
	(-) => ( 2 ); // unset
	(b) => ( 1 ); // bold
	(d) => ( 2 ); // dim or faint
	(i) => ( 3 ); // italic (could be Inversed or Blink)
	(u) => ( 4 ); // underline
	(v) => ( 5 ); // slow blink
	(w) => ( 6 ); // rapid blink
	(r) => ( 7 ); // reversed (invert)
	(h) => ( 8 ); // hide
	(s) => ( 9 ); // strike
	
	(!) => ("\x1B[m"); // reset (better than /;)
	
	// color prefixes:
	
	(fg) => ( 3); // normal foreground
	(bg) => ( 4); // normal background
	(FG) => ( 9); // intense foreground
	(BG) => (10); // intense background
	
	// basic colors:
	
	(black)   => (0);
	(red)     => (1);
	(green)   => (2);
	(yellow)  => (3);
	(blue)    => (4);
	(magenta) => (5);
	(cyan)    => (6);
	(white)   => (7);
	(normal)  => (9);
	
	// more colors (do not prefix with FG or BG):
	
	(color) => ("8;5"); // 256 colors (N)
	(rgb)   => ("8;2"); // true color (R, G, B)
	
	{ ($($arg:literal $(,)?)+) } => { concat!($(';', $arg,)+) };
	{ $lit:literal } => { $lit };
}
