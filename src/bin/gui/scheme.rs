/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: AGPL-3.0-only
 */

use std::rc::Rc;
use declarative::{construct, view};
use glib::subclass::types::ObjectSubclassIsExt;
use gtk::{glib, prelude::{BoxExt, GObjectPropertyExpressionExt, ListItemExt}};
use palette::{FromColor, Srgba, rgb::channels::Rgba};
use crate::icons;

pub const SVG_WIDTH: i32 = 140;
pub const SVG_HEIGHT: i32 = 70;

pub struct Scheme {
	pub        style: gtk::CssProvider,
	pub       css_id: String,
	pub namespace_id: compact_str::CompactString,
	pub     theme_id: compact_str::CompactString,
	pub    scheme_id: compact_str::CompactString,
	pub         data: Rc<aquarelle::scheme::Data>,
	pub         dark: bool,
}

impl Scheme {
	pub fn location(&self) -> (&str, &str, &str) {
		(&self.namespace_id, &self.theme_id, &self.scheme_id)
	}
}

glib::wrapper! {
	pub struct Object(ObjectSubclass<imp::Object>);
}

impl Object {
	pub fn new(data: Rc<aquarelle::scheme::Data>,
	   namespace_id: compact_str::CompactString,
	       theme_id: compact_str::CompactString,
	      scheme_id: compact_str::CompactString,
	        display: &gtk::gdk::Display,
	) -> Self {
		let foreground = palette::luma::SrgbLuma::from_color(
			Srgba::from_u32::<Rgba>(data.lower.text).into_format() as Srgba
		).luma;
		
		let background = palette::luma::SrgbLuma::from_color(
			Srgba::from_u32::<Rgba>(data.lower.like).into_format() as Srgba
		).luma;
		
		let css_id = format!("{namespace_id}-{theme_id}-{scheme_id}");
		
		let style = gtk::CssProvider::new();
		style.load_from_data(&css_thumbnail(&css_id, &data));
		
		gtk::style_context_add_provider_for_display(
			display, &style, gtk::STYLE_PROVIDER_PRIORITY_APPLICATION
		);
		
		let object: Self = glib::Object::new();
		
		object.imp().0.set(Scheme {
			style, css_id, namespace_id, theme_id,
			scheme_id, data, dark: foreground > background,
		}).unwrap_or_else(|_| panic![]);
		
		object
	}
	
	pub fn borrow(&self) -> &Scheme { self.imp().0.get().unwrap() }
}

mod imp {
	use super::{glib, Scheme};
	
	#[derive(Default)]
	pub struct Object(pub std::cell::OnceCell<Scheme>);
	
	#[glib::object_subclass]
	impl glib::subclass::types::ObjectSubclass for Object {
		const NAME: &'static str = "Scheme";
		type Type = super::Object;
	}
	
	impl glib::subclass::object::ObjectImpl for Object { }
}

#[view[ ref item {
	set_child: Some(&_) @ gtk::Box {
		orientation: gtk::Orientation::Vertical
		spacing: 12
		~
		append: &_ @ adw::Bin {
			css_classes: ["card"]
			halign: gtk::Align::Center
			width_request: SVG_WIDTH
			height_request: SVG_HEIGHT
			
			child: &_ @ adw::Bin thumbnail {
				css_classes: ["card"]
				
				child: &_ @ gtk::Image {
					icon_name: icons::OBJECT_SELECT
					pixel_size: 14
					halign: gtk::Align::End
					valign: gtk::Align::End
				}
			}
		}
		append: &_ @ gtk::Label name {
			css_classes: ["caption-heading"]
			ellipsize: gtk::pango::EllipsizeMode::End
			justify: gtk::Justification::Center
			lines: 2
		}
	}
	property_expression: "item" 'back {
		chain_closure::<String>: glib::closure! {
			|_: Option<glib::Object>, scheme: Option<Object>| scheme
				.map(|scheme| scheme.borrow().data.name.to_string())
				.unwrap_or_default()
		}
		bind: &name, "label", gtk::Widget::NONE ~~
	}
	property_expression: "item" 'back {
		chain_closure::<String>: glib::closure! {
			|_: Option<glib::Object>, scheme: Option<Object>| scheme
				.map(|scheme| scheme.borrow().css_id.clone())
				.unwrap_or_default()
		}
		bind: &thumbnail, "name", gtk::Widget::NONE ~~
	}
} ]]

pub fn factory_setup(_: &gtk::SignalListItemFactory, list_item: &glib::Object) {
	let item = glib::object::Cast::downcast_ref::<gtk::ListItem>(list_item).unwrap();
	expand_view_here! { }
}

fn css_thumbnail(id: &str, scheme: &aquarelle::scheme::Data) -> String {
	let aquarelle::scheme::Data {
		lower, upper, red, yellow, green,
		cyan, blue, magenta, any, name: _
	} = &scheme;
	
	format!(
		"widget#{id} {{\
			background: url(\"data:image/svg+xml,\
			<svg width='{SVG_WIDTH}' height='{SVG_HEIGHT}' viewBox='0 0 28 14'>\
				<rect fill='#{:08X}' width='14' height='2'/>\
				<rect fill='#{:08X}' width='14' height='2' x='14'/>\
				<rect fill='#{:08X}' width='4' height='6' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='4' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='8' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='12' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='16' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='20' y='2'/>\
				<rect fill='#{:08X}' width='4' height='3' x='24' y='2'/>\
				<rect fill='#{:08X}' width='4' height='5' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='4' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='8' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='12' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='16' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='20' y='5'/>\
				<rect fill='#{:08X}' width='4' height='5' x='24' y='5'/>\
				<rect fill='#{:08X}' width='2' height='1' x='1' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='5' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='9' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='13' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='17' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='21' y='7'/>\
				<rect fill='#{:08X}' width='2' height='1' x='25' y='7'/>\
				<rect fill='#{:08X}' width='7' height='4' y='10'/>\
				<rect fill='#{:08X}' width='7' height='4' x='7' y='10'/>\
				<rect fill='#{:08X}' width='7' height='4' x='14' y='10'/>\
				<rect fill='#{:08X}' width='7' height='4' x='21' y='10'/>\
			</svg>\");\
		}}",
		
		lower.text, upper.text,
		red.like, cyan.like, yellow.like, blue.like, green.like, magenta.like, any.like,
		red.area, cyan.area, yellow.area, blue.area, green.area, magenta.area, any.area,
		red.text, cyan.text, yellow.text, blue.text, green.text, magenta.text, any.text,
		lower.like, lower.area, upper.like , upper.area,
	)
}

#[cfg(test)]
mod tests {
	use aquarelle::{cache::Cache, theme::Theme};
	
	#[test]
	fn thumbnail() {
		let toml = include_str!("../../../aquarelle/themes/neon_cake.toml");
		let theme: Theme = toml::de::from_str(toml).unwrap();
		let namespace_id = compact_str::CompactString::const_new("aquarelle");
		
		let css = super::css_thumbnail("test", &theme.scheme(
			"light", &namespace_id, &Cache::new(|_| ()), Default::default(),
		).unwrap_or_else(|_| panic!()));
		
		println!("'Theme' {:?} thumbnail:\n\n{css}\n", theme.name);
	}
}
