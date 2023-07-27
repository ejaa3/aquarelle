/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

fn out() { `"#${this.to_hex_rgba(true)}"` }

`{
	"ver": "4.10.2",
	
	"settings": {
		"version": "4.10.2",
		
		${/* General */}
		"nativeScrollbars": true, ${/* Use native scroll-bars: on */}
		
		${/* Context menu */}
		"ctxMenuNative": true, ${/* Use native context menu: on */}
		
		${/* Navigation bar */}
		"hideAddBtn": true, ${/* Hide "Create panel" button: on */}
		"navBtnCount": true, ${/* Show count of tabs/bookmarks: on (default?) */}
		"hideEmptyPanels": false, ${/* Hide empty tabs panels: off */}
		"navActTabsPanelLeftClickAction": "new_tab", ${/* Left click on active tabs panel: create tab */}
		"navActBookmarksPanelLeftClickAction": "scroll", ${/* Left click on active bookmarks panel: scroll to start/end */}
		"navMidClickAction": "none", ${/* Middle click on tabs panel: none (default) */}
		"navSwitchPanelsWheel": true, ${/* Switch panels with mouse wheel: on (default) */}
		
		${/* Group page */}
		"groupLayout": "grid", ${/* Layout of tabs: grid (default) */}
		
		${/* Tabs */}
		"hideInact": true, ${/* Hide tabs of inactive panels: on */}
		"activateAfterClosing": "prev_act", ${/* After closing current tab activate: previously active tab */}
		
		${/* Position of new tab */}
		"moveNewTab": "after", ${/* Place new tab (for the other cases): after active tab */}
		
		${/* Pinned tabs */}
		"pinnedTabsList": true, ${/* Show titles of pinned tabs: on */}
		
		${/* Bookmarks */}
		"warnOnMultiBookmarkDelete": "any", ${/* Warn on trying delete multile bookmarks: any */}
		"openBookmarkNewTab": true, ${/* Open bookmark in new tab: on */}
		"midClickBookmark": "open_new_tab", ${/* Middle click on the bookmark: open in new tab (default) */}
			"actMidClickTab": true, ${/* Activate tab: on */}
		"showBookmarkLen": true, ${/* Show folder size: on */}
		"highlightOpenBookmarks": true, ${/* Highlight open bookmars: on */}
			"activateOpenBookmarkTab": true, ${/* Go to open tab instead of opening new one: on */}
		
		${/* Appearance */}
		"style": "${if main.lower.text.luma() > main.upper.area.luma() { "dark" } else { "light" }}", ${/* Color scheme: __ */}
		
		${/* Mouse */}
		"hScrollThroughPanels": true, ${/* Use horizontal scroll to switch panels: __on__ */}
		"scrollThroughTabs": "panel", ${/* Switch tabs with scroll whell: panel */}
			"scrollThroughVisibleTabs": true, ${/* Skip folded tabs: on */}
			"scrollThroughTabsSkipDiscarded": true, ${/* Skip discarded tabs: on */}
			"scrollThroughTabsExceptOverflow": false, ${/* Except if panel is overflowing: off */}
			"scrollThroughTabsCyclic": true, ${/* Ciclically: on */}
		
		${/* Help */}
		"markWindow": true, ${/* Add preface to the browser window's title if sidebery is active: on */}
			"markWindowPreface": "­" ${/* Preface value: (invisible character) */}
	},
	
	"cssVars": {
		${/* Common */}
		"bg": ${main.lower.area.out()},
		"title_fg": ${main.yellow.like.out()},
		"label_fg": ${main.lower.text.out()},
		"label_fg_hover": ${main[accent].like.out()},
		"info_fg": ${main.blue.like.out()},
		"true_fg": ${main.green.like.out()},
		"false_fg": ${main.red.like.out()},
		"active_fg": ${main.cyan.like.out()},
		"inactive_fg": ${main.lower.text.fade(main.dim).out()},
		"favicons_placeholder_bg": ${main.lower.text.out()},
		
		${/* Buttons */}
		"btn_bg": ${main[accent].area.out()},
		"btn_bg_hover": ${lab::mix(main[accent].area, main[accent].text, 0.1).out()},
		"btn_bg_active": ${lab::mix(main[accent].area, main[accent].text, 0.2).out()},
		"btn_fg": ${main[accent].text.out()},
		"btn_fg_hover": ${main[accent].text.out()},
		"btn_fg_active": ${main[accent].text.out()},
		
		${/* Context Menu */}
		"ctx_menu_bg": ${main.upper.like.out()},
		"ctx_menu_fg": ${main.upper.text.out()},
		"ctx_menu_bg_hover": ${main.upper.text.fade(0.1).out()},
		
		${/* Navigation Strip */}
		"nav_btn_fg": ${main[accent].like.out()},
		
		${/* Tabs */}
		"tabs_fg": ${main.lower.text.out()},
		"tabs_fg_hover": ${main.lower.text.out()},
		"tabs_bg_hover": ${main.lower.text.fade(0.1).out()},
		"tabs_bg_active": ${main.lower.text.fade(0.3).out()},
		"tabs_activated_bg": ${main.lower.text.fade(0.2).out()},
		"tabs_activated_fg": ${main.lower.text.out()},
		"tabs_selected_bg": ${main[accent].area.out()},
		"tabs_selected_fg": ${main[accent].text.out()},
		
		${/* Bookmarks */}
		"bookmarks_node_title_fg": ${main.lower.text.out()},
		"bookmarks_node_title_fg_hover": ${main.lower.text.out()},
		"bookmarks_node_title_fg_active": ${main.lower.text.out()},
		"bookmarks_node_bg_hover": ${main.lower.text.fade(0.1).out()},
		"bookmarks_node_bg_active": ${main.lower.text.fade(0.2).out()},
		"bookmarks_folder_closed_fg": ${main.blue.like.out()},
		"bookmarks_folder_closed_fg_hover": ${main.blue.like.out()},
		"bookmarks_folder_closed_fg_active": ${main.blue.like.out()},
		"bookmarks_folder_open_fg": ${main.magenta.like.out()},
		"bookmarks_folder_open_fg_hover": ${main.magenta.like.out()},
		"bookmarks_folder_open_fg_active": ${main.magenta.like.out()},
		"bookmarks_folder_empty_fg": ${main.red.like.out()},
		"bookmarks_open-bookmark_fg": ${main.cyan.like.out()}
	}
}`
