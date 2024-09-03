/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const m  = cfg::scheme("main");
const p  = cfg::option("prefix");
const il = cfg::option("initial");
const e  = cfg::option("filter");
const es = cfg::option("filter-selector");
const f  = cfg::option("fill");
const fs = cfg::option("fill-selector");
const s  = cfg::option("stroke");
const ss = cfg::option("stroke-selector");
const a  = cfg::option("area");
const t  = cfg::option("text");

const emph = cfg::option("emph");

fn o() { '#' + this.to_hex_rgb(true) }
fn f() { "brightness(0) " + this.to_css_filter() }
fn i(color) { if global::il { color.get(0) } else { color } } // css

`:root {
	--${p + i("lower")    }: ${m.lower.like.o()}; /* lower colors */
	--${p + i("lower") + a}: ${m.lower.area.o()};
	--${p + i("lower") + t}: ${m.lower.text.o()};
	
	--${p + i("upper")    }: ${m.upper.like.o()}; /* upper colors */
	--${p + i("upper") + a}: ${m.upper.area.o()};
	--${p + i("upper") + t}: ${m.upper.text.o()};
	
	--${p + i("emph"   )}: ${m[emph]  .like.o()}; /* like colors */
	--${p + i("red"    )}: ${m.red    .like.o()};
	--${p + i("yellow" )}: ${m.yellow .like.o()};
	--${p + i("green"  )}: ${m.green  .like.o()};
	--${p + i("cyan"   )}: ${m.cyan   .like.o()};
	--${p + i("blue"   )}: ${m.blue   .like.o()};
	--${p + i("magenta")}: ${m.magenta.like.o()};
	--${p + i("any"    )}: ${m.any    .like.o()};
	
	--${p + i("emph"   ) + a}: ${m[emph]  .area.o()}; /* area colors */
	--${p + i("red"    ) + a}: ${m.red    .area.o()};
	--${p + i("yellow" ) + a}: ${m.yellow .area.o()};
	--${p + i("green"  ) + a}: ${m.green  .area.o()};
	--${p + i("cyan"   ) + a}: ${m.cyan   .area.o()};
	--${p + i("blue"   ) + a}: ${m.blue   .area.o()};
	--${p + i("magenta") + a}: ${m.magenta.area.o()};
	--${p + i("any"    ) + a}: ${m.any    .area.o()};
	
	--${p + i("emph"   ) + t}: ${m[emph]  .text.o()}; /* text colors */
	--${p + i("red"    ) + t}: ${m.red    .text.o()};
	--${p + i("yellow" ) + t}: ${m.yellow .text.o()};
	--${p + i("green"  ) + t}: ${m.green  .text.o()};
	--${p + i("cyan"   ) + t}: ${m.cyan   .text.o()};
	--${p + i("blue"   ) + t}: ${m.blue   .text.o()};
	--${p + i("magenta") + t}: ${m.magenta.text.o()}; /* for a transparent color, reduce 100% of: */
	--${p + i("any"    ) + t}: ${m.any    .text.o()}; /* color-mix(in srgb, #0000, var(--color) 100%) */
	
	--${p + e + i("lower")    }: ${m.lower.like.f()}; /* lower colors */
	--${p + e + i("lower") + a}: ${m.lower.area.f()};
	--${p + e + i("lower") + t}: ${m.lower.text.f()};
	
	--${p + e + i("upper")    }: ${m.upper.like.f()}; /* upper colors */
	--${p + e + i("upper") + a}: ${m.upper.area.f()};
	--${p + e + i("upper") + t}: ${m.upper.text.f()};
	
	--${p + e + i("emph"   )}: ${m[emph]  .like.f()}; /* like colors */
	--${p + e + i("red"    )}: ${m.red    .like.f()};
	--${p + e + i("yellow" )}: ${m.yellow .like.f()};
	--${p + e + i("green"  )}: ${m.green  .like.f()};
	--${p + e + i("cyan"   )}: ${m.cyan   .like.f()};
	--${p + e + i("blue"   )}: ${m.blue   .like.f()};
	--${p + e + i("magenta")}: ${m.magenta.like.f()};
	--${p + e + i("any"    )}: ${m.any    .like.f()};
	
	--${p + e + i("emph"   ) + a}: ${m[emph]  .area.f()}; /* area colors */
	--${p + e + i("red"    ) + a}: ${m.red    .area.f()};
	--${p + e + i("yellow" ) + a}: ${m.yellow .area.f()};
	--${p + e + i("green"  ) + a}: ${m.green  .area.f()};
	--${p + e + i("cyan"   ) + a}: ${m.cyan   .area.f()};
	--${p + e + i("blue"   ) + a}: ${m.blue   .area.f()};
	--${p + e + i("magenta") + a}: ${m.magenta.area.f()};
	--${p + e + i("any"    ) + a}: ${m.any    .area.f()};
	
	--${p + e + i("emph"   ) + t}: ${m[emph]  .text.f()}; /* text colors */
	--${p + e + i("red"    ) + t}: ${m.red    .text.f()};
	--${p + e + i("yellow" ) + t}: ${m.yellow .text.f()};
	--${p + e + i("green"  ) + t}: ${m.green  .text.f()};
	--${p + e + i("cyan"   ) + t}: ${m.cyan   .text.f()};
	--${p + e + i("blue"   ) + t}: ${m.blue   .text.f()};
	--${p + e + i("magenta") + t}: ${m.magenta.text.f()};
	--${p + e + i("any"    ) + t}: ${m.any    .text.f()};
}

/* color classes */

.${p + i("lower")    } { color: ${m.lower.like.o()} } /* lower colors */
.${p + i("lower") + a} { color: ${m.lower.area.o()} }
.${p + i("lower") + t} { color: ${m.lower.text.o()} }

.${p + i("upper")    } { color: ${m.upper.like.o()} } /* upper colors */
.${p + i("upper") + a} { color: ${m.upper.area.o()} }
.${p + i("upper") + t} { color: ${m.upper.text.o()} }

.${p + i("emph"   )} { color: ${m[emph]  .like.o()} } /* like colors */
.${p + i("red"    )} { color: ${m.red    .like.o()} }
.${p + i("yellow" )} { color: ${m.yellow .like.o()} }
.${p + i("green"  )} { color: ${m.green  .like.o()} }
.${p + i("cyan"   )} { color: ${m.cyan   .like.o()} }
.${p + i("blue"   )} { color: ${m.blue   .like.o()} }
.${p + i("magenta")} { color: ${m.magenta.like.o()} }
.${p + i("any"    )} { color: ${m.any    .like.o()} }

.${p + i("emph"   ) + a} { color: ${m[emph]  .area.o()} } /* area colors */
.${p + i("red"    ) + a} { color: ${m.red    .area.o()} }
.${p + i("yellow" ) + a} { color: ${m.yellow .area.o()} }
.${p + i("green"  ) + a} { color: ${m.green  .area.o()} }
.${p + i("cyan"   ) + a} { color: ${m.cyan   .area.o()} }
.${p + i("blue"   ) + a} { color: ${m.blue   .area.o()} }
.${p + i("magenta") + a} { color: ${m.magenta.area.o()} }
.${p + i("any"    ) + a} { color: ${m.any    .area.o()} }

.${p + i("emph"   ) + t} { color: ${m[emph]  .text.o()} } /* text colors */
.${p + i("red"    ) + t} { color: ${m.red    .text.o()} }
.${p + i("yellow" ) + t} { color: ${m.yellow .text.o()} }
.${p + i("green"  ) + t} { color: ${m.green  .text.o()} }
.${p + i("cyan"   ) + t} { color: ${m.cyan   .text.o()} }
.${p + i("blue"   ) + t} { color: ${m.blue   .text.o()} }
.${p + i("magenta") + t} { color: ${m.magenta.text.o()} }
.${p + i("any"    ) + t} { color: ${m.any    .text.o()} }

/* filter classes */

.${p + e + i("lower")     + es } { filter: ${m.lower.like.f()} } /* lower colors */
.${p + e + i("lower") + a + es } { filter: ${m.lower.area.f()} }
.${p + e + i("lower") + t + es } { filter: ${m.lower.text.f()} }

.${p + e + i("upper")     + es } { filter: ${m.upper.like.f()} } /* upper colors */
.${p + e + i("upper") + a + es } { filter: ${m.upper.area.f()} }
.${p + e + i("upper") + t + es } { filter: ${m.upper.text.f()} }

.${p + e + i("emph"   ) + es } { filter: ${m[emph]  .like.f()} } /* like colors */
.${p + e + i("red"    ) + es } { filter: ${m.red    .like.f()} }
.${p + e + i("yellow" ) + es } { filter: ${m.yellow .like.f()} }
.${p + e + i("green"  ) + es } { filter: ${m.green  .like.f()} }
.${p + e + i("cyan"   ) + es } { filter: ${m.cyan   .like.f()} }
.${p + e + i("blue"   ) + es } { filter: ${m.blue   .like.f()} }
.${p + e + i("magenta") + es } { filter: ${m.magenta.like.f()} }
.${p + e + i("any"    ) + es } { filter: ${m.any    .like.f()} }

.${p + e + i("emph"   ) + a + es } { filter: ${m[emph]  .area.f()} } /* area colors */
.${p + e + i("red"    ) + a + es } { filter: ${m.red    .area.f()} }
.${p + e + i("yellow" ) + a + es } { filter: ${m.yellow .area.f()} }
.${p + e + i("green"  ) + a + es } { filter: ${m.green  .area.f()} }
.${p + e + i("cyan"   ) + a + es } { filter: ${m.cyan   .area.f()} }
.${p + e + i("blue"   ) + a + es } { filter: ${m.blue   .area.f()} }
.${p + e + i("magenta") + a + es } { filter: ${m.magenta.area.f()} }
.${p + e + i("any"    ) + a + es } { filter: ${m.any    .area.f()} }

.${p + e + i("emph"   ) + t + es } { filter: ${m[emph]  .text.f()} } /* text colors */
.${p + e + i("red"    ) + t + es } { filter: ${m.red    .text.f()} }
.${p + e + i("yellow" ) + t + es } { filter: ${m.yellow .text.f()} }
.${p + e + i("green"  ) + t + es } { filter: ${m.green  .text.f()} }
.${p + e + i("cyan"   ) + t + es } { filter: ${m.cyan   .text.f()} }
.${p + e + i("blue"   ) + t + es } { filter: ${m.blue   .text.f()} }
.${p + e + i("magenta") + t + es } { filter: ${m.magenta.text.f()} }
.${p + e + i("any"    ) + t + es } { filter: ${m.any    .text.f()} }

/* fill classes */

.${p + f + i("lower")     + fs } { fill: ${m.lower.like.o()} } /* lower colors */
.${p + f + i("lower") + a + fs } { fill: ${m.lower.area.o()} }
.${p + f + i("lower") + t + fs } { fill: ${m.lower.text.o()} }

.${p + f + i("upper")     + fs } { fill: ${m.upper.like.o()} } /* upper colors */
.${p + f + i("upper") + a + fs } { fill: ${m.upper.area.o()} }
.${p + f + i("upper") + t + fs } { fill: ${m.upper.text.o()} }

.${p + f + i("emph"   ) + fs } { fill: ${m[emph]  .like.o()} } /* like colors */
.${p + f + i("red"    ) + fs } { fill: ${m.red    .like.o()} }
.${p + f + i("yellow" ) + fs } { fill: ${m.yellow .like.o()} }
.${p + f + i("green"  ) + fs } { fill: ${m.green  .like.o()} }
.${p + f + i("cyan"   ) + fs } { fill: ${m.cyan   .like.o()} }
.${p + f + i("blue"   ) + fs } { fill: ${m.blue   .like.o()} }
.${p + f + i("magenta") + fs } { fill: ${m.magenta.like.o()} }
.${p + f + i("any"    ) + fs } { fill: ${m.any    .like.o()} }

.${p + f + i("emph"   ) + a + fs } { fill: ${m[emph]  .area.o()} } /* area colors */
.${p + f + i("red"    ) + a + fs } { fill: ${m.red    .area.o()} }
.${p + f + i("yellow" ) + a + fs } { fill: ${m.yellow .area.o()} }
.${p + f + i("green"  ) + a + fs } { fill: ${m.green  .area.o()} }
.${p + f + i("cyan"   ) + a + fs } { fill: ${m.cyan   .area.o()} }
.${p + f + i("blue"   ) + a + fs } { fill: ${m.blue   .area.o()} }
.${p + f + i("magenta") + a + fs } { fill: ${m.magenta.area.o()} }
.${p + f + i("any"    ) + a + fs } { fill: ${m.any    .area.o()} }

.${p + f + i("emph"   ) + t + fs } { fill: ${m[emph]  .text.o()} } /* text colors */
.${p + f + i("red"    ) + t + fs } { fill: ${m.red    .text.o()} }
.${p + f + i("yellow" ) + t + fs } { fill: ${m.yellow .text.o()} }
.${p + f + i("green"  ) + t + fs } { fill: ${m.green  .text.o()} }
.${p + f + i("cyan"   ) + t + fs } { fill: ${m.cyan   .text.o()} }
.${p + f + i("blue"   ) + t + fs } { fill: ${m.blue   .text.o()} }
.${p + f + i("magenta") + t + fs } { fill: ${m.magenta.text.o()} }
.${p + f + i("any"    ) + t + fs } { fill: ${m.any    .text.o()} }

/* stroke classes */

.${p + s + i("lower")     + ss } { stroke: ${m.lower.like.o()} } /* lower colors */
.${p + s + i("lower") + a + ss } { stroke: ${m.lower.area.o()} }
.${p + s + i("lower") + t + ss } { stroke: ${m.lower.text.o()} }

.${p + s + i("upper")     + ss } { stroke: ${m.upper.like.o()} } /* upper colors */
.${p + s + i("upper") + a + ss } { stroke: ${m.upper.area.o()} }
.${p + s + i("upper") + t + ss } { stroke: ${m.upper.text.o()} }

.${p + s + i("emph"   ) + ss } { stroke: ${m[emph]  .like.o()} } /* like colors */
.${p + s + i("red"    ) + ss } { stroke: ${m.red    .like.o()} }
.${p + s + i("yellow" ) + ss } { stroke: ${m.yellow .like.o()} }
.${p + s + i("green"  ) + ss } { stroke: ${m.green  .like.o()} }
.${p + s + i("cyan"   ) + ss } { stroke: ${m.cyan   .like.o()} }
.${p + s + i("blue"   ) + ss } { stroke: ${m.blue   .like.o()} }
.${p + s + i("magenta") + ss } { stroke: ${m.magenta.like.o()} }
.${p + s + i("any"    ) + ss } { stroke: ${m.any    .like.o()} }

.${p + s + i("emph"   ) + a + ss } { stroke: ${m[emph]  .area.o()} } /* area colors */
.${p + s + i("red"    ) + a + ss } { stroke: ${m.red    .area.o()} }
.${p + s + i("yellow" ) + a + ss } { stroke: ${m.yellow .area.o()} }
.${p + s + i("green"  ) + a + ss } { stroke: ${m.green  .area.o()} }
.${p + s + i("cyan"   ) + a + ss } { stroke: ${m.cyan   .area.o()} }
.${p + s + i("blue"   ) + a + ss } { stroke: ${m.blue   .area.o()} }
.${p + s + i("magenta") + a + ss } { stroke: ${m.magenta.area.o()} }
.${p + s + i("any"    ) + a + ss } { stroke: ${m.any    .area.o()} }

.${p + s + i("emph"   ) + t + ss } { stroke: ${m[emph]  .text.o()} } /* text colors */
.${p + s + i("red"    ) + t + ss } { stroke: ${m.red    .text.o()} }
.${p + s + i("yellow" ) + t + ss } { stroke: ${m.yellow .text.o()} }
.${p + s + i("green"  ) + t + ss } { stroke: ${m.green  .text.o()} }
.${p + s + i("cyan"   ) + t + ss } { stroke: ${m.cyan   .text.o()} }
.${p + s + i("blue"   ) + t + ss } { stroke: ${m.blue   .text.o()} }
.${p + s + i("magenta") + t + ss } { stroke: ${m.magenta.text.o()} }
.${p + s + i("any"    ) + t + ss } { stroke: ${m.any    .text.o()} }`
