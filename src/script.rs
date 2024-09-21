/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{borrow::Cow, collections::BTreeMap, fmt::Write, rc::Rc};
use annotate_snippets::{Level, Message, Snippet};
use compact_str::CompactString;
use palette::{FromColor, Srgba, rgb::channels::Rgba};
use rhai::{FLOAT as float, INT as int, plugin::*, packages::Package};
use crate::{role, scheme, set, Value};

type Fallible<T> = Result<T, Box<EvalAltResult>>;
pub(crate) type SmartString = smartstring::SmartString<smartstring::LazyCompact>;

struct Modules {
	  std: rhai::packages::StandardPackage,
	 base: Rc<Module>,
	  rgb: Rc<Module>,
	  hsl: Rc<Module>,
	hsluv: Rc<Module>,
	  hsv: Rc<Module>,
	  hwb: Rc<Module>,
	  lab: Rc<Module>,
	  lch: Rc<Module>,
	lchuv: Rc<Module>,
	  luv: Rc<Module>,
	oklab: Rc<Module>,
	oklch: Rc<Module>,
	  xyz: Rc<Module>,
	  yxy: Rc<Module>,
}

thread_local! {
	static MODULES: Modules = Modules {
		  std: rhai::packages::StandardPackage::new(),
		 base: Rc::new( base::rhai_module_generate()),
		  rgb: Rc::new( srgb::rhai_module_generate()),
		  hsl: Rc::new(  hsl::rhai_module_generate()),
		hsluv: Rc::new(hsluv::rhai_module_generate()),
		  hsv: Rc::new(  hsv::rhai_module_generate()),
		  hwb: Rc::new(  hwb::rhai_module_generate()),
		  lab: Rc::new(  lab::rhai_module_generate()),
		  lch: Rc::new(  lch::rhai_module_generate()),
		lchuv: Rc::new(lchuv::rhai_module_generate()),
		  luv: Rc::new(  luv::rhai_module_generate()),
		oklab: Rc::new(oklab::rhai_module_generate()),
		oklch: Rc::new(oklch::rhai_module_generate()),
		  xyz: Rc::new(  xyz::rhai_module_generate()),
		  yxy: Rc::new(  yxy::rhai_module_generate()),
	};
	pub(crate) static MAP_MODULE: Rc<Module> = Rc::new(map::rhai_module_generate());
}

pub(crate) fn naming_engine(
	arrangement_id: rhai::ImmutableString,
	   arrangement: &rhai::ImmutableString,
	       schemes: Rc<BTreeMap<CompactString, Rc<scheme::Data>>>,
) -> Engine {
	let mut module = Module::new();
	module
		.set_var("arrangement_id", arrangement_id)
		.set_var("arrangement", arrangement.clone());
	
	let mut engine = Engine::new_raw();
	engine
		.register_global_module(MODULES.with(|modules| modules.std.as_shared_module()))
		.register_global_module(module.into())
		
		.register_fn("scheme", move |context: NativeCallContext, index: &str| -> Fallible<_> {
			match schemes.get(index) {
				Some(scheme) => Ok(scheme.name.clone()),
				None => EvalAltResult::ErrorIndexNotFound(index.into(), context.position()).into()
			}
		});
	
	engine
}

pub(crate) fn engine(path: &std::path::Path) -> Engine {
	let mut engine = Engine::new_raw();
	
	MODULES.with(|modules| engine
		.set_module_resolver(rhai::module_resolvers::FileModuleResolver::new_with_path(path))
		
		.register_global_module(modules.std.as_shared_module())
		.register_global_module(Rc::clone(&modules.base))
		
		.register_static_module(  "rgb", Rc::clone(&modules.rgb))
		.register_static_module(  "hsl", Rc::clone(&modules.hsl))
		.register_static_module("hsluv", Rc::clone(&modules.hsluv))
		.register_static_module(  "hsv", Rc::clone(&modules.hsv))
		.register_static_module(  "hwb", Rc::clone(&modules.hwb))
		.register_static_module(  "lab", Rc::clone(&modules.lab))
		.register_static_module(  "lch", Rc::clone(&modules.lch))
		.register_static_module("lchuv", Rc::clone(&modules.lchuv))
		.register_static_module(  "luv", Rc::clone(&modules.luv))
		.register_static_module("oklab", Rc::clone(&modules.oklab))
		.register_static_module("oklch", Rc::clone(&modules.oklch))
		.register_static_module(  "xyz", Rc::clone(&modules.xyz))
		.register_static_module(  "yxy", Rc::clone(&modules.yxy))
		
		.on_print(|text| println!("{text}"))
		.on_debug(|text, source, pos|
			if let Some(source) = source {
				println!("{source} @ {pos:?} | {text}")
			} else if pos.is_none() {
				println!("{text}")
			} else {
				println!("{pos:?} | {text}")
			}
		));
	
	engine
}

