/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

import "../lib" as lib;

// Schemes:

const common = cfg::scheme("common");
const main   = cfg::scheme("main");

const bar    = cfg::scheme("activity-bar");
const menu   = cfg::scheme("menu");
const status = cfg::scheme("status-bar");
const term   = cfg::scheme("terminal");

const nav    = cfg::scheme("breadcrumb");
const editor = cfg::scheme("editor");
const side   = cfg::scheme("side-bar");
const tab    = cfg::scheme("tab-bar");
const title  = cfg::scheme("title-bar");

const notify  = cfg::scheme("notification");
const welcome = cfg::scheme("welcome-page");

// Numeric constants:

const      DIM = 0.75;
const    HOVER = 0.1;
const INACTIVE = 1.0 / 3;
const   ACTIVE = 2.0 / 3;

// Sets:

const accent   = cfg::option("accent");
const emphasis = cfg::option("emphasis");

// Roles:

const hard = if editor.dark() { "area" } else { "like" };
const soft = if editor.dark() { "like" } else { "area" };

const bright = if cfg::option("terminal-bold") { "area" } else { "like" };
const normal = if cfg::option("terminal-bold") { "like" } else { "area" };

// Colors:

const status_shadow = if status.dark() {
	lab::mix(editor.lower.area, 0xFF, lib::shadow(editor.lower.area)).out()
} else {`"#0000"`};

const status_text = lab::lighten(if status.dark()
	{ status.lower.text } else { status.lower.like }, 0.25);

// Shortcuts:

fn out() { `"#${this.to_hex_rgba(true)}"` }

fn dark() { this.lower.text.luma() > this.lower.like.luma() }

fn shadow() { 0xFF.fade(lib::shadow(this)).out() }

fn status(set) {
	const base = if global::status.dark()
		{ global::status.lower.like } else { global::status.lower.text };
	
	lch::saturate(lab::mix(base, global::status[set].area, 0.3), 0.2)
}

fn raise(set, role, bias) {
	switch this.dark() {
		true => lab::lighten(this[set][role], bias),
		   _ => lab::darken (this[set][role], bias)
	}
}

fn lower(set, role, bias) {
	switch this.dark() {
		true => lab::darken (this[set][role], bias),
		   _ => lab::lighten(this[set][role], bias)
	}
}

fn alternate() {
	if this.lower.like.luma() != this.lower.area.luma()
		{ this.lower.like } else { this.upper.area }
} // HACK better solarized

fn dev(text) { const devel = cfg::option("devel"); if devel { text } }

