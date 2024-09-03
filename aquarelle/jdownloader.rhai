/*
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const main    = cfg::scheme("main");
const accent  = cfg::option("accent");
const is_dark = main.lower.text.luma() > main.lower.like.luma();

// WATCH https://www.formdev.com/flatlaf/theme-editor

const link    = if accent == "blue"    { "any" } else { "blue"    };
const visited = if accent == "magenta" { "any" } else { "magenta" };

fn  out() {   '#' + this.to_hex_rgba(true) }
fn json() { "\"#" + this.to_hex_argb(true) + '"' }
fn  svg() { "\"#" + this.to_hex_rgba(true) + '"' }

fn raise(bias) {
	if global::is_dark { lab::lighten_fixed(this, bias).out() }
	else { lab::darken_fixed(this, bias).out() }
}

fn lower(bias) {
	if global::is_dark { lab::darken_fixed(this, bias).out() }
	else { lab::lighten_fixed(this, bias).out() }
}

fn shadow(factor) {
	const L = this.luma();
	lab::mix(this, 0xFF, (2 ** -L + 0.2 * L - 0.6) * factor)
}

fn dev(text) { } // ini
// fn dev(text) { '\n' + text }

const PROPERTIES = `@baseTheme = dark
TitlePane.useWindowDecorations = true
TitlePane.menuBarEmbedded = true

${dev(`
@accentBase2Color = #f00
@accentBaseColor = #0ff
@accentButtonDefaultBackground = #0f0
@accentColor = #f0f
@accentFocusColor = #00f
@accentLinkColor = #ff0
@accentSelectionBackground = #f00
@accentSliderColor = #0ff
@accentUnderlineColor = #0f0`)}
# BUG @background = ${main.upper.text.fade(0.5).out()} ${dev(`
@buttonArrowColor = #ff0`)}
@buttonBackground = ${main.lower.text.fade(0.4).out()} ${dev(`
@buttonDisabledArrowColor = #0ff
@buttonHoverArrowColor = #0f0
@buttonPressedArrowColor = #f0f
@cellFocusColor = #00f`)}
@componentBackground = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()} ${dev(`
@disabledBackground = #f00`)}
@disabledForeground = ${main.lower.text.fade(0.625).out()} ${dev(`
@dropCellBackground = #0f0
@dropCellForeground = #f0f
@dropLineColor = #00f
@dropLineShortColor = #ff0`)}
@foreground = ${main.lower.text.out()} ${dev(`
@menuAcceleratorForeground = #0ff
@menuAcceleratorSelectionForeground = #0f0
@menuBackground = #f0f
@menuCheckBackground = #00f
@menuHoverBackground = #ff0
@menuItemMargin = #f00
@menuSelectionBackground = #0ff`)}
@selectionBackground = ${main.lower.text.fade(0.625).out()}
@selectionForeground = ${main.lower.area.out()} ${dev(`
@selectionInactiveBackground = #00f
@selectionInactiveForeground = #ff0`)}

Button.background = ${main.lower.text.fade(0.2).out()}
Button.borderColor = ${main.lower.text.fade(0.25).out()}
Button.default.background = ${main[accent].area.out()}
Button.default.borderColor = ${main[accent].area.out()}
# Button.default.endBackground = ${main[accent].area.out()}
# Button.default.endBorderColor = ${main[accent].area.out()}
Button.default.focusColor = ${main[accent].area.lower(0.15)}
Button.default.focusedBackground = ${main[accent].area.out()}
# Button.default.focusedBorderColor = ${main[accent].area.out()}
Button.default.focusedForeground = ${main[accent].text.out()}
Button.default.foreground = ${main[accent].text.out()}
Button.default.hoverBackground = ${main[accent].area.raise(0.05)}
# Button.default.hoverBorderColor = ${main[accent].area.out()}
Button.default.hoverForeground = ${main[accent].text.out()}
Button.default.pressedBackground = ${main[accent].area.lower(0.05)}
Button.default.pressedForeground = ${main[accent].text.out()}
# Button.default.startBackground = ${main[accent].area.out()}
# Button.default.startBorderColor = ${main[accent].area.out()}
Button.disabledBackground = ${main.lower.text.fade(0.1).out()}
Button.disabledBorderColor = ${main.lower.text.fade(0.2).out()}
Button.disabledForeground = ${main.lower.text.fade(0.625).out()}
Button.disabledSelectedBackground = ${main[accent].area.fade(0.2).out() /* TODO test*/}
Button.disabledSelectedForeground = ${main.lower.text.fade(0.625).out()}
Button.disabledText = ${main.lower.text.fade(0.625).out()}
# Button.endBackground = #f00
# Button.endBorderColor = #f00
Button.focusedBackground = ${main.lower.text.fade(0.2).out()}
Button.focusedBorderColor = ${main[accent].area.lower(0.15)}
Button.focusedForeground = ${main.lower.text.out()}
Button.foreground = ${main.lower.text.out()}
Button.hoverBackground = ${main.lower.text.fade(0.3).out()}
Button.hoverBorderColor = #0000
Button.hoverForeground = ${main.lower.text.out()}
Button.pressedBackground = ${main.lower.text.fade(0.4).out()}
Button.pressedForeground = ${main.lower.text.out()}
Button.selectedBackground = ${main.lower.text.fade(0.75).out()}
Button.selectedForeground = ${main.lower.area.out()}
# Button.startBackground = #f00
# Button.startBorderColor = #f00
Button.toolbar.disabledSelectedBackground = #f00
Button.toolbar.disabledSelectedForeground = #f00
Button.toolbar.hoverBackground = ${main.lower.text.fade(0.15).out()}
Button.toolbar.hoverForeground = ${main.lower.text.out()}
Button.toolbar.pressedBackground = ${main.lower.text.fade(0.3).out()}
Button.toolbar.pressedForeground = ${main.lower.text.out()}
Button.toolbar.selectedBackground = ${main.lower.text.out()}
Button.toolbar.selectedForeground = ${main.lower.like.out()} ${dev(`
CheckBox.background = #f00
CheckBox.border = #0f0`)}
CheckBox.disabledText = ${main.lower.text.fade(0.625).out()}
CheckBox.foreground = ${main.lower.text.out()}
CheckBox.icon.background = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
CheckBox.icon.borderColor = ${main.lower.text.fade(0.4).out()}
CheckBox.icon.checkmarkColor = ${main.lower.text.out()}
CheckBox.icon.disabledBackground = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
CheckBox.icon.disabledBorderColor = ${main.lower.text.fade(0.2).out()}
CheckBox.icon.disabledCheckmarkColor = ${main.lower.text.fade(0.625).out()}
CheckBox.icon.disabledSelectedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
CheckBox.icon.disabledSelectedBorderColor = ${main.lower.text.fade(0.2).out()}
CheckBox.icon.focusColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.focusedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
CheckBox.icon.focusedBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.focusedCheckmarkColor = ${main.lower.text.out()}
CheckBox.icon.focusedSelectedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
CheckBox.icon.focusedSelectedBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.hoverBackground = ${lab::mix(main.lower.like, main.lower.text, 0.3).out()}
CheckBox.icon.hoverBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.hoverCheckmarkColor = ${main.lower.text.out()}
CheckBox.icon.hoverSelectedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.3).out()}
CheckBox.icon.hoverSelectedBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.pressedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.4).out()}
CheckBox.icon.pressedBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.pressedCheckmarkColor = ${main.lower.text.out()}
CheckBox.icon.pressedSelectedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.4).out()}
CheckBox.icon.pressedSelectedBorderColor = ${main[accent].area.lower(0.15)}
CheckBox.icon.selectedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
CheckBox.icon.selectedBorderColor = ${main.lower.text.fade(0.4).out()}
CheckBox.icon[filled].background = ${main.lower.text.fade(0.3).out()} ${dev(`
CheckBox.icon[filled].borderColor = #0ff`)}
CheckBox.icon[filled].checkmarkColor = ${main[accent].text.out()}
CheckBox.icon[filled].disabledBackground = ${main.lower.text.fade(0.15).out()} ${dev(`
CheckBox.icon[filled].disabledBorderColor = #ff0`)}
CheckBox.icon[filled].disabledCheckmarkColor = ${main[accent].text.fade(0.625).out()}
CheckBox.icon[filled].disabledSelectedBackground = ${main[accent].area.lower(0.15)} ${dev(`
CheckBox.icon[filled].disabledSelectedBorderColor = #0f0`)}
CheckBox.icon[filled].hoverBackground = ${main.lower.text.fade(0.4).out()} ${dev(`
CheckBox.icon[filled].hoverBorderColor = #00f`)}
CheckBox.icon[filled].hoverCheckmarkColor = ${main[accent].text.out()}
CheckBox.icon[filled].hoverSelectedBackground = ${main[accent].area.raise(0.1)}${dev(`
CheckBox.icon[filled].hoverSelectedBorderColor = #0ff`)}
CheckBox.icon[filled].pressedBackground = ${main.lower.text.fade(0.5).out()}${dev(`
CheckBox.icon[filled].pressedBorderColor = #f0f`)}
CheckBox.icon[filled].pressedCheckmarkColor = ${main[accent].text.out()}
CheckBox.icon[filled].pressedSelectedBackground = ${main[accent].area.raise(0.2)} ${dev(`
CheckBox.icon[filled].pressedSelectedBorderColor = #f00`)}
CheckBox.icon[filled].selectedBackground = ${main[accent].area.out()} ${dev(`
CheckBox.icon[filled].selectedBorderColor = #0f0`)}
CheckBoxMenuItem.acceleratorForeground = ${main.upper.text.fade(0.625).out()}
CheckBoxMenuItem.acceleratorSelectionForeground = ${main.upper.text.fade(0.625).out()}${dev(`
CheckBoxMenuItem.background = #ff0`)}
CheckBoxMenuItem.disabledForeground = ${main.upper.text.fade(0.625).out()}
CheckBoxMenuItem.foreground = ${main.upper.text.out()}
CheckBoxMenuItem.icon.checkmarkColor = ${main.lower.text.out()}
CheckBoxMenuItem.icon.disabledCheckmarkColor = ${main.lower.text.fade(0.625).out()}
CheckBoxMenuItem.selectionBackground = ${main.upper.text.fade(0.2).out()}
CheckBoxMenuItem.selectionForeground = ${main.upper.text.out()}${dev(`
ColorChooser.background = #f00
ColorChooser.foreground = #0ff
ColorChooser.swatchesDefaultRecentColor = #0f0
ColumnControlButton.iconColor = #f0f`)}
ComboBox.background = ${main.lower.text.fade(0.2).out()}
ComboBox.buttonArrowColor = ${main.lower.text.out()}
ComboBox.buttonBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
ComboBox.buttonDisabledArrowColor = ${main.lower.text.fade(0.625).out()}
ComboBox.buttonDisabledSeparatorColor = ${main.lower.text.fade(0.125).out()}
ComboBox.buttonEditableBackground = ${main.lower.text.fade(0.15).out()}
ComboBox.buttonFocusedBackground = ${main.lower.text.fade(0.3).out()}
ComboBox.buttonHoverArrowColor = ${main.lower.text.raise(0.1)}
ComboBox.buttonPressedArrowColor = ${main.lower.text.lower(0.1)}
ComboBox.buttonSeparatorColor = ${main.lower.text.fade(0.25).out()}
ComboBox.disabledBackground = ${main.lower.area.fade(0.5).out()}
ComboBox.disabledForeground = ${main.lower.text.fade(0.625).out()}
ComboBox.editableBackground = ${main.lower.text.fade(0.1).out()}
ComboBox.focusedBackground = ${main.lower.text.fade(0.2).out()}
ComboBox.foreground = ${main.lower.text.out()}
ComboBox.popupBackground = ${main.upper.like.out()}
ComboBox.selectionBackground = ${main[accent].area.out()}
ComboBox.selectionForeground = ${main[accent].text.out()} ${dev(`
Component.accentColor = #00f`)}
Component.borderColor = ${main.lower.text.fade(0.25).out()} ${dev(`
Component.custom.borderColor = #f00`)}
Component.disabledBorderColor = ${main.lower.text.fade(0.25).out()} ${dev(`
Component.error.borderColor = #0f0
Component.error.focusedBorderColor = #f0f`)}
Component.focusColor = ${main[accent].area.lower(0.15)}
Component.focusedBorderColor = ${main[accent].area.lower(0.15)} ${dev(`
Component.linkColor = #f00
Component.warning.borderColor = #0ff
Component.warning.focusedBorderColor = #0f0`)}
Desktop.background = ${main.lower.area.out()} ${dev(`
DesktopIcon.background = #f00
DesktopIcon.foreground = #0ff`)}
EditorPane.background = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
EditorPane.caretForeground = ${main.lower.text.out()}
EditorPane.disabledBackground = ${main.lower.like.out()}
EditorPane.focusedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
EditorPane.foreground = ${main.lower.text.out()}
EditorPane.inactiveBackground = ${main.lower.like.out()}
EditorPane.inactiveForeground = ${main.lower.text.fade(0.625).out()}
EditorPane.selectionBackground = ${main.lower.text.fade(0.625).out()}
EditorPane.selectionForeground = ${main.lower.area.out()}
FormattedTextField.background = ${main.lower.text.fade(0.1).out()}
FormattedTextField.caretForeground = ${main.lower.text.out()} ${dev(`
FormattedTextField.disabledBackground = #0000`)}
FormattedTextField.focusedBackground = ${main.lower.text.fade(0.2).out()}
FormattedTextField.foreground = ${main.lower.text.out()}
FormattedTextField.inactiveBackground = ${main.lower.like.out()}
FormattedTextField.inactiveForeground = ${main.lower.text.fade(0.625).out()}
FormattedTextField.placeholderForeground = ${main.lower.text.fade(0.625).out()}
FormattedTextField.selectionBackground = ${main.lower.text.fade(0.625).out()}
FormattedTextField.selectionForeground = ${main.lower.area.out()}
HelpButton.background = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
HelpButton.borderColor = ${main.lower.text.fade(0.4).out()}
HelpButton.disabledBackground = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
HelpButton.disabledBorderColor = ${main.lower.text.fade(0.3).out()}
HelpButton.disabledQuestionMarkColor = ${main.lower.text.fade(0.625).out()}
HelpButton.focusedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
HelpButton.focusedBorderColor = ${main[accent].area.lower(0.15)}
HelpButton.hoverBackground = ${lab::mix(main.lower.like, main.lower.text, 0.3).out()}
HelpButton.hoverBorderColor = ${main.lower.text.fade(0.5).out()}
HelpButton.pressedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.4).out()}
HelpButton.questionMarkColor = ${main.lower.text.out()}
Hyperlink.disabledText = ${main[link].like.fade(0.625).out() /* TODO test */}
Hyperlink.linkColor = ${main[link].like.out()}
Hyperlink.visitedColor = ${main[visited].like.out()}
InternalFrame.activeBorderColor = ${main.lower.like.raise(0.1)}
InternalFrame.activeDropShadowColor = ${main.lower.like.shadow(1).out()}
InternalFrame.activeTitleBackground = ${main.upper.like.out()}
InternalFrame.activeTitleForeground = ${main.lower.text.out()} ${dev(`
InternalFrame.borderColor = #f00`)}
InternalFrame.buttonHoverBackground = ${main.lower.text.fade(0.2).out()}
InternalFrame.buttonPressedBackground = ${main.lower.text.fade(0.3).out()}
InternalFrame.closeHoverBackground = ${main.red.area.out()}
InternalFrame.closeHoverForeground = ${main.red.text.out()}
InternalFrame.closePressedBackground = ${main.red.area.raise(0.1)}
InternalFrame.closePressedForeground = ${main.red.text.out()}
InternalFrame.inactiveBorderColor = ${main.lower.like.raise(0.1)}
InternalFrame.inactiveDropShadowColor = ${main.lower.like.shadow(1).out()}
InternalFrame.inactiveTitleBackground = ${main.lower.like.out()}
InternalFrame.inactiveTitleForeground = ${main.lower.text.out()} ${dev(`
Label.background = #f00`)}
Label.disabledForeground = ${main.lower.text.fade(0.625).out()}
Label.foreground = ${main.lower.text.out()}
List.background = ${main.lower.area.out()}
List.cellFocusColor = ${main[accent].area.out()} ${dev(`
List.dropCellBackground = #0f0
List.dropCellForeground = #f0f
List.dropLineColor = #f00`)}
List.foreground = ${main.lower.text.out()}
List.selectionBackground = ${main[accent].area.fade(0.3).out()}
List.selectionForeground = ${main.lower.text.out()}
List.selectionInactiveBackground = ${main.lower.text.fade(0.2).out()}
List.selectionInactiveForeground = ${main.lower.text.out()}
Menu.acceleratorForeground = ${main.upper.text.out() /* TODO test */}
Menu.acceleratorSelectionForeground = ${main[accent].text.out() /* TODO test */} ${dev(`
Menu.background = #f00`)}
Menu.disabledForeground = ${main.upper.text.fade(0.625).out()}
Menu.foreground = ${main.upper.text.out()}
Menu.icon.arrowColor = ${main.upper.text.out()}
Menu.icon.disabledArrowColor = ${main.upper.text.fade(0.625).out()}
Menu.selectionBackground = ${main.upper.text.fade(0.2).out()}
Menu.selectionForeground = ${main.upper.text.out()}
MenuBar.background = ${main.upper.like.out()}
MenuBar.borderColor = ${main.lower.like.shadow(1).out()}
MenuBar.foreground = ${main.lower.text.out()}
MenuBar.hoverBackground = ${main.lower.text.fade(0.2).out()}
MenuBar.selectionBackground = ${main[accent].area.out()}
MenuBar.selectionForeground = ${main[accent].text.out()} ${dev(`
MenuBar.underlineSelectionBackground = #f00
MenuBar.underlineSelectionColor = #0ff`)}
MenuItem.acceleratorForeground = ${main.upper.text.fade(0.625).out()}
MenuItem.acceleratorSelectionForeground = ${main.upper.text.fade(0.625).out()} ${dev(`
MenuItem.background = #00f
MenuItem.checkBackground = #ff0`)}
MenuItem.disabledForeground = ${main.upper.text.fade(0.625).out()}
MenuItem.foreground = ${main.upper.text.out()}
MenuItem.selectionBackground = ${main.upper.text.fade(0.2).out()}
MenuItem.selectionForeground = ${main.upper.text.out()} ${dev(`
MenuItem.underlineSelectionBackground = #00f
MenuItem.underlineSelectionCheckBackground = #ff0
MenuItem.underlineSelectionColor = #f00
OptionPane.background = #f0f
OptionPane.foreground = #0f0
OptionPane.icon.errorColor = #ff0
OptionPane.foreground = #0ff
OptionPane.icon.informationColor = #f0f
OptionPane.icon.questionColor = #0f0
OptionPane.icon.warningColor = #ff0
OptionPane.messageForeground = #0ff`)}
Panel.background = ${main.lower.like.out()}
Panel.foreground = ${main.lower.text.out() /* TODO test */}
PasswordField.background = ${main.lower.text.fade(0.1).out()} ${dev(`
PasswordField.capsLockIconColor = #ff0`)}
PasswordField.caretForeground = ${main.lower.text.out()} ${dev(`
PasswordField.disabledBackground = #0000`)}
PasswordField.focusedBackground = ${main.lower.text.fade(0.2).out()}
PasswordField.foreground = ${main.lower.text.out()}
PasswordField.inactiveBackground = ${main.lower.like.out()}
PasswordField.inactiveForeground = ${main.lower.text.fade(0.625).out()}
PasswordField.placeholderForeground = ${main.lower.text.fade(0.625).out()} ${dev(`
PasswordField.revealIconColor = #0f0`)}
PasswordField.selectionBackground = ${main.lower.text.fade(0.625).out()}
PasswordField.selectionForeground = ${main.lower.area.out()} ${dev(`
Popup.dropShadowColor = #f00`)}
PopupMenu.background = ${main.upper.area.out()}
PopupMenu.borderColor = ${main.lower.like.shadow(1).out()}
PopupMenu.foreground = ${main.upper.text.out()} ${dev(`
PopupMenu.hoverScrollArrowBackground = #ff0
PopupMenu.scrollArrowColor = #0ff`)}
ProgressBar.background = ${main.lower.text.fade(0.3).out()}
ProgressBar.foreground = ${main[accent].area.out()}
ProgressBar.selectionBackground = ${main.lower.text.out()}
ProgressBar.selectionForeground = ${main[accent].text.out()} ${dev(`
RadioButton.background = #f00`)}
RadioButton.disabledText = ${main.lower.text.fade(0.625).out()}
RadioButton.foreground = ${main.lower.text.out()}
RadioButtonMenuItem.acceleratorForeground = ${main.upper.text.fade(0.625).out()}
RadioButtonMenuItem.acceleratorSelectionForeground = ${main.upper.text.fade(0.625).out()} ${dev(`
RadioButtonMenuItem.background = #f00`)}
RadioButtonMenuItem.disabledForeground = ${main.upper.text.fade(0.625).out()}
RadioButtonMenuItem.foreground = ${main.upper.text.out()}
RadioButtonMenuItem.selectionBackground = ${main.upper.text.fade(0.2).out()}
RadioButtonMenuItem.selectionForeground = ${main.upper.text.out()}
RootPane.activeBorderColor = ${lab::mix(main.lower.like, main.blue.area, 0.625).out()} ${dev(`
RootPane.background = #00f
RootPane.foreground = #ff0`)}
RootPane.inactiveBorderColor = ${lab::mix(main.lower.like, main.lower.text, 0.25).out()}
ScrollBar.background = ${main.lower.like.lower(0.04)}
ScrollBar.buttonArrowColor = ${main.lower.text.out()}
ScrollBar.buttonDisabledArrowColor = ${main.lower.text.fade(0.625).out()} ${dev(`
ScrollBar.foreground = #0f0`)}
ScrollBar.hoverButtonBackground = ${main.lower.text.fade(0.2).out()}
ScrollBar.hoverThumbColor = ${main.lower.text.fade(0.5).out()}
ScrollBar.hoverTrackColor = ${main.lower.like.lower(0.05)}
ScrollBar.pressedButtonBackground = ${main.lower.text.fade(0.3).out()}
ScrollBar.pressedThumbColor = ${main.lower.text.fade(0.6).out()}
ScrollBar.pressedTrackColor = ${main.lower.like.lower(0.06)} ${dev(`
ScrollPane.background = #f0f
ScrollPane.foreground = #0f0`)}
SearchField.clearIconColor = ${main.lower.text.out()}
SearchField.clearIconHoverColor = ${main.lower.text.fade(0.75).out()}
SearchField.clearIconPressedColor = ${main.lower.text.out()} ${dev(`
SearchField.searchIconColor = #f00
SearchField.searchIconHoverColor = #f0f
SearchField.searchIconPressedColor = #00f
Separator.background = #f00`)}
Separator.foreground = ${main.lower.text.fade(0.25).out()} ${dev(`
Slider.background = #f00`)}
Slider.disabledThumbBorderColor = ${main.lower.like.shadow(1).out()}
Slider.disabledThumbColor = ${lab::mix(main.lower.like, main.lower.text, 0.375).out()}
Slider.disabledTrackColor = ${main.lower.text.fade(0.2).out()}
Slider.focusedColor = ${main.lower.text.fade(0.25).out()}
Slider.focusedThumbBorderColor = ${main.lower.like.shadow(1).out()} ${dev(`
Slider.foreground = #f00`)}
Slider.hoverThumbColor = ${main.lower.text.out()} ${dev(`
Slider.hoverTrackColor = #0f0`)}
Slider.pressedThumbColor = ${main[accent].area.out()} ${dev(`
Slider.pressedTrackColor = #00f`)}
Slider.thumbBorderColor = ${main.lower.like.shadow(1).out()}
Slider.thumbColor = ${lab::mix(main.lower.like, main.lower.text, 0.75).out()}
Slider.tickColor = ${main.lower.text.fade(0.625).out()}
Slider.trackColor = ${main.lower.text.fade(0.4).out()}
Slider.trackValueColor = ${main[accent].area.out()}
Spinner.background = ${main.lower.text.fade(0.1).out()}
Spinner.buttonArrowColor = ${main.lower.text.out()}
Spinner.buttonBackground = ${main.lower.text.fade(0.15).out()}
Spinner.buttonDisabledArrowColor = ${main.lower.text.fade(0.625).out()}
Spinner.buttonDisabledSeparatorColor = ${main.lower.text.fade(0.125).out()}
Spinner.buttonHoverArrowColor = ${main.lower.text.raise(0.1)}
Spinner.buttonPressedArrowColor = ${main.lower.text.lower(0.1)}
Spinner.buttonSeparatorColor = ${main.lower.text.fade(0.25).out()}
Spinner.disabledBackground = ${main.lower.area.fade(0.5).out()}
Spinner.disabledForeground = ${main.lower.text.fade(0.625).out()}
Spinner.focusedBackground = ${main.lower.text.fade(0.2).out()}
Spinner.foreground = ${main.lower.text.out()}
SplitPane.background = ${main.lower.like.out()}
TabbedPane.background = ${main.lower.like.out()}
TabbedPane.buttonHoverBackground = ${main.lower.text.fade(0.2).out()}
TabbedPane.buttonPressedBackground = ${main.lower.text.fade(0.3).out()} ${dev(`
TabbedPane.closeBackground = #f0f
TabbedPane.closeForeground = #00f
TabbedPane.closeHoverBackground = #ff0
TabbedPane.closeHoverForeground = #f00
TabbedPane.closePressedBackground = #0ff
TabbedPane.closePressedForeground = #0f0`)}
TabbedPane.contentAreaColor = ${main.lower.area.shadow(1).out()}
TabbedPane.disabledForeground = ${main.lower.text.fade(0.625).out()}
TabbedPane.disabledUnderlineColor = ${main.lower.text.fade(0.375).out()}
TabbedPane.focusColor = ${main[accent].like.fade(0.2).out()}
TabbedPane.focusForeground = ${main.lower.text.out()}
TabbedPane.foreground = ${main.lower.text.out()}
TabbedPane.hoverColor = ${main.lower.text.fade(0.25).out()}
TabbedPane.hoverForeground = ${main.lower.text.out()}
TabbedPane.inactiveUnderlineColor = ${main[accent].area.fade(0.75).out()}
TabbedPane.selectedBackground = ${main.lower.text.fade(0.15).out()}
TabbedPane.selectedForeground = ${main[accent].like.out()} ${dev(`
TabbedPane.tabSeparatorColor = #0f0`)}
TabbedPane.underlineColor = ${main[accent].area.out()}
Table.alternateRowColor = ${main.lower.like.out()}
Table.background = ${main.lower.area.out()}
Table.cellFocusColor = ${main[accent].area.out()} ${dev(`
Table.dropCellBackground = #f0f
Table.dropCellForeground = #00f
Table.dropLineColor = #ff0
Table.dropLineShortColor = #f00`)}
Table.focusCellBackground = ${main.lower.text.fade(0.1).out()}
Table.focusCellForeground = ${main.lower.text.out()}
Table.foreground = ${main.lower.text.out()} ${dev(`
Table.gridColor = #00f`)}
Table.selectionBackground = ${main[accent].area.fade(0.3).out()}
Table.selectionForeground = ${main.lower.text.out()}
Table.selectionInactiveBackground = ${main.lower.text.fade(0.2).out()}
Table.selectionInactiveForeground = ${main.lower.text.out()}
Table.sortIconColor = ${main.lower.text.out()}
TableHeader.background = ${main.upper.like.out()}
TableHeader.bottomSeparatorColor = ${main.lower.area.shadow(1).out()} ${dev(`
TableHeader.focusCellBackground = #0f0`)}
TableHeader.foreground = ${main.lower.text.out()}
TableHeader.hoverBackground = ${main.upper.like.raise(0.03)}
TableHeader.hoverForeground = ${main.lower.text.out()}
TableHeader.pressedBackground = ${main.upper.like.raise(0.06)}
TableHeader.pressedForeground = ${main.lower.text.out()}
TableHeader.separatorColor = ${main.lower.area.shadow(1).out()} ${dev(`
TaskPane.background = #f00
TaskPane.borderColor = #0ff
TaskPane.specialTitleBackground = #0f0
TaskPane.specialTitleForeground = #f0f
TaskPane.titleForeground = #00f`)}
TextArea.background = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
TextArea.caretForeground = ${main.lower.text.out()}
TextArea.disabledBackground = ${main.lower.like.out()}
TextArea.focusedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
TextArea.foreground = ${main.lower.text.out()}
TextArea.inactiveBackground = ${main.lower.like.out()}
TextArea.inactiveForeground = ${main.lower.text.fade(0.625).out()}
TextArea.selectionBackground = ${main.lower.text.fade(0.625).out()}
TextArea.selectionForeground = ${main.lower.area.out()}
TextField.background = ${lab::mix(main.lower.like, main.lower.text, 0.1).out()}
TextField.caretForeground = ${main.lower.text.out()}
TextField.disabledBackground = ${main.lower.like.out()}
TextField.focusedBackground = ${lab::mix(main.lower.like, main.lower.text, 0.2).out()}
TextField.foreground = ${main.lower.text.out()}
TextField.inactiveBackground = ${main.lower.like.out()}
TextField.inactiveForeground = ${main.lower.text.fade(0.625).out()}
TextField.placeholderForeground = ${main.lower.text.fade(0.625).out()}
TextField.selectionBackground = ${main.lower.text.fade(0.625).out()}
TextField.selectionForeground = ${main.lower.area.out()}
TitledBorder.titleColor = #f00
TitlePane.background = ${main.upper.like.out()}
TitlePane.borderColor = ${main.lower.like.shadow(1).out()}
TitlePane.buttonHoverBackground = ${main.lower.text.fade(0.1).out()}
TitlePane.buttonPressedBackground = ${main.lower.text.fade(0.2).out()}
TitlePane.closeHoverBackground = ${main.red.area.out()}
TitlePane.closeHoverForeground = ${main.red.text.out()}
TitlePane.closePressedBackground = ${main.red.area.raise(0.1)}
TitlePane.closePressedForeground = ${main.red.text.out()}
TitlePane.embeddedForeground = ${main.lower.text.out()}
TitlePane.foreground = ${main.lower.text.out()}
TitlePane.inactiveBackground = ${main.lower.like.out()}
TitlePane.inactiveForeground = ${main.lower.text.out()} ${dev(`
TitlePane.small.background = #0ff
TitlePane.small.buttonHoverBackground = #0f0
TitlePane.small.buttonPressedBackground = #f0f
TitlePane.small.closeHoverBackground = #00f
TitlePane.small.closeHoverForeground = #ff0
TitlePane.small.closePressedBackground = #f00
TitlePane.small.closePressedForeground = #0ff
TitlePane.small.embeddedForeground = #0f0
TitlePane.small.foreground = #f0f
TitlePane.small.inactiveBackground = #00f
TitlePane.small.inactiveForeground = #ff0`)}
TitlePane.unifiedBackground = #f00
ToggleButton.background = ${main.lower.text.fade(0.2).out()}
ToggleButton.disabledBackground = ${main.lower.text.fade(0.1).out()}
ToggleButton.disabledSelectedBackground = ${main[accent].area.fade(0.2).out() /* TODO test*/}
ToggleButton.disabledSelectedForeground = ${main.lower.text.fade(0.625).out()}
ToggleButton.focusedBackground = ${main.lower.text.fade(0.2).out()}
ToggleButton.focusedForeground = ${main.lower.text.out()}
ToggleButton.foreground = ${main.lower.text.out()}
ToggleButton.hoverBackground = ${main.lower.text.fade(0.3).out()}
ToggleButton.hoverForeground = ${main.lower.text.out()}
ToggleButton.pressedBackground = ${main.lower.text.fade(0.4).out()}
ToggleButton.pressedForeground = ${main.lower.text.out()}
ToggleButton.selectedBackground = ${main.lower.text.fade(0.75).out()}
ToggleButton.selectedForeground = ${main.lower.area.out()}
ToggleButton.tab.disabledUnderlineColor = ${main[accent].area.fade(0.5).out()}
ToggleButton.tab.focusBackground = ${main[accent].area.fade(0.3).out()}
ToggleButton.tab.focusForeground = ${main.lower.text.out()}
ToggleButton.tab.hoverBackground = ${main.lower.text.fade(0.3).out()}
ToggleButton.tab.hoverForeground = ${main[accent].like.out()}
ToggleButton.tab.selectedBackground = ${main.lower.text.fade(0.2).out()}
ToggleButton.tab.selectedForeground = ${main[accent].like.out()}
ToggleButton.tab.underlineColor = ${main[accent].area.out()}
ToggleButton.toolbar.disabledSelectedBackground = ${main.lower.text.fade(0.1).out()}
ToggleButton.toolbar.disabledSelectedForeground = ${main.lower.text.fade(0.625).out()}
ToggleButton.toolbar.hoverBackground = ${main.lower.text.fade(0.3).out()}
ToggleButton.toolbar.hoverForeground = ${main.lower.text.out()}
ToggleButton.toolbar.pressedBackground = ${main.lower.text.fade(0.4).out()}
ToggleButton.toolbar.pressedForeground = ${main.lower.text.out()}
ToggleButton.toolbar.selectedBackground = ${main.lower.text.fade(0.2).out()}
ToggleButton.toolbar.selectedForeground = ${main.lower.text.out()}
ToolBar.background = ${main.lower.like.out()} ${dev(`
ToolBar.dockingBackground = #0ff
ToolBar.dockingForeground = #0f0
ToolBar.floatingBackground = #f0f
ToolBar.floatingForeground = #00f
ToolBar.foreground = #ff0
ToolBar.gripColor = #f00`)}
ToolBar.hoverButtonGroupBackground = ${main[accent].area.fade(0.2).out()}
ToolBar.separatorColor = ${main.lower.text.fade(0.5).out()}
ToolTip.background = ${main.upper.area.out()}
ToolTip.foreground = ${main.upper.text.out()}
Tree.background = ${main.lower.area.out()} ${dev(`
Tree.closedIcon = #f00
Tree.dropCellBackground = #0ff
Tree.dropCellForeground = #0f0
Tree.dropLineColor = #f0f
Tree.editorBorderSelectionColor = #00f
Tree.foreground = #ff0
Tree.icon.closedColor = #f00`)}
Tree.icon.collapsedColor = ${main.lower.text.out()}
Tree.icon.expandedColor = ${main[accent].like.out()} ${dev(`
Tree.icon.leafColor = #f0f
Tree.icon.openColor = #00f
# Tree.rendererFillBackground = #ff0`)}
Tree.selectionBackground = ${main[accent].area.fade(0.3).out()}
Tree.selectionBorderColor = ${main[accent].area.out()}
Tree.selectionForeground = ${main.lower.text.out()}
Tree.selectionInactiveBackground = ${main.lower.text.fade(0.2).out()}
Tree.selectionInactiveForeground = ${main.lower.text.out()}
Tree.textBackground = ${main.lower.like.out()}
Tree.textForeground = ${main.lower.text.out()}
${dev(`UIColorHighlighter.stripingBackground = #fff`)}
Viewport.background = ${main.lower.like.out()}
Viewport.foreground = ${main.lower.text.out()}`; // json

const JSON = `{
	"colorforconfigheadertextcolor": ${main.lower.text.json()},
	"colorforconfigpaneldescriptiontext": ${main.lower.text.json()},
	"colorforerrorforeground": ${main.red.like.json()},
	${dev(`"colorforlinkgrabberdupehighlighter": "#ffff0000",`)}
	"colorforpanelbackground": ${main.lower.like.json()},
	"colorforpanelborders": ${main.lower.area.shadow(1).json()},
	"colorforpanelheaderbackground": ${main[accent].area.fade(0.25).json()}, ${dev(`
	"colorforpanelheaderforeground": "#ff00ffff",
	"colorforprogressbarforeground1": "#ffffff00",
	"colorforprogressbarforeground2": "#ffffffff",
	"colorforprogressbarforeground3": "#ff00ff00",
	"colorforprogressbarforeground4": "#ff000000",
	"colorforprogressbarforeground5": "#ff0000ff",
	"colorforscrollbarsmouseoverstate": "#ffff0000",
	"colorforscrollbarsnormalstate": "#ff007f00",`)}
	"colorforspeedmeteraverage": ${main.magenta.area.fade(0.5).json()},
	"colorforspeedmeteraveragetext": ${main.magenta.like.json()},
	"colorforspeedmetercurrentbottom": ${main.lower.area.shadow(1).json()},
	"colorforspeedmetercurrenttop": ${main.green.area.fade(0.5).json()},
	"colorforspeedmeterlimiterbottom": ${main.lower.area.shadow(1).json()},
	"colorforspeedmeterlimitertop": ${main.red.area.json()},
	"colorforspeedmetertext": ${main.lower.text.json()},
	"colorfortableaccounterrorrowbackground": ${main.red.area.fade(0.25).json()},
	"colorfortableaccounterrorrowforeground": ${main.lower.text.json()},
	"colorfortableaccounttemperrorrowbackground": ${main.yellow.area.fade(0.25).json()},
	"colorfortableaccounttemperrorrowforeground": ${main.lower.text.json()},
	"colorfortablealternaterowbackground": ${main.lower.area.json()},
	"colorfortablealternaterowforeground": ${main.lower.text.json()},
	"colorfortablefilteredview": ${main.green.area.json()},
	"colorfortablemouseoverrowbackground": ${lab::mix(main.lower.like, main.lower.text, 0.1).json()},
	"colorfortablemouseoverrowforeground": ${main.lower.text.json()},
	"colorfortablepackagerowbackground": ${main.lower.like.json()},
	"colorfortablepackagerowforeground": ${main.lower.text.json()},
	"colorfortablerowgap": ${main.lower.area.shadow(1).json()},
	"colorfortableselectedrowsbackground": ${lab::mix(main.lower.area, main[accent].area, 0.25).json()},
	"colorfortableselectedrowsforeground": ${main.lower.text.json()},
	"colorfortablesortedcolumnview": ${main.magenta.area.json()},
	"colorfortooltipforeground": ${main.lower.text.fade(0.625).json()},
	"configlabeldisabledtextcolor": ${main.lower.text.fade(0.625).json()},
	"configlabelenabledtextcolor": ${main.lower.text.json()},
	"speedmeterantialiasingenabled": true,
	"tablealternaterowhighlightenabled": true,
	"textantialiasenabled": true,
	"windowdecorationenabled": true
}`;

#{
	properties: PROPERTIES, json: JSON, // xml
	
	auto_reconnect: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="m 10,4 v 1 h 9 v 7 h 1 V 5 4 Z m -6,7 v 6 h 1 v -6 z m 4,4 v 2 h 2 v 3 h 3 v -5 z"/>
		<path fill=${main.blue.like.svg()} d="m 4,4 v 6 h 2 v 7 a 3,3 0 0 0 3,3 h 1 V 19 H 9 A 2,2 0 0 1 7,17 V 10 H 9 V 4 Z M 5,5 H 8 V 9 H 5 Z M 6,6 V 8 H 7 V 6 Z"/>
		<path fill=${main.cyan.like.svg()} d="m 17,13 a 2,2 0 0 0 -2,2 v 2 h -1 v 3 h 6 v -3 h -1 v -2 a 2,2 0 0 0 -2,-2 z m 0,1 a 1,1 0 0 1 1,1 v 2 h -2 v -2 a 1,1 0 0 1 1,-1 z"/>
	</svg>`, // xml
	
	clipboard: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="m 4,4 v 14 h 4 v 2 H 18 V 11 L 14,7 H 13 L 10,4 Z M 5,5 H 9 V 7 H 8 V 17 H 5 Z m 4,3 h 4 v 4 h 4 v 7 H 9 Z"/>
	</svg>`, // xml
	
	extract: `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 16 16">
		<path fill=${main.green.like.svg()} d="M 2,2 V 14 H 14 V 2 Z M 3,3 H 7 V 4 H 8 V 3 h 5 V 13 H 3 Z M 8,4 V 5 H 9 V 4 Z M 8,5 H 7 V 6 H 8 Z M 8,6 V 7 H 9 V 6 Z M 8,7 H 7 V 8 H 8 Z M 8,8 V 9 H 9 V 8 Z M 8,9 H 7 v 1 1 H 8 9 V 10 H 8 Z"/>
	</svg>`, // xml
	
	false_: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.red.like.svg()} d="M 2.75,2 2,2.75 7.25,8 2,13.25 2.75,14 8,8.75 13.25,14 14,13.25 8.75,8 14,2.75 13.25,2 8,7.25 Z"/>
	</svg>`, // xml
	
	false_orange: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.yellow.like.svg()} d="M 2.75,2 2,2.75 7.25,8 2,13.25 2.75,14 8,8.75 13.25,14 14,13.25 8.75,8 14,2.75 13.25,2 8,7.25 Z"/>
	</svg>`, // xml
	
	go_bottom: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4.75,5 4,5.75 l 8,8 8,-8 L 19.25,5 12,12.25 Z m 0,5 -0.75,0.75 8,8 8,-8 L 19.25,10 12,17.25 Z M 4,19 v 1 h 16 v -1 z"/>
	</svg>`, // xml
	
	go_down: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4.75,8 4,8.75 l 8,8 8,-8 L 19.25,8 12,15.25 Z"/>
	</svg>`, // xml
	
	go_top: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4.75,19 4,18.25 l 8,-8 8,8 L 19.25,19 12,11.75 Z m 0,-5 -0.75,-0.75 8,-8 8,8 L 19.25,14 12,6.75 Z M 4,5 V 4 h 16 v 1 z"/>
	</svg>`, // xml
	
	go_up: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4.75,16 4,15.25 l 8,-8 8,8 L 19.25,16 12,8.75 Z"/>
	</svg>`, // xml
	
	media_playback_pause: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="m 4,4 v 16 h 6 V 4 Z m 10,0 v 16 h 6 V 4 Z"/>
	</svg>`, // xml
	
	media_playback_start: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4,4 20,12 4,20 Z"/>
	</svg>`, // xml
	
	media_playback_stop: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 4,4 V 20 H 20 V 4 Z"/>
	</svg>`, // xml
	
	package_closed: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.lower.text.svg()} d="M 2,2 V 14 H 14 V 4 H 9 L 7,2 Z M 3,3 H 6.6 L 7.5,4 H 7 L 5,6 H 3 Z m 0,4 h 10 v 6 H 3 Z"/>
	</svg>`, // xml
	
	package_open: `<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 16 16">
		<path fill=${main.lower.text.svg()} d="M 2,2 V 14 H 14 V 4 H 9 L 7,2 Z m 5,4 h 6 v 7 H 3 V 8 h 2 z"/>
	</svg>`, // xml
	
	popDownLarge: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11 6">
		<path fill=${main.lower.text.svg()} d="M 5.5,4.5 1,0 0.25,0.75 5.5,6 10.75,0.75 10,0 Z"/>
	</svg>`, // xml
	
	popUpLarge: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11 6">
		<path fill=${main.lower.text.svg()} d="M 5.5,1.5 1,6 0.25,5.25 5.5,0 10.75,5.25 10,6 Z"/>
	</svg>`, // xml
	
	premium: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.green.like.svg()} d="m 3,10 v 1 h 6 v 1 h 1 v 1 h 1 v 4 h -1 v 1 H 9 v 1 H 3 v 1 h 8 1 v -9 -1 z m 1,2 a 3,3 0 0 0 -1,0.2 v 1.1 A 2,2 0 0 1 4,13 2,2 0 0 1 6,15 2,2 0 0 1 4,17 2,2 0 0 1 3,16.7 v 1.1 A 3,3 0 0 0 4,18 3,3 0 0 0 7,15 3,3 0 0 0 4,12 Z"/>
		<path fill=${main.lower.text.svg()} d="m 16,4 a 3,3 0 0 0 -3,3 3,3 0 0 0 3,3 3,3 0 0 0 3,-3 3,3 0 0 0 -3,-3 z m 0,7 a 5,5 0 0 0 -2,0.4 l 0.5,0.9 A 4,4 0 0 1 16,12 a 4,4 0 0 1 4,4 h -6 v 1 h 7 v -1 a 5,5 0 0 0 -5,-5 z"/>
	</svg>`, // xml
	
	reconnect: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="m 10,4 v 1 h 9 V 15 H 8 v 2 h 2 v 3 h 4 2 v -1 h -2 v -2 h 5 1 V 5 4 Z m -6,7 v 6 h 1 v -6 z"/>
		<path fill=${main.blue.like.svg()} d="m 4,4 v 6 h 2 v 7 a 3,3 0 0 0 3,3 h 1 V 19 H 9 A 2,2 0 0 1 7,17 V 10 H 9 V 4 Z M 5,5 H 8 V 9 H 5 Z M 6,6 V 8 H 7 V 6 Z"/>
	</svg>`, // xml
	
	silentmode: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="M 11,3 A 1,1 0 0 0 10,4 1,1 0 0 0 10,4.2 4,4 0 0 0 7.8,5.6 L 8.5,6.3 A 3,3 0 0 1 11,5 a 3,3 0 0 1 3,3 7,8 0 0 0 2.4,6 h -0.2 l 1,1 h 0.4 0.4 v -1 0 0 A 6,7 0 0 1 15,8 4,4 0 0 0 12,4.1 1,1 0 0 0 12,4 1,1 0 0 0 11,3 Z M 6.9,9.2 A 6,7 0 0 1 4,14 v 0 0 1 h 7 1.8 l -1,-1 H 5.6 A 7,8 0 0 0 7.7,10 Z M 9.3,16 a 2,2 0 0 0 -0.3,1 2,2 0 0 0 2,2 2,2 0 0 0 2,-2 2,2 0 0 0 -0.3,-1 z"/>
		<path fill=${main.red.like.svg()} d="M 3,3.75 3.75,3 19,18.25 18.25,19 Z"/>
	</svg>`, // xml
	
	tree_minus: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.lower.text.svg()} d="M 2,5.75 2.75,5 8,10.25 13.25,5 14,5.75 l -6,6 z"/>
	</svg>`, // xml
	
	tree_plus: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.lower.text.svg()} d="M 5.75,14 5,13.25 10.25,8 5,2.75 5.75,2 l 6,6 z"/>
	</svg>`, // xml
	
	true_: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.green.like.svg()} d="M 2.75,8.25 5.75,11 13.25,3.5 14,4.25 5.75,12.5 2,9 Z"/>
	</svg>`, // xml
	
	true_orange: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16">
		<path fill=${main.yellow.like.svg()} d="M 2.75,8.25 5.75,11 13.25,3.5 14,4.25 5.75,12.5 2,9 Z"/>
	</svg>`, // xml
	
	update: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.svg()} d="m 12,4 a 8,8 0 0 0 -8,8 h 1 a 7,7 0 0 1 7,-7 7,7 0 0 1 7,7 7,7 0 0 1 -7,7 7,7 0 0 1 -6.3,-4 H 8 V 14 H 5.25 5 4.25 4 v 4 H 5 V 15.75 A 8,8 0 0 0 12,20 8,8 0 0 0 20,12 8,8 0 0 0 12,4 Z m 0,3 -4,4 h 2 v 5 h 4 v -5 h 2 z"/>
	</svg>`, // xml
	
	update_b: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
		<path fill=${main.lower.text.fade(0.75).svg()} d="m 12,4 a 8,8 0 0 0 -8,8 h 1 a 7,7 0 0 1 7,-7 7,7 0 0 1 7,7 7,7 0 0 1 -7,7 7,7 0 0 1 -6.3,-4 H 8 V 14 H 5.25 5 4.25 4 v 4 H 5 V 15.75 A 8,8 0 0 0 12,20 8,8 0 0 0 20,12 8,8 0 0 0 12,4 Z m 0,3 -4,4 h 2 v 5 h 4 v -5 h 2 z"/>
	</svg>`,
}
