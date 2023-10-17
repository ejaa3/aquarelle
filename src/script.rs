/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::{collections::BTreeMap, fmt::Write, rc::Rc};
use compact_str::CompactString;
use palette::{FromColor, Srgba, rgb::channels::Rgba};
use rhai::{FLOAT as float, INT as int, plugin::*, packages::Package};
use crate::{role, scheme, set, Value};

type Fallible<T> = Result<T, Box<EvalAltResult>>;
pub type SmartString = smartstring::SmartString<smartstring::LazyCompact>;

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
		  rgb: Rc::new(  rgb::rhai_module_generate()),
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
	pub static MAP_MODULE: Rc<Module> = Rc::new(map::rhai_module_generate());
}

pub fn naming_engine(
	arrangement_id: ImmutableString,
	   arrangement: ImmutableString,
	       schemes: Rc<BTreeMap<CompactString, Rc<scheme::Static>>>,
) -> Engine {
	let mut module = Module::new();
	module
		.set_var("arrangement_id", arrangement_id)
		.set_var("arrangement", arrangement);
	
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

pub fn engine(path: &std::path::Path) -> Engine {
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

pub fn cfg_module(id: ImmutableString, options: BTreeMap<CompactString, Value>) -> Module {
	let mut module = Module::new();
	module.set_var("id", id);
	
	module.set_native_fn("option", move |index: &str| -> Fallible<Dynamic> {
		let value = options.get(index).ok_or(Box::new(
			EvalAltResult::ErrorIndexNotFound(index.into(), Position::NONE)
		))?;
		
		match value {
			Value::Bool (value) => Ok((*value).into()),
			Value::Int (value) => Ok((*value).into()),
			Value::Float   (value) => Ok((*value).into()),
			Value::String  (value) => Ok(value.clone().into()),
			Value::Set     { set } => Ok((set.to_str()).into()),
			Value::Role   { role } => Ok((role.to_str()).into()),
			Value::Binding    (..)  |
			Value::Bind       (..) => unreachable!(),
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
	pub type Scheme = Rc<scheme::Static>;
	pub type Set = scheme::Roles;
	
	#[rhai_fn(get = "border", pure)]
	pub fn border(scheme: &mut Scheme) -> float { scheme.border }
	
	#[rhai_fn(get = "dim", pure)]
	pub fn dim(scheme: &mut Scheme) -> float { scheme.dim }
	
	#[rhai_fn(index_get, pure, return_raw)]
	pub fn set(scheme: &mut Scheme, index: &str) -> Result<Set, Box<EvalAltResult>> {
		match index {
			set::LOWER   => Ok(scheme.sets.lower),
			set::UPPER   => Ok(scheme.sets.upper),
			set::RED     => Ok(scheme.sets.red),
			set::YELLOW  => Ok(scheme.sets.yellow),
			set::GREEN   => Ok(scheme.sets.green),
			set::CYAN    => Ok(scheme.sets.cyan),
			set::BLUE    => Ok(scheme.sets.blue),
			set::MAGENTA => Ok(scheme.sets.magenta),
			set::ANY     => Ok(scheme.sets.any),
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
	
	pub fn to_hex_rgb(rgba: int, uppercase: bool) -> ImmutableString {
		let mut string = SmartString::new_const();
		
		if uppercase { write!(&mut string, "{:06X}", rgba as u32 >> 8).unwrap() }
		else         { write!(&mut string, "{:06X}", rgba as u32 >> 8).unwrap() }
		
		string.into()
	}
	
	pub fn to_hex_rgba(rgba: int, uppercase: bool) -> ImmutableString {
		let mut string = SmartString::new_const();
		
		if uppercase { write!(&mut string, "{:08X}", rgba as u32).unwrap() }
		else         { write!(&mut string, "{:08x}", rgba as u32).unwrap() }
		
		string.into()
	}
	
	pub fn to_hex_argb(rgba: int, uppercase: bool) -> ImmutableString {
		let mut string = SmartString::new_const();
		
		if uppercase { write!(&mut string, "{:08X}", (rgba as u32) << 24 | rgba as u32 >> 8).unwrap() }
		else         { write!(&mut string, "{:08x}", (rgba as u32) << 24 | rgba as u32 >> 8).unwrap() }
		
		string.into()
	}
	
	pub fn to_css_filter(rgba: int) -> ImmutableString {
		let palette::Srgb { red, green, blue, .. } = Srgba::from_u32::<Rgba>(rgba as _).color;
		let rgb = crate::css_filter::Rgb { red: red as _, green: green as _, blue: blue as _ };
		crate::css_filter::Solver { rgb }.solve().to_css_filter()
	}
}

#[export_module]
mod rgb {
	#[rhai_fn(name = "rgb", global)]
	pub fn new(r: int, g: int, b: int) -> int {
		((r as u8) as int) << 16 | ((g as u8) as int) << 8 |
		((b as u8) as int)       | 0xFF << 24
	}
	
	#[rhai_fn(name = "rgb", global)]
	pub fn new_a(r: int, g: int, b: int, a: int) -> int {
		((r as u8) as int) << 24 | ((g as u8) as int) << 16 |
		((b as u8) as int) <<  8 | ((a as u8) as int)
	}
	
	#[rhai_fn(name = "rgb", global)]
	pub fn new_f(r: float, g: float, b: float) -> int {
		((255.0 * r) as u8 as int) << 16 |
		((255.0 * g) as u8 as int) <<  8 |
		((255.0 * b) as u8 as int)       | 0xFF << 24
	}
	
	#[rhai_fn(name = "rgb", global)]
	pub fn new_af(r: float, g: float, b: float, a: float) -> int {
		((255.0 * r) as u8 as int) << 24 |
		((255.0 * g) as u8 as int) << 16 |
		((255.0 * b) as u8 as int) <<  8 |
		((255.0 * a) as u8 as int)
	}
	
	pub fn mix(a: int, b: int, bias: float) -> int {
		Srgba::from_linear(palette::Mix::mix(
			Srgba::from_u32::<Rgba>(a as _).into_linear(),
			Srgba::from_u32::<Rgba>(b as _).into_linear(), bias
		)).into_u32::<Rgba>() as _
	}
	
	pub fn lighten(rgba: int, factor: float) -> int {
		Srgba::from_linear(palette::Lighten::lighten(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		)).into_u32::<Rgba>() as _
	}
	
	pub fn lighten_fixed(rgba: int, factor: float) -> int {
		Srgba::from_linear(palette::Lighten::lighten_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		)).into_u32::<Rgba>() as _
	}
	
	pub fn darken(rgba: int, factor: float) -> int {
		Srgba::from_linear(palette::Darken::darken(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		)).into_u32::<Rgba>() as _
	}
	
	pub fn darken_fixed(rgba: int, factor: float) -> int {
		Srgba::from_linear(palette::Darken::darken_fixed(
			Srgba::from_u32::<Rgba>(rgba as _).into_linear(), factor
		)).into_u32::<Rgba>() as _
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
	
	pub fn coords_f(rgba: int) -> palette::Srgba {
		palette::Srgba::from_u32::<Rgba>(rgba as _).into_format()
	}
	
	#[rhai_fn(get = "alpha")]
	pub fn alpha_f(color: palette::Srgba) -> float { color.alpha }
	
	#[rhai_fn(get = "red")]
	pub fn red_f(color: palette::Srgba) -> float { color.red }
	
	#[rhai_fn(get = "green")]
	pub fn green_f(color: palette::Srgba) -> float { color.green }
	
	#[rhai_fn(get = "blue")]
	pub fn blue_f(color: palette::Srgba) -> float { color.blue }
	
	#[rhai_fn(get = "hue")]
	pub fn hue(color: palette::Srgba) -> float {
		palette::GetHue::get_hue(&color).into_positive_degrees()
	}
}

macro_rules! feature { ($any:tt) => () }

macro_rules! module {
	($name:ident, $new:tt, $type:ty $(:s $saturate:tt)? $(, $([$hue:ident])? $point:ident: $get:tt)+) => {
		#[export_module]
		mod $name {
			#[rhai_fn(name = $new, global)]
			pub fn newf(x: float, y: float, z: float) -> int {
				Srgba::from_color(<$type>::new(x, y, z, 1.0 as float))
					.into_format().into_u32::<Rgba>() as _
			}
			
			#[rhai_fn(name = $new, global)]
			pub fn newaf(x: float, y: float, z: float, a:float) -> int {
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
				<$type>::from_color(
					palette::Srgba::from_u32::<Rgba>(rgba as _).into_format()
				)
			}
			
			$(
				#[rhai_fn(get = $get)]
				pub fn $point(color: $type) -> float { if_hue![color.$point] }
			)+
		}
	}
}

macro_rules! if_hue {
	($color:ident.hue) => {
		palette::GetHue::get_hue(&$color).into_positive_degrees()
	};
	($color:ident.$ident:ident) => { $color.$ident };
}

module!(hsl  , "hsl"  , palette::Hsla:s!  , alpha: "alpha", hue: "hue", saturation: "saturation", lightness: "lightness");
module!(hsluv, "hsluv", palette::Hsluva:s!, alpha: "alpha", hue: "hue", saturation: "saturation", l: "l");
module!(hsv  , "hsv"  , palette::Hsva:s!  , alpha: "alpha", hue: "hue", saturation: "saturation", value: "value");
module!(hwb  , "hwb"  , palette::Hwba     , alpha: "alpha", hue: "hue", whiteness: "whiteness", blackness: "blackness");
module!(lab  , "lab"  , palette::Laba     , alpha: "alpha", hue: "hue", l: "l", a: "a", b: "b");
module!(lch  , "lch"  , palette::Lcha:s!  , alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(lchuv, "lchuv", palette::Lchuva:s!, alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(luv  , "luv"  , palette::Luva     , alpha: "alpha", hue: "hue", l: "l", u: "u", v: "v");
module!(okhsl, "okhsl", palette::Okhsla:s!, alpha: "alpha", hue: "hue", saturation: "saturation", lightness: "lightness");
module!(okhsv, "okhsv", palette::Okhsva:s!, alpha: "alpha", hue: "hue", saturation: "saturation", value: "value");
module!(okhwb, "okhwb", palette::Okhwba   , alpha: "alpha", hue: "hue", whiteness: "whiteness", blackness: "blackness");
module!(oklab, "oklab", palette::Oklaba   , alpha: "alpha", hue: "hue", l: "l", a: "a", b: "b");
module!(oklch, "oklch", palette::Oklcha   , alpha: "alpha", hue: "hue", l: "l", chroma: "chroma");
module!(xyz  , "xyz"  , palette::Xyza     , alpha: "alpha", x: "x", y: "y", z: "z");
module!(yxy  , "yxy"  , palette::Yxya     , alpha: "alpha", x: "x", y: "y", luma: "luma");

#[cfg(feature = "cli")]
pub fn show_error(out: &mut impl std::io::Write, mut error: Box<EvalAltResult>, script: &str) -> std::io::Result<i32> {
	let pos = error.take_position();
	
	if pos.is_none() { writeln!(out, "{error}")? } else {
		let line = pos.line().unwrap();
		
		writeln!(out,
			crate::csi!("\n{}: " /fg magenta; "{}"! '\n' /"{}" F /b:fg red; '^'! " {}"!),
			line, script.split('\n').nth(line - 1).unwrap().replace('\t', " "),
			2 + (line as f64).log10() as usize + pos.position().unwrap(), error)?
	}
	
	Ok(exitcode::DATAERR)
}