pub(crate) fn cfg_module(id: &str, options: BTreeMap<CompactString, Value>) -> Module {
	let mut module = Module::new();
	module.set_var("id", ImmutableString::from(id));
	
	module.set_native_fn("option", move |index: &str| -> Fallible<Dynamic> {
		let value = options.get(index).ok_or(Box::new(
			EvalAltResult::ErrorIndexNotFound(index.into(), Position::NONE)
		))?;
		
		match value {
			Value::Bool   (value) => Ok((*value).into()),
			Value::Int    (value) => Ok((*value).into()),
			Value::Float  (value) => Ok((*value).into()),
			Value::Str    (value) => Ok(value.clone().into()),
			Value::Acc { accent } => Ok((accent.to_str()).into()),
			Value::Bind    { .. } => unreachable!(),
		}
	});
	
	module
}

#[export_module]
mod base {
	pub fn luma(rgba: int) -> float {
		palette::luma::SrgbLuma::from_color(
			Srgba::from_u32::<Rgba>(rgba as _).into_format() as Srgba
		).luma
	}
	
	pub fn fade(rgba: int, by: float) -> int {
		(by * (rgba & 0xFF) as float) as u8 as int | (rgba & 0xFF_FF_FF_00_u32 as int)
	}
	
	pub fn sgr_bg(rgba: int) -> ImmutableString {
		let rgb = palette::Srgb::from_u32::<Rgba>(rgba as _);
		let mut string = SmartString::new_const();
		
		write!(&mut string, crate::csi! {
			/fg rgb("{0};{1};{2}"):bg rgb("{0};{1};{2}"); "0x{3:08X}"!
		}, rgb.red, rgb.green, rgb.blue, rgba).unwrap();
		
		string.into()
	}
	
	pub fn sgr_fg(rgba: int) -> ImmutableString {
		let rgb = palette::Srgb::from_u32::<Rgba>(rgba as _);
		let mut string = SmartString::new_const();
		
		write!(&mut string, crate::csi!(/fg rgb("{0};{1};{2}"); "0x{3:08X}"!),
		       rgb.red, rgb.green, rgb.blue, rgba).unwrap();
		
		string.into()
	}
}

#[export_module]
mod map {
	pub type Scheme = Rc<scheme::Data>;
	pub type Set = scheme::Roles;
	
	#[rhai_fn(index_get, pure, return_raw)]
	pub fn set(scheme: &mut Scheme, index: &str) -> Result<Set, Box<EvalAltResult>> {
		match index {
			set::LOWER   => Ok(scheme.lower),
			set::UPPER   => Ok(scheme.upper),
			set::RED     => Ok(scheme.red),
			set::YELLOW  => Ok(scheme.yellow),
			set::GREEN   => Ok(scheme.green),
			set::CYAN    => Ok(scheme.cyan),
			set::BLUE    => Ok(scheme.blue),
			set::MAGENTA => Ok(scheme.magenta),
			set::ANY     => Ok(scheme.any),
			_ => Err(EvalAltResult::ErrorIndexNotFound(index.into(), Position::NONE).into())
		}
	}
	
	#[rhai_fn(index_get, pure, return_raw)]
	pub fn role(set: &mut Set, index: &str) -> Result<int, Box<EvalAltResult>> {
		match index {
			role::LIKE => Ok(set.like as int),
			role::AREA => Ok(set.area as int),
			role::TEXT => Ok(set.text as int),
			_ => Err(EvalAltResult::ErrorIndexNotFound(index.into(), Position::NONE).into())
		}
	}
	
