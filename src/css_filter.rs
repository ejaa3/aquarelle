/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

// https://stackoverflow.com/questions/42966641/how-to-transform-black-into-any-given-color-using-only-css-filters

#![allow(non_snake_case)]

use std::fmt::Write;
use palette::{Hsl, Srgb, FromColor};

pub struct Rgb { pub red: f32, pub green: f32, pub blue: f32 }

impl Rgb {
	fn invert(&mut self, value: f32) { // (1.0)
		let red   = ((value + (self.red   / 255.0) * (1.0 - 2.0 * value)) * 255.0).clamp(0.0, 255.0);
		let green = ((value + (self.green / 255.0) * (1.0 - 2.0 * value)) * 255.0).clamp(0.0, 255.0);
		let blue  = ((value + (self.blue  / 255.0) * (1.0 - 2.0 * value)) * 255.0).clamp(0.0, 255.0);
		
		*self = Rgb { red, green, blue }
	}
	
	fn multiply(&mut self, matrix: [f32; 9]) {
		let red   = (self.red * matrix[0] + self.green * matrix[1] + self.blue * matrix[2]).clamp(0.0, 255.0);
		let green = (self.red * matrix[3] + self.green * matrix[4] + self.blue * matrix[5]).clamp(0.0, 255.0);
		let blue  = (self.red * matrix[6] + self.green * matrix[7] + self.blue * matrix[8]).clamp(0.0, 255.0);
		
		*self = Rgb { red, green, blue }
	}
	
	fn sepia(&mut self, value: f32) { // (1.0)
		self.multiply([
			0.393 + 0.607 * (1.0 - value), 0.769 - 0.769 * (1.0 - value), 0.189 - 0.189 * (1.0 - value),
			0.349 - 0.349 * (1.0 - value), 0.686 + 0.314 * (1.0 - value), 0.168 - 0.168 * (1.0 - value),
			0.272 - 0.272 * (1.0 - value), 0.534 - 0.534 * (1.0 - value), 0.131 + 0.869 * (1.0 - value),
		])
	}
	
	fn saturate(&mut self, value: f32) { // (1.0)
		self.multiply([
			0.213 + 0.787 * value, 0.715 - 0.715 * value, 0.072 - 0.072 * value,
			0.213 - 0.213 * value, 0.715 + 0.285 * value, 0.072 - 0.072 * value,
			0.213 - 0.213 * value, 0.715 - 0.715 * value, 0.072 + 0.928 * value,
		])
	}
	
	fn hue_rotate(&mut self, mut angle: f32) { // (0.0)
		angle = angle / 180.0 * std::f32::consts::PI;
		
		let sin = f32::sin(angle);
		let cos = f32::cos(angle);
		
		self.multiply([
			0.213 + cos * 0.787 - sin * 0.213, 0.715 - cos * 0.715 - sin * 0.715, 0.072 - cos * 0.072 + sin * 0.928,
			0.213 - cos * 0.213 + sin * 0.143, 0.715 + cos * 0.285 + sin * 0.140, 0.072 - cos * 0.072 - sin * 0.283,
			0.213 - cos * 0.213 - sin * 0.787, 0.715 - cos * 0.715 + sin * 0.715, 0.072 + cos * 0.928 + sin * 0.072,
		])
	}
	
	/* fn grayscale(&mut self, value: f32) { // (1.0)
		self.multiply([
			0.2126 + 0.7874 * (1.0 - value), 0.7152 - 0.7152 * (1.0 - value), 0.0722 - 0.0722 * (1.0 - value),
			0.2126 - 0.2126 * (1.0 - value), 0.7152 + 0.2848 * (1.0 - value), 0.0722 - 0.0722 * (1.0 - value),
			0.2126 - 0.2126 * (1.0 - value), 0.7152 - 0.7152 * (1.0 - value), 0.0722 + 0.9278 * (1.0 - value),
		])
	} */
	
	fn linear(&mut self, slope: f32, intercept: f32) { // (1.0, 0.0)
		let red   = (self.red   * slope + intercept * 255.0).clamp(0.0, 255.0);
		let green = (self.green * slope + intercept * 255.0).clamp(0.0, 255.0);
		let blue  = (self.blue  * slope + intercept * 255.0).clamp(0.0, 255.0);
		
		*self = Rgb { red, green, blue }
	}
	
	fn brightness(&mut self, value: f32) { self.linear(value, 0.0) } // (1.0)
	fn contrast(&mut self, value: f32) { self.linear(value, 0.5 - (0.5 * value)) } // (1.0)
}

pub struct Solver { pub rgb: Rgb }

