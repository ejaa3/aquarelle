/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

// Schemes:

const     main = cfg::scheme("main");
const  calling = cfg::scheme("call");
const  dialogs = cfg::scheme("dialogs");
const incoming = cfg::scheme("incoming");
const outgoing = cfg::scheme("outgoing");
const  history = cfg::scheme("history");
const  sidebar = cfg::scheme("sidebar");
const    title = cfg::scheme("title");

// Sets:

const  in_select = cfg::option("incoming-selected");
const out_select = cfg::option("outgoing-selected");

const accent = cfg::option("accent");
const   good = if accent == "green" { "cyan" } else { "green" };
const    bad = if accent == "red" { "yellow" } else { "red" };
const   note = if accent == "yellow" { "any" } else { "yellow" };

// Numbers:

const    ACT = 0.1; // Common text fade for interactions.
const SELECT = 0.375;

// Shortcuts:

fn out() { '#' + this.to_hex_rgba(true) }
fn dim(set) { this[set].text.fade(this.dim).out() }
fn dark() { this.lower.text.luma() > this.lower.like.luma() }
fn shadow() { const L = this.luma(); 2 ** -L + 0.2 * L - 0.6 }

fn solar_bg() {
	if !this.dark() || this.lower.area.luma() < this.lower.like.luma()
		{ this.lower.like } else { this.upper.area };
} // HACK better solarized

const image = `
<svg xmlns='http://www.w3.org/2000/svg' width='1' height='1' viewBox='0 0 1 1'>
	<rect width='1' height='1' fill='${
		if history.dark() { history.lower.area.out() } else { history.upper.area.out() }
	}'/>
</svg>`;