	pub fn to_hex_rgb(rgba: int, uppercase: bool) -> Dynamic {
		let mut string = SmartString::new_const();
		match uppercase {
			true => write!(&mut string, "{:06X}", rgba as u32 >> 8),
			_    => write!(&mut string, "{:06x}", rgba as u32 >> 8),
		}.map(|_| string.into()).unwrap_or(Dynamic::UNIT)
	}
	
	pub fn to_hex_rgba(rgba: int, uppercase: bool) -> Dynamic {
		let mut string = SmartString::new_const();
		match uppercase {
			true => write!(&mut string, "{:08X}", rgba as u32),
			_    => write!(&mut string, "{:08x}", rgba as u32),
		}.map(|_| string.into()).unwrap_or(Dynamic::UNIT)
	}
	
	pub fn to_hex_argb(rgba: int, uppercase: bool) -> Dynamic {
		let mut string = SmartString::new_const();
		match uppercase {
			true => write!(&mut string, "{:08X}", (rgba as u32).rotate_right(8)),
			_    => write!(&mut string, "{:08x}", (rgba as u32).rotate_right(8)),
		}.map(|_| string.into()).unwrap_or(Dynamic::UNIT)
	}
	
	pub fn to_css_filter(rgba: int) -> Dynamic {
		let palette::Srgb { red, green, blue, .. } = Srgba::from_u32::<Rgba>(rgba as _).color;
		let rgb = crate::css_filter::Rgb { red: red as _, green: green as _, blue: blue as _ };
		crate::css_filter::Solver { rgb }.solve().to_css_filter()
	}
}

#[export_module]
mod srgb {
	#[rhai_fn(name = "srgb", global)]
	pub fn new(r: int, g: int, b: int) -> int {
		Srgba::new(r as u8, g as u8, b as u8, 255).into_u32::<Rgba>() as _
	}
	
	#[rhai_fn(name = "srgb", global)]
	pub fn new_a(r: int, g: int, b: int, a: int) -> int {
		Srgba::new(r as u8, g as u8, b as u8, a as u8).into_u32::<Rgba>() as _
	}
	
	#[rhai_fn(name = "srgb", global)]
	pub fn new_f(r: float, g: float, b: float) -> int {
		Srgba::new(r, g, b, 1.0).into_format().into_u32::<Rgba>() as _
	}
	
