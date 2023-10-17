/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { '#' + this.to_hex_rgba(true) }

`
#root.root {--toolbar-el-overlay-clicked-bg: ${main.lower.text.fade(0.2).out()};}
#root.root {--toolbar-el-overlay-hover-bg: ${main.lower.text.fade(0.15).out()};}
#root.root {--toolbar-bg: ${main.lower.area.out()};}
#root.root {--toolbar-fg: ${main.lower.text.out()};}
#root.root {--frame-el-overlay-selected-border: ${main[accent].area.out()};}
#root.root {--frame-el-overlay-selected-bg: ${main[accent].area.fade(0.15).out()};}
#root.root {--frame-el-overlay-clicked-bg: ${main.lower.text.fade(0.15).out()};}
#root.root {--frame-el-overlay-hover-bg: ${main.lower.text.fade(0.1).out()};}
#root.root {--frame-fg: ${main.lower.text.out()};}
#root.root {--frame-bg: ${main.lower.area.out()};}
#root.root {--tabs-activated-fg: ${main.lower.text.out()};}
#root.root {--tabs-activated-bg: ${main.lower.text.fade(0.15).out()};}
#root.root {--tabs-normal-fg: ${main.lower.text.out()};}
#root.root {--popup-fg: ${main.lower.text.out()};}
#root.root {--popup-bg: ${main.lower.like.out()};}
#root.root {--ctx-menu-separator: ${main.lower.text.fade(main.border).out()};}
#root.root {--ctx-menu-fg: ${main.lower.text.out()};}
#root.root {--ctx-menu-bg: ${main.lower.like.out()};}
#root.root {--notification-fg: ${main.lower.text.out()};}
#root.root {--notification-bg: ${main.lower.like.out()};}
#root.root {--scroll-color: ${main.lower.text.fade(0.3).out()};}
#root.root {--status-notice: ${main.cyan.like.out()};}
#root.root {--status-active: ${main.blue.like.out()};}
#root.root {--status-err: ${main.red.like.out()};}
#root.root {--status-ok: ${main.green.like.out()};}
`