impl Solver {
	fn loss(&self, filters: [f32; 6]) -> f32 {
		let mut rgb = Rgb { red: 0.0, green: 0.0, blue: 0.0 };
		
		rgb.invert(filters[0] / 100.0);
		rgb.sepia(filters[1] / 100.0);
		rgb.saturate(filters[2] / 100.0);
		rgb.hue_rotate(filters[3] * 3.6);
		rgb.brightness(filters[4] / 100.0);
		rgb.contrast(filters[5] / 100.0);
		
		let hsl_1 = Hsl::from_color(Srgb::new(rgb.red / 255.0, rgb.green / 255.0, rgb.blue / 255.0));
		let hsl_0 = Hsl::from_color(Srgb::new(self.rgb.red / 255.0, self.rgb.green / 255.0, self.rgb.blue / 255.0));
		
		  (rgb.red   - self.rgb.red  ).abs()
		+ (rgb.green - self.rgb.green).abs()
		+ (rgb.blue  - self.rgb.blue ).abs()
		+ (hsl_1.hue.into_positive_degrees() - hsl_0.hue.into_positive_degrees()).abs() / 3.6
		+ (hsl_1.saturation - hsl_0.saturation).abs() * 100.0
		+ (hsl_1.lightness  - hsl_0.lightness ).abs() * 100.0
	}
	
	fn spsa(&self, A: f32, a: [f32; 6], c: f32, mut values: [f32; 6], iters: u16) -> Result {
		const ALPHA: f32 = 1.0;
		const GAMMA: f32 = 1.0 / 6.0;
		
		let mut      best = None;
		let mut best_loss = f32::INFINITY;
		let mut    deltas = [0f32; 6];
		let mut high_args = [0f32; 6];
		let mut  low_args = [0f32; 6];
		
		for k in 0..iters {
			let ck = c / (k as f32 + 1.0).powf(GAMMA);
			
			for i in 0..6 {
				   deltas[i] = if fastrand::bool() { 1.0 } else { -1.0 };
				high_args[i] = values[i] + ck * deltas[i];
				 low_args[i] = values[i] - ck * deltas[i];
			}
			
			let loss_diff = self.loss(high_args) - self.loss(low_args);
			
			for i in 0..6 {
				let g = loss_diff / (2.0 * ck) * deltas[i];
				let ak = a[i] / (A + k as f32 + 1.0).powf(ALPHA);
				let (mut value, mut max) = (values[i] - ak * g, 100.0);
				
				if i == 2 /* saturate */ { max = 7500.0 } else
				if i == 4 /* brightness */ || i == 5 /* contrast */ { max = 200.0 }
				
				if i == 3 /* hue-rotate */ {
					if value > max { value = value % max } else
					if value < 0.0 { value = max + value % max }
				} else if value < 0.0 { value = 0.0 }
				  else if value > max { value = max }
				
				values[i] = value;
			}
			
			let loss = self.loss(values);
			if loss < best_loss { best = Some(values); best_loss = loss }
		}
		
		Result { values: best, loss: best_loss }
	}
	
	fn solve_wide(&self) -> Result {
		let A = 5.0;
		let a = [60.0, 180.0, 18000.0, 600.0, 1.2, 1.2];
		let c = 15.0;
		
		let mut best = Result { values: None, loss: f32::INFINITY };
		for _ in 0..3 {
			if best.loss <= 25.0 { break }
			let initial = [50.0, 20.0, 3750.0, 50.0, 100.0, 100.0];
			let result = self.spsa(A, a, c, initial, 1000);
			if result.loss < best.loss { best = result }
		} best
	}
	
	fn solve_narrow(&self, wide: Result) -> Result {
		let  A = wide.loss;
		let  c = 2.0;
		let A1 = A + 1.0;
		let  a = [0.25 * A1, 0.25 * A1, A1, 0.25 * A1, 0.2 * A1, 0.2 * A1];
		self.spsa(A, a, c, wide.values.unwrap(), 500)
	}
	
	pub fn solve(&self) -> Result {
		self.solve_narrow(self.solve_wide())
	}
}

pub struct Result { values: Option<[f32; 6]>, loss: f32 }

impl Result {
	pub fn to_css_filter(&self) -> rhai::ImmutableString {
		let mut string = crate::script::SmartString::new_const();
		let filters = self.values.as_ref().unwrap();
		let fmt = |index, multiplier| f32::round(filters[index] * multiplier); // (_, 1.0)
		
		write!(&mut string,
			"invert({}%) sepia({}%) saturate({}%) hue-rotate({}deg) brightness({}%) contrast({}%)",
			fmt(0, 1.0), fmt(1, 1.0), fmt(2, 1.0), fmt(3, 3.6), fmt(4, 1.0), fmt(5, 1.0)).unwrap();
		
		string.into()
	}
}