	#[rhai_fn(name = "srgb", global)]
	pub fn new_af(r: float, g: float, b: float, a: float) -> int {
		Srgba::new(r, g, b, a).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn mix(a: int, b: int, bias: float) -> int {
		palette::Mix::mix(
			Srgba::from_u32::<Rgba>(a as _).into_format(),
			Srgba::from_u32::<Rgba>(b as _).into_format(), bias
		).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn lighten(rgba: int, factor: float) -> int {
		palette::Lighten::lighten(
			Srgba::from_u32::<Rgba>(rgba as _).into_format(), factor
		).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn lighten_fixed(rgba: int, factor: float) -> int {
		palette::Lighten::lighten_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_format(), factor
		).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn darken(rgba: int, factor: float) -> int {
		palette::Darken::darken(
			Srgba::from_u32::<Rgba>(rgba as _).into_format(), factor
		).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn darken_fixed(rgba: int, factor: float) -> int {
		palette::Darken::darken_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_format(), factor
		).into_format().into_u32::<Rgba>() as _
	}
	
	pub fn coords(rgba: int) -> palette::Srgba<u8> {
		palette::Srgba::from_u32::<Rgba>(rgba as _)
	}
	
	#[rhai_fn(get = "alpha")]
	pub fn alpha(color: palette::Srgba<u8>) -> int { color.alpha as _ }
	
	#[rhai_fn(get = "red")]
	pub fn red(color: palette::Srgba<u8>) -> int { color.red as _ }
	
	#[rhai_fn(get = "green")]
	pub fn green(color: palette::Srgba<u8>) -> int { color.green as _ }
	
	#[rhai_fn(get = "blue")]
	pub fn blue(color: palette::Srgba<u8>) -> int { color.blue as _ }
}

#[export_module]
mod linear {
	use palette::LinSrgba;
		
	#[rhai_fn(name = "linear", global)]
	pub fn new(r: float, g: float, b: float) -> int {
		(LinSrgba::new(r, g, b, 1.0).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	#[rhai_fn(name = "linear", global)]
	pub fn new_a(r: float, g: float, b: float, a: float) -> int {
		(LinSrgba::new(r, g, b, a).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn mix(a: int, b: int, bias: float) -> int {
		(palette::Mix::mix(
			Srgba::from_u32::<Rgba>(a as _).into_linear(),
			Srgba::from_u32::<Rgba>(b as _).into_linear(), bias
		).into_encoding()  as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn lighten(rgba: int, factor: float) -> int {
		(palette::Lighten::lighten(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn lighten_fixed(rgba: int, factor: float) -> int {
		(palette::Lighten::lighten_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn darken(rgba: int, factor: float) -> int {
		(palette::Darken::darken(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn darken_fixed(rgba: int, factor: float) -> int {
		(palette::Darken::darken_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		).into_encoding() as Srgba<u8>).into_u32::<Rgba>() as _
	}
	
	pub fn coords(rgba: int) -> LinSrgba {
		palette::Srgba::from_u32::<Rgba>(rgba as _).into_linear()
	}
	
	#[rhai_fn(get = "alpha")]
	pub fn alpha(color: LinSrgba) -> int { color.alpha as _ }
	
	#[rhai_fn(get = "red")]
	pub fn red(color: LinSrgba) -> int { color.red as _ }
	
	#[rhai_fn(get = "green")]
	pub fn green(color: LinSrgba) -> int { color.green as _ }
	
	#[rhai_fn(get = "blue")]
	pub fn blue(color: LinSrgba) -> int { color.blue as _ }
}

macro_rules! feature { ($any:tt) => () }

macro_rules! module {
	($name:ident, $new:tt, $type:ty $(:s $saturate:tt)? $(, $point:ident: $get:tt)+) => {
		#[export_module]
		mod $name {
			#[rhai_fn(name = $new, global)]
			pub fn new(x: float, y: float, z: float) -> int {
				Srgba::from_color(<$type>::new(x, y, z, 1.0 as float))
					.into_format().into_u32::<Rgba>() as _
			}
			
			#[rhai_fn(name = $new, global)]
			pub fn new_a(x: float, y: float, z: float, a:float) -> int {
				Srgba::from_color(<$type>::new(x, y, z, a)).into_format().into_u32::<Rgba>() as _
			}
			
			pub fn mix(a: int, b: int, bias: float) -> int {
				Srgba::from_color(palette::Mix::mix(
					<$type>::from_color(Srgba::from_u32::<Rgba>(a as _).into_format()),
					<$type>::from_color(Srgba::from_u32::<Rgba>(b as _).into_format()), bias
				)).into_format().into_u32::<Rgba>() as _
			}
			
			pub fn lighten(rgba: int, by: float) -> int {
				Srgba::from_color(palette::Lighten::lighten(
					<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
				)).into_format().into_u32::<Rgba>() as _
			}
			
			pub fn lighten_fixed(rgba: int, by: float) -> int {
				Srgba::from_color(palette::Lighten::lighten_fixed(
					<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
				)).into_format().into_u32::<Rgba>() as _
			}
			
			pub fn darken(rgba: int, by: float) -> int {
				Srgba::from_color(palette::Darken::darken(
					<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
				)).into_format().into_u32::<Rgba>() as _
			}
			
			pub fn darken_fixed(rgba: int, by: float) -> int {
				Srgba::from_color(palette::Darken::darken_fixed(
					<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
				)).into_format().into_u32::<Rgba>() as _
			}
			
			$(feature!($saturate);
				pub fn saturate(rgba: int, by: float) -> int {
					Srgba::from_color(palette::Saturate::saturate(
						<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
					)).into_format().into_u32::<Rgba>() as _
				}
				
				pub fn saturate_fixed(rgba: int, by: float) -> int {
					Srgba::from_color(palette::Saturate::saturate_fixed(
						<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
					)).into_format().into_u32::<Rgba>() as _
				}
				
				pub fn desaturate(rgba: int, by: float) -> int {
					Srgba::from_color(palette::Desaturate::desaturate(
						<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
					)).into_format().into_u32::<Rgba>() as _
				}
				
				pub fn desaturate_fixed(rgba: int, by: float) -> int {
					Srgba::from_color(palette::Desaturate::desaturate_fixed(
						<$type>::from_color(Srgba::from_u32::<Rgba>(rgba as _).into_format()), by
					)).into_format().into_u32::<Rgba>() as _
				}
			)?
			
			pub fn coords(rgba: int) -> $type {
				<$type>::from_color(palette::Srgba::from_u32::<Rgba>(rgba as _).into_format())
			}
			
			$(#[rhai_fn(get = $get)]
			  pub fn $point(color: $type) -> float { if_hue![color.$point] })+
		}
	}
}

macro_rules! if_hue {
	($color:ident.hue) => { palette::GetHue::get_hue(&$color).into_positive_degrees() };
	($color:ident.$ident:ident) => { $color.$ident };
}

module!(hsl   , "hsl"   , palette::Hsla:s!  , alpha: "alpha", hue: "hue", saturation: "saturation", lightness: "lightness");
module!(hsluv , "hsluv" , palette::Hsluva:s!, alpha: "alpha", hue: "hue", saturation: "saturation", l: "l");
module!(hsv   , "hsv"   , palette::Hsva:s!  , alpha: "alpha", hue: "hue", saturation: "saturation", value: "value");
module!(hwb   , "hwb"   , palette::Hwba     , alpha: "alpha", hue: "hue", whiteness: "whiteness", blackness: "blackness");
module!(lab   , "lab"   , palette::Laba     , alpha: "alpha", hue: "hue", l: "l", a: "a", b: "b");
module!(lch   , "lch"   , palette::Lcha:s!  , alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(lchuv , "lchuv" , palette::Lchuva:s!, alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(luv   , "luv"   , palette::Luva     , alpha: "alpha", hue: "hue", l: "l", u: "u", v: "v");
module!(okhsl , "okhsl" , palette::Okhsla:s!, alpha: "alpha", hue: "hue", saturation: "saturation", lightness: "lightness");
module!(okhsv , "okhsv" , palette::Okhsva:s!, alpha: "alpha", hue: "hue", saturation: "saturation", value: "value");
module!(okhwb , "okhwb" , palette::Okhwba   , alpha: "alpha", hue: "hue", whiteness: "whiteness", blackness: "blackness");
module!(oklab , "oklab" , palette::Oklaba   , alpha: "alpha", hue: "hue", l: "l", a: "a", b: "b");
module!(oklch , "oklch" , palette::Oklcha   , alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(xyz   , "xyz"   , palette::Xyza     , alpha: "alpha", x: "x", y: "y", z: "z");
module!(yxy   , "yxy"   , palette::Yxya     , alpha: "alpha", x: "x", y: "y", luma: "luma");

pub fn error_msg<'b>(
	mut error: Box<rhai::EvalAltResult>,
	      cow: &'b mut Cow<str>,
	     code: &'b str,
	    paths: (&'b str, &'b str),
	      src: &'b str,
	   script: &'b crate::Spanned
) -> Message<'b> {
	let pos = error.take_position();
	*cow = Cow::Owned(error.to_string());
	let mut msg = Level::Error.title(cow);
	
	let (path, start) = if paths.0.is_empty() {
		let (mut chars, mut lines) = (0, 0);
		for line in src.lines() {
			chars += line.len() + 1; lines += 1;
			if chars >= script.span().start {
				if line.ends_with("\"\"\"")
				|| line.ends_with("'''") { lines += 1 }
				break
			}
		} (paths.1, lines)
	} else { (paths.0, 1) };
	
	if !pos.is_none() {
		let error_line = pos.line().unwrap_or(0);
		let (mut line, mut sum) = (0, 0);
		
		for code in code.split('\n') {
			if line + 1 >= error_line { break }
			sum += code.len() + 1;
			line += 1;
		}
		sum += pos.position().unwrap_or(0) - 1;
		msg = msg.snippet(Snippet::source(code).origin(path).line_start(start)
			.fold(true).annotation(Level::Error.span(sum..sum).label("here")))
	} msg
}