const palette = `
activeButtonBg: ${main[accent].area.out()}; // default active button background
activeButtonBgOver: ${main[accent].text.fade(ACT).out()}; // default active button background with mouse over
activeButtonBgRipple: ${main[accent].text.fade(ACT).out()}; // default active button ripple effect
activeButtonFg: ${main[accent].text.out()}; // default active button text
activeButtonFgOver: activeButtonFg; // default active button text with mouse over
activeButtonSecondaryFg: ${main.dim(accent)}; // default active button additional text (selected messages counter in forward / delete buttons)
activeButtonSecondaryFgOver: activeButtonFg; // default active button additional text with mouse over

activeLineFg: ${main[accent].area.out()}; // default active line (like code input field bottom border when you log in and field is focused)
activeLineFgError: ${main[bad].area.out()}; // default active line for error state (like code input field bottom border when you log in and you've entered incorrect code)

attentionButtonBgOver: ${main.red.like.fade(ACT).out()}; // default attention button background with mouse over
attentionButtonBgRipple: ${main.red.like.fade(ACT).out()}; // default attention button ripple effect
attentionButtonFg: ${main.red.like.out()}; // default attention button text (like confirm button on log out)
attentionButtonFgOver: attentionButtonFg; // default attention button text with mouse over

botKbBg: #FF0000; // FIXME bot keyboard button background
botKbColor: #00FF00; // FIXME bot keyboard button text
botKbDownBg: #0000FF; // FIXME bot keyboard button ripple effect

boxBg: ${main.lower.like.out()}; // box background
boxSearchBg: ${main.lower.like.out()}; // box search field background (like in contacts box)
boxTextFg: ${main.lower.text.out()}; // box text
boxTextFgError: ${main.red.like.out()}; // rejecting box text (like when choosing username that is occupied)
boxTextFgGood: ${main.green.like.out()}; // accepted box text (like when choosing username that is not occupied)
boxTitleAdditionalFg: ${main.dim("lower")}; // box title additional text (like in create group box when you see chosen members count)
boxTitleCloseFg: boxTextFg; // settings close icon and box search cancel icon (like in contacts box)
boxTitleCloseFgOver: ${main[accent].like.out()}; // settings close icon and box search cancel icon (like in contacts box) with mouse over
boxTitleFg: boxTextFg; // box title text

callAnswerBg: ${calling[good].area.out()}; // phone call popup answer button background
callAnswerBgOuter: ${calling[good].area.fade(SELECT).out()}; // phone call popup answer button outer ripple effect
callAnswerRipple: ${calling[good].text.fade(1.5 * ACT).out()}; // phone call popup answer button ripple effect

callArrowFg: ${main[good].like.out()}; // received phone call arrow (in calls list box)
callArrowMissedFg: ${main[bad].like.out()}; // missed phone call arrow (in calls list box)

callBarBg: ${main[out_select].like.out()}; // active phone call bar background
callBarBgMuted: ${main[in_select].like.out()}; // phone call bar with muted mic background
callBarFg: ${main.lower.area.out()}; // phone call bar text and icons

callBarMuteRipple: #FF0000; // FIXME active phone call bar mute and hangup button ripple effect
callBarUnmuteRipple: #0000FF; // FIXME phone call bar with muted mic mute and hangup button ripple effect
callBg: #FFFF00; // FIXME phone call popup background
callCancelBg: ${calling.dim("lower")}; // phone call popup line busy cancel button background
callCancelFg: ${calling.lower.area.out()}; // phone call popup line busy cancel button icon
callCancelRipple: #FF00FF; // FIXME phone call popup line busy cancel button ripple effect
callFingerprintBg: #00FF00; // FIXME phone call popup emoji fingerprint background
callHangupBg: ${calling.red.area.out()}; // phone call popup hangup button background
callHangupRipple: ${calling.red.text.fade(1.5 * ACT).out()}; // phone call popup hangup button ripple effect
callIconFg: #00ff00; // FIXME phone call popup answer, hangup and mute mic icon
callMuteRipple: ${calling.dim("lower")}; // phone call popup mute mic ripple effect
callNameFg: ${calling.lower.text.out()}; // phone call popup name text
callStatusFg: ${calling.dim("lower")}; // phone call popup status text

cancelIconFg: #FF0000; // BUG default for settings close icon and box search cancel icon
cancelIconFgOver: #FFFF00; // BUG default for settings close icon and box search cancel icon with mouse over

changePhoneSimcardFrom: notificationSampleTextFg; // FIXME change phone number box left simcard icon
changePhoneSimcardTo: notificationSampleNameFg; // FIXME change phone number box right simcard and plane icons

checkboxFg: ${main.dim("lower")}; // default unchecked checkbox rounded rectangle (and also emoji category icons)

contactsBg: ${main.lower.area.out()}; // contacts (and some other) box row background
contactsBgOver: ${main.lower.text.fade(ACT).out()}; // contacts (and some other) box row background with mouse over
contactsNameFg: ${main.lower.text.out()}; // contacts (and some other) box row name text
contactsStatusFg: ${main.dim("lower")}; // contacts (and some other) box row additional text (like last seen stamp)
contactsStatusFgOnline: ${main[accent].like.out()}; // contacts (and some other) box row active additional text (like online status)
contactsStatusFgOver: ${main.lower.text.out()}; // contacts (and some other) box row additional text (like last seen stamp) with mouse over

dialogsArchiveFg: ${dialogs.dim("lower")}; // chat list archive name text
dialogsArchiveFgOver: ${dialogs.lower.text.out()}; // chat list archive name text with mouse over

dialogsBg: ${dialogs.solar_bg().out()}; // chat list background
dialogsBgActive: ${dialogs[accent].area.out()}; // chat list background for current (active) chat
dialogsBgOver: ${lab::mix(dialogs.solar_bg(), dialogs.lower.text, ACT).out()}; // chat list background with mouse over

dialogsChatIconFg: ${dialogs.lower.text.out()}; // chat list group or channel icon
dialogsChatIconFgActive: ${dialogs[accent].text.out()}; // chat list group or channel icon for current (active) chat
dialogsChatIconFgOver: ${dialogs.lower.text.out()}; // chat list group or channel icon with mouse over

dialogsDateFg: ${dialogs.dim("lower")}; // chat list date text
dialogsDateFgActive: ${dialogs[accent].text.out()}; // chat list date text for current (active) chat
dialogsDateFgOver: ${dialogs.lower.text.out()}; // chat list date text with mouse over

dialogsDraftFg: ${dialogs[note].like.out()}; // chat list draft label
dialogsDraftFgActive: ${dialogs[accent].text.out()}; // chat list draft label for current (active) chat
dialogsDraftFgOver: ${dialogs.lower.text.out()}; // chat list draft label with mouse over

dialogsForwardBg: #FF0000; // FIXME forwarding panel background (when forwarding messages in the smallest window size)
dialogsForwardFg: #FFFF00; // FIXME forwarding panel text (when forwarding messages in the smallest window size)

dialogsMenuIconFg: ${dialogs.lower.text.out()}; // main menu and lock telegram icon
dialogsMenuIconFgOver: ${dialogs[accent].like.out()}; // main menu and lock telegram icon with mouse over

dialogsNameFg: ${dialogs.lower.text.out()}; // chat list name text
dialogsNameFgActive: ${dialogs[accent].text.out()}; // chat list name text for current (active) chat
dialogsNameFgOver: ${dialogs.lower.text.out()}; // chat list name text with mouse over

dialogsOnlineBadgeFg: ${dialogs[accent].like.out()}; // chat list online status
dialogsOnlineBadgeFgActive: ${dialogs[accent].text.out()}; // chat list online status for current (active) chat

dialogsRippleBg: ${dialogs.lower.text.fade(ACT).out()}; // 
dialogsRippleBgActive: ${dialogs[accent].text.fade(2 * ACT).out()}; // 

dialogsScamFg: ${dialogs[bad].like.out()}; // chat list scam label
dialogsScamFgActive: ${dialogs[accent].text.out()}; // chat list scam label for current (active) chat
dialogsScamFgOver: ${dialogs.lower.text.out()}; // chat list scam label with mouse over

dialogsSendingIconFg: dialogsDraftFg; // chat list sending message icon (clock)
dialogsSendingIconFgActive: dialogsDraftFgActive; // chat list sending message icon (clock) for current (active) chat
dialogsSendingIconFgOver: dialogsDraftFgOver; // chat list sending message icon (clock) with mouse over

dialogsSentIconFg: ${dialogs[good].like.out()}; // chat list sent message tick / double tick icon
dialogsSentIconFgActive: ${dialogs[accent].text.out()}; // chat list sent message tick / double tick icon for current (active) chat
dialogsSentIconFgOver: ${dialogs.lower.text.out()}; // chat list sent message tick / double tick icon with mouse over

dialogsTextFg: ${dialogs.dim("lower")}; // chat list message text
dialogsTextFgActive: ${dialogs[accent].text.out()}; // chat list message text for current (active) chat
dialogsTextFgOver: ${dialogs.lower.text.out()}; // chat list message text with mouse over
dialogsTextFgService: ${dialogs[accent].like.out()}; // chat list group sender name text (or media message type text)
dialogsTextFgServiceActive: ${dialogs[accent].text.out()}; // chat list group sender name text for current (active) chat
dialogsTextFgServiceOver: ${dialogs.lower.text.out()}; // chat list group sender name text with mouse over

dialogsUnreadBg: ${dialogs[accent].area.out()}; // chat list unread badge background for not muted chat
dialogsUnreadBgActive: ${dialogs[accent].text.out()}; // chat list unread badge background for not muted chat for current (active) chat
dialogsUnreadBgMuted: ${dialogs.dim("lower")}; // chat list unread badge background for muted chat
dialogsUnreadBgMutedActive: ${dialogs.solar_bg().out()}; // chat list unread badge background for muted chat for current (active) chat
dialogsUnreadBgMutedOver: ${dialogs.lower.text.out()}; // chat list unread badge background for muted chat with mouse over
dialogsUnreadBgOver: ${dialogs[accent].like.out()}; // chat list unread badge background for not muted chat with mouse over
dialogsUnreadFg: ${dialogs[accent].text.out()}; // chat list unread badge text
dialogsUnreadFgActive: ${dialogs[accent].like.out()}; // chat list unread badge text for current (active) chat
dialogsUnreadFgOver: ${dialogs.solar_bg().out()}; // chat list unread badge text with mouse over

dialogsVerifiedIconBg: ${dialogs[good].like.out()}; // chat list verified icon background
dialogsVerifiedIconBgActive: ${dialogs[accent].text.out()}; // chat list verified icon background for current (active) chat
dialogsVerifiedIconBgOver: ${dialogs.lower.text.out()}; // chat list verified icon background with mouse over
dialogsVerifiedIconFg: dialogsBg; // chat list verified icon check
dialogsVerifiedIconFgActive: dialogsBgActive; // chat list verified icon check for current (active) chat
dialogsVerifiedIconFgOver: dialogsBgOver; // chat list verified icon check with mouse over

emojiIconFg: ${main.lower.text.out()}; // emoji category icon
emojiIconFgActive: #00FFFF; // BUG active emoji category icon
emojiPanBg: ${main.solar_bg().out()}; // emoji panel background
emojiPanCategories: ${main.upper.area.out()}; // emoji panel categories background
emojiPanHeaderBg: #FF00FF; // BUG emoji panel section header background
emojiPanHeaderFg: ${main.lower.text.out()}; // emoji panel section header text
emojiSubIconFgActive: ${main[accent].like.out()}; // active emoji subcategory icon

filterInputActiveBg: ${dialogs.lower.area.out()}; // default rounded input field active background (like in chats list search field when field is focused)
filterInputBorderFg: ${dialogs.dim("lower")}; // default rounded input field border (like in chats list search field when field is focused)
filterInputInactiveBg: dialogsBgOver; // default rounded input field background (like in chats list search field when field is inactive)

historyCallArrowInFg: ${incoming[good].like.out()}; // received phone call arrow
historyCallArrowInFgSelected: ${incoming[in_select].text.out()}; // received phone call arrow in a selected message
historyCallArrowMissedInFg: ${incoming[bad].like.out()}; // missed phone call arrow
historyCallArrowMissedInFgSelected: ${incoming[in_select].text.out()}; // missed phone call arrow in a selected message
historyCallArrowOutFg: ${outgoing[accent].like.out()}; // outgoing phone call arrow
historyCallArrowOutFgSelected: ${outgoing[out_select].text.out()}; // outgoing phone call arrow

historyComposeAreaBg: ${history.solar_bg().out()}; // history compose area background (message write area / reply information / forwarding information)
historyComposeAreaFg: ${history.lower.text.out()}; // history compose area text
historyComposeAreaFgService: ${history.dim("lower")}; // history compose area text when replying to a media message
historyComposeButtonBg: ${history.solar_bg().out()}; // unblock / join channel / mute channel button background
historyComposeButtonBgOver: ${lab::mix(history.solar_bg(), history.lower.text, ACT).out()}; // unblock / join channel / mute channel button background with mouse over
historyComposeButtonBgRipple: ${history.lower.text.fade(ACT).out()}; // unblock / join channel / mute channel button ripple effect
historyComposeIconFg: ${history.dim("lower")}; // history compose area icon (like emoji, attach, bot command..)
historyComposeIconFgOver: ${history.lower.text.out()}; // history compose area icon with mouse over

historyFileInIconFg: ${incoming[accent].text.out()}; // inbox file without thumbnail (like audio file) download arrow icon
historyFileInIconFgSelected: ${incoming[in_select].area.out()}; // inbox selected file without thumbnail (like audio file) download arrow icon
historyFileInRadialFg: historyFileInIconFg; // inbox file without thumbnail (like audio file) radial download animation line
historyFileInRadialFgSelected: historyFileInIconFgSelected; // inbox selected file without thumbnail (like audio file) radial download animation line

historyFileNameInFg: ${incoming.upper.text.out()}; // inbox media filename text
historyFileNameInFgSelected: ${incoming[in_select].text.out()}; // inbox media filename text in a selected message
historyFileNameOutFg: ${outgoing.upper.text.out()}; // outbox media filename text
historyFileNameOutFgSelected: ${outgoing[out_select].text.out()}; // outbox media filename text in a selected message

historyFileOutIconFg: ${outgoing[accent].text.out()}; // outbox file without thumbnail (like audio file) download arrow icon
historyFileOutIconFgSelected: ${outgoing[out_select].area.out()}; // outbox selected file without thumbnail (like audio file) download arrow icon
historyFileOutRadialFg: historyFileOutIconFg; // outbox file without thumbnail (like audio file) radial download animation line
historyFileOutRadialFgSelected: historyFileOutIconFgSelected; // outbox selected file without thumbnail (like audio file) radial download animation line

// NOTE above image
historyFileThumbIconFg: #FF0000; // FIXME file with thumbnail (or photo / video) download arrow icon
historyFileThumbIconFgSelected: #00FFFF; // FIXME selected file with thumbnail (or photo / video) download arrow icon
historyFileThumbRadialFg: #FFFF00; // FIXME file with thumbnail (or photo / video) radial download animation line
historyFileThumbRadialFgSelected: #0000FF; // FIXME selected file with thumbnail (or photo / video) radial download animation line

historyForwardChooseBg: #0000ff; // FIXME forwarding messages in a large window size "choose recipient" background [#0000004c]
historyForwardChooseFg: #ffff00; // FIXME forwarding messages in a large window size "choose recipient" text [windowFgActive]

historyIconFgInverted: #00ffff; // FIXME media message tick / double tick icon (like in sent photo)

historyLinkInFg: ${incoming.blue.like.out()}; // inbox message link
historyLinkInFgSelected: ${incoming[in_select].text.out()}; // inbox message link in a selected text or message
historyLinkOutFg: ${outgoing.blue.like.out()}; // outbox message link
historyLinkOutFgSelected: ${outgoing[out_select].text.out()}; // outbox message link in a selected text or message

historyOutIconFg: ${outgoing[accent].like.out()}; // outbox message tick / double tick icon
historyOutIconFgSelected: ${outgoing[out_select].text.out()}; // outbox message tick / double tick icon in a selected message

historyPeer1NameFg: ${incoming.red.like.out()}; // red group member name
historyPeer1NameFgSelected: ${incoming[in_select].text.out()}; // red group member name in a selected message
historyPeer1UserpicBg: ${incoming.red.area.out()}; // red userpic background
historyPeer2NameFg: ${incoming.green.like.out()}; // green group member name
historyPeer2NameFgSelected: ${incoming[in_select].text.out()}; // green group member name in a selected message
historyPeer2UserpicBg: ${incoming.green.area.out()}; // green userpic background
historyPeer3NameFg: #FF0000; // BUG yellow group member name
historyPeer3NameFgSelected: #7F7F7F; // BUG yellow group member name in a selected message
historyPeer3UserpicBg: #00FF00; // BUG yellow userpic background
historyPeer4NameFg: ${incoming.blue.like.out()}; // blue group member name
historyPeer4NameFgSelected: ${incoming[in_select].text.out()}; // blue group member name in a selected message
historyPeer4UserpicBg: ${incoming.blue.area.out()}; // blue userpic background
historyPeer5NameFg: ${incoming.any.like.out()}; // purple group member name
historyPeer5NameFgSelected: ${incoming[in_select].text.out()}; // purple group member name in a selected message
historyPeer5UserpicBg: ${incoming.any.area.out()}; // purple userpic background
historyPeer6NameFg: ${incoming.magenta.like.out()}; // pink group member name
historyPeer6NameFgSelected: ${incoming[in_select].text.out()}; // pink group member name in a selected message
historyPeer6UserpicBg: ${incoming.magenta.area.out()}; // pink userpic background
historyPeer7NameFg: ${incoming.cyan.like.out()}; // sea group member name
historyPeer7NameFgSelected: ${incoming[in_select].text.out()}; // sea group member name in a selected message
historyPeer7UserpicBg: ${incoming.cyan.area.out()}; // sea userpic background
historyPeer8NameFg: ${incoming.yellow.like.out()}; // orange group member name
historyPeer8NameFgSelected: ${incoming[in_select].text.out()}; // orange group member name in a selected message
historyPeer8UserpicBg: ${incoming.yellow.area.out()}; // orange userpic background
historyPeerUserpicFg: ${incoming.upper.like.out()}; // default userpic initials

historyPinnedBg: ${history.solar_bg().out()}; // pinned message area background
historyReplyBg: ${history.solar_bg().out()}; // reply / forward / edit message area background

historyReplyCancelFg: ${history.red.like.out()}; // reply / forward / edit message cancel button
historyReplyCancelFgOver: ${history.lower.text.out()}; // reply / forward / edit message cancel button with mouse over

historyReplyIconFg: ${history[accent].like.out()}; // reply / forward / edit message left icon

historyScrollBarBg: #8989897a; // FIXME scroll bar current rectangle, the bar itself in the chat view (adjusted)
historyScrollBarBgOver: #6b6b6bbc; // FIXME scroll bar current rectangle with mouse over it in the chat view (adjusted)
historyScrollBg: #5f5f5f4c; // FIXME scroll bar background (adjusted)
historyScrollBgOver: #6262626b; // FIXME scroll bar background with mouse over the scroll bar (adjusted)

historySendIconFg: ${history[accent].like.out()}; // send message icon
historySendIconFgOver: ${history.lower.text.out()}; // send message icon with mouse over

historySendingInIconFg: ${incoming[note].like.out()}; // inbox sending message icon (clock) (like in sent messages to yourself or in sent messages to a channel)
historySendingInvertedIconFg: #ffffffc8; // FIXME media sending message icon (clock) (like in sent photo)
historySendingOutIconFg: ${outgoing[note].like.out()}; // outbox sending message icon (clock)

historyTextInFg: ${incoming.upper.text.out()}; // inbox message text
historyTextInFgSelected: ${incoming[in_select].text.out()}; // inbox message selected text or text in a selected message
historyTextOutFg: ${outgoing.upper.text.out()}; // outbox message text
historyTextOutFgSelected: ${outgoing[out_select].text.out()}; // outbox message selected text or text in a selected message

historyToDownBg: ${history.upper.like.out()}; // arrow button background (to scroll to the end of the viewed chat)
historyToDownBgOver: ${history[accent].area.out()}; // arrow button background with mouse over
historyToDownBgRipple: ${history[accent].text.fade(1.5 * ACT).out()}; // arrow button ripple effect

historyToDownFg: ${history.upper.text.out()}; // arrow button icon
historyToDownFgOver: ${history[accent].text.out()}; // arrow button icon with mouse over
historyToDownShadow: ${0xFF.fade(history.upper.like.shadow()).out()}; // arrow button shadow

historyUnreadBarBg: ${history.solar_bg().out()}; // new unread messages bar background
historyUnreadBarBorder: ${0xFF.fade(history.solar_bg().shadow()).out()}; // new unread messages bar shadow
historyUnreadBarFg: ${history[accent].like.out()}; // new unread messages bar text

historyVideoMessageProgressFg: historyFileThumbIconFg; // FIXME radial playback progress in round video messages

imageBg: #000000; // FIXME image background fallback (when photo size is less than minimum allowed)
imageBgTransparent: #ffffff; // FIXME image background when displaying an image with opacity where no opacity is needed

importantTooltipBg: toastBg; // 
importantTooltipFg: toastFg; // 
importantTooltipFgLink: #65fce8; // 

inputBorderFg: ${main.lower.text.fade(main.border).out()}; // default input field bottom border (like in code input field when you log in and field is not focused)

// TODO intro
introBg: windowBg; // login background
introCoverBottomBg: #188173; // intro gradient bottom (to)
introCoverIconsFg: #34a495; // intro cloud graphics
introCoverPlaneInner: #ced9e2; // intro plane part
introCoverPlaneOuter: #97a9b5; // intro plane part
introCoverPlaneTop: #ffffff; // intro plane part
introCoverPlaneTrace: #329d8f; // intro plane traces
introCoverTopBg: #188173; // intro gradient top (from)
introDescriptionFg: #999999; // login description text
introErrorFg: #999999; // login error text (like when providing a wrong log in code)
introTitleFg: #eeeeee; // login title text

layerBg: #0000007f; // FIXME box and main menu background layer fade

lightButtonBg: #00000000; // default light button background (like buttons in boxes)
lightButtonBgOver: ${main[accent].like.fade(ACT).out()}; // default light button background with mouse over
lightButtonBgRipple: ${main[accent].like.fade(ACT).out()}; // default light button ripple effect
lightButtonFg: ${main[accent].like.out()}; // default light button text
lightButtonFgOver: ${main[accent].like.out()}; // default light button text with mouse over

mainMenuBg: ${main.lower.like.out()}; // main menu background

// FIXME mainMenu
mainMenuCloudBg: #0e837f; // 
mainMenuCloudFg: #FFFF00; // 
mainMenuCoverBg: #009687; // main menu top cover background
mainMenuCoverFg: #FF0000; // main menu top cover text

mediaInFg: ${incoming.dim("upper")}; // inbox media message status text (like in file that is being downloaded)
mediaInFgSelected: ${incoming[in_select].text.out()}; // inbox selected media message status text (like in file that is being downloaded)
mediaOutFg: ${outgoing.dim("upper")}; // outbox media message status text (like in file that is being downloaded)
mediaOutFgSelected: ${outgoing[out_select].text.out()}; // outbox selected media message status text (like in file that is being downloaded)

// FIXME mediaPlayer
mediaPlayerActiveFg: #00FF00; // audio file player playback progress already played part
mediaPlayerBg: #0000FF; // audio file player background
mediaPlayerDisabledFg: #9dd1ef; // audio file player loading progress (when you're playing an audio file and switch to the previous one which is not loaded yet)
mediaPlayerInactiveFg: #ff00ff; // audio file player playback progress upcoming (not played yet) part with mouse over

// FIXME mediaview
mediaviewBg: #222222eb; // Media Viewer background
mediaviewCaptionBg: #11111180; // caption text background (when viewing photo with caption)
mediaviewCaptionFg: mediaviewControlFg; // caption text
mediaviewControlBg: #0000003c; // controls background (like next photo / previous photo)
mediaviewControlFg: #00FF00; // controls icon (like next photo / previous photo)

mediaviewFileBg: windowBg; // file rectangle background (when you view a png file in Media Viewer and go to a previous, not loaded yet, file)
mediaviewFileBlueCornerFg: #599dcf; // blue file thumbnail placeholder corner in file rectangle (for a file without thumbnail, like .dmg)
mediaviewFileExtFg: activeButtonFg; // file extension text in file thumbnail placeholder in file rectangle
mediaviewFileGreenCornerFg: #49a957; // green file thumbnail placeholder corner in file rectangle (for a file without thumbnail, like .exe)
mediaviewFileNameFg: windowFg; // file name in file rectangle
mediaviewFileRedCornerFg: #d55959; // red file thumbnail placeholder corner in file rectangle (for a file without thumbnail, like .pdf)
mediaviewFileSizeFg: windowSubTextFg; // file size text in file rectangle
mediaviewFileYellowCornerFg: #e8a659; // yellow file thumbnail placeholder corner in file rectangle (for a file without thumbnail, like .zip)
mediaviewMenuBg: #383838; // context menu in Media Viewer background
mediaviewMenuBgOver: #505050; // context menu item background with mouse over
mediaviewMenuBgRipple: #676767; // context menu item ripple effect
mediaviewMenuFg: windowFgActive; // context menu item text
mediaviewPlaybackActive: #c7c7c7; // video playback progress already played part
mediaviewPlaybackActiveOver: #ffffff; // video playback progress already played part with mouse over
mediaviewPlaybackIconFg: mediaviewPlaybackActive; // video playback controls icon
mediaviewPlaybackIconFgOver: mediaviewPlaybackActiveOver; // video playback controls icon with mouse over
mediaviewPlaybackInactive: #252525; // video playback progress upcoming (not played yet) part
mediaviewPlaybackInactiveOver: #474747; // video playback progress upcoming (not played yet) part with mouse over
mediaviewPlaybackProgressFg: #ffffffc7; // video playback progress text
mediaviewSaveMsgBg: toastBg; // save to file toast message background in Media Viewer
mediaviewSaveMsgFg: toastFg; // save to file toast message text
mediaviewTextLinkFg: #66f7e4; // caption text link
mediaviewTransparentBg: #ffffff; // transparent filling part (when viewing a transparent .png file in Media Viewer)
mediaviewTransparentFg: #cccccc; // another transparent filling part
mediaviewVideoBg: imageBg; // Media Viewer background when viewing a video in full screen

membersAboutLimitFg: #5e6065; // FIXME text in channel members box about the limit (max 200 last members are shown)

menuBg: ${main.solar_bg().out()}; // default popup menu background
menuBgOver: ${main.lower.text.fade(ACT).out()}; // default popup menu item background with mouse over
menuBgRipple: ${main.lower.text.fade(ACT).out()}; // default popup menu item ripple effect
menuFgDisabled: ${main.dim("lower")}; // default popup menu item disabled text (like unavailable items in message field context menu)
menuIconFg: ${main.dim("lower")}; // default popup menu item icon (like main menu)
menuIconFgOver: ${main.lower.text.out()}; // default popup menu item icon with mouse over
menuSeparatorFg: ${main.lower.text.fade(main.border).out()}; // default popup menu separator (like in message field context menu)
menuSubmenuArrowFg: ${main.dim("lower")}; // default popup menu submenu arrow icon (like in message field context menu in case of RTL system language)

// FIXME
msgBotKbIconFg: msgServiceFg; // bot inline keyboard button icon in the top-right corner (like in @vote bot when a poll is ready to be shared)
msgBotKbOverBgAdd: #ffffff14; // this is painted over a bot inline keyboard button (which has msgServiceBg background) when mouse is over that button
msgBotKbRippleBg: #9e9d9d10; // bot inline keyboard button ripple effect
msgDateImgBg: #00000054; // media message time bubble background (like time bubble in a sent photo) or file with thumbnail download icon circle background
msgDateImgBgOver: #00000074; // media message download icon circle background with mouse over (like file with thumbnail download icon)
msgDateImgBgSelected: #1c706587; // selected media message time bubble background
msgDateImgFg: msgServiceFg; // media message time text (like time text in a sent photo)
msgFile1Bg: ${main.blue.area.out()}; // blue shared links / files without image square thumbnail
msgFile1BgDark: ${main.blue.text.fade(ACT).out()}; // blue shared files without image download circle background
msgFile1BgOver: ${main.blue.text.fade(ACT).out()}; // blue shared files without image download circle background with mouse over
msgFile1BgSelected: ${main.blue.like.out()}; // blue shared files without image download circle background if file is selected
msgFile2Bg: ${main.green.area.out()}; // green shared links / shared files without image square thumbnail
msgFile2BgDark: ${main.green.text.fade(ACT).out()}; // green shared files without image download circle background
msgFile2BgOver: ${main.green.text.fade(ACT).out()}; // green shared files without image download circle background with mouse over
msgFile2BgSelected: ${main.green.like.out()}; // green shared files without image download circle background if file is selected
msgFile3Bg: ${main.red.area.out()}; // red shared links / shared files without image square thumbnail
msgFile3BgDark: ${main.red.text.fade(ACT).out()}; // red shared files without image download circle background
msgFile3BgOver: ${main.red.text.fade(ACT).out()}; // red shared files without image download circle background with mouse over
msgFile3BgSelected: ${main.red.like.out()}; // red shared files without image download circle background if file is selected
msgFile4Bg: ${main.yellow.area.out()}; // yellow shared links / shared files without image square thumbnail
msgFile4BgDark: ${main.yellow.text.fade(ACT).out()}; // yellow shared files without image download circle background
msgFile4BgOver: ${main.yellow.text.fade(ACT).out()}; // yellow shared files without image download circle background with mouse over
msgFile4BgSelected: ${main.yellow.like.out()}; // yellow shared files without image download circle background if file is selected

msgFileInBg: ${incoming[accent].area.out()}; // inbox audio file download circle background
msgFileInBgOver: #FF00FF; // FIXME inbox audio file download circle background with mouse over
msgFileInBgSelected: ${incoming[in_select].text.out()}; // inbox selected audio file download circle background

msgFileOutBg: ${outgoing[accent].area.out()}; // outbox audio file download circle background
msgFileOutBgOver: #0000FF; // FIXME outbox audio file download circle background with mouse over
msgFileOutBgSelected: ${outgoing[out_select].text.out()}; // outbox selected audio file download circle background

msgFileThumbLinkInFg: ${incoming.blue.like.out()}; // inbox media file message with thumbnail download / open with button text
msgFileThumbLinkInFgSelected: ${incoming[in_select].text.out()}; // inbox selected media file message with thumbnail download / open with button text

msgFileThumbLinkOutFg: ${outgoing.blue.like.out()}; // outbox media file message with thumbnail download / open with button text
msgFileThumbLinkOutFgSelected: ${outgoing[out_select].text.out()}; // outbox selected media file message with thumbnail download / open with button text

msgImgReplyBarColor: msgServiceFg; // FIXME sticker message reply outline

msgInBg: ${incoming.upper.like.out()}; // inbox message background
msgInBgSelected: ${incoming[in_select].area.out()}; // inbox selected message background (and background of selected text in those messages)
msgInDateFg: ${incoming.dim("upper")}; // inbox message time text
msgInDateFgSelected: ${incoming[in_select].text.out()}; // inbox selected message time text
msgInMonoFg: ${incoming.yellow.like.out()}; // inbox message monospace text (like a message sent with 'test' text)
msgInMonoFgSelected: ${incoming[in_select].text.out()}; // inbox message monospace text in a selected text or message
msgInReplyBarColor: ${incoming[accent].area.out()}; // inbox message reply outline
msgInReplyBarSelColor: ${incoming[in_select].text.out()}; // inbox selected message reply outline
msgInServiceFg: ${incoming[accent].like.out()}; // inbox message information text (like information about a forwarded message original sender)
msgInServiceFgSelected: ${incoming[in_select].text.out()}; // inbox selected message information text (like information about a forwarded message original sender)

msgInShadow: ${lab::mix(incoming.lower.like, 0xFF, incoming.lower.like.shadow()).out()}; // inbox message shadow (below the bubble)
msgInShadowSelected: ${lab::mix(incoming[in_select].area, 0xFF, incoming[in_select].area.shadow()).out()}; // inbox selected message shadow (below the bubble)

msgOutBg: ${outgoing.upper.like.out()}; // outbox message background
msgOutBgSelected: ${outgoing[out_select].area.out()}; // outbox selected message background (and background of selected text in those messages)
msgOutDateFg: ${outgoing.dim("upper")}; // outbox message time text
msgOutDateFgSelected: ${outgoing[out_select].text.out()}; // outbox selected message time text
msgOutMonoFg: ${outgoing.yellow.like.out()}; // outbox message monospace text
msgOutMonoFgSelected: ${outgoing[out_select].text.out()}; // outbox message monospace text in a selected text or message
msgOutReplyBarColor: ${outgoing[accent].area.out()}; // outbox message reply outline
msgOutReplyBarSelColor: ${outgoing[out_select].text.out()}; // outbox selected message reply outline
msgOutServiceFg: ${outgoing[accent].like.out()}; // outbox message information text (like information about a forwarded message original sender)
msgOutServiceFgSelected: ${outgoing[out_select].text.out()}; // outbox message information text (like information about a forwarded message original sender)

msgOutShadow: ${lab::mix(outgoing.lower.like, 0xFF, outgoing.lower.like.shadow()).out()}; // outbox message shadow (below the bubble)
msgOutShadowSelected: ${lab::mix(outgoing[out_select].area, 0xFF, outgoing[out_select].area.shadow()).out()}; // outbox selected message shadow (below the bubble)

msgSelectOverlay: ${history[accent].area.fade(SELECT).out()}; // overlay which is filling the media parts of selected messages (like in selected photo message)

// FIXME msgService msgSticker
msgServiceBg: ${history.upper.area.out()}; // service message background (like in a service message about group title being changed) (adjusted)
msgServiceBgSelected: #009687; // service message selected text background (like in a service message about group title being changed) (adjusted)
msgServiceFg: ${history.upper.text.out()}; // service message text (like date dividers or service message about the group title being changed)
msgStickerOverlay: #35d4bf7f; // overlay which is filling the selected sticker message

msgWaveformInActive: ${incoming[accent].like.out()}; // inbox voice message active waveform lines (like played part of currently playing voice message)
msgWaveformInActiveSelected: ${incoming[in_select].text.out()}; // inbox selected voice message active waveform lines (like played part of currently playing voice message)
msgWaveformInInactive: ${incoming.upper.text.fade(SELECT).out()}; // inbox voice message inactive waveform lines (like upcoming part of currently playing voice message)
msgWaveformInInactiveSelected: ${incoming[in_select].text.fade(SELECT).out()}; // inbox selected voice message inactive waveform lines (like upcoming part of currently playing voice message)
msgWaveformOutActive: ${outgoing[accent].like.out()}; // outbox voice message active waveform lines (like played part of currently playing voice message)
msgWaveformOutActiveSelected: ${outgoing[out_select].text.out()}; // outbox selected voice message active waveform lines (like played part of currently playing voice message)
msgWaveformOutInactive: ${outgoing.upper.text.fade(SELECT).out()}; // outbox voice message inactive waveform lines (like upcoming part of currently playing voice message)
msgWaveformOutInactiveSelected: ${outgoing[out_select].text.fade(SELECT).out()}; // outbox selected voice message inactive waveform lines (like upcoming part of currently playing voice message)

// FIXME
notificationBg: #0000FF; // custom notification window background
notificationSampleCloseFg: #d7d7d7; // custom notifications settings box small sample close button placeholder
notificationSampleNameFg: #939393; // custom notifications settings box small sample name placeholder
notificationSampleTextFg: #d7d7d7; // custom notifications settings box small sample text placeholder
notificationSampleUserpicFg: #FF0000; // custom notifications settings box small sample userpic placeholder
notificationsBoxMonitorFg: #00FF00; // custom notifications settings box monitor color
notificationsBoxScreenBg: #0000FF; // #6389a8; // custom notifications settings box monitor screen background
outlineButtonBg: #FFFF00; // default left outlined button background (like shared media links in profiles)
outlineButtonBgOver: #313b43; // default left outlined button background with mouse over
outlineButtonBgRipple: #3c474f; // default left outlined button ripple effect
outlineButtonOutlineFg: #29baa7; // default left outlined button left outline border
overviewCheckBg: #00000040; // shared files / links checkbox background for not selected rows when some rows are selected
overviewCheckBorder: #e4eaef; // shared media round checkbox border
overviewCheckFg: #ffffff; // shared files / links checkbox icon for not selected rows when some rows are selected
overviewCheckFgActive: #ffffff; // shared files / links checkbox icon for selected rows
overviewPhotoSelectOverlay: #40ace333; // shared photos / videos / links fill for selected rows
photoCropFadeBg: #FFFF00; // avatar crop box fade background (when choosing a new photo in Settings or for a group)
photoCropPointFg: #ffffff7f; // avatar crop box corner rectangles (when choosing a new photo in Settings or for a group)
placeholderFg: #818991; // default input field placeholder when field is not focused (like in phone input field when you log in)
placeholderFgActive: #5d6165; // default input field placeholder when field is focused
profileAdminStartFg: #00FF00; // group members list admin star icon
profileStatusFgOver: #9c9c9c; // group members list in group profile user last seen text with mouse over
profileVerifiedCheckBg: #00FFFF; // profile verified check icon background
profileVerifiedCheckFg: #ffffff; // profile verified check icon tick
radialBg: #00000056; // default radial loader background (like in Media Viewer when loading a photo)
radialFg: #FF0000; // default radial loader line (like in Media Viewer when loading a photo)
reportSpamBg: #363c42; // report spam panel background (like a non contact user writes your for the first time)
reportSpamFg: #00FF00; // report spam panel text (when you send a report from that panel)
scrollBarBg: #ffffff53; // default scroll bar current rectangle, the bar itself (like in chats list)
scrollBarBgOver: #ffffff7a; // default scroll bar current rectangle with mouse over it
scrollBg: #ffffff1a; // default scroll bar background
scrollBgOver: #ffffff2c; // default scroll bar background with mouse over the scroll bar
searchedBarBg: #3a4047; // search results bar background (in chats list, contacts box..)
searchedBarFg: #a8a8a8; // search results bar text (in chats list, contacts box..)
shadowFg: ${lab::mix(main.solar_bg(), 0xFF, main.solar_bg().shadow()).out()}; // most shadows (including opacity)

sideBarBadgeBg: ${sidebar[accent].area.out()}; // filters side bar badge background
sideBarBadgeBgMuted: ${sidebar.dim("lower")}; // filters side bar unimportant badge background
sideBarBadgeFg: ${sidebar[accent].text.out()}; // filters side bar badge text
sideBarBg: ${sidebar.upper.area.out()}; // filters side bar background
sideBarBgActive: ${sidebar.lower.area.out()}; // filters side bar active background
sideBarBgRipple: ${sidebar.lower.text.fade(ACT).out()}; // filters side bar ripple effect
sideBarIconFg: ${sidebar.dim("lower")}; // filters side bar icon
sideBarIconFgActive: ${sidebar[accent].area.out()}; // filters side bar active item icon
sideBarTextFg: ${sidebar.lower.text.out()}; // filters side bar text
sideBarTextFgActive: ${sidebar[accent].like.out()}; // filters side bar active item text

slideFadeOutBg: #0000003F; // slide animation (chat to profile) fade out filling
slideFadeOutShadowFg: #000000; // slide animation (chat to profile) fade out right section shadow

sliderBgActive: ${main[accent].area.out()}; // default slider active bar (like in Settings when you choose interface scale or custom notifications count)
sliderBgInactive: ${main[accent].like.fade(main.dim).out()}; // default slider not active bar (like in Settings when you choose interface scale or custom notifications count)

// FIXME
smallCloseIconFg: #6d6d6d; // small X icon (like in Show all sessions box to the right for sessions termination)
smallCloseIconFgOver: #a3a3a3; // small X icon with mouse over
stickerPanDeleteBg: ${luv::lighten(main.red.area, 0.75).out()}; // delete X button background for custom sent stickers in stickers panel (legacy)
stickerPanDeleteFg: ${luv::darken(main.red.area, 0.75).out()}; // delete X button icon for custom sent stickers in stickers panel (legacy)
stickerPreviewBg: #000000b0; // sticker and GIF preview background (when you press and hold on a sticker)

titleBg: ${title.upper.area.out()}; // custom window title background when window is inactive
titleBgActive: ${title.upper.area.out()}; // custom window title background when window is active
titleButtonBg: #00000000; // custom window title minimize/maximize/restore button background when window is inactive (Windows only)
titleButtonBgActive: #00000000; // custom window title minimize/maximize/restore button background when window is active (Windows only)
titleButtonBgActiveOver: ${title.lower.text.fade(ACT).out()}; // custom window title minimize/maximize/restore button background with mouse over when window is active (Windows only)
titleButtonBgOver: ${title.lower.text.fade(ACT).out()}; // custom window title minimize/maximize/restore button background with mouse over when window is inactive (Windows only)
titleButtonCloseBg: #00000000; // custom window title close button background when window is inactive (Windows only)
titleButtonCloseBgActive: #00000000; // custom window title close button background when window is active (Windows only)
titleButtonCloseBgActiveOver: ${title.red.area.out()}; // custom window title close button background with mouse over when window is active (Windows only)
titleButtonCloseBgOver: ${title.red.area.out()}; // custom window title close button background with mouse over when window is inactive (Windows only)
titleButtonCloseFg: ${title.lower.text.fade(title.dim).out()}; // custom window title close button icon when window is inactive (Windows only)
titleButtonCloseFgActive: ${title.lower.text.out()}; // custom window title close button icon when window is active (Windows only)
titleButtonCloseFgActiveOver: ${title.red.text.out()}; // custom window title close button icon with mouse over when window is active (Windows only)
titleButtonCloseFgOver: ${title.red.text.out()}; // custom window title close button icon with mouse over when window is inactive (Windows only)
titleButtonFg: ${title.lower.text.fade(title.dim).out()}; // custom window title minimize/maximize/restore button icon when window is inactive (Windows only)
titleButtonFgActive: ${title.lower.text.out()}; // custom window title minimize/maximize/restore button icon when window is active (Windows only)
titleButtonFgActiveOver: ${title.lower.text.out()}; // custom window title minimize/maximize/restore button icon with mouse over when window is active (Windows only)
titleButtonFgOver: ${title.lower.text.out()}; // custom window title minimize/maximize/restore button icon with mouse over when window is inactive (Windows only)
// titleFg: #666666; // FIXME custom window title text when window is inactive (macOS only)
// titleFgActive: #808080; // FIXME custom window title text when window is active (macOS only)
titleShadow: ${
	if     !cfg::option("title-shadow") { "#00000000" }
	else if cfg::option("title-border") { title.lower.text.fade(title.border).out() }
	else { 0xFF.fade(title.upper.area.shadow()).out() }
}; // one pixel line shadow at the bottom of custom window title

toastBg: ${main[good].area.out()}; // toast notification background (like when you click on your t.me link when editing your username)
toastFg: ${main[good].text.out()}; // toast notification text (like when you click on your t.me link when editing your username)

tooltipBg: ${main.upper.like.out()}; // tooltip background (like when you put mouse over the message timestamp and wait)
tooltipBorderFg: ${lab::mix(main.upper.like, main.upper.text, main.border).out()}; // tooltip border
tooltipFg: ${main.upper.text.out()}; // tooltip text

topBarBg: ${main.solar_bg().out()}; // top bar background (in chat view, media overview..)

// FIXME
trayCounterBg: #f23c34; // tray icon counter background
trayCounterBgMacInvert: #ffffff; // tray icon counter background when tray icon is pressed or when dark theme of macOS is used (macOS only)
trayCounterBgMute: #888888; // tray icon counter background if all unread messages are muted
trayCounterFg: #ffffff; // tray icon counter text
trayCounterFgMacInvert: #ffffff01; // tray icon counter text when tray icon is pressed or when dark theme of macOS is used (macOS only)
videoPlayIconBg: #0000007f; // other video play icon background (like when a link to a vimeo video with a webpage preview is sent)
videoPlayIconFg: #ffffff; // other video play icon arrow (like when a link to a vimeo video with a webpage preview is sent)

windowActiveTextFg: ${main[accent].like.out()}; // online blue: fallback for active text like online status
windowBg: ${main.lower.like.out()}; // white: fallback for background
windowBgActive: ${main[accent].area.out()}; // bright blue: fallback for blue filled active areas
windowBgOver: ${main.lower.text.fade(ACT).out()}; // light gray: fallback for background with mouse over
windowBgRipple: ${main.lower.text.fade(ACT).out()}; // darker gray: fallback for ripple effect
windowBoldFg: ${main.lower.text.out()}; // dark gray: fallback for bold text
windowBoldFgOver: ${main.lower.text.out()}; // dark gray: fallback for bold text with mouse over
windowFg: ${main.lower.text.out()}; // black: fallback for text
windowFgActive: ${main[accent].text.out()}; // white: fallback for text on active areas
windowFgOver: ${main.lower.text.out()}; // black: fallback for text with mouse over
windowShadowFg: #000000; // black: fallback for shadow
windowShadowFgFallback: #0000ff; // FIXME gray: fallback for shadow without opacity
windowSubTextFg: ${main.dim("lower")}; // gray: fallback for additional text
windowSubTextFgOver: ${main.lower.text.out()}; // darker gray: fallback for additional text with mouse over

// FIXME
youtubePlayIconBg: #e83131c8; // youtube play icon background (when a link to a youtube video with a webpage preview is sent)
youtubePlayIconFg: windowFgActive; // youtube play icon arrow (when a link to a youtube video with a webpage preview is sent)
`;

#{ image: image, palette: palette }