export const colors = `{
	"activityBar.activeBackground": ${bar.lower.area.out()},
	"activityBar.activeBorder": ${lab::mix(bar.lower.area, bar.lower.text, 0.5).out()},
	"activityBar.activeFocusBorder": ${bar.lower.text.out()},
	"activityBar.background": ${bar.upper.area.out()},
	"activityBar.border": ${bar.lower.like.shadow()},
	"activityBar.dropBorder": ${lab::mix(bar.upper.area, bar.lower.text, 0.5).out()},
	"activityBar.foreground": ${bar.lower.text.out()},
	"activityBar.inactiveForeground": ${bar.lower.text.fade(bar.dim).out()},
	
	"activityBarBadge.background": ${bar[emphasis].area.out()},
	"activityBarBadge.foreground": ${bar[emphasis].text.out()},
	
	// REMOVE
	// "activityBarItem.settingsProfilesBackground": ${bar.lower.text.fade(1.5 * HOVER).out()},
	// "activityBarItem.settingsProfilesForeground": ${bar.lower.text.fade(DIM).out()},
	// "activityBarItem.settingsProfilesHoverForeground": ${bar.lower.text.out()},
	
	"badge.background": ${side[accent].area.out()},
	"badge.foreground": ${side[accent].text.out()},
	
	${dev(`"banner.background": "#7f0000",`) /* FIXME */}
	${dev(`"banner.foreground": "#ff7F7F",`) /* FIXME */}
	${dev(`"banner.iconForeground": "#ff0000",`) /* FIXME */}
	
	"bookmarks.lineBackground": ${editor.yellow.like.fade(0.1).out()},
	"bookmarks.lineBorder": ${editor.yellow.like.fade(0.1).out()},
	"bookmarks.overviewRuler": ${editor.yellow.area.out()},
	
	"breadcrumb.activeSelectionForeground": ${nav[accent].like.out()},
	"breadcrumb.background": ${nav.alternate().out()},
	"breadcrumb.focusForeground": ${nav.lower.text.out()},
	"breadcrumb.foreground": ${nav.lower.text.fade(DIM).out()},
	"breadcrumbPicker.background": ${common.upper.like.out()},
	
	"button.background": ${common[emphasis].area.out()},
	// "button.border": ${common[emphasis].area.fade(common.border).out()},
	"button.foreground": ${common[emphasis].text.out()},
	"button.hoverBackground": ${lab::mix(common[emphasis].area, common[emphasis].text, HOVER).out()},
	"button.secondaryBackground": ${notify.lower.text.fade(0.15).out()},
	"button.secondaryForeground": ${notify.lower.text.out()},
	"button.secondaryHoverBackground": ${notify.lower.text.fade(0.2).out()},
	"button.separator": ${common[emphasis].text.fade(common.dim).out()},
	
	${dev(`"charts.blue": "#ff0000",`) /* FIXME */}
	${dev(`"charts.foreground": "#ff0000",`) /* FIXME */}
	${dev(`"charts.green": "#ff0000",`) /* FIXME */}
	${dev(`"charts.lines": "#ff0000",`) /* FIXME */}
	${dev(`"charts.orange": "#ff0000",`) /* FIXME */}
	${dev(`"charts.purple": "#ff0000",`) /* FIXME */}
	${dev(`"charts.red": "#ff0000",`) /* FIXME */}
	${dev(`"charts.yellow": "#ff0000",`) /* FIXME */}
	
	"checkbox.background": ${side.upper.like.out()},
	"checkbox.border": ${lab::mix(side.upper.like, side.upper.text, side.border).out()},
	"checkbox.foreground": ${side.upper.text.out()},
	"checkbox.selectBackground": "#F00", // BUG
	"checkbox.selectBorder": "#FFF", // BUG
	
	"commandCenter.activeBackground": ${title.lower.text.fade(0.2).out()},
	"commandCenter.activeBorder": "#0000",
	"commandCenter.activeForeground": ${title.lower.text.out()},
	"commandCenter.background": ${title.lower.text.fade(0.15).out()},
	"commandCenter.border": "#0000",
	"commandCenter.foreground": ${title.lower.text.out()},
	"commandCenter.inactiveBorder": "#0000",
	"commandCenter.inactiveForeground": ${title.lower.text.fade(0.1).out()},
	
	// TODO "contrastActiveBorder": "$ {main.lower.text.fade(cfg::option("contrast-active-border"))}",
	// TODO "contrastBorder": "$ {main.lower.text.fade(cfg::option("contrast-border"))}",
	
	${dev(`"debugConsole.errorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugConsole.infoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugConsole.sourceForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugConsole.warningForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"debugConsoleInputIcon.foreground": "#ff0000",`) /* FIXME */}
	
	${dev(`"debugExceptionWidget.background": "#ff0000",`) /* FIXME */}
	${dev(`"debugExceptionWidget.border": "#ff0000",`) /* FIXME */}
	
	${dev(`"debugIcon.breakpointCurrentStackframeForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.breakpointDisabledForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.breakpointForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.breakpointStackframeForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.breakpointUnverifiedForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.continueForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.disconnectForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.pauseForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.restartForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.startForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.stepBackForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.stepIntoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.stepOutForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.stepOverForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugIcon.stopForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"debugTokenExpression.boolean": "#ff0000",`) /* FIXME */}
	${dev(`"debugTokenExpression.error": "#ff0000",`) /* FIXME */}
	${dev(`"debugTokenExpression.name": "#ff0000",`) /* FIXME */}
	${dev(`"debugTokenExpression.number": "#ff0000",`) /* FIXME */}
	${dev(`"debugTokenExpression.string": "#ff0000",`) /* FIXME */}
	${dev(`"debugTokenExpression.value": "#ff0000",`) /* FIXME */}
	
	"debugToolBar.background": ${editor.upper.like.out()},
	// "debugToolBar.border": "#0000",
	
	${dev(`"debugView.exceptionLabelBackground": "#ff0000",`) /* FIXME */}
	${dev(`"debugView.exceptionLabelForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugView.stateLabelBackground": "#ff0000",`) /* FIXME */}
	${dev(`"debugView.stateLabelForeground": "#ff0000",`) /* FIXME */}
	${dev(`"debugView.valueChangedHighlight": "#ff0000",`) /* FIXME */}
	
	"descriptionForeground": ${common.lower.text.fade(ACTIVE).out()}, // or side.~
	
	${dev(`"diffEditor.border": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.diagonalFill": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.insertedLineBackground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.insertedTextBackground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.insertedTextBorder": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.removedLineBackground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.removedTextBackground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditor.removedTextBorder": "#ff0000",`) /* FIXME */}
	
	${dev(`"diffEditorGutter.insertedLineBackground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditorGutter.removedLineBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"diffEditorOverview.insertedForeground": "#ff0000",`) /* FIXME */}
	${dev(`"diffEditorOverview.removedForeground": "#ff0000",`) /* FIXME */}
	
	"disabledForeground": ${common.lower.text.out()}, // No alpha?
	
	"dropdown.background": ${side.upper.like.out()},
	"dropdown.border": ${lab::mix(side.upper.like, side.upper.text, side.border).out()},
	"dropdown.foreground": ${side.upper.text.out()},
	"dropdown.listBackground": ${side.upper.like.out()},
	
	"editor.background": ${editor.lower.area.out()},
	"editor.findMatchBackground": ${editor.cyan.like.fade(0.15).out()},
	"editor.findMatchBorder": "#0000",
	"editor.findMatchHighlightBackground": ${editor.magenta.like.fade(0.3).out()},
	"editor.findMatchHighlightBorder": ${editor.magenta.like.fade(0.3).out()},
	"editor.findRangeHighlightBackground": ${editor.raise("lower", "area", 0.04).out()},
	"editor.findRangeHighlightBorder": ${editor.lower.text.fade(0.1).out()},
	${dev(`"editor.focusedStackFrameHighlightBackground": "#ff0000",`) /* FIXME */}
	"editor.foldBackground": ${editor.blue.like.fade(0.1).out()},
	"editor.foreground": ${editor.lower.text.out()},
	"editor.hoverHighlightBackground": ${editor[accent].like.fade(0.2).out()},
	"editor.inactiveSelectionBackground": ${editor.lower.text.fade(0.1).out()},
	${dev(`"editor.inlineValuesBackground": "#007f00",`) /* FIXME */}
	${dev(`"editor.inlineValuesForeground": "#7fff7f",`) /* FIXME */}
	"editor.lineHighlightBackground": ${editor.lower.text.fade(0.1).out()},
	"editor.lineHighlightBorder": "#0000",
	${dev(`"editor.linkedEditingBackground": "#ff0000",`) /* FIXME */}
	"editor.rangeHighlightBackground": ${editor.blue.like.fade(0.1).out()},
	"editor.rangeHighlightBorder": ${editor.blue.like.fade(0.1).out()},
	"editor.selectionBackground": ${editor.lower.text.fade(0.15).out()},
	"editor.selectionForeground": ${editor[accent].like.out()},
	"editor.selectionHighlightBackground": ${editor.cyan.like.fade(0.15).out()},
	"editor.selectionHighlightBorder": ${editor.cyan.like.fade(0.15).out()},
	${dev(`"editor.snippetFinalTabstopHighlightBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editor.snippetFinalTabstopHighlightBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editor.snippetTabstopHighlightBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editor.snippetTabstopHighlightBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editor.stackFrameHighlightBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editor.symbolHighlightBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editor.symbolHighlightBorder": "#ff0000",`) /* FIXME */}
	"editor.wordHighlightBackground": ${editor.yellow.like.fade(0.2).out()},
	"editor.wordHighlightBorder": ${editor.yellow.like.fade(0.2).out()},
	"editor.wordHighlightTextBackground": ${editor.yellow.like.fade(0.2).out()},
	"editor.wordHighlightTextBorder": ${editor.yellow.like.fade(0.2).out()},
	"editor.wordHighlightStrongBackground": ${editor.cyan.like.fade(0.15).out()},
	"editor.wordHighlightStrongBorder": ${editor.cyan.like.fade(0.15).out()},
	
	"editorBracketHighlight.foreground1": ${editor.cyan.area.out()},
	"editorBracketHighlight.foreground2": ${editor.magenta.area.out()},
	"editorBracketHighlight.foreground3": ${editor.green.area.out()},
	"editorBracketHighlight.foreground4": ${editor.blue.area.out()},
	"editorBracketHighlight.foreground5": ${editor.yellow[hard].out()},
	"editorBracketHighlight.foreground6": ${editor.any.area.out()},
	"editorBracketHighlight.unexpectedBracket.foreground": ${editor.red.area.out()},
	
	"editorBracketMatch.background": ${editor.yellow.like.fade(0.2).out()},
	"editorBracketMatch.border": ${editor.yellow.like.fade(0.2).out()},
	
	"editorBracketPairGuide.activeBackground1": ${editor.cyan.area.fade(ACTIVE).out()},
	"editorBracketPairGuide.activeBackground2": ${editor.magenta.area.fade(ACTIVE).out()},
	"editorBracketPairGuide.activeBackground3": ${editor.green.area.fade(ACTIVE).out()},
	"editorBracketPairGuide.activeBackground4": ${editor.blue.area.fade(ACTIVE).out()},
	"editorBracketPairGuide.activeBackground5": ${editor.yellow[hard].fade(ACTIVE).out()},
	"editorBracketPairGuide.activeBackground6": ${editor.any.area.fade(ACTIVE).out()},
	
	"editorBracketPairGuide.background1": ${editor.cyan.area.fade(INACTIVE).out()},
	"editorBracketPairGuide.background2": ${editor.magenta.area.fade(INACTIVE).out()},
	"editorBracketPairGuide.background3": ${editor.green.area.fade(INACTIVE).out()},
	"editorBracketPairGuide.background4": ${editor.blue.area.fade(INACTIVE).out()},
	"editorBracketPairGuide.background5": ${editor.yellow[hard].fade(INACTIVE).out()},
	"editorBracketPairGuide.background6": ${editor.any.area.fade(INACTIVE).out()},
	
	"editorCodeLens.foreground": ${editor.lower.text.fade(0.75).out()},
	
	${dev(`"editorCommentsWidget.rangeActiveBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editorCommentsWidget.rangeActiveBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editorCommentsWidget.rangeBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editorCommentsWidget.rangeBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editorCommentsWidget.resolvedBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editorCommentsWidget.unresolvedBorder": "#ff0000",`) /* FIXME */}
	
	"editorCursor.background": ${editor.lower.area.out()},
	"editorCursor.foreground": ${editor.lower.text.out()},
	
	"editorError.background": ${editor.red.like.fade(0.15).out()},
	"editorError.border": "#0000",
	"editorError.foreground": ${editor.red.area.out()},
	
	${dev(`"editorGhostText.background": "#ff0000",`) /* FIXME */}
	${dev(`"editorGhostText.border": "#ff0000",`) /* FIXME */}
	${dev(`"editorGhostText.foreground": "#ff0000",`) /* FIXME */}
	
	"editorGroup.border": ${common.lower.like.shadow()},
	"editorGroup.dropBackground": ${common[emphasis].area.fade(0.2).out()},
	${dev(`"editorGroup.dropIntoPromptBackground": "#ff0000",`) /* FIXME */}
	${dev(`"editorGroup.dropIntoPromptBorder": "#ff0000",`) /* FIXME */}
	${dev(`"editorGroup.dropIntoPromptForeground": "#ff0000",`) /* FIXME */}
	"editorGroup.emptyBackground": ${common.alternate().out()},
	${dev(`"editorGroup.focusedEmptyBorder": "#00ff00",`) /* FIXME */}
	
	"editorGroupHeader.border": "#FFFFFF07",
	"editorGroupHeader.noTabsBackground": ${tab.lower.like.out()},
	"editorGroupHeader.tabsBackground": ${tab.lower.like.out()},
	"editorGroupHeader.tabsBorder": ${tab.lower.like.shadow()},
	
	${dev(`"editorGutter.addedBackground": "#ff0000",`) /* FIXME */}
	"editorGutter.background": ${editor.raise("lower", "area", 0.04).out()},
	${dev(`"editorGutter.commentGlyphForground": "#ff0000",`) /* FIXME */}
	${dev(`"editorGutter.commentRangeForeground": "#ff0000",`) /* FIXME */}
	"editorGutter.deletedBackground": ${editor.red.area.out()},
	"editorGutter.foldingControlForeground": ${editor.lower.text.fade(editor.dim).out()},
	"editorGutter.modifiedBackground": ${editor.blue.area.out()},
	
	"editorHint.border": ${editor.lower.area.shadow()},
	"editorHint.foreground": ${editor.lower.text.fade(editor.dim).out()},
	
	"editorHoverWidget.background": ${editor.raise("lower", "area", 0.04).out()},
	"editorHoverWidget.border": ${editor.lower.text.fade(editor.border).out()},
	"editorHoverWidget.foreground": ${editor.lower.text.out()},
	${dev(`"editorHoverWidget.highlightForeground": "#00ff00",`) /* FIXME */}
	"editorHoverWidget.statusBarBackground": ${editor.alternate().out()},
	
	"editorIndentGuide.activeBackground": ${editor.lower.text.fade(ACTIVE).out()},
	"editorIndentGuide.background": ${editor.lower.text.fade(INACTIVE).out()},
	
	${dev(`"editorInfo.background": "#ff0000",`) /* FIXME */}
	${dev(`"editorInfo.border": "#ff0000",`) /* FIXME */}
	${dev(`"editorInfo.foreground": "#ff0000",`) /* FIXME */}
	
	"editorInlayHint.background": ${editor.cyan.area.fade(0.1).out()},
	"editorInlayHint.foreground": ${editor.cyan.area.out()},
	"editorInlayHint.parameterBackground": ${editor.green.area.fade(0.1).out()},
	"editorInlayHint.parameterForeground": ${editor.green.area.out()},
	"editorInlayHint.typeBackground": ${editor.blue.area.fade(0.1).out()},
	"editorInlayHint.typeForeground": ${editor.blue.area.out()},
	
	"editorLightBulb.foreground": ${editor.yellow.area.out()},
	
	${dev(`"editorLightBulbAutoFix.foreground": "#ff0000",`) /* FIXME */}
	
	"editorLineNumber.activeForeground": ${editor.lower.text.out()},
	${dev(`"editorLineNumber.dimmedForeground": "#ff0000",`) /* FIXME */}
	"editorLineNumber.foreground": ${editor.lower.text.fade(editor.dim).out()},
	
	"editorLink.activeForeground": ${editor.lower.text.out()},
	
	${dev(`"editorMarkerNavigation.background": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorMarkerNavigationError.background": "#ff0000",`) /* FIXME */}
	${dev(`"editorMarkerNavigationError.headerBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorMarkerNavigationInfo.background": "#ff0000",`) /* FIXME */}
	${dev(`"editorMarkerNavigationInfo.headerBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorMarkerNavigationWarning.background": "#ff0000",`) /* FIXME */}
	${dev(`"editorMarkerNavigationWarning.headerBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorOverviewRuler.addedForeground": "#ff0000",`) /* FIXME */}
	"editorOverviewRuler.background": ${editor.raise("lower", "area", 0.04).out()},
	"editorOverviewRuler.border": ${editor.raise("lower", "area", 0.04).shadow()},
	${dev(`"editorOverviewRuler.bracketMatchForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.commonContentForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.currentContentForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.deletedForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.errorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.findMatchForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.incomingContentForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.infoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.modifiedForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.rangeHighlightForeground": "#ff0000",`) /* FIXME */}
	"editorOverviewRuler.selectionHighlightForeground": ${editor.yellow.area.out()},
	${dev(`"editorOverviewRuler.warningForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.wordHighlightForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.wordHighlightStrongForeground": "#ff0000",`) /* FIXME */}
	${dev(`"editorOverviewRuler.wordHighlightTextForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorPane.background": "#00ff00",`) /* FIXME */}
	
	"editorRuler.foreground": ${editor.lower.text.fade(editor.border).out()},
	
	${dev(`"editorStickyScroll.background": "#ff0000",`) /* FIXME */}
	
	${dev(`"editorStickyScrollHover.background": "#ff0000",`) /* FIXME */}
	
	"editorSuggestWidget.background": ${editor.raise("lower", "area", 0.04).out()},
	"editorSuggestWidget.border": ${editor.blue.area.fade(editor.dim).out()},
	"editorSuggestWidget.focusHighlightForeground": ${editor[accent].text.out()},
	"editorSuggestWidget.foreground": ${editor.lower.text.out()},
	"editorSuggestWidget.highlightForeground": ${editor[accent].like.out()},
	"editorSuggestWidget.selectedBackground": ${editor[accent].area.out()},
	"editorSuggestWidget.selectedForeground": ${editor[accent].text.out()},
	"editorSuggestWidget.selectedIconForeground": ${editor[accent].text.out()},
	
	${dev(`"editorSuggestWidgetStatus.foreground": "#00ff00",`) /* FIXME */}
	
	${dev(`"editorUnicodeHighlight.background": "#00ff00",`) /* FIXME */}
	${dev(`"editorUnicodeHighlight.border": "#ffff00",`) /* FIXME */}
	
	"editorUnnecessaryCode.border": ${editor.lower.area.shadow()},
	"editorUnnecessaryCode.opacity": "#0000009F",
	
	"editorWarning.background": ${editor.yellow.like.fade(0.1).out()},
	"editorWarning.border": "#0000",
	"editorWarning.foreground": ${editor.yellow.area.out()},
	
	"editorWhitespace.foreground": ${editor.lower.text.fade(editor.dim / 2).out()},
	
	"editorWidget.background": ${editor.raise("lower", "area", 0.04).out()},
	"editorWidget.border": ${editor.lower.text.fade(editor.border).out()},
	"editorWidget.foreground": ${editor.lower.text.out()},
	"editorWidget.resizeBorder": ${editor.lower.text.fade(0.5).out()},
	
	"errorForeground": ${common.red.like.out()},
	
	"errorLens.errorBackground": ${editor.red.like.fade(0.15).out()},
	"errorLens.errorBackgroundLight": ${editor.red.like.fade(0.15).out()},
	"errorLens.errorForeground": ${editor.red.like.out()},
	"errorLens.errorForegroundLight": ${editor.red.like.out()},
	
	${dev(`"errorLens.errorMessageBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"errorLens.hintBackground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.hintBackgroundLight": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.hintForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.hintForegroundLight": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.hintMessageBackground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.infoBackground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.infoBackgroundLight": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.infoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.infoForegroundLight": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.infoMessageBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"errorLens.statusBarErrorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.statusBarHintForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.statusBarIconErrorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.statusBarIconWarningForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.statusBarInfoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"errorLens.statusBarWarningForeground": "#ff0000",`) /* FIXME */}
	
	"errorLens.warningBackground": ${editor.yellow.like.fade(0.1).out()},
	"errorLens.warningBackgroundLight": ${editor.yellow.like.fade(0.1).out()},
	"errorLens.warningForeground": ${editor.yellow.like.out()},
	"errorLens.warningForegroundLight": ${editor.yellow.like.out()},
	${dev(`"errorLens.warningMessageBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"extensionBadge.remoteBackground": "#ff0000",`) /* FIXME */}
	${dev(`"extensionBadge.remoteForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"extensionButton.background": "#ff0000",`) /* FIXME */}
	${dev(`"extensionButton.foreground": "#ff0000",`) /* FIXME */}
	${dev(`"extensionButton.hoverBackground": "#ff0000",`) /* FIXME */}
	"extensionButton.prominentBackground": ${common[emphasis].area.out()},
	"extensionButton.prominentForeground": ${common[emphasis].text.out()},
	"extensionButton.prominentHoverBackground": ${lab::mix(common[emphasis].area, common[emphasis].text, HOVER).out()},
	${dev(`"extensionButton.separator": "#ff0000",`) /* FIXME */}
	
	${dev(`"extensionIcon.preReleaseForeground": ${common.red.area.out()},`) /* FIXME strange */}
	${dev(`"extensionIcon.sponsorForeground": "#ff0000",`) /* FIXME */}
	"extensionIcon.starForeground": ${common.yellow.area.out()},
	"extensionIcon.verifiedForeground": ${common.green.area.out()},
	
	"focusBorder": ${common[accent].area.out()},
	
	"foreground": ${common.lower.text.out()},
	
	"gitDecoration.addedResourceForeground": ${side.cyan.like.out()},
	${dev(`"gitDecoration.conflictingResourceForeground": "#ff0000",`) /* FIXME */}
	"gitDecoration.deletedResourceForeground": ${side.red.like.out()},
	"gitDecoration.ignoredResourceForeground": ${side.lower.text.fade(DIM).out()},
	"gitDecoration.modifiedResourceForeground": ${side.magenta.like.out()},
	"gitDecoration.renamedResourceForeground": ${side.any.like.out()},
	"gitDecoration.stageDeletedResourceForeground": ${side.red.like.out()},
	"gitDecoration.stageModifiedResourceForeground": ${side.blue.like.out()},
	${dev(`"gitDecoration.submoduleResourceForeground": "#ff0000",`) /* FIXME */}
	"gitDecoration.untrackedResourceForeground": ${side.green.like.out()},
	
	"icon.foreground": ${common.lower.text.out()},
	
	"input.background": ${common.lower("lower", "area", 0.04).out()},
	"input.border": ${common.lower.text.fade(common.border).out()},
	"input.foreground": ${common.lower.text.out()},
	"input.placeholderForeground": ${common.lower.text.fade(common.dim).out()},
	
	"inputOption.activeBackground": ${editor[emphasis].like.fade(0.15).out()},
	"inputOption.activeBorder": ${editor[emphasis].like.fade(0.15).out()},
	"inputOption.activeForeground": ${editor[emphasis].like.out()},
	"inputOption.hoverBackground": ${editor.lower.text.fade(0.15).out()},
	
	${dev(`"inputValidation.errorBackground": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.errorBorder": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.errorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.infoBackground": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.infoBorder": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.infoForeground": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.warningBackground": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.warningBorder": "#ff0000",`) /* FIXME */}
	${dev(`"inputValidation.warningForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"interactive.activeCodeBorder": "#00ff00",`) /* FIXME */}
	${dev(`"interactive.inactiveCodeBorder": "#ff0000",`) /* FIXME */}
	
	"keybindingLabel.background": ${common.lower.text.fade(0.1).out()},
	"keybindingLabel.border": ${common.lower.like.shadow()},
	"keybindingLabel.bottomBorder": ${common.lower.like.shadow()},
	"keybindingLabel.foreground": ${common.lower.text.out()},
	"keybindingTable.headerBackground": ${editor.lower.text.fade(0.1).out()},
	"keybindingTable.rowsBackground": ${editor.alternate().out()},
	
	"list.activeSelectionBackground": ${common[accent].area.out()},
	"list.activeSelectionForeground": ${common[accent].text.out()},
	"list.activeSelectionIconForeground": ${common[accent].text.out()},
	${dev(`"list.deemphasizedForeground": "#00ff00",`) /* FIXME */}
	"list.dropBackground": ${common[accent].area.fade(0.3).out()},
	"list.errorForeground": ${common.red.like.out()},
	"list.filterMatchBackground": ${editor.magenta.like.fade(0.3).out()},
	"list.filterMatchBorder": ${editor.magenta.like.fade(0.3).out()},
	"list.focusAndSelectionOutline": "#0000",
	"list.focusBackground": ${common[accent].like.fade(0.2).out()},
	"list.focusForeground": ${common[accent].like.out()},
	"list.focusHighlightForeground": ${common[accent].text.out()},
	"list.focusOutline": ${common[accent].like.fade(0.2).out()},
	"list.highlightForeground": ${common[accent].like.out()},
	"list.hoverBackground": ${common.lower.text.fade(HOVER).out()},
	"list.hoverForeground": ${common.lower.text.out()},
	"list.inactiveFocusBackground": ${common[emphasis].like.fade(0.1).out()},
	"list.inactiveFocusOutline": ${common[emphasis].like.fade(common.border).out()},
	"list.inactiveSelectionBackground": ${common[emphasis].like.fade(0.1).out()},
	"list.inactiveSelectionForeground": ${common[emphasis].like.out()},
	"list.inactiveSelectionIconForeground": ${common[emphasis].like.out()},
	${dev(`"list.invalidItemForeground": "#ffff00",`) /* FIXME */}
	"list.warningForeground": ${common.yellow.like.out()},
	
	"listFilterWidget.background": ${side.upper.area.out()},
	${dev(`"listFilterWidget.noMatchesOutline": "#00ff00",`) /* FIXME */}
	${dev(`"listFilterWidget.outline": "#ffff00",`) /* FIXME */}
	"listFilterWidget.shadow": "#0000005F",
	
	"menu.background": ${menu.upper.like.out()},
	"menu.border": "#0000",
	"menu.foreground": ${menu.upper.text.out()},
	"menu.selectionBackground": ${menu.upper.text.fade(HOVER).out()},
	"menu.selectionBorder": ${menu.upper.text.fade(HOVER).out()},
	"menu.selectionForeground": ${menu.upper.text.out()},
	"menu.separatorBackground": ${menu.upper.like.shadow()},
	
	"menubar.selectionBackground": ${title.lower.text.fade(HOVER).out()},
	"menubar.selectionBorder": ${title.lower.text.fade(title.border).out()},
	"menubar.selectionForeground": ${title.lower.text.out()},
	
	${dev(`"merge.border": "#ff0000",`) /* FIXME */}
	${dev(`"merge.commonContentBackground": "#ff0000",`) /* FIXME */}
	${dev(`"merge.commonHeaderBackground": "#ff0000",`) /* FIXME */}
	${dev(`"merge.currentContentBackground": "#ff0000",`) /* FIXME */}
	${dev(`"merge.currentHeaderBackground": "#ff0000",`) /* FIXME */}
	${dev(`"merge.incomingContentBackground": "#ff0000",`) /* FIXME */}
	${dev(`"merge.incomingHeaderBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"mergeEditor.change.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.change.word.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.changeBase.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.changeBase.word.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.handled.minimapOverViewRuler": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.handledFocused.border": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.handledUnfocused.border": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.input1.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.input2.background": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.unhandled.minimapOverViewRuler": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.unhandledFocused.border": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflict.unhandledUnfocused.border": "#ff0000",`) /* FIXME */}
	${dev(`"mergeEditor.conflictingLines.background": "#ff0000",`) /* FIXME */}
	
	"minimap.background": ${editor.raise("lower", "area", 0.04).out()},
	"minimap.errorHighlight": ${editor.red.like.out()},
	"minimap.findMatchHighlight": ${editor.magenta.like.out()},
	"minimap.foregroundOpacity": "#000F",
	"minimap.selectionHighlight": ${editor.lower.text.fade(0.375).out()},
	"minimap.selectionOccurrenceHighlight": ${editor.yellow.area.out()},
	"minimap.warningHighlight": ${editor.yellow.like.out()},
	
	${dev(`"minimapGutter.addedBackground": "#ff0000",`) /* FIXME */}
	${dev(`"minimapGutter.deletedBackground": "#ff0000",`) /* FIXME */}
	${dev(`"minimapGutter.modifiedBackground": "#ff0000",`) /* FIXME */}
	"minimapSlider.activeBackground": ${editor.lower.text.fade(0.2).out()},
	"minimapSlider.background": ${editor.lower.text.fade(0.1).out()},
	"minimapSlider.hoverBackground": ${editor.lower.text.fade(0.15).out()},
	
	${dev(`"notebook.cellBorderColor": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.cellEditorBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.cellHoverBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.cellInsertionIndicator": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.cellStatusBarItemHoverBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.cellToolbarSeparator": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.editorBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.focusedCellBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.focusedCellBorder": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.focusedEditorBorder": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.inactiveFocusedCellBorder": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.inactiveSelectedCellBorder": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.outputContainerBackgroundColor": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.outputContainerBorderColor": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.selectedCellBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.selectedCellBorder": "#ff0000",`) /* FIXME */}
	${dev(`"notebook.symbolHighlightBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"notebookEditorOverviewRuler.runningCellForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"notebookScrollbarSlider.activeBackground": "#ff0000",`) /* FIXME */}
	${dev(`"notebookScrollbarSlider.background": "#ff0000",`) /* FIXME */}
	${dev(`"notebookScrollbarSlider.hoverBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"notebookStatusErrorIcon.foreground": "#ff0000",`) /* FIXME */}
	${dev(`"notebookStatusRunningIcon.foreground": "#ff0000",`) /* FIXME */}
	${dev(`"notebookStatusSuccessIcon.foreground": "#ff0000",`) /* FIXME */}
	
	// "notificationCenter.border": "#0000",
	"notificationCenterHeader.background": ${notify.upper.area.out()},
	"notificationCenterHeader.foreground": ${notify.lower.text.out()},
	
	"notificationLink.foreground": ${notify.blue.like.out()},
	
	"notifications.background": ${notify.lower.like.out()},
	"notifications.border": ${notify.lower.like.shadow()},
	"notifications.foreground": ${notify.lower.text.out()},
	
	"notificationsErrorIcon.foreground": ${notify.red.like.out()},
	"notificationsInfoIcon.foreground": ${notify.cyan.like.out()},
	"notificationsWarningIcon.foreground": ${notify.yellow.like.out()},
	"notificationToast.border": ${notify.lower.text.fade(notify.border).out()},
	
	"panel.background": ${side.lower.like.out()},
	"panel.border": ${side.lower.like.shadow()},
	"panel.dropBorder": ${lab::mix(side.lower.like, side.lower.text, 0.5).out()},
	
	${dev(`"panelInput.border": "#00ff00",`) /* FIXME */}
	
	${dev(`"panelSection.border": "#00ffff",`) /* FIXME */}
	${dev(`"panelSection.dropBackground": "#0000ff",`) /* FIXME */}
	
	${dev(`"panelSectionHeader.background": "#00007f",`) /* FIXME */}
	${dev(`"panelSectionHeader.border": "#ffff00",`) /* FIXME */}
	${dev(`"panelSectionHeader.foreground": "#ffff7f",`) /* FIXME */}
	
	"panelTitle.activeBorder": ${side[accent].area.out()},
	"panelTitle.activeForeground": ${side.lower.text.out()},
	"panelTitle.inactiveForeground": ${side.lower.text.fade(side.dim).out()},
	
	"peekView.border": ${editor[emphasis].area.fade(0.5).out()},
	"peekViewEditor.background": ${editor.lower("lower", "area", 0.2).out()},
	"peekViewEditor.matchHighlightBackground": ${editor[accent].like.fade(0.15).out()},
	"peekViewEditor.matchHighlightBorder": ${editor[accent].like.fade(0.25).out()},
	"peekViewEditorGutter.background": ${editor.lower.area.out()},
	${dev(`"peekViewEditorStickyScroll.background": "#ff0000",`) /* FIXME */}
	"peekViewResult.background": ${editor.raise("lower", "area", 0.04).out()},
	"peekViewResult.fileForeground": ${editor.lower.text.out()},
	"peekViewResult.lineForeground": ${editor[emphasis].area.out()},
	"peekViewResult.matchHighlightBackground": ${editor.lower("lower", "area", 0.3).out()},
	"peekViewResult.selectionBackground": ${editor[accent].like.fade(0.2).out()},
	"peekViewResult.selectionForeground": ${editor[accent].like.out()},
	"peekViewTitle.background": ${editor.alternate().out()},
	"peekViewTitleDescription.foreground": ${editor.blue.like.out()},
	"peekViewTitleLabel.foreground": ${editor[emphasis].area.out()},
	
	"pickerGroup.border": ${common.lower.like.shadow()}, // TODO test
	"pickerGroup.foreground": ${common[accent].like.out()},
	
	${dev(`"ports.iconRunningProcessForeground": "#ff0000",`) /* FIXME */}
	
	"problemsErrorIcon.foreground": ${side.red.like.out()},
	"problemsInfoIcon.foreground": ${side.cyan.like.out()},
	"problemsWarningIcon.foreground": ${side.yellow.like.out()},
	
	${dev(`"profileBadge.background": "#ff0000",`) /* FIXME */}
	${dev(`"profileBadge.foreground": "#ff0000",`) /* FIXME */}
	
	"progressBar.background": ${common[accent].area.out()}, // NOTE or notification?
	
	"quickInput.background": ${common.upper.like.out()},
	"quickInput.foreground": ${common.upper.text.out()},
	"quickInputList.focusBackground": ${common[accent].area.out()},
	"quickInputList.focusForeground": ${common[accent].text.out()},
	"quickInputList.focusIconForeground": ${common[accent].text.out()},
	"quickInputTitle.background": ${lab::lighten(common.upper.like, 0.06).out()},
	
	${dev(`"rust_analyzer.syntaxTreeBorder": "#ff0000",`) /* FIXME */}
	
	"sash.hoverBorder": ${common[accent].area.out()},
	${dev(`"scm.providerBorder": "#ff00ff",`) /* FIXME */}
	
	"scrollbar.shadow": "#0000005F",
	"scrollbarSlider.activeBackground": ${editor.lower.text.fade(0.25).out()},
	"scrollbarSlider.background": ${editor.lower.text.fade(0.15).out()},
	"scrollbarSlider.hoverBackground": ${editor.lower.text.fade(0.2).out()},
	
	${dev(`"searchEditor.findMatchBackground": "#ff0000",`) /* FIXME */}
	${dev(`"searchEditor.findMatchBorder": "#ff0000",`) /* FIXME */}
	${dev(`"searchEditor.textInputBorder": "#ff0000",`) /* FIXME */}
	
	"selection.background": ${common.blue.area.fade(0.4).out()},
	
	"settings.checkboxBackground": ${editor.lower.like.out()},
	"settings.checkboxBorder": ${editor.lower.text.fade(editor.border).out()},
	"settings.checkboxForeground": ${editor[accent].like.out()},
	"settings.dropdownBackground": ${editor.lower.text.fade(0.1).out()},
	"settings.dropdownBorder": ${editor.lower.text.fade(0.1).out()},
	"settings.dropdownForeground": ${editor.lower.text.out()},
	${dev(`"settings.dropdownListBorder": "#ffff00",`) /* FIXME */}
	"settings.focusedRowBackground": ${editor[emphasis].like.fade(0.1).out()},
	"settings.focusedRowBorder": ${editor[emphasis].like.fade(0.15).out()},
	"settings.headerBorder": ${editor.lower.text.fade(editor.border).out()},
	"settings.headerForeground": ${editor[accent].like.out()},
	"settings.modifiedItemIndicator": ${editor[emphasis].area.out()},
	"settings.numberInputBackground": ${editor.lower.text.fade(0.1).out()},
	"settings.numberInputBorder": ${editor.lower.text.fade(0.1).out()},
	"settings.numberInputForeground": ${editor.lower.text.out()},
	"settings.rowHoverBackground": ${editor.lower.text.fade(0.05).out()},
	"settings.sashBorder": ${editor.lower.text.fade(editor.border).out()},
	${dev(`"settings.settingsHeaderHoverForeground": "#ff0000",`) /* FIXME */}
	"settings.textInputBackground": ${editor.lower.text.fade(0.1).out()},
	"settings.textInputBorder": ${editor.lower.text.fade(0.1).out()},
	"settings.textInputForeground": ${editor.lower.text.out()},
	
	"sideBar.background": ${side.lower.like.out()},
	"sideBar.border": ${side.lower.like.shadow()},
	${dev(`"sideBar.dropBackground": "#ffff00",`) /* FIXME */}
	"sideBar.foreground": ${side.lower.text.out()},
	"sideBarSectionHeader.background": ${side.upper.area.out()},
	"sideBarSectionHeader.border": ${side.upper.area.shadow()},
	"sideBarSectionHeader.foreground": ${side.lower.text.out()},
	"sideBarTitle.foreground": ${side.lower.text.out()},
	
	${dev(`"sideBySideEditor.horizontalBorder": "#ffff00",`) /* FIXME */}
	${dev(`"sideBySideEditor.verticalBorder": "#ff00dd",`) /* FIXME */}
	
	"statusBar.background": ${status("blue").out()},
	"statusBar.border": ${status_shadow},
	"statusBar.debuggingBackground": ${status(emphasis).out()},
	"statusBar.debuggingBorder": ${status_shadow},
	"statusBar.debuggingForeground": ${status_text.out()},
	"statusBar.focusBorder": "#000",
	"statusBar.foreground": ${status_text.out()},
	"statusBar.noFolderBackground": ${status("magenta").out()},
	"statusBar.noFolderBorder": ${status_shadow},
	"statusBar.noFolderForeground": ${status_text.out()},
	
	"statusBarItem.activeBackground": ${status_text.fade(0.2).out()},
	${dev(`"statusBarItem.compactHoverBackground": "#ff0000",`) /* FIXME */}
	"statusBarItem.errorBackground": ${status.red.area.out()},
	"statusBarItem.errorForeground": ${status.red.text.out()},
	${dev(`"statusBarItem.focusBorder": "#ff0000",`) /* FIXME */}
	"statusBarItem.hoverBackground": ${status_text.fade(0.1).out()},
	"statusBarItem.prominentBackground": "#0000004F",
	"statusBarItem.prominentForeground": ${status_text.out()},
	"statusBarItem.prominentHoverBackground": "#FF0000", // BUG ?
	"statusBarItem.remoteBackground": ${
		const base = status.lower[if status.dark() { "like" } else { "text" }];
		lch::saturate(lab::mix(base, status.green.area, 0.5), 0.5).out()
	},
	"statusBarItem.remoteForeground": ${lab::lighten_fixed(status_text, 0.08).out()},
	"statusBarItem.warningBackground": ${status.yellow.area.out()},
	"statusBarItem.warningForeground": ${status.yellow.text.out()},
	
	"symbolIcon.arrayForeground": ${side.green.like.out()},
	"symbolIcon.booleanForeground": ${side.magenta.like.out()},
	"symbolIcon.classForeground": ${side.blue.like.out()},
	"symbolIcon.colorForeground": ${side.red.like.out()},
	"symbolIcon.constantForeground": ${side.green.like.out()},
	"symbolIcon.constructorForeground": ${side.cyan.like.out()},
	"symbolIcon.enumeratorForeground": ${side.blue.like.out()},
	"symbolIcon.enumeratorMemberForeground": ${side.magenta.like.out()},
	"symbolIcon.eventForeground": ${side.cyan.like.out()},
	"symbolIcon.fieldForeground": ${side.yellow.text.out()},
	"symbolIcon.fileForeground": ${side.lower.text.out()},
	"symbolIcon.folderForeground": ${side.any.like.out()},
	"symbolIcon.functionForeground": ${side.cyan.like.out()},
	"symbolIcon.interfaceForeground": ${side.blue.like.out()},
	"symbolIcon.keyForeground": ${side.yellow.like.out()},
	"symbolIcon.keywordForeground": ${side.red.like.out()},
	"symbolIcon.methodForeground": ${side.cyan.like.out()},
	"symbolIcon.moduleForeground": ${side.any.like.out()},
	"symbolIcon.namespaceForeground": ${side.any.like.out()},
	"symbolIcon.nullForeground": ${side.magenta.like.out()},
	"symbolIcon.numberForeground": ${side.magenta.like.out()},
	"symbolIcon.objectForeground": ${side.green.like.out()},
	"symbolIcon.operatorForeground": ${side.red.like.out()},
	"symbolIcon.packageForeground": ${side.any.like.out()},
	"symbolIcon.propertyForeground": ${side.lower.text.out()},
	"symbolIcon.referenceForeground": ${side.red.like.out()},
	"symbolIcon.snippetForeground": ${side.green.like.out()},
	"symbolIcon.stringForeground": ${side.yellow.like.out()},
	"symbolIcon.structForeground": ${side.blue.like.out()},
	"symbolIcon.textForeground": ${side.yellow.like.out()},
	"symbolIcon.typeParameterForeground": ${side.lower.text.out()},
	"symbolIcon.unitForeground": ${side.any.text.out()},
	"symbolIcon.variableForeground": ${side.lower.text.out()},
	
	"tab.activeBackground": ${tab.upper.like.out()},
	"tab.activeBorder": ${tab[accent].area.out()},
	"tab.activeBorderTop": ${lab::lighten(tab.upper.like, if tab.dark() { 0.05 } else { 0.5 }).out()},
	"tab.activeForeground": ${tab.lower.text.out()},
	${dev(`"tab.activeModifiedBorder": "#FF0000",`) /* FIXME */}
	"tab.border": ${tab.lower.like.shadow()},
	"tab.hoverBackground": ${tab.upper.like.fade(ACTIVE).out()},
	"tab.hoverBorder": ${tab[emphasis].area.fade(tab.dim).out()},
	"tab.hoverForeground": ${tab.lower.text.out()},
	"tab.inactiveBackground": ${tab.upper.like.fade(INACTIVE).out()},
	"tab.inactiveForeground": ${tab.lower.text.fade(DIM).out()},
	${dev(`"tab.inactiveModifiedBorder": "#FF0000",`) /* FIXME */}
	"tab.lastPinnedBorder": ${tab[emphasis].area.out()},
	"tab.unfocusedActiveBackground": ${tab.upper.like.out()},
	"tab.unfocusedActiveBorder": ${tab.lower.text.fade(tab.dim / 1.5).out()},
	"tab.unfocusedActiveBorderTop": "#0000",
	"tab.unfocusedActiveForeground": ${tab.lower.text.out()},
	${dev(`"tab.unfocusedActiveModifiedBorder": "#FF0000",`) /* FIXME */}
	"tab.unfocusedHoverBackground": ${tab.upper.like.fade(ACTIVE).out()},
	"tab.unfocusedHoverBorder": ${tab[emphasis].area.fade(tab.dim).out()},
	"tab.unfocusedHoverForeground": ${tab.lower.text.out()},
	"tab.unfocusedInactiveBackground": ${tab.upper.like.fade(INACTIVE).out()},
	"tab.unfocusedInactiveForeground": ${tab.lower.text.fade(DIM).out()},
	${dev(`"tab.unfocusedInactiveModifiedBorder": "#FF0000",`) /* FIXME */}
	
	"terminal.ansiBlack": ${term.alternate().out()},
	"terminal.ansiBlue": ${term.blue[normal].out()},
	"terminal.ansiCyan": ${term.cyan[normal].out()},
	"terminal.ansiGreen": ${term.green[normal].out()},
	"terminal.ansiMagenta": ${term.magenta[normal].out()},
	"terminal.ansiRed": ${term.red[normal].out()},
	"terminal.ansiWhite": ${term.any[normal].out()},
	"terminal.ansiYellow": ${term.yellow[normal].out()},
	
	"terminal.ansiBrightBlack": ${lab::mix(term.lower.text, term.lower.area, term.dim).out()},
	"terminal.ansiBrightBlue": ${term.blue[bright].out()},
	"terminal.ansiBrightCyan": ${term.cyan[bright].out()},
	"terminal.ansiBrightGreen": ${term.green[bright].out()},
	"terminal.ansiBrightMagenta": ${term.magenta[bright].out()},
	"terminal.ansiBrightRed": ${term.red[bright].out()},
	"terminal.ansiBrightWhite": ${term.upper.text.out()},
	"terminal.ansiBrightYellow": ${term.yellow[bright].out()},
	
	"terminal.background": ${term.lower.area.out()},
	"terminal.border": ${term.lower.text.fade(term.border).out()},
	${dev(`"terminal.dropBackground": "#ff0000",`) /* FIXME */}
	${dev(`"terminal.findMatchBackground": "#ff0000",`) /* FIXME */}
	${dev(`"terminal.findMatchBorder": "#ff0000",`) /* FIXME */}
	${dev(`"terminal.findMatchHighlightBackground": "#ff0000",`) /* FIXME */}
	${dev(`"terminal.findMatchHighlightBorder": "#ff0000",`) /* FIXME */}
	"terminal.foreground": ${term.lower.text.out()},
	"terminal.inactiveSelectionBackground": ${term.lower.text.fade(0.1).out()},
	"terminal.selectionBackground": ${term.lower.text.fade(0.15).out()},
	// "terminal.selectionForeground": ${term.upper.text.out()},
	"terminal.tab.activeBorder": ${term[accent].area.out()},
	
	${dev(`"terminalCommandDecoration.defaultBackground": "#ff0000",`) /* FIXME */}
	${dev(`"terminalCommandDecoration.errorBackground": "#ff0000",`) /* FIXME */}
	${dev(`"terminalCommandDecoration.successBackground": "#ff0000",`) /* FIXME */}
	"terminalCursor.background": ${term.lower.area.out()},
	"terminalCursor.foreground": ${term.lower.text.out()},
	${dev(`"terminalOverviewRuler.cursorForeground": "#ff0000",`) /* FIXME */}
	${dev(`"terminalOverviewRuler.findMatchForeground": "#ff0000",`) /* FIXME */}
	
	${dev(`"testing.iconErrored": "#ff0000",`) /* FIXME */}
	${dev(`"testing.iconFailed": "#ff0000",`) /* FIXME */}
	${dev(`"testing.iconPassed": "#ff0000",`) /* FIXME */}
	${dev(`"testing.iconQueued": "#ff0000",`) /* FIXME */}
	${dev(`"testing.iconSkipped": "#ff0000",`) /* FIXME */}
	${dev(`"testing.iconUnset": "#ff0000",`) /* FIXME */}
	${dev(`"testing.message.error.decorationForeground": "#ff0000",`) /* FIXME */}
	${dev(`"testing.message.error.lineBackground": "#ff0000",`) /* FIXME */}
	${dev(`"testing.message.info.decorationForeground": "#ff0000",`) /* FIXME */}
	${dev(`"testing.message.info.lineBackground": "#ff0000",`) /* FIXME */}
	${dev(`"testing.peekBorder": "#ff0000",`) /* FIXME */}
	${dev(`"testing.peekHeaderBackground": "#ff0000",`) /* FIXME */}
	${dev(`"testing.runAction": "#ff0000",`) /* FIXME */}
	
	"textBlockQuote.background": ${editor.lower.text.fade(0.1).out()},
	"textBlockQuote.border": ${editor.blue.area.fade(0.5).out()},
	"textCodeBlock.background": ${editor.lower("lower", "area", 0.2).out()},
	"textLink.activeForeground": ${common[emphasis].like.out()},
	"textLink.foreground": ${common.blue.like.out()},
	"textPreformat.foreground": ${editor.yellow.like.out()},
	${dev(`"textSeparator.foreground": "#ff0000",`) /* FIXME */}
	
	"titleBar.activeBackground": ${title.upper.area.out()},
	"titleBar.activeForeground": ${title.lower.text.out()},
	"titleBar.border": ${title.lower.like.shadow()},
	"titleBar.inactiveBackground": ${
		if cfg::option("dim-header") { title.lower.like.out() } else { title.upper.area.out() }
	},
	"titleBar.inactiveForeground": ${title.lower.text.out()},
	
	"toolbar.activeBackground": ${main.lower.text.fade(0.2).out()},
	"toolbar.hoverBackground": ${main.lower.text.fade(0.1).out()},
	"toolbar.hoverOutline": ${main.lower.text.fade(main.border).out()},
	
	${dev(`"tree.inactiveIndentGuidesStroke": "#ff0000",`) /* FIXME */}
	"tree.indentGuidesStroke": ${side.lower.text.fade(0.5).out()},
	"tree.tableColumnsBorder": ${main.lower.text.fade(main.border).out()},
	${dev(`"tree.tableOddRowsBackground": "#ff0000",`) /* FIXME */}
	
	${dev(`"walkThrough.embeddedEditorBackground": "#ff0000",`) /* FIXME */}
	${dev(`"walkthrough.stepTitle.foreground": "#ff0000",`) /* FIXME */}
	
	${dev(`"welcomeOverlay.background": "#ff0000",`) /* FIXME */}
	"welcomePage.background": ${welcome.lower.area.out()},
	"welcomePage.progress.background": ${welcome.upper.text.fade(welcome.dim / 2).out()},
	"welcomePage.progress.foreground": ${welcome[accent].area.out()},
	"welcomePage.tileBackground": ${welcome.upper.like.out()},
	${dev(`"welcomePage.tileBorder": "#ff0000",`) /* FIXME */}
	"welcomePage.tileHoverBackground": ${lab::mix(welcome.upper.like, welcome.upper.text, HOVER).out()},
	
	${dev(`"widget.border": "#ff0000",`) /* FIXME */}
	"widget.shadow": "#0000005F",
	
${if main.dark() {
	const active = lab::mix(main.lower.like, main.blue.area, main.dim).out();
`	"window.activeBorder": ${active},
	"window.inactiveBorder": ${if cfg::option("dim-border") {
		lab::mix(main.lower.like, main.lower.text, main.border).out()
	} else { active }},`
} else {
	const inactive = main.blue.area.out();
`	"window.activeBorder": ${inactive},
	"window.inactiveBorder": ${if cfg::option("dim-border") {
		lab::mix(main.lower.like, main.lower.text, main.dim / 1.5).out()
	} else { inactive }},`
}}
}`
