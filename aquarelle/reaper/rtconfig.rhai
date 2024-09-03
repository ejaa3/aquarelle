/*
 * SPDX-FileCopyrightText: 2024 Cockos Inc
 * SPDX-FileCopyrightText: 2024 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: LGPL-2.0-or-later
 */

private fn rgb () { let rgb = rgb::coords(this); `${rgb.red} ${rgb.green} ${rgb.blue}` }
private fn rgba() { let rgb = rgb::coords(this); `${rgb.red} ${rgb.green} ${rgb.blue} ${rgb.alpha}` }

export const TEXT = /* REAPER */ `
; Copyright (C) 2015 and onward Cockos Inc
; LICENSE: LGPL v2 or later - http://www.gnu.org/licenses/lgpl.html

version 7.0
use_pngs 1
use_overlays 1
warnings all
tinttcp 298
peaksedges 0
tcp_showborders 0
mcp_showborders 0
trans_showborders 0
tcp_folderindent 0
tcp_heights 4 25 54 64
envcp_min_height 27
mcp_min_height 220 80
misc_dpi_translate 50 100
misc_dpi_translate 134 150
misc_dpi_translate 174 200

tcp_vol_zeroline FF666666
tcp_pan_zeroline 66000000
mcp_vol_zeroline FF666666
mcp_pan_zeroline 85000000
trans_speed_zeroline FF000000
gen_vol_zeroline FF000000
gen_pan_zeroline FF000000

; font #1/6/11 - calibri 8
; font #2/7/12 - calibri 9
; font #3/8/13 - calibri 10
; font #4/9/14 - calibri 11
; font #5/10/15 - calibri 12

macro brightnessFromRGB R G B output
	set output / + + * R 299 * G 587 * B 114 1000
endmacro

define_parameter visSections 					'Visualise sections' 0 0 1
define_parameter textBrightness 				'Text Brightness' 100 50 150
define_parameter colorTrackLabels 				'Custom Color Track Labels' 1 0 1
define_parameter customColorDepthParam 			'Custom Color Strength' 30 0 100
define_parameter selectStrength 				'Selection Overlay Strength' 25 0 100
define_parameter selInvertLabels 				'Selection Invert Labels' 1 0 1
define_parameter selDot 						'Selection Dot' 1 0 1

brightnessFromRGB 								trackcolor_r trackcolor_g trackcolor_b cColorBrightness
set cColorTextOnDark							cColorBrightness{0}<75 + [100 100 100] * 2 [trackcolor_r trackcolor_g trackcolor_b] [trackcolor_r trackcolor_g trackcolor_b] 
set customColorRatio 							?trackcolor_valid / customColorDepthParam{0} 100 0
set selectColRatio 								?track_selected / selectStrength{0} 100 0

#>---------------------------- TRACK CONTROL PANELS -----------------------------------

macro flowProxy index

	set proxy##index 	tcpFlowLocation##index==1 tcpLabelBlock	\
						tcpFlowLocation##index==2 tcp.volume.label	\
						tcpFlowLocation##index==3 tcpMSBlock	\
						tcpFlowLocation##index==4 tcp.io	\
						tcpFlowLocation##index==5 tcpFxBlock	\
						tcpFlowLocation##index==6 tcpPanBlock	\
						tcpFlowLocation##index==7 tcp.recmode	\
						tcpFlowLocation##index==8 tcpInputBlock	\
						tcpFlowLocation##index==9 tcp.env \
						tcpFlowLocation##index==10 tcp.phase
	
	set thisWs * Scale proxy##index{2}
	set thisHs * Scale 20
	
	set thisXMargin * Scale xMargin
	set thisYMargin * Scale yMargin
	
	set proxy##index + + [previous previous] [previous{2} 0 thisWs thisHs] proxy##index{2}>0 [thisXMargin] [0] ; position it at the end of the current row
	; OH NO ITS HIDE set flowProxy 1 ?hide_##this{0} + [previous] [previous{2} . 0 .] . ; apply hide by setting w to zero and ignoring both thisXMargin and xOffs
	
	set sectionRHS + tcpSectionMainMargin{0} tcpSectionMainMargin{2}
	set thisRHS + proxy##index{0} proxy##index{2}
	set thisBS + proxy##index{1} proxy##index{3}
	
; if it'll fit in this row, its already there now, use it to possbly set a new biggestY
	set biggestY thisRHS{0}<=sectionRHS{0} thisBS{0}>biggestY{0} thisBS{0} .  

; -- move to next row--	
; if it WON'T fit in this row, use it to start the next row at biggestY + thisYMargin	
	set proxy##index thisRHS{0}>sectionRHS{0} + + [tcpSectionMainMargin thisYMargin{0} proxy##index proxy##index] [0 biggestY{0}] tcpfolderBalanceType==1 * Scale [tcpFolderBalancer] [0]  .
; it didn't fit in the row, so it was used (in previous line) to start the next row, which means it will now be the new biggestY
	set biggestY thisRHS{0}>sectionRHS{0} + proxy##index{1} proxy##index{3}
; it didn't fit in the row, so it was used to start the next row, so the containing section will now need extra height.
	set tcp.custom.sectionMain thisRHS{0}>sectionRHS{0} - + [0 0 0 proxy##index{1}] [tcp.custom.sectionMain tcp.custom.sectionMain tcp.custom.sectionMain proxy##index] [0 0 0 tcp.custom.sectionMain{1}]
	
; -- cull if it extends below the height of the panel --	
	set thisBS + proxy##index{1} proxy##index{3} ; do that again because it might have moved rows
	set panelBottom - h sectionMargin{0}
	set thisYMarginPlus10 + thisYMargin{0} * Scale 10 ; use to avoid rounding errors on height calculations. 10 is half the element height.
	set proxy##index thisBS{0}>panelBottom{0} \
					h<singleRowH{0} \
							proxy##index{1}>thisYMarginPlus10{0} [proxy##index proxy##index 0 0] . \
							[proxy##index proxy##index 0 proxy##index] \
					!previous{3} [proxy##index proxy##index 0 0] .   ; cull method is to set width to zero
	
; -- cull if it is itself too wide for the section
	set thisWPlus2Margins + + proxy##index{2} thisXMargin{0} thisXMargin{0}
	set proxy##index thisWPlus2Margins{0}>tcp.custom.sectionMain{2} [proxy##index proxy##index 0 0] .
	
; -- cull if previous element is zero height
	set proxy##index previous{3}==0 [proxy##index proxy##index 0 0] .
	
; -- this is the new previous	
	set previous proxy##index
	
endmacro


macro attachProxy index
	set tcpLabelBlock 		tcpFlowLocation##index==1 proxy##index
	set tcp.volume.label 	tcpFlowLocation##index==2 proxy##index
	set tcpMSBlock 			tcpFlowLocation##index==3 proxy##index
	set tcp.io 				tcpFlowLocation##index==4 proxy##index
	set tcpFxBlock 			tcpFlowLocation##index==5 proxy##index
	set tcpPanBlock 		tcpFlowLocation##index==6 proxy##index
	set tcp.recmode 		tcpFlowLocation##index==7 proxy##index
	set tcpInputBlock 		tcpFlowLocation##index==8 proxy##index
	set tcp.env 			tcpFlowLocation##index==9 proxy##index
	set tcp.phase 			tcpFlowLocation##index==10 proxy##index						
endmacro


macro doHideLogic element param
	set hide_##element 							0
	set hide_##element 							param##&1 ?mixer_visible 1 0
	set hide_##element 							param##&2 !track_selected 1 hide_##element
	set hide_##element 							param##&4 !recarm 1 hide_##element
	set hide_##element 							param##&8 1 hide_##element
	set hide_##element							?supercollapsedH{0} 1
endmacro


macro hideSection sec locIdx var thisLayout
	set showParam								?actingParamCount{0} 1 0
	set showParam								Layout##thisLayout##-tcpFxparmVisflag1==1 ?actingFxCount{0} ?tcp_fxlist_enabled{0} 1 
	set showParam								Layout##thisLayout##-tcpFxparmVisflag2==1 ?actingSendCount{0} ?tcp_sends_enabled{0} 1
	set showParam								Layout##thisLayout##-tcpFxembedLocation{0}==Layout##thisLayout##-tcpFxparmLocation{0} 1
	
	set section##sec##var 						Layout##thisLayout##-tcpFxparmLocation{0}==locIdx !showParam{0} 0 . \
	 											Layout##thisLayout##-tcpFxLocation{0}==locIdx !actingFxCount{0} 0 !tcp_fxlist_enabled{0} 0 . \
	 											Layout##thisLayout##-tcpSendLocation{0}==locIdx !actingSendCount{0} 0 !tcp_sends_enabled{0} 0 . \
	 											Layout##thisLayout##-tcpFxembedLocation{0}==locIdx !actingEmbeddedUiCount{0} 0 . \
	 											0 
												
	set showParamT								?fx_parm_cnt 1 0
	set showParamT								Layout##thisLayout##-tcpFxparmVisflag1==1 ?fx_cnt ?tcp_fxlist_enabled{0} 1 
	set showParamT								Layout##thisLayout##-tcpFxparmVisflag2==1 ?send_cnt ?tcp_sends_enabled{0} 1
	set showParamT								Layout##thisLayout##-tcpFxembedLocation{0}==Layout##thisLayout##-tcpFxparmLocation{0} 1		
												
	set section##sec##NotEmpty					Layout##thisLayout##-tcpFxparmLocation{0}==locIdx !showParamT{0} 0 1 \
	 											Layout##thisLayout##-tcpFxLocation{0}==locIdx !fx_cnt 0 !tcp_fxlist_enabled{0} 0 1 \
	 											Layout##thisLayout##-tcpSendLocation{0}==locIdx !send_cnt 0 !tcp_sends_enabled{0} 0 1 \
	 											Layout##thisLayout##-tcpFxembedLocation{0}==locIdx !tcp_fxembed 0 1 \
	 											0
endmacro


macro assignLoc element assignedLoc
	set element									?supercollapsedH{0} [0] \
												assignedLoc##{0}==1 tcpSectionLeft1Margin \
												assignedLoc##{0}==2 tcpSectionLeft2Margin \
												assignedLoc##{0}==3 tcpSectionLeft3Margin \
												assignedLoc##{0}==4 tcpSectionBottom1Margin \
												assignedLoc##{0}==5 tcpSectionBottom2Margin \
												assignedLoc##{0}==6 tcpSectionBottom3Margin \
												assignedLoc##{0}==7 tcpSectionRight1Margin \
												assignedLoc##{0}==8 tcpSectionRight2Margin \
												assignedLoc##{0}==9 tcpSectionRight3Margin \
												[0]
endmacro



;-- GLOABL TCP PARAMS --

define_parameter sectionMargin 					'Section Margins' 6 0 12
define_parameter xMargin 						'X-Axis spacing' 4 2 12
define_parameter yMargin 						'Y-Axis spacing' 6 2 12
define_parameter tcpfolderIndentSize			'TCP Folder Indent' 20 0 40
define_parameter tcpfolderBalanceType			'TCP Folder Balance Type' 0 0 2
define_parameter tcpDivOpacity 					'TCP Div Opacity' 80 0 255
${ let rgb = rgb::coords(lab::mix(main.lower.like, main.lower.text, 0.1)); `
define_parameter tcpBgColR 						'TCP background colour' ${rgb.red} 0 255
define_parameter tcpBgColG 						'TCP background colour G' ${rgb.green} 0 255
define_parameter tcpBgColB 						'TCP background colour B' ${rgb.blue} 0 255` }
define_parameter emptyTcpSecOpacity 			'Empty TCP Section Opacity' 128 1 255
define_parameter tcpFlowLocation1				'TCP flow location 1' 1 1 10
define_parameter tcpFlowLocation2				'TCP flow location 2' 2 1 10
define_parameter tcpFlowLocation3				'TCP flow location 3' 3 1 10
define_parameter tcpFlowLocation4				'TCP flow location 4' 4 1 10
define_parameter tcpFlowLocation5				'TCP flow location 5' 5 1 10
define_parameter tcpFlowLocation6				'TCP flow location 6' 6 1 10
define_parameter tcpFlowLocation7				'TCP flow location 7' 7 1 10
define_parameter tcpFlowLocation8				'TCP flow location 8' 8 1 10
define_parameter tcpFlowLocation9				'TCP flow location 9' 9 1 10
define_parameter tcpFlowLocation10				'TCP flow location 10' 10 1 10


macro drawTcp thisLayout Scale 

;-- HOUSEKEEPING --

clear tcp.*
set Scale 										[Scale Scale Scale Scale Scale Scale Scale Scale] ; ohOK
set tcp.size 									* Scale [300 100 40] 
set singleRowH 									* Scale + 20 * 2 sectionMargin{0}
set ySqueeze 									h<singleRowH{0} - * Scale sectionMargin{0} * 0.5 - singleRowH{0} - h 1 * Scale sectionMargin{0}	
set supercollapsedMinH							* Scale 5						  
set supercollapsedH								h<supercollapsedMinH{0} 1 0
set textBrightnessMult							* textBrightness{0} 0.01
set Layout##thisLayout##-tcpVolumeLength 		Layout##thisLayout##-tcpVolumeLength{0}<=40 20 .
set Layout##thisLayout##-tcpFxparmVisflag1		!tcp_fxlist_enabled{0} -1 .
set Layout##thisLayout##-tcpFxparmVisflag2		!tcp_sends_enabled{0} -1 .			
set sectionMarginXYWH 							h<singleRowH{0} + * Scale - [sectionMargin{0}] * 2 [0 0 sectionMargin{0}] - [0 ySqueeze{0}] * 2 [0 0 0 ySqueeze{0}] \
												* Scale + [sectionMargin{0} sectionMargin{0}] * -2 [0 0 sectionMargin{0} sectionMargin{0}]

;-- TCP SECTIONS (pt.1) --	

set thisTcpfolderIndent							* - maxfolderdepth - maxfolderdepth folderdepth tcpfolderIndentSize
set tcpFolderBalancer							tcpfolderBalanceType>0 * - maxfolderdepth folderdepth tcpfolderIndentSize
set thisTcpLabelLength							+ Layout##thisLayout##-tcpLabelLength tcpfolderBalanceType==1 tcpFolderBalancer 0
set actingParamCount							+ fx_parm_cnt ?fx_parm_cnt 0 ?Layout##thisLayout##-tcpFxparmPin{0} 1 0
set actingFxCount								+ fx_cnt ?fx_cnt 0 ?Layout##thisLayout##-tcpFxPin{0} 1 0
set actingSendCount 							+ send_cnt ?send_cnt 0 ?Layout##thisLayout##-tcpSendPin{0} 1 0
set actingEmbeddedUiCount						+ tcp_fxembed ?tcp_fxembed 0 ?Layout##thisLayout##-tcpFxembedPin{0} 1 0

custom tcp.custom.tcpDiv
	set tcp.custom.tcpDiv 						- + * Scale * [1 0 -1] thisTcpfolderIndent [0 h w 1] [0 1] 
	set tcp.custom.tcpDiv.color 				* Scale [0 0 0 0 0 0 0 tcpDivOpacity{0}]								
custom tcp.custom.sectionNumber
	set tcp.custom.sectionNumber 				+ - [0 0 0 h] [0 0 0 1] * Scale [thisTcpfolderIndent 0 20]
	set tcp.custom.sectionNumber.color 			?trackcolor_valid [0 0 0 0 trackcolor_r trackcolor_g trackcolor_b] [0 0 0 0 tcpBgColR tcpBgColG tcpBgColB 255]
	set tcp.foldercomp							?supercollapsedH{0} [0] + [tcp.custom.sectionNumber] * Scale [0 0 20 18]
	set tcp.folder                  			?supercollapsedH{0} [0] + [tcp.custom.sectionNumber h] * Scale [0 -14 20 14]
	front tcp.folder
	set tcp_folder_min							* Scale folderstate==1 50 32
	set tcp.folder                				h<tcp_folder_min{0} folderstate<0 . [0] .
	brightnessFromRGB 							trackcolor_r trackcolor_g trackcolor_b tcpSectionNumberBrightness
	set tcp.trackidx							?supercollapsedH{0} [0] + tcp.custom.sectionNumber * Scale folderstate==1 [0 16 0 -16] folderstate<0 [0 -10 0 10] [0]
	set tcp.trackidx.margin						+ [0 0 0 0 0.5] trackidx<100 - * 0.5 + ?selDot{0} [0 0 8] [0] [0 tcp.trackidx{3} 0 tcp.trackidx{3}] [0 10 0 10] [3 0 7 0]
	set tcp.trackidx.color 						tcpSectionNumberBrightness{0}>128 [${lower_bg.rgba()} 0 0 0 0]  [${main.lower.text.rgba()} 0 0 0 0] 
	set tcp.trackidx.font						trackidx<100 Scale{0}==1 [3] Scale{0}==1.5 [8] [13] Scale{0}==1 [1] Scale{0}==1.5 [6] [11]
set tcp.dragdropinfo 							+ [0 tcp.custom.sectionNumber{2}] * Scale [thisTcpfolderIndent thisTcpfolderIndent]	
custom tcp.custom.indentInfill
	set tcp.custom.indentInfill					[0 0 tcp.custom.sectionNumber{0} h]
	set tcp.custom.indentInfill.color			[0 0 0 0 ${main.lower.like.rgba()}]
custom tcp.custom.sectionNumberDiv
	set tcp.custom.sectionNumberDiv				+ + [tcp.custom.sectionNumber tcp.custom.sectionNumber 1 tcp.custom.sectionNumber] [tcp.custom.sectionNumber{2}] [-1]
	set tcp.custom.sectionNumberDiv.color		* Scale [0 0 0 0 0 0 0 tcpDivOpacity{0}]
	front tcp.custom.sectionNumberDiv
	
custom tcp.custom.tcp_selectionDot 				'' 0 '' 'tcp_selectionDot'
set tcp.custom.tcp_selectionDot 				!selDot{0} [0] ?track_selected [0] + + [tcp.custom.sectionNumber] - [tcp.custom.sectionNumber{2} tcp.custom.sectionNumber{3}] * 0.5 [0 tcp.custom.sectionNumber{3}] * Scale [-4 -4 8 8]
custom tcp.custom.tcp_selectionDotSel			'' 0 '' 'tcp_selectionDot_sel'	
set tcp.custom.tcp_selectionDotSel 				!selDot{0} [0] !track_selected [0] + + [tcp.custom.sectionNumber] - [tcp.custom.sectionNumber{2} tcp.custom.sectionNumber{3}] * 0.5 [0 tcp.custom.sectionNumber{3}] * Scale [-4 -4 8 8]
front tcp.custom.tcp_selectionDot tcp.custom.tcp_selectionDotSel	

set sectionLeft1Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==1 0 Layout##thisLayout##-tcpFxLocation{0}==1 0 \
													Layout##thisLayout##-tcpSendLocation{0}==1 0 Layout##thisLayout##-tcpFxembedLocation{0}==1 0 1
set sectionLeft2Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==2 0 Layout##thisLayout##-tcpFxLocation{0}==2 0 \
													Layout##thisLayout##-tcpSendLocation{0}==2 0 Layout##thisLayout##-tcpFxembedLocation{0}==2 0 1
set sectionLeft3Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==3 0 Layout##thisLayout##-tcpFxLocation{0}==3 0 \
													Layout##thisLayout##-tcpSendLocation{0}==3 0 Layout##thisLayout##-tcpFxembedLocation{0}==3 0 1
set sectionBottomMinimise						Layout##thisLayout##-tcpFxparmLocation{0}==4 0 Layout##thisLayout##-tcpFxLocation{0}==4 0 \
													Layout##thisLayout##-tcpSendLocation{0}==4 0 Layout##thisLayout##-tcpFxembedLocation{0}==4 0 1
set sectionRight1Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==7 0 Layout##thisLayout##-tcpFxLocation{0}==7 0 \
													Layout##thisLayout##-tcpSendLocation{0}==7 0 Layout##thisLayout##-tcpFxembedLocation{0}==7 0 1
set sectionRight2Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==8 0 Layout##thisLayout##-tcpFxLocation{0}==8 0 \
													Layout##thisLayout##-tcpSendLocation{0}==8 0 Layout##thisLayout##-tcpFxembedLocation{0}==8 0 1
set sectionRight3Minimise 						?supercollapsedH{0} 1 Layout##thisLayout##-tcpFxparmLocation{0}==9 0 Layout##thisLayout##-tcpFxLocation{0}==9 0 \
													Layout##thisLayout##-tcpSendLocation{0}==9 0 Layout##thisLayout##-tcpFxembedLocation{0}==9 0 1

set emptyTcpSecColor							[0 0 0 0 38 38 38 emptyTcpSecOpacity{0}]
custom tcp.custom.sectionLeft1
	set sectionLeft1DrawW 						?sectionLeft1Minimise{0} 0 * Scale Layout##thisLayout##-sectionLeftW{0}
	hideSection Left1 1	DrawW thisLayout										
	set tcp.custom.sectionLeft1 				+ + tcpfolderBalanceType==2 * Scale [tcpFolderBalancer] [0] [tcp.custom.sectionNumber] [tcp.custom.sectionNumber{w} 0 sectionLeft1DrawW{0} h] 
	set tcp.custom.sectionLeft1 				tcp.custom.sectionLeft1{2}<0 [. . 0 .] ; preventing negative width
	set tcp.custom.sectionLeft1.color 			?visSections [0 0 0 0 255 100 100 150] ?sectionLeft1NotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor
	
custom tcp.custom.sectionLeft2
	set sectionLeft2DrawW 						?sectionLeft2Minimise{0} 0 * Scale Layout##thisLayout##-sectionLeftW{0}
	hideSection Left2 2	DrawW thisLayout 
	set tcp.custom.sectionLeft2 				+ [tcp.custom.sectionLeft1] [tcp.custom.sectionLeft1{w} 0 sectionLeft2DrawW{0} h] 
	set tcp.custom.sectionLeft2 				tcp.custom.sectionLeft2{2}<0 [. . 0 .] ; preventing negative width
	set tcp.custom.sectionLeft2.color 			?visSections [0 0 0 0 255 50 50 100] ?sectionLeft2NotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor
	
custom tcp.custom.sectionLeft3
	set sectionLeft3DrawW 						?sectionLeft3Minimise{0} 0 * Scale Layout##thisLayout##-sectionLeftW{0}
	hideSection Left3 3 DrawW thisLayout
	set tcp.custom.sectionLeft3 				+ [tcp.custom.sectionLeft2] [tcp.custom.sectionLeft2{w} 0 sectionLeft3DrawW{0} h] 
	set tcp.custom.sectionLeft3 				tcp.custom.sectionLeft3{2}<0 [. . 0 .] ; preventing negative width
	set tcp.custom.sectionLeft3.color 			?visSections [0 0 0 0 255 150 150 200] ?sectionLeft3NotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor
	
; Calculate sectionRight widths now so that sectionMain can use them
	set sectionRight1DrawW 						?sectionRight1Minimise{0} 0 Layout##thisLayout##-sectionRightW{0}
	hideSection Right1 7 DrawW thisLayout												
	set sectionRight2DrawW 						?sectionRight2Minimise{0} 0 Layout##thisLayout##-sectionRightW{0}
	hideSection 								Right2 8 DrawW thisLayout
												
	set sectionRight3DrawW 						?sectionRight3Minimise{0} 0 Layout##thisLayout##-sectionRightW{0}
	hideSection 								Right3 9 DrawW thisLayout

custom tcp.custom.sectionMain
	set tcp.custom.sectionMain 					[0]												
	set tcp.custom.sectionMain 					+ + + [tcp.custom.sectionLeft3{2}] [tcp.custom.sectionLeft3 ySqueeze w] * Scale [0 0 0 20] \
													* -1 \
														+ + + + [0 0 tcp.custom.sectionLeft3{0}] [0 0 tcp.custom.sectionLeft3{2}] \
														* Scale + + [0 0 sectionRight1DrawW{0}] [0 0 sectionRight2DrawW{0}] [0 0 sectionRight3DrawW{0}] \
														* Scale [0 0 Layout##thisLayout##-tcpMeterWidth{0}]	
	set tcp.custom.sectionMain.color 			?visSections [0 0 0 0 50 50 255 100] [0]
; Calculate resulting color for use in text brightness judgement	
set tcpMainSecCol								+ * - 1 selectColRatio + \
													* customColorRatio [trackcolor_r trackcolor_g trackcolor_b] \
													* - 1 customColorRatio [tcpBgColR tcpBgColG tcpBgColB] \
												* selectColRatio [255 255 255] 
brightnessFromRGB 								tcpMainSecCol{0} tcpMainSecCol{1} tcpMainSecCol{2} tcpMainSecColBrightness	

;-- HIDING-- for assorted reasons

doHideLogic 									tcpLabelBlock Layout##thisLayout##-hideTcpLabelBlock{0}	
doHideLogic 									tcp.recmon Layout##thisLayout##-hideTcpRecmon{0}
set tcpRecmonW									?hide_tcp.recmon{0} 0 14 
doHideLogic										labelsValues Layout##thisLayout##-hideTcpLabelsValues{0}
set hide_tcp.volume.label						!hide_labelsValues{0} 0 1
doHideLogic 									tcpMSBlock Layout##thisLayout##-hideTcpMSBlock{0}
doHideLogic 									tcp.io Layout##thisLayout##-hideTcpIo{0}
doHideLogic 									tcpFxBlock Layout##thisLayout##-hideTcpFxBlock{0}
doHideLogic 									tcpPanBlock Layout##thisLayout##-hideTcpPanBlock{0}
doHideLogic 									tcp.recmode Layout##thisLayout##-hideTcpRecmode{0}
doHideLogic 									tcpInputBlock Layout##thisLayout##-hideTcpInputBlock{0}
doHideLogic 									tcp.env Layout##thisLayout##-hideTcpEnv{0}
doHideLogic 									tcp.phase Layout##thisLayout##-hideTcpPhase{0}
doHideLogic										meterValues Layout##thisLayout##-hideTcpMeterValues{0}

;-- TCP SECTIONS (pt.2) --	

set tcpLabelBlockW								+ + + thisTcpLabelLength{0} Layout##thisLayout##-tcpVolumeLength{0} 20 tcpRecmonW{0} ; 20 is the recarm width
set tcpInputBlockW								+ 20 Layout##thisLayout##-tcpRecinputLength{0} ; 20 is the width of tcp.fxin
set tcpPanBlockW								trackpanmode<=3 !hide_labelsValues{0} 58 20 trackpanmode==5 !hide_labelsValues{0} 80 42 trackpanmode==6 !hide_labelsValues{0} 100 60
set longestTcpBlock								* Scale + + sectionMargin{0} sectionMargin{0} tcpLabelBlockW{0}>tcpInputBlockW{0} tcpLabelBlockW{0} tcpInputBlockW{0}
set tcp.custom.sectionMain 						tcp.custom.sectionMain{2}<longestTcpBlock{0} [tcp.custom.sectionMain tcp.custom.sectionMain longestTcpBlock{0} tcp.custom.sectionMain] .
	set tcpSectionMainMargin 					+ tcp.custom.sectionMain + * Scale [sectionMargin{0}] * -2 * Scale [0 0 sectionMargin{0}]

custom tcp.custom.sectionRight1
	set tcp.custom.sectionRight1 				+ + [tcp.custom.sectionMain 0 0 h] [tcp.custom.sectionMain{2}] * Scale [0 0 sectionRight1DrawW{0}]
	set tcp.custom.sectionRight1.color 			?visSections [0 0 0 0 255 255 100 150] ?sectionRight1NotEmpty{0} [0 0 0 0 ${lower_bg.rgba()}] emptyTcpSecColor
	
custom tcp.custom.sectionRight2
	set tcp.custom.sectionRight2 				+ + [tcp.custom.sectionRight1 0 0 h] [tcp.custom.sectionRight1{2}] * Scale [0 0 sectionRight2DrawW{0}]
	set tcp.custom.sectionRight2.color 			?visSections [0 0 0 0 255 200 100 200] ?sectionRight2NotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor

custom tcp.custom.sectionRight3
	set tcp.custom.sectionRight3 				+ + [tcp.custom.sectionRight2 0 0 h] [tcp.custom.sectionRight2{2}] * Scale [0 0 sectionRight3DrawW{0}]
	set tcp.custom.sectionRight3.color 			?visSections [0 0 0 0 255 255 200 150] ?sectionRight3NotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor	

custom tcp.custom.sectionMeter
	set tcp.custom.sectionMeter 				+ + [tcp.custom.sectionRight3 0 0 h] [tcp.custom.sectionRight3{2}] * Scale [0 0 Layout##thisLayout##-tcpMeterWidth{0}]
	set tcp.custom.sectionMeter.color 			?visSections [0 0 0 0 10 255 10 255] [0 0 0 0 ${lower_bg.rgba()}]
	
; Add margins to sections
set tcpSectionLeft1Margin 						+ tcp.custom.sectionLeft1 sectionMarginXYWH	
set tcpSectionLeft2Margin 						+ tcp.custom.sectionLeft2 sectionMarginXYWH	
set tcpSectionLeft3Margin 						+ tcp.custom.sectionLeft3 sectionMarginXYWH	
set tcpSectionRight1Margin 						+ tcp.custom.sectionRight1 sectionMarginXYWH	
set tcpSectionRight2Margin 						+ tcp.custom.sectionRight2 sectionMarginXYWH	
set tcpSectionRight3Margin 						+ tcp.custom.sectionRight3 sectionMarginXYWH	
	
;------------------

set tcp.meter 									+ + tcp.custom.sectionMeter * Scale [Layout##thisLayout##-tcpMeterBorder{0} Layout##thisLayout##-tcpMeterBorder{0}] \
													* -2 * Scale [0 0 Layout##thisLayout##-tcpMeterBorder{0} Layout##thisLayout##-tcpMeterBorder{0}]
	set tcp.meter.vu.div                    	[Layout##thisLayout##-tcpMeterBorder{0}]
	set tcp.meter.readout.color             	?hide_meterValues{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [100 100 100 255 255 183 171 255]
	set tcp.meter.scale.color.lit.bottom    	?hide_meterValues{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set tcp.meter.scale.color.lit.top       	?hide_meterValues{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set tcp.meter.scale.color.unlit.bottom  	?hide_meterValues{0} [0 0 0 0 0 0 0 0] ?recarm [255 64 0 255 0 0 0 0] + * - textBrightnessMult{0} 1 [0 0 0 100] [255 255 255 60 0 0 0 0]
	set tcp.meter.scale.color.unlit.top     	?hide_meterValues{0} [0 0 0 0 0 0 0 0] ?recarm [255 64 0 255 0 0 0 0] + * - textBrightnessMult{0} 1 [0 0 0 100] [255 255 255 60 0 0 0 0]

;-- POPULATE MAIN --
	
;reset values for 'follow' macro
set biggestY 0
set xOffs 0
set noSpace 0

custom tcp.custom.panBlock
custom tcp.custom.labelBlock 
custom tcp.custom.inputBlock

set tcpLabelBlock 							?hide_tcpLabelBlock{0} [0 0 0] [0 0 tcpLabelBlockW{0}]
set tcp.volume.label						?hide_tcp.volume.label{0} [0 0 0] [0 0 48]
set tcpMSBlock								?hide_tcpMSBlock{0} [0 0 0] [0 0 39]
set tcp.io									?hide_tcp.io{0} [0 0 0] [0 0 30]
set tcpFxBlock								?hide_tcpFxBlock{0} [0 0 0] [0 0 36]
set tcpPanBlock								?hide_tcpPanBlock{0} [0 0 0] [0 0 tcpPanBlockW]
set tcp.recmode								?hide_tcp.recmode{0} [0 0 0] [0 0 42]
set tcpInputBlock							?hide_tcpInputBlock{0} [0 0 0] [0 0 tcpInputBlockW{0}]
set tcp.env 								?hide_tcp.env{0} [0 0 0] [0 0 40]
set tcp.phase 								?hide_tcp.phase{0} [0 0 0] [0 0 16]
set previous 								+ [tcpSectionMainMargin tcpSectionMainMargin] * Scale - [0 0 0 20] [xMargin{0}] ; mainNullElement

flowProxy 1
flowProxy 2
flowProxy 3
flowProxy 4
flowProxy 5
flowProxy 6
flowProxy 7
flowProxy 8
flowProxy 9
flowProxy 10

attachProxy 1
attachProxy 2
attachProxy 3
attachProxy 4
attachProxy 5
attachProxy 6
attachProxy 7
attachProxy 8
attachProxy 9
attachProxy 10

					
custom tcp.custom.labelBlockBg 					'' 0 '' 'tcp_labelBlock_bg'
	custom tcp.custom.labelBlockBgSel			'' 0 '' 'tcp_labelBlock_bg_sel'
	set tcp.custom.labelBlockBg					+ * Scale [0 0 -2] ?selInvertLabels{0} ?track_selected [0] tcpLabelBlock tcpLabelBlock
	set tcp.custom.labelBlockBgSel				+ * Scale [0 0 -2] ?selInvertLabels{0} ?track_selected tcpLabelBlock [0] [0]
set tcp.recarm 									!tcpLabelBlock{2} [0] + [tcpLabelBlock tcpLabelBlock] * Scale [0 0 24 20]
set tcp.recmon									!tcpLabelBlock{2} [0] + [tcp.recarm tcp.recarm] + [tcp.recarm{2}] * Scale [0 0 tcpRecmonW{0} 20] 
set tcp.label									!tcpLabelBlock{2} [0] + [tcp.recmon tcp.recmon] + [tcp.recmon{2}] * Scale - [0 0 thisTcpLabelLength{0} 20] [0 0 6] 
	set tcp.label.margin 						* Scale [6 0 2 0]
	set tcp.label.font 							+ Layout##thisLayout##-tcpLabelSize{0} Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set tcp.label.color 						?recarm [${main.red.like.rgb()}] ?trackcolor_valid ?colorTrackLabels cColorTextOnDark * textBrightnessMult{0} [200 200 200] * textBrightnessMult{0} [${main.lower.text.rgb()}] 
	set tcp.label.color							?selInvertLabels{0} ?track_selected ?recarm [180 0 10] [${main.lower.like.rgb()}] . .
set tcp.volume									!tcpLabelBlock{2} [0] + [tcp.label tcp.label] + [tcp.label{2}] * Scale [0 0 Layout##thisLayout##-tcpVolumeLength{0} 20] 
	set thisVolL								* Scale Layout##thisLayout##-tcpVolumeLength{0}
	set volKnobFlipW							* Scale 40
	set tcp.volume.fadermode 					thisVolL{0}<=volKnobFlipW{0} [1] [0]	
set tcp.volume.label.font						Scale{0}==1 [1] Scale{0}==1.5 [6] [11]
	set tcp.volume.label.color					* textBrightnessMult{0} tcpMainSecColBrightness{0}<150 [${main.lower.text.rgb()}] [${lower_bg.rgb()}]
	set tcp.volume.label.margin					* Scale [6 0 0 0 0]
set tcp.mute 									!tcpMSBlock{2} [0] + [tcpMSBlock tcpMSBlock] * Scale [0 0 20 20]
set tcp.solo 									!tcpMSBlock{2} [0] + [tcp.mute tcp.mute] * Scale [19 0 20 20]
set tcp.fx										!tcpFxBlock{2} [0] + [tcpFxBlock tcpFxBlock] * Scale [0 0 20 20]
	set tcp.fxbyp								!tcpFxBlock{2} [0] + [tcp.fx tcp.fx] * Scale [20 0 16 20]
	front tcp.fxbyp 
set tcp.custom.panBlock							?visSections tcpPanBlock [0]
	set tcp.custom.panBlock.color 				?visSections [0 0 0 0 255 255 100 255] [0 0 0 0 0 0 0]
set panLabelW									* Scale !hide_labelsValues{0} 38 0
set tcp.pan.label								!tcpPanBlock{2} [0] trackpanmode<=3 + [tcpPanBlock tcpPanBlock panLabelW{0}] * Scale [0 0 0 20] + + [tcpPanBlock tcpPanBlock panLabelW{0}] \
													* Scale [0 0 0 10] trackpanmode==6 * Scale [0 10] [0]
	set tcp.pan.label.color						* textBrightnessMult{0} tcpMainSecColBrightness{0}<150 [${main.lower.text.rgb()}] [${lower_bg.rgb()}]
	set tcp.pan.label.margin					+ [0 0 0 0 1] * Scale [0 0 4]
	set tcp.pan.label.font						Scale{0}==1 [1] Scale{0}==1.5 [6] [11]
set tcp.pan										!tcpPanBlock{2} [0] trackpanmode<6 + + [tcp.pan.label tcp.pan.label] [tcp.pan.label{2}] * Scale [0 0 20 20] \
																				   + + [tcpPanBlock tcpPanBlock] [tcp.pan.label{2}] * Scale [0 10 62 10]
	set tcp.pan.fadermode						trackpanmode==6 [-1] [1]
set tcp.width									!tcpPanBlock{2} [0] trackpanmode<=3 [0] trackpanmode<6 + + [tcp.pan tcp.pan] [tcp.pan{2}] * Scale [2 0 20 20] \
																									   + + [tcpPanBlock tcpPanBlock] [tcp.pan.label{2}] * Scale [0 0 62 10]
	set tcp.width.fadermode						tcp.pan.fadermode
set tcp.width.label								!tcpPanBlock{2} [0] trackpanmode<=3 [0] trackpanmode<6 + [tcp.pan.label tcp.pan.label panLabelW{0}] * Scale [0 10 0 10] \
																									   + [tcpPanBlock tcpPanBlock panLabelW{0}] * Scale [0 0 0 10]
	set tcp.width.label.color					tcp.pan.label.color
	set tcp.width.label.margin					tcp.pan.label.margin
	set tcp.width.label.font					Scale{0}==1 [1] Scale{0}==1.5 [6] [11]
set tcp.custom.inputBlock						?visSections tcpInputBlock [0]
	set tcp.custom.inputBlock.color 			?visSections [0 0 0 0 255 255 100 255] [0 0 0 0 0 0 0]
set tcp.fxin									!tcpInputBlock{2} [0] + [tcpInputBlock tcpInputBlock] * Scale [0 0 20 20]
set tcp.recinput								!tcpInputBlock{2} [0] + + [tcpInputBlock tcpInputBlock] [tcp.fxin{2} 0] * Scale [0 0 Layout##thisLayout##-tcpRecinputLength{0} 20]
	set tcp.recinput.color 						* textBrightnessMult{0} [${main.lower.text.rgb()}]         		
	set tcp.recinput.font						+ Layout##thisLayout##-tcpInputFontSize{0} Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set tcp.recinput.margin 					+ [0 0 0 0 0.5] * Scale [2 0 20]


;-- TCP SECTIONS (pt.3) --

custom tcp.custom.sectionBottom 				; follows those calculations on main section, within the 'follow' macro, so that this is y-correct
	set sectionBottomH							?sectionBottomMinimise{0} 0 - h + tcp.custom.sectionMain{1} tcp.custom.sectionMain{3}
	hideSection Bottom 4 H thisLayout
	; hideSection sets bottomSectionH to 0 if params or sends is empty, even if embed is set to bottom (fx will never be empty if there's an embed!). This overrides that...
	set sectionBottomH 							!actingEmbeddedUiCount{0} . Layout##thisLayout##-tcpFxembedLocation{0}>4 Layout##thisLayout##-tcpFxembedLocation{0}<7 ?sectionBottomMinimise{0} 0 - h + tcp.custom.sectionMain{1} tcp.custom.sectionMain{3}
	
	;hideSection sets bottomSectionH to 0 if inserts and sends are set to bottom and inserts are empty. This overrides that...
	set sectionBottomH							!actingSendCount{0} . ?actingFxCount{0} . \
												Layout##thisLayout##-tcpFxLocation{0}==4 Layout##thisLayout##-tcpSendLocation{0}==5 ?sectionBottomMinimise{0} 0 - h + tcp.custom.sectionMain{1} tcp.custom.sectionMain{3} . .
	
	; if embed is set to bottom (section 5 or 6), and embed is empty, then bottomDiv will be 1 too big
	set thisTcpSectionBottomDiv					Layout##thisLayout##-tcpSectionBottomDiv{0}
	set thisTcpSectionBottomDiv					?actingEmbeddedUiCount{0} . Layout##thisLayout##-tcpFxembedLocation{0}>4	Layout##thisLayout##-tcpFxembedLocation{0}<7 - Layout##thisLayout##-tcpSectionBottomDiv{0} 1 . .	
	
	set tcp.custom.sectionBottom 				+ + [0 tcp.custom.sectionMain] [tcp.custom.sectionMain tcp.custom.sectionMain{3} tcp.custom.sectionMain sectionBottomH{0}] * Scale [0 sectionMargin{0}]
	custom tcp.custom.sectionBottom1			
	set tcp.custom.sectionBottom1				/ tcp.custom.sectionBottom [1 1 thisTcpSectionBottomDiv{0} 1]
	set tcp.custom.sectionBottom1.color 		?visSections [0 0 0 0 100 255 100 150] ?sectionBottomNotEmpty{0} [0 0 0 0 ${lower_bg.rgba()} 255] emptyTcpSecColor
	custom tcp.custom.sectionBottom2			
	set tcp.custom.sectionBottom2				thisTcpSectionBottomDiv{0}<2 [0] + [tcp.custom.sectionBottom1{2}] / tcp.custom.sectionBottom [1 1 thisTcpSectionBottomDiv{0} 1]
	set tcp.custom.sectionBottom2.color 		?visSections [0 0 0 0 150 200 100 150] ?sectionBottomNotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor
	custom tcp.custom.sectionBottom3			
	set tcp.custom.sectionBottom3				thisTcpSectionBottomDiv{0}<3 [0] + + + [tcp.custom.sectionBottom1 tcp.custom.sectionBottom1 0 tcp.custom.sectionBottom2] \
													[tcp.custom.sectionBottom1{2}] [tcp.custom.sectionBottom2{2}] / [0 0 tcp.custom.sectionBottom] thisTcpSectionBottomDiv{0}
	set tcp.custom.sectionBottom3.color 		?visSections [0 0 0 0 100 255 150 150] ?sectionBottomNotEmpty{0} [0 0 0 0 38 38 38 255] emptyTcpSecColor
		
	set tcpSectionBottom1Margin					+ tcp.custom.sectionBottom1 * * Scale sectionMargin{0} [1 1 -2 -2]
	set tcpSectionBottom2Margin					+ tcp.custom.sectionBottom2 * * Scale sectionMargin{0} [0 1 0 -2]
	set tcpSectionBottom3Margin					+ tcp.custom.sectionBottom3 * * Scale sectionMargin{0} [0 1 -1 -2]

custom tcp.custom.tcpSelBox
	set tcp.custom.tcpSelBox 					!track_selected [0] selectStrength{0}>0 [0 0 w h] [0]
	set tcp.custom.tcpSelBox.color 				+ * / selectStrength{0} 100 [0 0 0 0 0 0 0 255] [0 0 0 0 ${lab::mix(main.lower.like, main.lower.text, 0.5).rgb()}]

custom tcp.custom.colourBox
	set customColorDepth 						* customColorDepthParam 2.55
	set tcp.custom.colourBox 					customColorDepth{0}>0 + + * [1 0 -1] tcp.custom.sectionNumber{w} [1 0 w h] [-1 0 -1] [0]
	set tcp.custom.colourBox.color 				?trackcolor_valid [0 0 0 0 trackcolor_r trackcolor_g trackcolor_b customColorDepth{0}] [0 0 0 0 0 0 0 0]

custom tcp.custom.tcpBgBox
	set tcp.custom.tcpBgBox 					[0 0 w h] 
	set tcp.custom.tcpBgBox.color 				[0 0 0 0 tcpBgColR tcpBgColG tcpBgColB 255]
	
;-- POPULATE SECTIONS --	
	
assignLoc tcp.fxparm Layout##thisLayout##-tcpFxparmLocation
	set tcp.fxparm.margin 						* Scale [3 0 4 0 0 0 0 4]
	set Layout##thisLayout##-tcpFxparmWidth		Layout##thisLayout##-tcpFxparmWidth{0}>tcp.fxparm{2} tcp.fxparm{2}
	set tcp.fxparm.font 						+ * Scale [0 24 60 Layout##thisLayout##-tcpFxparmWidth{0}] + [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set tcp.fxparm.visflags						[1 Layout##thisLayout##-tcpFxparmVisflag1 Layout##thisLayout##-tcpFxparmVisflag2]

assignLoc tcp.fxlist Layout##thisLayout##-tcpFxLocation
	set tcp.fxlist								!tcp_fxlist_enabled{0} [0] . ; if disabled in options
	set tcp.fxlist.font 						+ * Scale [0 18 Layout##thisLayout##-tcpFxMinWidth{0} Layout##thisLayout##-tcpFxMaxWidth{0}] + [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set tcp.fxlist.margin						* Scale [3 0 4 6 0.5 0 20 sectionMargin{0}] 	

assignLoc tcp.sendlist Layout##thisLayout##-tcpSendLocation
set tcp.sendlist								!tcp_sends_enabled{0} [0] . ; if disabled in options
	set tcp.sendlist.margin 					* Scale [2 0 0 0 0 0 0 sectionMargin{0}]
	set tcp.sendlist.font 						+ * Scale [0 20 26 Layout##thisLayout##-tcpSendMaxWidth{0}] + [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]

assignLoc tcp.fxembed Layout##thisLayout##-tcpFxembedLocation	
	set tcp.fxembedheader.color					[200 200 200]

set minTcpW										+ + + \
												  * Scale + + thisTcpfolderIndent tcp.custom.sectionNumber{2} Layout##thisLayout##-tcpMeterWidth{0} \
												  longestTcpBlock{0} \
												  + + tcp.custom.sectionLeft1{2} tcp.custom.sectionLeft2{2} tcp.custom.sectionLeft3{2} \
												  + + tcp.custom.sectionRight1{2} tcp.custom.sectionRight2{2} tcp.custom.sectionRight3{2} 
set tcp.size 									[. . minTcpW]	

endMacro							



define_parameter LayoutA-tcpFxparmLocation 				'Layout A - FX Parameters Section' 4 0 9
define_parameter LayoutA-tcpSendLocation 				'Layout A - Send List Section' 0 0 9
define_parameter LayoutA-tcpFxLocation 					'Layout A - FX List Section' 7 0 9
define_parameter LayoutA-tcpFxembedLocation 			'Layout A - Embedded FX Section' 5 0 9
define_parameter LayoutA-tcpFxparmPin 					'Layout A - FX Parameters Pin' 0 0 1
define_parameter LayoutA-tcpSendPin 					'Layout A - Send List Pin' 0 0 1
define_parameter LayoutA-tcpFxPin 						'Layout A - FX List Pin' 0 0 1
define_parameter LayoutA-tcpFxembedPin 					'Layout A - Embedded FX Pin' 0 0 1
define_parameter LayoutA-tcpFxparmVisflag1 				'Layout A - tcpFxparmVisflag1' -1 -1 1
define_parameter LayoutA-tcpFxparmVisflag2 				'Layout A - tcpFxparmVisflag2' 1 -1 1
define_parameter LayoutA-tcpSectionBottomDiv 			'Layout A - tcpSectionBottomDiv' 2 1 3
define_parameter LayoutA-sectionLeftW 					'Layout A - Left Section Width' 75 46 400
define_parameter LayoutA-sectionRightW 					'Layout A - Right Section Width' 75 46 400
define_parameter LayoutA-tcpLabelLength 				'Layout A - TCP Label Length' 100 40 300
define_parameter LayoutA-tcpLabelSize 					'Layout A - TCP Label Font Size' 4 1 5
define_parameter LayoutA-tcpVolumeLength 				'Layout A - TCP Volume Length' 40 40 300
define_parameter LayoutA-tcpInputFontSize 				'Layout A - TCP Input Font Size' 1 1 5
define_parameter LayoutA-tcpRecinputLength 				'Layout A - TCP Input Length' 100 40 300
define_parameter LayoutA-tcpFxparmWidth 				'Layout A - FX Parameters Width' 88 50 200
define_parameter LayoutA-tcpFxMinWidth 					'Layout A - FX Minimum Width' 30 20 200
define_parameter LayoutA-tcpFxMaxWidth 					'Layout A - FX Maximum Width' 88 20 200
define_parameter LayoutA-tcpSendMaxWidth 				'Layout A - Send Maximum Width' 88 26 200
define_parameter LayoutA-tcpMeterWidth 					'Layout A - TCP Meter Width' 20 10 300
define_parameter LayoutA-tcpMeterBorder 				'Layout A - TCP Meter Border' 2 0 8

define_parameter LayoutA-hideTcpLabelBlock 				'Layout A - Visflag Track Label Block' 0 0 15
define_parameter LayoutA-hideTcpRecmon 					'Layout A - Visflag Track Recmon' 4 0 15
define_parameter LayoutA-hideTcpMSBlock					'Layout A - Visflag Track MS Block' 0 0 15		
define_parameter LayoutA-hideTcpIo 						'Layout A - Visflag Track Io' 0 0 15	
define_parameter LayoutA-hideTcpFxBlock					'Layout A - Visflag Track Fx Block' 0 0 15	
define_parameter LayoutA-hideTcpPanBlock 				'Layout A - Visflag Track Pan Block' 1 0 15	
define_parameter LayoutA-hideTcpRecmode					'Layout A - Visflag Track Recmode' 4 0 15	
define_parameter LayoutA-hideTcpInputBlock				'Layout A - Visflag Track Input Block' 4 0 15	
define_parameter LayoutA-hideTcpEnv		 				'Layout A - Visflag Track Env' 1 0 15
define_parameter LayoutA-hideTcpPhase	 				'Layout A - Visflag Track Phase' 1 0 15
define_parameter LayoutA-hideTcpLabelsValues			'Layout A - Visflag Track Labels and Values' 8 0 15
define_parameter LayoutA-hideTcpMeterValues				'Layout A - Visflag Track Meter Values' 8 0 15

drawTcp A 1
Layout "A"
drawTcp A 1
endLayout

Layout "150%_A" "150"
drawTcp A 1.5
endLayout

Layout "200%_A" "200"
drawTcp A 2
endLayout


define_parameter LayoutB-tcpFxparmLocation 				'Layout B - FX Parameters Section' 4 0 9
define_parameter LayoutB-tcpSendLocation 				'Layout B - Send List Section' 0 0 9
define_parameter LayoutB-tcpFxLocation 					'Layout B - FX List Section' 7 0 9
define_parameter LayoutB-tcpFxembedLocation 			'Layout B - Embedded FX Section' 5 0 9
define_parameter LayoutB-tcpFxparmPin 					'Layout B - FX Parameters Pin' 0 0 1
define_parameter LayoutB-tcpSendPin 					'Layout B - Send List Pin' 0 0 1
define_parameter LayoutB-tcpFxPin 						'Layout B - FX List Pin' 0 0 1
define_parameter LayoutB-tcpFxembedPin 					'Layout B - Embedded FX Pin' 0 0 1
define_parameter LayoutB-tcpFxparmVisflag1 				'Layout B - tcpFxparmVisflag1' -1 -1 1
define_parameter LayoutB-tcpFxparmVisflag2 				'Layout B - tcpFxparmVisflag2' 1 -1 1
define_parameter LayoutB-tcpSectionBottomDiv 			'Layout B - tcpSectionBottomDiv' 2 1 3
define_parameter LayoutB-sectionLeftW 					'Layout B - Left Section Width' 75 46 400
define_parameter LayoutB-sectionRightW 					'Layout B - Right Section Width' 75 46 400
define_parameter LayoutB-tcpLabelLength 				'Layout B - TCP Label Length' 100 40 300
define_parameter LayoutB-tcpLabelSize 					'Layout B - TCP Label Font Size' 4 1 5
define_parameter LayoutB-tcpVolumeLength 				'Layout B - TCP Volume Length' 40 40 300
define_parameter LayoutB-tcpInputFontSize 				'Layout B - TCP Input Font Size' 1 1 5
define_parameter LayoutB-tcpRecinputLength 				'Layout B - TCP Input Length' 100 40 300
define_parameter LayoutB-tcpFxparmWidth 				'Layout B - FX Parameters Width' 88 50 200
define_parameter LayoutB-tcpFxMinWidth 					'Layout B - FX Minimum Width' 30 20 200
define_parameter LayoutB-tcpFxMaxWidth 					'Layout B - FX Maximum Width' 88 20 200
define_parameter LayoutB-tcpSendMaxWidth 				'Layout B - Send Maximum Width' 88 26 200
define_parameter LayoutB-tcpMeterWidth 					'Layout B - TCP Meter Width' 20 10 300
define_parameter LayoutB-tcpMeterBorder 				'Layout B - TCP Meter Border' 2 0 8

define_parameter LayoutB-hideTcpLabelBlock 				'Layout B - Visflag Track Label Block' 0 0 15
define_parameter LayoutB-hideTcpRecmon 					'Layout B - Visflag Track Recmon' 0 0 15
define_parameter LayoutB-hideTcpMSBlock					'Layout B - Visflag Track MS Block' 0 0 15	
define_parameter LayoutB-hideTcpIo 						'Layout B - Visflag Track Io' 0 0 15	
define_parameter LayoutB-hideTcpFxBlock					'Layout B - Visflag Track Fx Block' 0 0 15	
define_parameter LayoutB-hideTcpPanBlock 				'Layout B - Visflag Track Pan Block' 0 0 15	
define_parameter LayoutB-hideTcpRecmode					'Layout B - Visflag Track Recmode' 0 0 15	
define_parameter LayoutB-hideTcpInputBlock				'Layout B - Visflag Track Input Block' 0 0 15	
define_parameter LayoutB-hideTcpEnv		 				'Layout B - Visflag Track Env' 0 0 15
define_parameter LayoutB-hideTcpPhase	 				'Layout B - Visflag Track Phase' 0 0 15
define_parameter LayoutB-hideTcpLabelsValues			'Layout B - Visflag Track Labels and Values' 0 0 15
define_parameter LayoutB-hideTcpMeterValues				'Layout B - Visflag Track Meter Values' 8 0 15

Layout "B"
drawTcp B 1
endLayout

Layout "150%_B" "150"
drawTcp B 1.5
endLayout

Layout "200%_B" "200"
drawTcp B 2
endLayout


define_parameter LayoutC-tcpFxparmLocation 				'Layout C - FX Parameters Section' 4 0 9
define_parameter LayoutC-tcpSendLocation 				'Layout C - Send List Section' 0 0 9
define_parameter LayoutC-tcpFxLocation 					'Layout C - FX List Section' 0 0 9
define_parameter LayoutC-tcpFxembedLocation 			'Layout C - Embedded FX Section' 5 0 9
define_parameter LayoutC-tcpFxparmPin 					'Layout C - FX Parameters Pin' 0 0 1
define_parameter LayoutC-tcpSendPin 					'Layout C - Send List Pin' 0 0 1
define_parameter LayoutC-tcpFxPin 						'Layout C - FX List Pin' 0 0 1
define_parameter LayoutC-tcpFxembedPin 					'Layout C - Embedded FX Pin' 0 0 1
define_parameter LayoutC-tcpFxparmVisflag1 				'Layout C - tcpFxparmVisflag1' 1 -1 1
define_parameter LayoutC-tcpFxparmVisflag2 				'Layout C - tcpFxparmVisflag2' 1 -1 1
define_parameter LayoutC-tcpSectionBottomDiv 			'Layout C - tcpSectionBottomDiv' 2 1 3
define_parameter LayoutC-sectionLeftW 					'Layout C - Left Section Width' 75 46 400
define_parameter LayoutC-sectionRightW 					'Layout C - Right Section Width' 75 46 400
define_parameter LayoutC-tcpLabelLength 				'Layout C - TCP Label Length' 140 40 300
define_parameter LayoutC-tcpLabelSize 					'Layout C - TCP Label Font Size' 4 1 5
define_parameter LayoutC-tcpVolumeLength 				'Layout C - TCP Volume Length' 140 40 300
define_parameter LayoutC-tcpInputFontSize 				'Layout C - TCP Input Font Size' 1 1 5
define_parameter LayoutC-tcpRecinputLength 				'Layout C - TCP Input Length' 140 40 300
define_parameter LayoutC-tcpFxparmWidth 				'Layout C - FX Parameters Width' 88 50 200
define_parameter LayoutC-tcpFxMinWidth 					'Layout C - FX Minimum Width' 30 20 200
define_parameter LayoutC-tcpFxMaxWidth 					'Layout C - FX Maximum Width' 88 20 200
define_parameter LayoutC-tcpSendMaxWidth 				'Layout C - Send Maximum Width' 88 26 200
define_parameter LayoutC-tcpMeterWidth 					'Layout C - TCP Meter Width' 100 10 300
define_parameter LayoutC-tcpMeterBorder 				'Layout C - TCP Meter Border' 2 0 8

define_parameter LayoutC-hideTcpLabelBlock 				'Layout C - Visflag Track Label Block' 0 0 15
define_parameter LayoutC-hideTcpRecmon 					'Layout C - Visflag Track Recmon' 4 0 15
define_parameter LayoutC-hideTcpMSBlock					'Layout C - Visflag Track MS Block' 0 0 15	
define_parameter LayoutC-hideTcpIo 						'Layout C - Visflag Track Io' 0 0 15	
define_parameter LayoutC-hideTcpFxBlock					'Layout C - Visflag Track Fx Block' 0 0 15	
define_parameter LayoutC-hideTcpPanBlock 				'Layout C - Visflag Track Pan Block' 1 0 15	
define_parameter LayoutC-hideTcpRecmode					'Layout C - Visflag Track Recmode' 4 0 15	
define_parameter LayoutC-hideTcpInputBlock				'Layout C - Visflag Track Input Block' 0 0 15	
define_parameter LayoutC-hideTcpEnv		 				'Layout C - Visflag Track Env' 1 0 15
define_parameter LayoutC-hideTcpPhase	 				'Layout C - Visflag Track Phase' 1 0 15
define_parameter LayoutC-hideTcpLabelsValues			'Layout C - Visflag Track Labels and Values' 8 0 15
define_parameter LayoutC-hideTcpMeterValues				'Layout C - Visflag Track Meter Values' 0 0 15

Layout "C"
drawTcp C 1
endLayout

Layout "150%_C" "150"
drawTcp C 1.5
endLayout

Layout "200%_C" "200"
drawTcp C 2
endLayout


#<
#>------------------------- MASTER TRACK CONTROL PANEL --------------------------------


macro masterFollow this thisW thisH xOffs noSpace

	set thisWs * Scale thisW
	set thisHs * Scale thisH
	set xOffsS * Scale ?xOffs{0} 0 .
	set thisXMargin * Scale !noSpace{0} xMargin 0
	set thisYMargin * Scale yMargin{0}
	set this + + + [previous previous] [previous{2}] [thisXMargin 0 thisWs{0} thisHs{0}] [xOffs{0}] ; position it at the end of the current row
	
	set sectionRHS + masterTcpSectionMainMargin{0} masterTcpSectionMainMargin{2}
	set thisRHS + this{0} this{2}
	set thisBS + this{1} this{3}
	
; if it'll fit in this row, its already there now, use it to possbly set a new biggestY
	set biggestY thisRHS{0}<=sectionRHS{0} thisBS{0}>biggestY{0} thisBS{0} .  

; -- move to next row--	
; if it WON'T fit in this row, use it to start the next row at biggestY + thisYMargin	
	set this thisRHS{0}>sectionRHS{0} + [masterTcpSectionMainMargin thisYMargin{0} this this] [0 biggestY{0}] .
; it didn't fit in the row, so it was used (in previous line) to start the next row, which means it will now be the new biggestY
	set biggestY thisRHS{0}>sectionRHS{0} + this{1} this{3}
; it didn't fit in the row, so it was used to start the next row, so the containing section will now need extra height
	set masterTcpSectionMain thisRHS{0}>sectionRHS{0} + + [0 0 0 this{1}] [masterTcpSectionMain masterTcpSectionMain masterTcpSectionMain this] [0 0 0 masterTcpSectionMainMargin{1}]
	
; -- cull if it extends below the height of the panel --	
	set thisBS + this{1} this{3} ; do that again because it might have moved rows
	set this thisBS{0}>h [this this 0 this] !previous{3} [this this 0 0] .   ; cull method is to set width to zero
	
; -- cull if it is itself too wide for the section
	set thisWPlus2Margins + this{2} * Scale + xMargin{0} xMargin{0}
	set this thisWPlus2Margins{0}>masterTcpSectionMain{2} [this this 0 0] .
	
; -- cull if previous element is zero height
	set this previous{3}==0 [this this 0 0] .

	set previous this
	
endmacro

define_parameter masterTcpMeterWidth 				'Master TCP Meter Width' 100 10 600
define_parameter masterTcpMeterBorder 				'Master TCP Meter Border' 2 0 8
define_parameter masterTcpMeterVals					'Master TCP Meter Values' 1 0 1
define_parameter masterTcpVals						'Master TCP Values' 1 0 1
define_parameter masterTcpLabels					'Master TCP Labels' 1 0 1
define_parameter masterTcpBgColR 					'Master TCP background colour' ${rgb::coords(main.lower.like).red} 0 255
define_parameter masterTcpBgColG 					'Master TCP background colour G' ${rgb::coords(main.lower.like).green} 0 255
define_parameter masterTcpBgColB 					'Master TCP background colour B' ${rgb::coords(main.lower.like).blue} 0 255
define_parameter masterTcpVolumeLength 				'Master TCP Volume Length' 40 40 600


macro drawMasterTcp Scale

set master.tcp.size									[300 100 500]

custom master.tcp.custom.sectionMeter
	set masterTcpMeterWidthS						* Scale masterTcpMeterWidth{0}
	set master.tcp.custom.sectionMeter 				- [w 0 masterTcpMeterWidthS{0} h] [masterTcpMeterWidthS{0}]
	set master.tcp.custom.sectionMeter.color 		[0 0 0 0 ${lower_bg.rgba()}]
set masterTcpMeterBorderS							* Scale masterTcpMeterBorder{0}
set master.tcp.meter 								+ + master.tcp.custom.sectionMeter [masterTcpMeterBorderS{0} masterTcpMeterBorderS{0}] * -2 [0 0 masterTcpMeterBorderS{0} masterTcpMeterBorderS{0}]
	set master.tcp.meter.vu.div                    	[masterTcpMeterBorderS{0}]
	set master.tcp.meter.readout.color             	!masterTcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(5.0 / 6).rgba() /* NOTE it was rgb */}]
	set master.tcp.meter.scale.color.lit.bottom    	!masterTcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set master.tcp.meter.scale.color.lit.top       	!masterTcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set master.tcp.meter.scale.color.unlit.bottom  	!masterTcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]
	set master.tcp.meter.scale.color.unlit.top     	!masterTcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]	

set masterTcpSectionMain							+ - [0 0 w] [0 0 master.tcp.custom.sectionMeter{2}] * Scale + [0 0 0 20] * 2 [0 0 0 sectionMargin{0}] 
	set masterTcpSectionMainMargin					+ masterTcpSectionMain * Scale + [sectionMargin{0} sectionMargin{0}] * -2 [0 0 sectionMargin{0} sectionMargin{0}]
	
set masterTcpSelectColRatio 					?track_selected / selectStrength{0} 100 0	
set masterTcpCol								+ * - 1 masterTcpSelectColRatio \
													[masterTcpBgColR masterTcpBgColG masterTcpBgColB] \
												* masterTcpSelectColRatio [${lab::mix(main.lower.like, main.lower.text, 0.5).rgb()}] 													
brightnessFromRGB 								masterTcpCol{0} masterTcpCol{1} masterTcpCol{2} masterTcpColBrightness	

;reset values for 'masterFollow' macro
set biggestY 0
set xOffs 0
set noSpace 0

set previous									+ [masterTcpSectionMainMargin masterTcpSectionMainMargin] * Scale [0 0 0 20] 
set masterTcpVolumeLength 						masterTcpVolumeLength{0}==40 20 . ; convert to a knob
custom master.tcp.custom.labelBlock 			'' 0 '' 'tcp_labelBlock_bg'
custom master.tcp.custom.labelBlockSel 			'' 0 '' 'tcp_labelBlock_bg_sel'
set masterTcpVolLabelBlockW						+ masterTcpVolumeLength{0} ?masterTcpLabels{0} 68 0
set master.tcp.size								* Scale + + [. . masterTcpVolLabelBlockW{0}] [0 0 masterTcpMeterWidth{0}] * 2 [0 0 sectionMargin{0}] ; set the y-axis tooSmall
masterFollow masterTcpLabelBlock				masterTcpVolLabelBlockW{0} 20 0 1	
	set master.tcp.custom.labelBlock 			?selInvertLabels{0} ?track_selected [0] masterTcpLabelBlock masterTcpLabelBlock
	set master.tcp.custom.labelBlockSel			?selInvertLabels{0} ?track_selected masterTcpLabelBlock [0] [0]
	set master.tcp.label						+ [masterTcpLabelBlock masterTcpLabelBlock] * Scale ?masterTcpLabels{0} [0 0 68 20] [0 0 0 20]
	set master.tcp.label.color					* textBrightnessMult{0} [${main.lower.text.rgb()}]
	set master.tcp.label.color					?selInvertLabels{0} ?track_selected [${main.lower.like.rgb()}] . .
	set master.tcp.label.font					+ 3 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
set master.tcp.volume							- + + [masterTcpLabelBlock masterTcpLabelBlock masterTcpLabelBlock] [master.tcp.label{2}] * Scale [0 0 0 20] [0 0 master.tcp.label]
set masterTcpVolLabelW							masterTcpVals{0}>0 48 0
masterFollow master.tcp.volume.label			masterTcpVolLabelW{0} 20 0 1
	set master.tcp.volume.label.font			+ 1 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set master.tcp.volume.label.color			* textBrightnessMult{0} masterTcpColBrightness{0}<150 [${main.lower.text.rgb()}] [38 38 38]
	set master.tcp.volume.label.margin			* Scale [6 0 0 0 0]
masterFollow master.tcp.mute 					20 20 0 0
masterFollow master.tcp.solo				 	20 20 0 1
masterFollow master.tcp.io 				 		30 20 0 0
masterFollow masterTcpFxBlock 					38 20 0 0
set master.tcp.fx								!masterTcpFxBlock{2} [0] + [masterTcpFxBlock masterTcpFxBlock] * Scale [0 0 20 20]
set master.tcp.fxbyp							!masterTcpFxBlock{2} [0] + [master.tcp.fx master.tcp.fx] * Scale [20 0 16 20]
front master.tcp.fxbyp 
set masterTcpPanBlockW							trackpanmode<=3 masterTcpVals{0}>0 58 20 trackpanmode==5 masterTcpVals{0}>0 80 42 trackpanmode==6 masterTcpVals{0}>0 100 60
masterFollow masterTcpPanBlock 					masterTcpPanBlockW 20 0 0
	custom master.tcp.custom.panBlock
	set master.tcp.custom.panBlock				?visSections masterTcpPanBlock [0]
	set master.tcp.custom.panBlock.color 		?visSections [0 0 0 0 255 255 100 255] [0 0 0 0 0 0 0]

set masterPanLabelW								* Scale masterTcpVals{0}>0 38 0
set master.tcp.pan.label						!masterTcpPanBlock{2} [0] trackpanmode<=3 + [masterTcpPanBlock masterTcpPanBlock masterPanLabelW{0}] * Scale [0 0 0 20] \
													+ + [masterTcpPanBlock masterTcpPanBlock masterPanLabelW{0}] \
													* Scale [0 0 0 10] trackpanmode==6 * Scale [0 10] [0]
	set master.tcp.pan.label.color				* textBrightnessMult{0} masterTcpColBrightness{0}<150 [${main.lower.text.rgb()}] [38 38 38]
	set master.tcp.pan.label.margin				+ [0 0 0 0 1] * Scale [0 0 4]
	set master.tcp.pan.label.font				+ 1 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
set master.tcp.pan								!masterTcpPanBlock{2} [0] trackpanmode<6 + + [master.tcp.pan.label master.tcp.pan.label] [master.tcp.pan.label{2}] * Scale [0 0 20 20] \
																				   + + [ masterTcpPanBlock masterTcpPanBlock] [master.tcp.pan.label{2}] * Scale [0 10 62 10]
	set master.tcp.pan.fadermode				trackpanmode==6 [-1] [1]
set master.tcp.width							!masterTcpPanBlock{2} [0] trackpanmode<=3 [0] trackpanmode<6 + + [master.tcp.pan master.tcp.pan] [master.tcp.pan{2}] * Scale [2 0 20 20] \
																									   + + [masterTcpPanBlock masterTcpPanBlock] [master.tcp.pan.label{2}] * Scale [0 0 62 10]
	set master.tcp.width.fadermode				master.tcp.pan.fadermode
set master.tcp.width.label						!masterTcpPanBlock{2} [0] trackpanmode<=3 [0] trackpanmode<6 + [master.tcp.pan.label master.tcp.pan.label masterPanLabelW{0}] * Scale [0 10 0 10] \
																									   + [masterTcpPanBlock masterTcpPanBlock masterPanLabelW{0}] * Scale [0 0 0 10]
	set master.tcp.width.label.color			master.tcp.pan.label.color
	set master.tcp.width.label.margin			master.tcp.pan.label.margin
	set master.tcp.width.label.font				+ 1 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]

masterFollow master.tcp.env 				 	40 20 0 0
set masterTcpMonoW								?masterTcpLabels{0} 44 20
masterFollow master.tcp.mono 				  	masterTcpMonoW{0} 20 0 0

set masterTcpSelDotY							* 0.5 h<masterTcpSectionMain{3} h masterTcpSectionMain{3}
custom master.tcp.custom.tcp_selectionDot 		'' 0 '' 'tcp_selectionDot'
set master.tcp.custom.tcp_selectionDot 			!selDot{0} [0] ?track_selected [0] + + [masterTcpSectionMain masterTcpSectionMain] [masterTcpSectionMain{2} masterTcpSelDotY{0}] * Scale [-4 -4 8 8]
custom master.tcp.custom.tcp_selectionDotSel	'' 0 '' 'tcp_selectionDot_sel'	
set master.tcp.custom.tcp_selectionDotSel 		!selDot{0} [0] !track_selected [0] + + [masterTcpSectionMain masterTcpSectionMain] [masterTcpSectionMain{2} masterTcpSelDotY{0}] * Scale [-4 -4 8 8]
front master.tcp.custom.tcp_selectionDot master.tcp.custom.tcp_selectionDotSel

custom master.tcp.custom.sectionMain																
	set master.tcp.custom.sectionMain			masterTcpSectionMain
	set master.tcp.custom.sectionMain.color 	?visSections [0 0 0 0 50 50 255 100] [0 0 0 0 masterTcpCol{0} masterTcpCol{1} masterTcpCol{2} 255]

custom master.tcp.custom.sectionBottom
	set master.tcp.custom.sectionBottom 		- [0 masterTcpSectionMain{3} masterTcpSectionMain h] [0 0 0 masterTcpSectionMain{3}] 
	set master.tcp.custom.sectionBottom.color 	?visSections [0 0 0 0 100 255 100 150] [0 0 0 0 ${lower_bg.rgba()}]	
	set masterTcpSectionBottomMargin			+ master.tcp.custom.sectionBottom * Scale * sectionMargin{0} [1 1 -2 -2]

set master.tcp.fxparm							masterTcpSectionBottomMargin
	set master.tcp.fxparm.margin 				* Scale [3 0 4 0 1 0 0 4]
	set master.tcp.fxparm.font 					+ * Scale [0 24 60 LayoutA-tcpFxparmWidth{0}] + [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	
endMacro

drawMasterTcp 1
Layout "A"
drawMasterTcp 1
endLayout

Layout "150%_A" "150"
drawMasterTcp 1.5
endLayout

Layout "200%_A" "200"
drawMasterTcp 2
endLayout	
	
	
	
#<
#> -------------------------- ENVELOPE CONTROL PANELS ---------------------------------

macro envFollow this thisW thisH xOffs noSpace
	
	set thisWs * Scale thisW
	set thisHs * Scale thisH
	set xOffsS * Scale xOffs
	set thisXMargin * Scale !noSpace{0} xMargin 0
	set thisYMargin * Scale yMargin
	set this + + + [previous previous] [previous{2}] [thisXMargin 0 thisWs thisHs] [xOffsS] ; position it at the end of the current row
	set this ?hide_##this{0} + [previous] [previous{2} . 0 .] . ; apply hide by setting w to zero and ignoring both thisXMargin and xOffs
	
	set sectionRHS + envcp.custom.sectionMain{0} envcp.custom.sectionMain{2}
	set thisRHS + this{0} this{2}
	set thisBS + this{1} this{3}
	
; if it'll fit in this row, its already there now, use it to possbly set a new biggestY
	set biggestY thisRHS{0}<=sectionRHS{0} thisBS{0}>biggestY{0} thisBS{0} .  

; -- move to next row--	
; if it WON'T fit in this row, use it to start the next row at biggestY + thisYMargin	
	set this thisRHS{0}>sectionRHS{0} + [envMargin thisYMargin{0} this this] [0 biggestY{0}]
; it didn't fit in the row, so it was used (in previous line) to start the next row, which means it will now be the new biggestY
	set biggestY thisRHS{0}>sectionRHS{0} + this{1} this{3}
	
; -- cull if it extends below the height of the panel --	
	set thisBS + this{1} this{3} ; do that again because it might have moved rows
	set this thisBS{0}>h \
				h<singleRowH{0} \
					this{1}>thisYMarginPlus10{0} [this this 0 0] . \
					[this this 0 this] \
				!previous{3} [this this 0 0] .   ; cull method is to set width to zero
	
; -- cull if it is itself too wide for the section
	set thisWPlus2Margins + + this{2} thisXMargin{0} thisXMargin{0}}
	set this thisWPlus2Margins{0}>envcp.custom.sectionMain{2} [this this 0 0] .
	
; -- cull if previous element is zero height
	set this previous{3}==0 [this this 0 0] .
	
; -- this is the new previous	
	set previous this
	
endmacro


define_parameter indentEnvcp 						'Env inherit track indent' 1 0 1
define_parameter showEnvValue 						'Show envelope value' 1 0 1
define_parameter envcpLabelLength 					'Env Label Length' 160 40 300
define_parameter envcpFaderLength 					'Env Fader Length' 100 40 300
define_parameter envcpFontSize 						'Env Label Font Size' 2 1 5
define_parameter envcpDivOpacity 					'Env Div Opacity' 80 0 255
define_parameter envcpBgColR 						'EnvCP background colour' ${rgb::coords(main.lower.like).red} 0 255
define_parameter envcpBgColG 						'EnvCP background colour G' ${rgb::coords(main.lower.like).green} 0 255
define_parameter envcpBgColB 						'EnvCP background colour B' ${rgb::coords(main.lower.like).blue} 0 255
define_parameter envCustomColorDepth 				'Env Custom Color Strength' 0 0 100

set envCustomColorRatio 							?trackcolor_valid / envCustomColorDepth{0} 100 0

macro drawEnvCP Scale

set envcp.size										* Scale [300 100 40] 
set singleRowH 										* Scale + 20 * 2 sectionMargin{0}
set ySqueeze 										h<singleRowH{0} - * Scale sectionMargin{0} * 0.5 - singleRowH{0} h * Scale sectionMargin{0}	
set thisTcpfolderIndentS							* Scale thisTcpfolderIndent{0}
custom envcp.custom.sectionMain	
	set envcp.custom.sectionMain					?indentEnvcp{0} - [thisTcpfolderIndentS{0} ySqueeze w h] [0 0 thisTcpfolderIndentS{0}] [0 ySqueeze w h] 
	set envcp.custom.sectionMain.color				?visSections [0 0 0 0 100 255 150 150] [0 0 0 0 0 0 0 0]
set biggestY 0
set xOffs 0
set noSpace 0
set envMargin										?indentEnvcp{0} + tcpfolderBalanceType==2 * Scale tcpFolderBalancer 0 + envcp.custom.sectionMain * Scale sectionMargin{0} * Scale sectionMargin{0} 
set previous										+ [envMargin envcp.custom.sectionMain] * Scale [0 0 0 20]
	
set hide_envcpLabelBlock							0
set hide_envcp.fader								0
set hide_envcp.value								?showEnvValue{0} 0 1
set hide_envcp.mod									envcp_type==4 0 1	; 4 if FX envelope (can display additional controls)
set hide_envcp.learn								envcp_type==4 0 1
set hide_envcp.hide									0											

;reset values for 'envFollow' macro
set biggestY 0
set xOffs 0
set noSpace 0
														
set thisEnvcpLabelLength							?indentEnvcp{0} tcpfolderBalanceType==1 + envcpLabelLength tcpFolderBalancer envcpLabelLength envcpLabelLength
set envcpFaderLength 								envcpFaderLength{0}<=40 20 .
set envcpLabelBlockW								+ + + thisEnvcpLabelLength{0} envcpFaderLength{0}<=40 20 0 20 15 ; 20 is the recarm width, 15 is the bypass width
envFollow envcpLabelBlock	 						envcpLabelBlockW{0} 20 0 1

custom envcp.custom.labelBlock 					
	custom envcp.custom.labelBlockBg 				'' 0 '' 'tcp_labelBlock_bg'
	custom envcp.custom.labelBlockBgSel				'' 0 '' 'tcp_labelBlock_bg_sel'
	set envcp.custom.labelBlockBg					?selInvertLabels{0} ?env_selected [0] envcpLabelBlock envcpLabelBlock
	set envcp.custom.labelBlockBgSel				?selInvertLabels{0} ?env_selected envcpLabelBlock [0] [0]

set envcp.arm  										envcpLabelBlock{2}==0 [0] + [envcpLabelBlock envcpLabelBlock] * Scale [2 0 20 20]
set envcp.bypass  									envcpLabelBlock{2}==0 [0] + + [envcp.arm envcp.arm] * Scale [2 0 14 20] [envcp.arm{2}]

set envcp.label   									envcpLabelBlock{2}==0 [0] + + [envcp.bypass envcp.bypass] * Scale [0 0 thisEnvcpLabelLength{0} 20] [envcp.bypass{2}]
set envcp.label.margin     							* Scale [2 0 4 0 0]
	set envcp.label.color							* textBrightnessMult{0} ?selInvertLabels{0} ?env_selected [${lower_bg.rgb()}] [${main.lower.text.rgb()}] [${main.lower.text.rgb()}] 
	set envcp.label.font							+ [envcpFontSize] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]

set envFaderXoffset									envcpFaderLength{0}<=40 -20 6
envFollow envcp.fader 	 							envcpFaderLength{0} 20 envFaderXoffset{0} 0
	set envcp.fader.fadermode 						envcpFaderLength{0}<=40 [1] [0]
	
; Calculate background color color now, for use in text brightness judgement	
set envSelectColRatio 							?env_selected / selectStrength{0} 100 0
set envcpCol									+ * - 1 envSelectColRatio + \
													* envCustomColorRatio [trackcolor_r trackcolor_g trackcolor_b] \
													* - 1 envCustomColorRatio [envcpBgColR envcpBgColG envcpBgColB] \
												* envSelectColRatio [${lab::mix(main.lower.like, main.lower.text, 0.5).rgb()}] 
brightnessFromRGB 								envcpCol{0} envcpCol{1} envcpCol{2} envcpColBrightness	

envFollow envcp.value 	 							52 20 4 0	
	set envcp.value.font       						+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set envcp.value.color      						* textBrightnessMult{0} envcpColBrightness{0}<120 [${main.lower.text.rgb()}] [${lower_bg.rgb()}]
	set envcp.value.margin     						* Scale [0 0 0 0 0]
envFollow envcp.mod 								20 20 0 0
envFollow envcp.learn								20 20 0 0
envFollow envcp.hide								36 20 0 0

custom envcp.custom.indentInfill
	set envcp.custom.indentInfill					?indentEnvcp{0} * Scale [0 0 thisTcpfolderIndent{0} h] [0 0 0 0]
	set envcp.custom.indentInfill.color				[0 0 0 0 ${main.lower.like.rgb()}]

custom envcp.custom.envcpDiv
	set envcp.custom.envcpDiv 						- [0 h w 1] [0 1]
	set envcp.custom.envcpDiv.color 				* Scale [0 0 0 0 0 0 0 envcpDivOpacity{0}]

custom envcp.custom.sectionMainBg
	set envcp.custom.sectionMainBg					[envcp.custom.sectionMain 0 envcp.custom.sectionMain h]
	set envcp.custom.sectionMainBg.color			?visSections [0 0 0 0 255 50 255 60] [0 0 0 0 envcpCol{0} envcpCol{1} envcpCol{2} 255]

endMacro

drawEnvCP 1
Layout "A"
drawEnvCP 1
endLayout

Layout "150%_A" "150"
drawEnvCP 1.5
endLayout

Layout "200%_A" "200"
drawEnvCP 2
endLayout

#<
#>---------------------------------- THE MIXER ----------------------------------------

;-- GLOABL TCP PARAMS --

define_parameter mcpfolderIndentSize		'MCP Folder Indent' 10 0 40
define_parameter mcpDivOpacity 				'MCP Div Opacity' 80 0 255
${ let rgb = rgb::coords(lab::mix(main.lower.like, main.lower.text, 0.1)); `
define_parameter mcpBgColR 					'MCP background colour' ${rgb.red} 0 255
define_parameter mcpBgColG 					'MCP background colour G' ${rgb.green} 0 255
define_parameter mcpBgColB 					'MCP background colour B' ${rgb.blue} 0 255` }
define_parameter mcpfolderBalanceType		'MCP Folder Balance Type' 0 0 1


macro mcpFollow this thisW thisH yOffs noSpace Form

	set thisWs * Scale thisW
	set thisHs * Scale thisH
	set yOffsS * Scale yOffs
	set thisYMargin * Scale !noSpace{0} 6 0 ; hard coding margin as 6
	
	set this mcpForm{0}==Form{0} + + + [previous previous] [0 previous{3}] [0 thisYMargin{0} thisWs thisHs] [0 yOffsS]
	set this mcpForm{0}==Form{0} ?hide_##this{0} + [previous previous] [0 previous{3} . 0] . ; apply hide by setting h to zero and ignoring both thisYMargin and yOffs
	
	set thisBS	mcpForm{0}==Form{0} + + this{1} this{3} thisYMargin{0}
	set sectionButtonsBS mcpForm{0}==Form{0} + mcp.custom.sectionButtons{1} mcp.custom.sectionButtons{3}
	set this mcpForm{0}==Form{0} thisBS{0}>sectionButtonsBS{0} [. . . 0] . ; cull if extending below buttons section
	set biggestY mcpForm{0}==Form{0} thisBS{0}>biggestY{0} thisBS{0}

	; -- this is the new previous	
	set previous mcpForm{0}==Form{0} this
	
endMacro


macro drawMcp thisLayout Scale

;-- HOUSEKEEPING --

clear mcp.*

set thisMcpfolderIndent						* folderdepth mcpfolderIndentSize
set hAfterIndent							- h * Scale thisMcpfolderIndent{0}

set mcpStripInputHeight						Layout##thisLayout##-mcpStripInputHeight{0}==30 0 Layout##thisLayout##-mcpStripInputHeight ; interpret that minimum height means hide it
set mcpStripVolumeHeight					* Scale Layout##thisLayout##-mcpStripVolumeHeight==80 20 Layout##thisLayout##-mcpStripVolumeHeight ; convert to a knob below 80
set mcpStripVolumeHeight					hAfterIndent{0}<Layout##thisLayout##-mcpStripVolKnobAtH{0} * Scale 20 . ; convert to a knob below mcpStripVolKnobAtH

set mcpNchanGrowPx							tracknch<3 0 * - tracknch 2 ?recarm Layout##thisLayout##-mcpNchanGrowRecarm ?track_selected Layout##thisLayout##-mcpNchanGrowSel Layout##thisLayout##-mcpNchanGrow
set mcpWidth 								* Scale + mcpNchanGrowPx{0} ?recarm Layout##thisLayout##-mcpWidthRecarm ?track_selected Layout##thisLayout##-mcpWidthSel Layout##thisLayout##-mcpWidth
set mcpFormW								* Scale [52 88]
set mcpForm									mcpWidth{0}<mcpFormW{0} [1] mcpWidth{0}<mcpFormW{1} [2] [3] ; 1=Strip, 2=Intermediate, 3=Normal
set addSidebar								?recarm ?Layout##thisLayout##-mcpSidebarRecarm 1 0 ?track_selected ?Layout##thisLayout##-mcpSidebarSel 1 0 ?Layout##thisLayout##-mcpSidebar 1 0
set sidebarWidth							* Scale ?addSidebar{0} Layout##thisLayout##-sidebarWidth 0
												


;-- SECTIONS --

; custom mcp.custom.measure
	; set mcp.custom.measure.color [0 0 0 0 255 0 0 255]
	; set mcp.custom.measure [0 0 20 hAfterIndent{0}]
	; front mcp.custom.measure


custom mcp.custom.mcpDiv
	set mcp.custom.mcpDiv 					- [0 0 1 h] * Scale [0 0 0 thisMcpfolderIndent{0}]
	set mcp.custom.mcpDiv.color 			* Scale [0 0 0 0 0 0 0 mcpDivOpacity{0}]

; calculate sectionBottom height
set sectionBottomH							* Scale + 44 thisMcpfolderIndent{0} 
set maxSectionBottomH						* Scale + 44 * mcp_maxfolderdepth mcpfolderIndentSize
set sectionBottomH							?mcpfolderBalanceType{0} maxSectionBottomH  .
set stripSectionBottomH						* Scale + + 20 Layout##thisLayout##-mcpStripLabelHeight * mcp_maxfolderdepth mcpfolderIndentSize

; calculate sectionButtons height
set mcpIntermediateSectionButtonsH			hAfterIndent{0}<Layout##thisLayout##-mcpInterShowSecButtons{0} 0 * Scale !Layout##thisLayout##-verboseMcp{0} 92 102
set mcpStripSectionButtonsH					* Scale hAfterIndent{0}<Layout##thisLayout##-mcpStripSecButAtH{0} 52 \
												+ + !Layout##thisLayout##-verboseMcp{0} 120 130 ?Layout##thisLayout##-mcpStripShowEnv{0} !Layout##thisLayout##-verboseMcp{0} 26 38 0 \
												?Layout##thisLayout##-mcpStripShowPhase{0} 22 0

set centW									* 0.5 mcpWidth{0}											
set firstThirdW								+ sidebarWidth * 0.3333 mcpWidth{0}
set secondThirdW							+ sidebarWidth * 0.6666 mcpWidth{0}	



;--Top Section--

custom mcp.custom.sectionTop 
custom mcp.custom.recinputBg_h				'' 0 '' 'dropdownBg_h'
custom mcp.custom.recinputBg_v				'' 0 '' 'dropdownBg_v'
custom mcp.custom.recmodeBg_h				'' 0 '' 'dropdownBg_h'
custom mcp.custom.recmodeBg_v				'' 0 '' 'dropdownBg_v'

; Normal Width
set mcp.custom.sectionTop					mcpForm{0}==3 + [sidebarWidth 0 mcpWidth{0}] * Scale hAfterIndent{0}>Layout##thisLayout##-mcpNormalShowSecIn{0} [0 0 0 50] [0]
set mcp.custom.recinputBg_v					mcpForm{0}==3 [0]
set mcp.custom.recmodeBg_v					mcpForm{0}==3 [0]
set mcp.custom.recinputBg_h					mcpForm{0}==3 !mcp.custom.sectionTop{3} [0] + [mcp.custom.sectionTop] + [0 0 mcpWidth{0}] * Scale [6 6 -12 20] 
set mcp.recinput							mcp.custom.recinputBg_h
set mcp.custom.recmodeBg_h					mcpForm{0}==3 !mcp.custom.sectionTop{3} [0] + [mcp.custom.sectionTop] * Scale [6 30 40 20] 
set mcp.recmode								mcp.custom.recmodeBg_h 
set mcp.fxin								mcpForm{0}==3 !mcp.custom.sectionTop{3} [0] + + [mcp.custom.sectionTop] [mcp.custom.sectionTop{2}] * Scale [-26 30 20 20] 

; Intermediate Width
set mcp.custom.sectionTop					mcpForm{0}==2 + [sidebarWidth 0 mcpWidth{0}] * Scale hAfterIndent{0}>Layout##thisLayout##-mcpInterShowSecIn{0} [0 0 0 72] [0]
set mcp.custom.recinputBg_h					mcpForm{0}==2 [0]
set mcp.custom.recmodeBg_h					mcpForm{0}==2 [0]
set mcp.custom.recinputBg_v					mcpForm{0}==2 mcp.custom.sectionTop{3}==0 [0] + [secondThirdW{0} 0 0 mcp.custom.sectionTop] * Scale [-6 6 20 -6]
set mcp.recinput							mcpForm{0}==2 mcp.custom.recinputBg_v
set mcp.custom.recmodeBg_v					mcpForm{0}==2 mcp.custom.sectionTop{3}==0 [0] + [firstThirdW{0}] * Scale [-12 6 20 40]
set mcp.recmode								mcpForm{0}==2 mcp.custom.recmodeBg_v
set mcp.fxin								mcpForm{0}==2 mcp.custom.sectionTop{3}==0 [0] + + [mcp.recmode mcp.recmode] [0 mcp.recmode{3}] * Scale [0 6 20 20]

; Strip Width
set mcp.custom.sectionTop					mcpForm{0}==1 + [sidebarWidth 0 mcpWidth{0}] * Scale hAfterIndent{0}<Layout##thisLayout##-mcpStripSecInAtH{0} [0] \
												+ + + ?Layout##thisLayout##-mcpStripShowRecmode{0} [0 0 0 46] [0] \
												?Layout##thisLayout##-mcpStripShowFxIn{0} [0 0 0 26] [0] [0 0 0 mcpStripInputHeight{0}] mcpStripInputHeight{0}>0 [0 0 0 6] [0 0 0 0]
set sectionTopCentW							* 0.5 mcp.custom.sectionTop{2}
set mcp.custom.recinputBg_h					mcpForm{0}==1 [0]
set mcp.custom.recmodeBg_h					mcpForm{0}==1 [0]												
set mcp.custom.recinputBg_v					mcpForm{0}==1 !mcp.custom.sectionTop{3} [0] + + [mcp.custom.sectionTop] [sectionTopCentW{0}] * Scale [-10 6 20 mcpStripInputHeight{0}]
set mcp.recinput							mcpForm{0}==1 mcp.custom.recinputBg_v
set mcp.custom.recmodeBg_v					mcpForm{0}==1 !mcp.custom.sectionTop{3} [0] + + + [mcp.recinput mcp.recinput] [0 mcp.recinput{3}] mcp.recinput{3}>0 * Scale [0 6] [0] ?Layout##thisLayout##-mcpStripShowRecmode{0} * Scale [0 0 20 40] [0]
set mcp.recmode								mcpForm{0}==1 mcp.custom.recmodeBg_v
set mcp.fxin								mcpForm{0}==1 !mcp.custom.sectionTop{3} [0] + + [mcp.recmode mcp.recmode] [0 mcp.recmode{3}] ?Layout##thisLayout##-mcpStripShowFxIn{0} * Scale mcp.recmode{3}>0 [0 6 20 20] [0 0 20 20] [0] 

set mcp.custom.sectionTop.color 			?visSections [0 0 0 0 255 100 100 150] [0 0 0 1 0 0 0 0]
set mcp.recinput.font						+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
set mcp.recinput.color 						* textBrightnessMult{0} [${main.lower.text.rgb()}] 
set mcp.recinput.margin						* Scale mcp.recinput{3}>mcp.recinput{2} [1 4 0 20] [4 1 20 0] 



;--Pan Section--

custom mcp.custom.sectionPan
; Calculate resulting color for use in text brightness judgement	
set mcpMainSecCol								+ * - 1 selectColRatio + \
													* customColorRatio [trackcolor_r trackcolor_g trackcolor_b] \
													* - 1 customColorRatio [mcpBgColR mcpBgColG mcpBgColB] \
												* selectColRatio [255 255 255] 
brightnessFromRGB 								mcpMainSecCol{0} mcpMainSecCol{1} mcpMainSecCol{2} mcpMainSecColBrightness
											
; Normal Width
set mcp.custom.sectionPan 					mcpForm{0}==3 + + [sidebarWidth 0 mcpWidth{0}] [0 mcp.custom.sectionTop{3}] hAfterIndent{0}<Layout##thisLayout##-mcpNormalShowSecPan{0} [0] * Scale !Layout##thisLayout##-verboseMcp{0} [0 0 0 30] [0 0 0 46]
set mcp.custom.sectionPan.color 			mcpForm{0}==3 [0 0 0 1 0 0 0 0]
set mcp.pan.label							mcpForm{0}==3 mcp.custom.sectionPan{3}==0 [0] !Layout##thisLayout##-verboseMcp{0} [mcp.custom.sectionPan mcp.custom.sectionPan] \
												+ [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14]
set mcp.pan.label.margin					mcpForm{0}==3 * [Scale Scale Scale Scale 1] trackpanmode>=4 [12 6 0 0 0] [6 6 6 0 0.5]
set mcp.pan.label.color						mcpForm{0}==3 * textBrightnessMult{0} mcpMainSecColBrightness{0}<150 [${main.lower.text.rgb()}] [${lower_bg.rgb()}]
set mcp.pan									mcpForm{0}==3 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6  + + * Scale [6 14 -12 10] [0 mcp.pan.label{3}] [mcp.pan.label mcp.pan.label mcp.custom.sectionPan] \
												+ + [centW mcp.pan.label{3}] [mcp.custom.sectionPan mcp.pan.label] * Scale trackpanmode>=4 [-20 4 20 20] [-10 4 20 20]
set mcp.width								mcpForm{0}==3 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6 + + * Scale [6 4 -12 10] [0 mcp.pan.label{3}] [mcp.pan.label mcp.pan.label mcp.custom.sectionPan] \
												trackpanmode>=4 + [mcp.pan mcp.pan] * Scale [22 0 20 20] [0]
set mcp.width.label							mcpForm{0}==3 mcp.custom.sectionPan{3}==0 [0] trackpanmode>=4 !Layout##thisLayout##-verboseMcp{0} [0] \
												+ [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14] [0]
set mcp.width.label.margin					mcpForm{0}==3 * [Scale Scale Scale Scale 1] [0 6 12 0 1]

; Intermediate Width
set mcp.custom.sectionPan 					mcpForm{0}==2 + + [sidebarWidth mcp.custom.sectionTop{3} mcpWidth{0}] [0 mcpIntermediateSectionButtonsH{0}] \
												hAfterIndent{0}<Layout##thisLayout##-mcpInterShowSecPan{0} [0] * Scale !Layout##thisLayout##-verboseMcp{0} [0 0 0 30] [0 0 0 46]
set mcp.custom.sectionPan.color 			mcpForm{0}==2 [0 0 0 1 0 0 0 0]
set mcp.pan.label							mcpForm{0}==2 mcp.custom.sectionPan{3}==0 [0] !Layout##thisLayout##-verboseMcp{0} [0 mcp.custom.sectionPan] \
												+ [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14]
set mcp.pan.label.margin					mcpForm{0}==2 * [Scale Scale Scale Scale 1] trackpanmode>=4 [4 6 0 0 0] [0 6 0 0 0.5]
set mcp.pan.label.color						mcpForm{0}==2 * textBrightnessMult{0} mcpMainSecColBrightness{0}<150 [220 220 220] [38 38 38]
set mcp.pan									mcpForm{0}==2 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6  + + * Scale [6 14 -12 10] [0 mcp.pan.label{3}] [mcp.pan.label mcp.pan.label mcp.custom.sectionPan] \
												+ + [centW mcp.pan.label{3}] [mcp.custom.sectionPan mcp.pan.label] * Scale trackpanmode>=4 [-20 4 20 20] [-10 4 20 20]
set mcp.width								mcpForm{0}==2 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6 + + * Scale [6 4 -12 10] [0 mcp.pan.label{3}] [mcp.pan.label mcp.pan.label mcp.custom.sectionPan] \
												trackpanmode>=4 + [mcp.pan mcp.pan] * Scale [22 0 20 20] [0]
set mcp.width.label							mcpForm{0}==2 mcp.custom.sectionPan{3}==0 [0] trackpanmode>=4 !Layout##thisLayout##-verboseMcp{0} [0] \
												+ [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14] [0]
set mcp.width.label.margin					mcpForm{0}==2 * [Scale Scale Scale Scale 1] [0 6 4 0 1]										

; Strip Width
set stripMode6yOffs							* Scale 12
set mcpStripShowSecPan 						hAfterIndent{0}<Layout##thisLayout##-mcpStripSecPanAtH{0} 0 Layout##thisLayout##-mcpStripShowSecPan{0}       
set mcp.custom.sectionPan 					mcpForm{0}==1 + + [sidebarWidth mcp.custom.sectionTop{3} mcpWidth{0}] [0 mcpStripSectionButtonsH{0}] \
												!mcpStripShowSecPan{0} [0] * Scale !Layout##thisLayout##-verboseMcp{0} [0 0 0 48] [0 0 0 76]
set mcp.custom.sectionPan.color 			mcpForm{0}==1 [0 0 0 1 ${lower_bg.rgba()}]
set mcp.pan.label							mcpForm{0}==1 mcp.custom.sectionPan{3}==0 [0] !Layout##thisLayout##-verboseMcp{0} [0 mcp.custom.sectionPan] \
												trackpanmode==6 + + [0 stripMode6yOffs{0}] [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 38 0 14] \
												+ [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14] 
set mcp.pan.label.margin					mcpForm{0}==1 * [Scale Scale Scale Scale 1] [0 6 0 0 0.5]	
set mcp.pan.label.color						mcpForm{0}==1 * textBrightnessMult{0} [150 150 150]	
set mcp.pan									mcpForm{0}==1 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6  + + + [0 stripMode6yOffs{0}] * Scale [0 14 0 10] [0 mcp.pan.label{3}] [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] \
												+ + [centW mcp.pan.label{3}] [mcp.custom.sectionPan mcp.pan.label] * Scale trackpanmode>=4 [-10 4 20 20] [-10 14 20 20]
set mcp.width								mcpForm{0}==1 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6 + + + [0 stripMode6yOffs{0}] * Scale [0 4 0 10] [0 mcp.pan.label{3}] [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] \
												trackpanmode>=4 + [mcp.pan mcp.pan] * Scale [0 24 20 20] [0]
set mcp.width.label							mcpForm{0}==1 mcp.custom.sectionPan{3}==0 [0] \
												trackpanmode==6 + [0 stripMode6yOffs{0}] !Layout##thisLayout##-verboseMcp{0} [0] + [mcp.custom.sectionPan mcp.custom.sectionPan mcp.custom.sectionPan] * Scale [0 0 0 14] \
												trackpanmode>=4 !Layout##thisLayout##-verboseMcp{0} [0] + + [mcp.custom.sectionPan mcp.width mcp.custom.sectionPan] * Scale [0 0 0 14] [0 mcp.width{3}]
set mcp.width.label.margin					mcpForm{0}==1 * [Scale Scale Scale Scale 1] [0 6 0 0 0.5]


	set mcp.custom.sectionPan.color 		?visSections{0} [0 0 0 0 100 255 100 100]
	set mcp.pan.label.font					+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set mcp.pan.fadermode					trackpanmode==6 [-1] [1]
	set mcp.width.fadermode					trackpanmode==6 [-1] [1]
	set mcp.width.label.font				+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set mcp.width.label.color				mcp.pan.label.color



;--Button Section--	
	
custom mcp.custom.sectionButtons
set mcpIoH									?Layout##thisLayout##-verboseMcp{0} 32 22
set mcpEnvH									?Layout##thisLayout##-verboseMcp{0} 32 22

; Normal Width
set mcp.custom.sectionButtons				mcpForm{0}==3 + [sidebarWidth] + [mcpWidth{0} mcp.custom.sectionPan] - + * Scale [-32 0 32] [0 mcp.custom.sectionPan{3} 0 h]	\
												+ + [0 0 0 mcp.custom.sectionPan{1}] [0 0 0 mcp.custom.sectionPan{3}] [0 0 0 sectionBottomH{0}]	
set mcp.custom.sectionButtons.color			mcpForm{0}==3 ?Layout##thisLayout##-mcpNormalDarkButtons{0} [0 0 0 1 ${lower_bg.rgba()}] [0 0 0 1 0 0 0 0]

set biggestY								0
set hide_mcp.mute							0
set hide_mcp.solo							0
set hide_mcp.io								!Layout##thisLayout##-mcpNormalShowRoute{0} 1 0
set hide_mcp.fxGroup						!Layout##thisLayout##-mcpNormalShowSecFx{0} 1 0
set hide_mcp.env							!Layout##thisLayout##-mcpNormalShowEnv{0} 1 0
set hide_mcp.phase							!Layout##thisLayout##-mcpNormalShowPhase{0} 1 0
set previous								mcpForm{0}==3 + [mcp.custom.sectionButtons mcp.custom.sectionButtons] * Scale [6 6 0 0] ; Null object	
mcpFollow mcp.mute							20 20 0 1 3
mcpFollow mcp.solo							20 20 0 1 3
mcpFollow mcp.io							20 mcpIoH{0} 0 0 3
mcpFollow mcp.fxGroup						20 36 0 0 3
set mcp.fx									mcp.fxGroup{3}>0 + [mcp.fxGroup mcp.fxGroup] * Scale [0 0 20 20] [0]
set mcp.fxbyp								mcp.fxGroup{3}>0 + + [mcp.fxGroup mcp.fxGroup] [0 mcp.fx{3}] * Scale [0 0 20 16] [0]
mcpFollow mcp.env							20 mcpEnvH{0} 0 0 3
mcpFollow mcp.phase							20 16 0 0 3

; Intermediate Width
set mcp.custom.sectionButtons				mcpForm{0}==2 + [sidebarWidth mcp.custom.sectionTop{3} mcpWidth{0}] [0 0 0 mcpIntermediateSectionButtonsH{0}]
set mcp.custom.sectionButtons.color			mcpForm{0}==2 [0 0 0 1 0 0 0 0]
set mcp.mute								mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [firstThirdW{0}] [0 mcp.custom.sectionButtons] * Scale [-12 6 20 20]
set mcp.solo 								mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [mcp.mute mcp.mute] [0 mcp.mute{3}] * Scale [0 0 20 20]
set mcp.io 									mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [mcp.solo mcp.solo] [0 mcp.solo{3}] * Scale ?Layout##thisLayout##-verboseMcp{0} [0 6 20 32] [0 6 20 22]
set mcp.fx									mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [secondThirdW{0}] [0 mcp.custom.sectionButtons] * Scale [-6 6 20 20]
set mcp.fxbyp 								mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [mcp.fx mcp.fx] [0 mcp.fx{3}] * Scale [0 0 20 16]
set mcp.env 								mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [mcp.fxbyp mcp.fxbyp] [0 mcp.fxbyp{3}] * Scale ?Layout##thisLayout##-verboseMcp{0} [0 6 20 32] [0 6 20 22]
set mcp.phase 								mcpForm{0}==2 mcpIntermediateSectionButtonsH{0}==0 [0] + + [mcp.env mcp.env] [0 mcp.env{3}] * Scale [0 4 20 16]

; Strip Width

set mcp.custom.sectionButtons				mcpForm{0}==1 + [sidebarWidth mcp.custom.sectionTop{3} mcpWidth{0}] [0 0 0 mcpStripSectionButtonsH{0}]	
set mcp.custom.sectionButtons.color			mcpForm{0}==1 [0 0 0 1 0 0 0 0]

set biggestY								0
set hide_mcp.mute							0
set hide_mcp.solo							0
set hide_mcp.io								0
set hide_mcp.fxGroup						0 
set hide_mcp.env							!Layout##thisLayout##-mcpStripShowEnv{0} 1 0
set hide_mcp.phase							!Layout##thisLayout##-mcpStripShowPhase{0} 1 0

set previous								mcpForm{0}==1 + + [mcp.custom.sectionButtons] [centW{0} mcp.custom.sectionButtons] * Scale [-10 6 0 0] ; Null object	
mcpFollow mcp.mute							20 20 0 1 1
mcpFollow mcp.solo							20 20 0 1 1
mcpFollow mcp.io							20 mcpIoH{0} 0 0 1
mcpFollow mcp.fxGroup						20 36 -2 0 1
set mcp.fx									mcpForm{0}==1 mcp.fxGroup{3}>0 + [mcp.fxGroup mcp.fxGroup] * Scale [0 0 20 20] [0]
set mcp.fxbyp								mcpForm{0}==1 mcp.fxGroup{3}>0 + + [mcp.fxGroup mcp.fxGroup] [0 mcp.fx{3}] * Scale [0 0 20 16] [0]
mcpFollow mcp.env							20 mcpEnvH{0} 0 0 1
mcpFollow mcp.phase							20 16 -2 0 1
front mcp.solo
set mcp.custom.sectionButtons.color			?visSections [0 0 0 0 100 100 255 150] 



;--Dark Box Section--	

custom mcp.custom.mcpDarkBox

; Normal Width
set mcp.custom.mcpDarkBox					mcpForm{0}==3 + + [sidebarWidth mcp.custom.sectionPan w h] [0 mcp.custom.sectionPan{3}] \
												* -1 + + [0 0 mcp.custom.sectionButtons sectionBottomH] [0 0 sidebarWidth mcp.custom.sectionPan{1}] [0 0 0 mcp.custom.sectionPan{3}]
set standardDarkBoxMinH						- h + + maxSectionBottomH mcp.custom.sectionPan{1} mcp.custom.sectionPan{3}												
set mcp.volume.label                     	mcpForm{0}==3 !Layout##thisLayout##-verboseMcp{0} [0] + [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox] * Scale [0 0 0 20]
set mcp.meter								mcpForm{0}==3 + + * Scale [4 6 -32 -36] [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox] \
												* [0 1 0 -1] [0 mcp.volume.label{3} 0 mcp.volume.label{3}]
set mcp.volume								mcpForm{0}==3 + + [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox 0 mcp.custom.mcpDarkBox] + [mcp.custom.mcpDarkBox{2}] * Scale [-26 6 25 -36] \
												* [0 1 0 -1] [0 mcp.volume.label{3} 0 mcp.volume.label{3}]
set mcpVolKnobH								* Scale 60												
set mcp.volume								mcpForm{0}==3 mcp.volume{3}<mcpVolKnobH{0} + [. . ] * Scale [0 0 20 20] ; turn into a knob												
set mcp.recarm								mcpForm{0}==3 + + [mcp.volume mcp.volume] * [0.5 1] [mcp.volume{2} mcp.volume{3}] * Scale [-12 4 24 20]
set mcp.recmon								mcpForm{0}==3 + + + [mcp.meter mcp.meter] * Scale [-10 4 20 20] [0 mcp.meter{3}] * 0.5 [mcp.meter{2}]

; Intermediate Width
set mcp.custom.mcpDarkBox					mcpForm{0}==2 + + [sidebarWidth mcp.custom.sectionPan mcpWidth{0} h] [0 mcp.custom.sectionPan{3}] \
														* -1 + + [0 0 0 mcp.custom.sectionPan{1}] [0 0 0 mcp.custom.sectionPan{3}] [0 0 0 sectionBottomH]
set mcp.volume.label                     	mcpForm{0}==2 !Layout##thisLayout##-verboseMcp{0} [0] + [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox] * Scale [0 0 0 20]
set mcp.meter								mcpForm{0}==2 + + * Scale [6 6 -42 -36] [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox] \
												* [0 1 0 -1] [0 mcp.volume.label{3} 0 mcp.volume.label{3}]
set mcp.volume								mcpForm{0}==2 + + [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox 0 mcp.custom.mcpDarkBox] + [mcp.custom.mcpDarkBox{2}] * Scale [-30 6 24 -36] \
												* [0 1 0 -1] [0 mcp.volume.label{3} 0 mcp.volume.label{3}]
set mcpVolKnobH								* Scale 60												
set mcp.volume								mcpForm{0}==2 mcp.volume{3}<mcpVolKnobH{0} + [. . ] * Scale [0 0 20 20] ; turn into a knob												
set mcp.recarm								mcpForm{0}==2 + + [mcp.volume mcp.volume] * [0.5 1] [mcp.volume{2} mcp.volume{3}] * Scale [-12 4 24 20]
set mcp.recmon								mcpForm{0}==2 + + + [mcp.meter mcp.meter] * Scale [-10 4 20 20] [0 mcp.meter{3}] * 0.5 [mcp.meter{2}]

; Strip Width
set mcp.custom.mcpDarkBox					mcpForm{0}==1 + + [sidebarWidth mcp.custom.sectionPan mcpWidth{0} h] [0 mcp.custom.sectionPan{3}] \
														* -1 + + [0 0 0 mcp.custom.sectionPan{1}] [0 0 0 mcp.custom.sectionPan{3}] [0 0 0 stripSectionBottomH]
set stripDarkBoxMinH						* Scale + + ?Layout##thisLayout##-mcpStripShowRecmon{0} 72 48 Layout##thisLayout##-mcpStripMeterHeight mcpStripVolumeHeight{0}
set mcp.custom.mcpDarkBox					mcpForm{0}==1 mcp.custom.mcpDarkBox{3}<stripDarkBoxMinH{0} [. . . stripDarkBoxMinH] . .	; stop strip stretching if too short
set mcp.meter								mcpForm{0}==1 - + mcp.custom.mcpDarkBox * Scale ?Layout##thisLayout##-mcpStripShowRecmon{0} [6 6 -12 -64] [6 6 -12 -42] \
												+ * Scale !Layout##thisLayout##-verboseMcp{0} [0] [0 0 0 20] [0 0 0 mcpStripVolumeHeight] ; 20 will be vol label h
set mcp.volume.label                     	mcpForm{0}==1 !Layout##thisLayout##-verboseMcp{0} [0] + + [mcp.custom.mcpDarkBox mcp.meter mcp.custom.mcpDarkBox] * Scale [0 0 0 20] [0 mcp.meter{3}]
set mcp.volume								mcpForm{0}==1 + + + [centW mcp.custom.mcpDarkBox] [mcp.custom.mcpDarkBox mcp.custom.mcpDarkBox{3}] * Scale ?Layout##thisLayout##-mcpStripShowRecmon{0} [-12 -52 24] [-12 -30 24] \
												* [0 -1 0 1] mcpStripVolumeHeight{0}
set mcp.recarm								mcpForm{0}==1 + + [mcp.volume mcp.volume] * [0.5 1] [mcp.volume{2} mcp.volume{3}] * Scale [-12 8 24 20]
set mcp.recmon								mcpForm{0}==1 ?Layout##thisLayout##-mcpStripShowRecmon{0} + + [mcp.recarm mcp.recarm] * Scale [0 4 20 20] [0 mcp.recarm{3}] [0] 



set mcp.custom.mcpDarkBox.color 			?visSections{0} [0 0 0 0 200 200 0] [0 0 0 0 ${lower_bg.rgb()}]
set mcp.volume.label.color            		* textBrightnessMult{0} [${lab::mix(lower_bg, main.lower.text, 2.0 / 3).rgb()}]
	  set mcp.volume.label.font				+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	  set mcp.volume.label.margin           * [Scale Scale Scale Scale 1] [0 6 0 0 0.5]
set mcp.meter.vu.div                   		* Scale [1 1]
	set mcp.meter.readout.color            	!Layout##thisLayout##-mcpMeterReadout{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(5.0 / 6).rgba()} 255 183 171 255]
	set showMcpMeterVals					?recarm ?Layout##thisLayout##-mcpMeterValsRecarm 1 0 ?track_selected ?Layout##thisLayout##-mcpMeterValsSel 1 0 ?Layout##thisLayout##-mcpMeterVals 1 0
	set mcp.meter.scale.color.lit.bottom   	!showMcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set mcp.meter.scale.color.lit.top      	!showMcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set mcp.meter.scale.color.unlit.bottom 	!showMcpMeterVals{0} [0 0 0 0 0 0 0 0] ?recarm [255 64 0 255 0 0 0 0] + * - textBrightnessMult{0} 1 [0 0 0 100] [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]
	set mcp.meter.scale.color.unlit.top    	!showMcpMeterVals{0} [0 0 0 0 0 0 0 0] ?recarm [255 64 0 255 0 0 0 0] + * - textBrightnessMult{0} 1 [0 0 0 100] [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]


;--Bottom Section & Sidebar--	

custom mcp.custom.sectionBottom
custom mcp.custom.mcpNameBg
custom mcp.custom.indentInfill
custom mcp.custom.mcpIdxBg
custom mcp.custom.mcp_selectionDot 				'' 0 '' 'tcp_selectionDot'
custom mcp.custom.mcp_selectionDotSel			'' 0 '' 'tcp_selectionDot_sel'	
custom mcp.custom.sidebarBg
set mcpFolderBalance						!mcpfolderBalanceType 0  * - mcp_maxfolderdepth folderdepth mcpfolderIndentSize

; Normal Width
set mcp.custom.sectionBottom				mcpForm{0}==3 + [0 mcp.custom.sectionButtons mcpWidth sectionBottomH] [0 mcp.custom.mcpDarkBox{3} sidebarWidth]
set mcp.custom.mcpNameBg 					mcpForm{0}==3 + + [0 mcp.custom.sectionBottom mcpWidth] * Scale + [0 0 0 24] [0 0 0 mcpFolderBalance{0}] [0 0 sidebarWidth]
set mcp.label 								mcpForm{0}==3 mcp.custom.mcpNameBg
set mcp.label.margin 						mcpForm{0}==3 * [Scale Scale Scale Scale 1] [4 0 4 0 0.5]
set mcp.custom.mcpIdxBg 					mcpForm{0}==3 + + [0 mcp.custom.mcpNameBg mcpWidth] * Scale [0 0 0 20] [0 mcp.custom.mcpNameBg{3} sidebarWidth]
set mcp.custom.sidebarBg					mcpForm{0}==3 - [0 0 sidebarWidth{0} h] [0 0 0 mcp.custom.sectionBottom{3}]
set mcp.extmixer.mode        				mcpForm{0}==3 ?addSidebar{0} [1] [-1]

; Intermediate Width
set mcp.custom.sectionBottom				mcpForm{0}==2 + [0 mcp.custom.mcpDarkBox mcpWidth sectionBottomH] [0 mcp.custom.mcpDarkBox{3} sidebarWidth]
set mcp.custom.mcpNameBg 					mcpForm{0}==2 + + [0 mcp.custom.sectionBottom mcpWidth] * Scale [0 0 0 24] [0 0 sidebarWidth]
set mcp.label 								mcpForm{0}==2 mcp.custom.mcpNameBg
set mcp.label.margin 						mcpForm{0}==2 * [Scale Scale Scale Scale 1] [4 0 4 0 0.5]
set mcp.custom.mcpIdxBg 					mcpForm{0}==2 + + [0 mcp.custom.mcpNameBg mcpWidth] * Scale [0 0 0 20] [0 mcp.custom.mcpNameBg{3} sidebarWidth]
set mcp.custom.sidebarBg					mcpForm{0}==2 - [0 0 sidebarWidth{0} h] [0 0 0 mcp.custom.sectionBottom{3}]
set mcp.extmixer.mode        				mcpForm{0}==2 ?addSidebar{0} [1] [-1]

; Strip Width
set mcp.custom.sectionBottom				mcpForm{0}==1 + [sidebarWidth mcp.custom.mcpDarkBox mcpWidth stripSectionBottomH] [0 mcp.custom.mcpDarkBox{3}] 
set mcpStripLabelHeightBal					* Scale + Layout##thisLayout##-mcpStripLabelHeight * mcpfolderIndentSize - mcp_maxfolderdepth folderdepth
set mcp.custom.mcpNameBg 					mcpForm{0}==1 [sidebarWidth mcp.custom.sectionBottom mcpWidth{0} mcpStripLabelHeightBal{0}]
set mcp.label 								mcpForm{0}==1 + + [mcp.custom.sectionBottom] [centW] + [0 mcp.custom.mcpNameBg 0 mcp.custom.mcpNameBg] * Scale [-10 0 20]
set mcp.label.margin 						mcpForm{0}==1 * [Scale Scale Scale Scale 1] [0 4 0 4 0]
set mcp.custom.mcpIdxBg 					mcpForm{0}==1 + + [0 mcp.custom.mcpNameBg mcpWidth] * Scale [0 0 0 20] [0 mcp.custom.mcpNameBg{3} sidebarWidth]
set mcp.custom.sidebarBg					mcpForm{0}==1 ?addSidebar{0} [0 0 sidebarWidth{0} mcp.custom.mcpIdxBg{1}] [0]
set mcp.extmixer.mode        				mcpForm{0}==1 ?addSidebar{0} [1] ?Layout##thisLayout##-mcpStripHideExtmixer{0} [1] [-1]

set mcp.custom.sectionBottom.color 			?visSections [0 0 0 0 50 150 200 100] [0 0 0 1 0 0 0 0]												
set mcp.custom.mcpNameBg.color 				?selInvertLabels{0} ?track_selected [0 0 0 0 ${main.lower.text.fade(0.5).rgba()}] [0 0 0 0 ${lower_bg.rgb()}] [0 0 0 0 ${lower_bg.rgb()}]
set mcp.label.font 							+ Layout##thisLayout##-mcpLabelSize{0} Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
set mcp.label.color 						?recarm [255 80 100] ?trackcolor_valid ?colorTrackLabels cColorTextOnDark * textBrightnessMult{0} [200 200 200] * textBrightnessMult{0} [${main.lower.text.rgb()}] 
set mcp.label.color 						?selInvertLabels{0} ?track_selected ?recarm [180 0 10] [${lower_bg.rgb()}] . .
set mcp.custom.indentInfill					+ + [0 mcp.custom.sectionBottom mcpWidth mcp.custom.sectionBottom] [0 mcp.custom.mcpNameBg{3} sidebarWidth] * Scale [0 20] ; 20 is about to be the indexBg h
set mcp.custom.indentInfill.color			[0 0 0 0 51 51 51]
set mcp.custom.mcpIdxBg.color 				?trackcolor_valid [0 0 0 0 trackcolor_r trackcolor_g trackcolor_b] [0 0 0 0 mcpBgColR mcpBgColG mcpBgColB]
set mcp.custom.mcp_selectionDot 			!selDot{0} [0] ?track_selected [0] + * 0.5 + [mcp.custom.mcpIdxBg{2}] folderstate==1 * Scale [18] [0] + [0 mcp.custom.mcpIdxBg] * Scale [-4 -4 8 8]
set mcp.custom.mcp_selectionDotSel 			!selDot{0} [0] !track_selected [0] + * 0.5 + [mcp.custom.mcpIdxBg{2}] folderstate==1 * Scale [18] [0] + [0 mcp.custom.mcpIdxBg] * Scale [-4 -4 8 8]
front mcp.custom.mcp_selectionDot mcp.custom.mcp_selectionDotSel
set mcp.trackidx                         	+ * 0.5 + [mcp.custom.mcpIdxBg{2}] folderstate==1 * Scale [18] [0] + [0 mcp.custom.mcpIdxBg] * Scale [-15 0 28 20]
	set mcp.trackidx.margin                	* [Scale Scale Scale Scale 1] [0 0 0 0 0.5]
	set mcp.trackidx.color					tcp.trackidx.color
	set mcp.trackidx.font                  	+ 3 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
set mcp.folder								folderstate<0 + + [mcp.custom.mcpIdxBg mcp.custom.mcpIdxBg] [mcp.custom.mcpIdxBg{2}] * Scale [-6 0 6 20] + [mcp.custom.mcpIdxBg mcp.custom.mcpIdxBg] * Scale [0 0 20 20] 
set mcp.custom.sidebarBg.color				[0 0 0 0 38 38 38]		
set mcp.extmixer.position					mcp.extmixer.mode{0}>0 + mcp.custom.sidebarBg * Scale [2 0 -2] \
												mcpDivOpacity{0}>0 [2 0 -4 0] [1 0 -2 0]
set mcp.fxparm.font 						+ * Scale [1 24] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set mcp.fxparm.margin					* [Scale Scale Scale Scale 1 Scale Scale Scale] [3 0 4 6 0.5 0 0 2]												
set mcp.fxlist.font 						+ * Scale [1 18 80 80] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set mcp.fxlist.margin					* [Scale Scale Scale Scale 1 Scale Scale Scale] [3 0 4 6 0.5 0 20 2]
set mcp.sendlist.font 						+ * Scale [1 18 80 80] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]	
	set mcp.sendlist.margin 				* [Scale Scale Scale Scale 1 Scale Scale Scale] [2 0 0 0 0 0 0 0 2]
front mcp.extmixer
	
;--MCP Size--
	
set minH									mcpForm{0}==3 + + + mcp.custom.sectionTop{3} mcp.custom.sectionPan{3} maxSectionBottomH{0} * Scale 90
set minH									mcpForm{0}==2 + + + + * Scale 100 mcp.custom.sectionTop{3} mcp.custom.sectionPan{3} maxSectionBottomH{0} mcp.custom.sectionButtons{3}
set minH									mcpForm{0}==1 + + + + mcp.custom.sectionTop{3} mcp.custom.sectionButtons{3} mcp.custom.sectionPan{3} mcp.custom.sectionBottom{3} stripDarkBoxMinH 
set mcp.size 								+ + [mcpWidth 0 0 minH{0}] [sidebarWidth] * Scale [0 360]	


;--Custom BGs--

custom mcp.custom.tcpSelBox
	set mcp.custom.tcpSelBox 				!track_selected [0] selectStrength{0}>0 + [0 0 mcp.size{0} 0 0 0 1 1] * Scale [0 0 0 360] [0]
	set mcp.custom.tcpSelBox.color 			+ * / selectStrength{0} 100 [0 0 0 0 0 0 0 255] [0 0 0 0 ${lab::mix(main.lower.like, main.lower.text, 0.5).rgb()}]	

custom mcp.custom.mcpColBox
	set mcp.custom.mcpColBox 				!customColorDepth{0} [0] + [0 0 mcp.size{0} 0 0 0 1 1]  * Scale [0 0 0 360]
	set mcp.custom.mcpColBox.color 			?trackcolor_valid [0 0 0 0 trackcolor_r trackcolor_g trackcolor_b customColorDepth{0}] [0 0 0 0 0]

custom mcp.custom.mcpBgBox
	set mcp.custom.mcpBgBox 				+ [0 0 mcp.size{0} 0 0 0 1 1] * Scale [0 0 0 360]
	set mcp.custom.mcpBgBox.color 			[0 0 0 0 mcpBgColR mcpBgColG mcpBgColB 255]

endLayout

endMacro



define_parameter LayoutA-verboseMcp 				'Layout A - Verbose MCP' 0 0 1
define_parameter LayoutA-mcpMeterReadout			'Layout A - mcpMeterReadout' 1 0 1
define_parameter LayoutA-mcpWidth					'Layout A - Mixer Panel Width' 88 28 140
define_parameter LayoutA-mcpWidthSel				'Layout A - Selected Mixer Panel Width' 88 28 140
define_parameter LayoutA-mcpWidthRecarm				'Layout A - Armed Mixer Panel Width' 88 28 140
define_parameter LayoutA-mcpSidebar					'Layout A - Mixer Sidebar' 0 0 1
define_parameter LayoutA-mcpSidebarSel				'Layout A - Selected Mixer Sidebar' 0 0 1
define_parameter LayoutA-mcpSidebarRecarm			'Layout A - Armed Mixer Sidebar' 0 0 1
define_parameter LayoutA-sidebarWidth				'Layout A - Sidebar Width' 88 34 300
define_parameter LayoutA-mcpNchanGrow				'Layout A - Mixer nChan Grow' 2 0 20
define_parameter LayoutA-mcpNchanGrowSel			'Layout A - Selected Mixer nChan Grow' 2 0 20
define_parameter LayoutA-mcpNchanGrowRecarm			'Layout A - Armed Mixer nChan Grow' 2 0 20
define_parameter LayoutA-mcpMeterVals				'Layout A - Mixer Meter Values' 0 0 1
define_parameter LayoutA-mcpMeterValsSel			'Layout A - Selected Mixer Meter Values' 0 0 1
define_parameter LayoutA-mcpMeterValsRecarm			'Layout A - Armed Mixer Meter Values' 1 0 1
define_parameter LayoutA-mcpNormalDarkButtons		'Layout A - Dark Under Buttons' 1 0 1
define_parameter LayoutA-mcpNormalShowSecIn			'Layout A - mcpNormalShowSecIn' 300 0 500
define_parameter LayoutA-mcpNormalShowSecPan		'Layout A - mcpNormalShowSecPan' 200 0 500
define_parameter LayoutA-mcpNormalShowRoute			'Layout A - mcpNormalShowRoute' 1 0 1
define_parameter LayoutA-mcpNormalShowSecFx			'Layout A - mcpNormalShowSecFx' 1 0 1
define_parameter LayoutA-mcpNormalShowEnv			'Layout A - mcpNormalShowEnv' 1 0 1
define_parameter LayoutA-mcpNormalShowPhase			'Layout A - mcpNormalShowPhase' 1 0 1
define_parameter LayoutA-mcpLabelSize 				'Layout A - MCP Label Font Size' 4 1 5
define_parameter LayoutA-mcpInterShowSecIn			'Layout A - mcpInterShowSecIn' 320 0 500
define_parameter LayoutA-mcpInterShowSecButtons		'Layout A - mcpInterShowSecButtons' 280 0 500
define_parameter LayoutA-mcpInterShowSecPan			'Layout A - mcpInterShowSecPan' 240 0 500
define_parameter LayoutA-mcpStripLabelHeight		'Layout A - Label Height' 88 20 300
define_parameter LayoutA-mcpStripInputHeight		'Layout A - Record Input Height' 70 0 140
define_parameter LayoutA-mcpStripShowRecmode		'Layout A - mcpStripShowRecmode' 1 0 1
define_parameter LayoutA-mcpStripSecInAtH			'Layout A - mcpStripSecInAtH' 580 0 1000
define_parameter LayoutA-mcpStripShowFxIn			'Layout A - mcpStripShowFxIn' 1 0 1
define_parameter LayoutA-mcpStripSecButAtH			'Layout A - mcpStripSecButAtH' 440 0 1000
define_parameter LayoutA-mcpStripShowEnv			'Layout A - mcpStripShowEnv' 1 0 1
define_parameter LayoutA-mcpStripShowPhase			'Layout A - mcpStripShowPhase' 1 0 1
define_parameter LayoutA-mcpStripShowSecPan			'Layout A - mcpStripShowSecPan' 1 0 1
define_parameter LayoutA-mcpStripSecPanAtH			'Layout A - mcpStripSecPanAtH' 300 0 1000
define_parameter LayoutA-mcpStripMeterHeight		'Layout A - Meter Height' 40 20 300
define_parameter LayoutA-mcpStripVolumeHeight		'Layout A - Volume Height' 120 80 300
define_parameter LayoutA-mcpStripVolKnobAtH			'Layout A - mcpStripVolKnobAtH' 650 0 1000
define_parameter LayoutA-mcpStripShowRecmon			'Layout A - mcpStripShowRecmon' 1 0 1
define_parameter LayoutA-mcpStripHideExtmixer		'Layout A - Hide non-sidebar ExtMixer' 0 0 1

drawMcp A 1
Layout "A"
drawMcp A 1
endLayout

Layout "150%_A" "150"
drawMcp A 1.5
endLayout

Layout "200%_A" "200"
drawMcp A 2
endLayout


define_parameter LayoutB-verboseMcp 				'Layout B - Verbose MCP' 0 0 1
define_parameter LayoutB-mcpMeterReadout			'Layout B - mcpMeterReadout' 0 0 1
define_parameter LayoutB-mcpWidth					'Layout B - Mixer Panel Width' 32 28 140
define_parameter LayoutB-mcpWidthSel				'Layout B - Selected Mixer Panel Width' 32 28 140
define_parameter LayoutB-mcpWidthRecarm				'Layout B - Armed Mixer Panel Width' 40 28 140
define_parameter LayoutB-mcpSidebar					'Layout B - Mixer Sidebar' 0 0 1
define_parameter LayoutB-mcpSidebarSel				'Layout B - Selected Mixer Sidebar' 0 0 1
define_parameter LayoutB-mcpSidebarRecarm			'Layout B - Armed Mixer Sidebar' 0 0 1
define_parameter LayoutB-sidebarWidth				'Layout B - Sidebar Width' 88 34 300
define_parameter LayoutB-mcpNchanGrow				'Layout B - Mixer nChan Grow' 0 0 20
define_parameter LayoutB-mcpNchanGrowSel			'Layout B - Selected Mixer nChan Grow' 0 0 20
define_parameter LayoutB-mcpNchanGrowRecarm			'Layout B - Armed Mixer nChan Grow' 0 0 20
define_parameter LayoutB-mcpMeterVals				'Layout B - Mixer Meter Values' 0 0 1
define_parameter LayoutB-mcpMeterValsSel			'Layout B - Selected Mixer Meter Values' 0 0 1
define_parameter LayoutB-mcpMeterValsRecarm			'Layout B - Armed Mixer Meter Values' 1 0 1
define_parameter LayoutB-mcpNormalDarkButtons		'Layout B - Dark Under Buttons' 1 0 1
define_parameter LayoutB-mcpNormalShowSecIn			'Layout B - mcpNormalShowSecIn' 350 0 500
define_parameter LayoutB-mcpNormalShowSecPan		'Layout B - mcpNormalShowSecPan' 300 0 500
define_parameter LayoutB-mcpNormalShowRoute			'Layout B - mcpNormalShowRoute' 1 0 1
define_parameter LayoutB-mcpNormalShowSecFx			'Layout B - mcpNormalShowSecFx' 1 0 1
define_parameter LayoutB-mcpNormalShowEnv			'Layout B - mcpNormalShowEnv' 1 0 1
define_parameter LayoutB-mcpNormalShowPhase			'Layout B - mcpNormalShowPhase' 1 0 1
define_parameter LayoutB-mcpLabelSize 				'Layout B - MCP Label Font Size' 3 1 5
define_parameter LayoutB-mcpInterShowSecIn			'Layout B - mcpInterShowSecIn' 350 0 500
define_parameter LayoutB-mcpInterShowSecButtons		'Layout B - mcpInterShowSecButtons' 380 0 500
define_parameter LayoutB-mcpInterShowSecPan			'Layout B - mcpInterShowSecPan' 300 0 500
define_parameter LayoutB-mcpStripLabelHeight		'Layout B - Label Height' 88 0 300
define_parameter LayoutB-mcpStripInputHeight		'Layout B - Record Input Height' 70 30 140
define_parameter LayoutB-mcpStripShowRecmode		'Layout B - mcpStripShowRecmode' 1 0 1
define_parameter LayoutB-mcpStripSecInAtH			'Layout B - mcpStripSecInAtH' 580 0 1000
define_parameter LayoutB-mcpStripShowFxIn			'Layout B - mcpStripShowFxIn' 1 0 1
define_parameter LayoutB-mcpStripSecButAtH			'Layout B - mcpStripSecButAtH' 440 0 1000
define_parameter LayoutB-mcpStripShowEnv			'Layout B - mcpStripShowEnv' 1 0 1
define_parameter LayoutB-mcpStripShowPhase			'Layout B - mcpStripShowPhase' 1 0 1
define_parameter LayoutB-mcpStripShowSecPan			'Layout B - mcpStripShowSecPan' 1 0 1
define_parameter LayoutB-mcpStripSecPanAtH			'Layout B - mcpStripSecPanAtH' 300 0 1000
define_parameter LayoutB-mcpStripMeterHeight		'Layout B - Meter Height' 20 20 300
define_parameter LayoutB-mcpStripVolumeHeight		'Layout B - Volume Height' 80 80 300
define_parameter LayoutB-mcpStripVolKnobAtH			'Layout B - mcpStripVolKnobAtH' 650 0 1000
define_parameter LayoutB-mcpStripShowRecmon			'Layout B - mcpStripShowRecmon' 1 0 1
define_parameter LayoutB-mcpStripHideExtmixer		'Layout B - Hide non-sidebar ExtMixer' 1 0 1

Layout "B"
drawMcp B 1
endLayout

Layout "150%_B" "150"
drawMcp B 1.5
endLayout

Layout "200%_B" "200"
drawMcp B 2
endLayout


define_parameter LayoutC-verboseMcp 				'Layout C - Verbose MCP' 1 0 1
define_parameter LayoutC-mcpMeterReadout			'Layout C - mcpMeterReadout' 1 0 1
define_parameter LayoutC-mcpWidth					'Layout C - Mixer Panel Width' 88 28 140
define_parameter LayoutC-mcpWidthSel				'Layout C - Selected Mixer Panel Width' 100 28 140
define_parameter LayoutC-mcpWidthRecarm				'Layout C - Armed Mixer Panel Width' 100 28 140
define_parameter LayoutC-mcpSidebar					'Layout C - Mixer Sidebar' 1 0 1
define_parameter LayoutC-mcpSidebarSel				'Layout C - Selected Mixer Sidebar' 1 0 1
define_parameter LayoutC-mcpSidebarRecarm			'Layout C - Armed Mixer Sidebar' 1 0 1
define_parameter LayoutC-sidebarWidth				'Layout C - Sidebar Width' 88 34 300
define_parameter LayoutC-mcpNchanGrow				'Layout C - Mixer nChan Grow' 2 0 20
define_parameter LayoutC-mcpNchanGrowSel			'Layout C - Selected Mixer nChan Grow' 2 0 20
define_parameter LayoutC-mcpNchanGrowRecarm			'Layout C - Armed Mixer nChan Grow' 2 0 20
define_parameter LayoutC-mcpMeterVals				'Layout C - Mixer Meter Values' 1 0 1
define_parameter LayoutC-mcpMeterValsSel			'Layout C - Selected Mixer Meter Values' 1 0 1
define_parameter LayoutC-mcpMeterValsRecarm			'Layout C - Armed Mixer Meter Values' 1 0 1
define_parameter LayoutC-mcpNormalDarkButtons		'Layout C - Dark Under Buttons' 1 0 1
define_parameter LayoutC-mcpNormalShowSecIn			'Layout C - mcpNormalShowSecIn' 350 0 500
define_parameter LayoutC-mcpNormalShowSecPan		'Layout C - mcpNormalShowSecPan' 300 0 500
define_parameter LayoutC-mcpNormalShowRoute			'Layout C - mcpNormalShowRoute' 1 0 1
define_parameter LayoutC-mcpNormalShowSecFx			'Layout C - mcpNormalShowSecFx' 1 0 1
define_parameter LayoutC-mcpNormalShowEnv			'Layout C - mcpNormalShowEnv' 1 0 1
define_parameter LayoutC-mcpNormalShowPhase			'Layout C - mcpNormalShowPhase' 1 0 1
define_parameter LayoutC-mcpLabelSize 				'Layout C - MCP Label Font Size' 4 1 5
define_parameter LayoutC-mcpInterShowSecIn			'Layout C - mcpInterShowSecIn' 350 0 500
define_parameter LayoutC-mcpInterShowSecButtons		'Layout C - mcpInterShowSecButtons' 380 0 500
define_parameter LayoutC-mcpInterShowSecPan			'Layout C - mcpInterShowSecPan' 300 0 500
define_parameter LayoutC-mcpStripLabelHeight		'Layout C - Label Height' 88 0 300
define_parameter LayoutC-mcpStripInputHeight		'Layout C - Record Input Height' 70 30 140
define_parameter LayoutC-mcpStripShowRecmode		'Layout C - mcpStripShowRecmode' 1 0 1
define_parameter LayoutC-mcpStripSecInAtH			'Layout C - mcpStripSecInAtH' 580 0 1000
define_parameter LayoutC-mcpStripShowFxIn			'Layout C - mcpStripShowFxIn' 1 0 1
define_parameter LayoutC-mcpStripSecButAtH			'Layout C - mcpStripSecButAtH' 440 0 1000
define_parameter LayoutC-mcpStripShowEnv			'Layout C - mcpStripShowEnv' 1 0 1
define_parameter LayoutC-mcpStripShowPhase			'Layout C - mcpStripShowPhase' 1 0 1
define_parameter LayoutC-mcpStripShowSecPan			'Layout C - mcpStripShowSecPan' 1 0 1
define_parameter LayoutC-mcpStripSecPanAtH			'Layout C - mcpStripSecPanAtH' 300 0 1000
define_parameter LayoutC-mcpStripMeterHeight		'Layout C - Meter Height' 40 20 300
define_parameter LayoutC-mcpStripVolumeHeight		'Layout C - Volume Height' 120 80 300
define_parameter LayoutC-mcpStripVolKnobAtH			'Layout C - mcpStripVolKnobAtH' 650 0 1000
define_parameter LayoutC-mcpStripShowRecmon			'Layout C - mcpStripShowRecmon' 1 0 1
define_parameter LayoutC-mcpStripHideExtmixer		'Layout C - Hide non-sidebar ExtMixer' 1 0 1

Layout "C"
drawMcp C 1
endLayout

Layout "150%_C" "150"
drawMcp C 1.5
endLayout

Layout "200%_C" "200"
drawMcp C 2
endLayout


#<

#>--------------------------------- MASTER MIXER --------------------------------------


define_parameter masterMcpWidth						'Master Mixer Panel Width' 132 90 400
define_parameter masterMcpMeterVals					'Master MCP Meter Values' 1 0 1
define_parameter masterMcpVals						'Master MCP Values' 1 0 1
define_parameter masterMcpLabels					'Master MCP Labels' 1 0 1
define_parameter masterMcpBgColR 					'Master MCP background colour' ${rgb::coords(main.lower.like).red} 0 255
define_parameter masterMcpBgColG 					'Master MCP background colour G' ${rgb::coords(main.lower.like).green} 0 255
define_parameter masterMcpBgColB 					'Master MCP background colour B' ${rgb::coords(main.lower.like).blue} 0 255

macro masterMcpFollow this thisW thisH yOffs noSpace

	set thisWs * Scale thisW
	set thisHs * Scale thisH
	set yOffsS * Scale yOffs
	set thisYMargin * Scale !noSpace{0} 6 0 ; hard coding margin as 6
	
	set this + + + [previous previous] [0 previous{3}] [0 thisYMargin{0} thisWs thisHs] [0 yOffsS]
	
	set thisBS	+ + this{1} this{3} thisYMargin{0}
	set sectionButtonsBS + master.mcp.custom.sectionButtons{1} master.mcp.custom.sectionButtons{3}

	set this thisBS{0}>sectionButtonsBS{0} [. . . 0] . ; cull if extending below buttons section

	; -- this is the new previous	
	set previous this
	
endMacro

macro drawMasterMcp Scale

set master.mcp.size									* Scale [masterMcpWidth{0} 360 0 120]

set masterMcpSelectColRatio 						?track_selected / selectStrength{0} 100 0
set masterMcpCol									+ * - 1 masterMcpSelectColRatio \
														[masterMcpBgColR masterMcpBgColG masterMcpBgColB] \
													* masterMcpSelectColRatio [${lab::mix(main.lower.like, main.lower.text, 0.5).rgb()}] 												
brightnessFromRGB 									masterMcpCol{0} masterMcpCol{1} masterMcpCol{2} masterMcpColBrightness

custom master.mcp.custom.sectionPan
	set master.mcp.custom.sectionPan 				+ [0 0 master.mcp.size{0}] * Scale + [0 0 -32] !masterMcpVals{0} [0 0 0 30] [0 0 0 46]  
	set master.mcp.custom.sectionPan.color 			?visSections{0} [0 0 0 0 100 255 100 150] [0 0 0 1 0 0 0 0]
	set master.mcp.pan.label						!masterMcpVals{0} [0 master.mcp.custom.sectionPan] + [master.mcp.custom.sectionPan master.mcp.custom.sectionPan master.mcp.custom.sectionPan] * Scale [0 0 0 14]
	set master.mcp.pan.label.font					+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set master.mcp.pan.label.margin             	trackpanmode>=4 [2 6 0 0 0] [6 6 6 0 0.5]
	set master.mcp.pan.label.color					* textBrightnessMult{0} masterMcpColBrightness{0}<150 [${main.lower.text.rgb()}] [38 38 38]
	set masterSectionPanCentW						* 0.5 master.mcp.custom.sectionPan{2}
set master.mcp.pan									master.mcp.custom.sectionPan{3}==0 [0] trackpanmode==6 + + * Scale [6 14 -12] [0 master.mcp.pan.label{3}] [master.mcp.pan.label master.mcp.pan.label master.mcp.custom.sectionPan 10] \
														+ + [0 master.mcp.pan.label{3}] [master.mcp.custom.sectionPan master.mcp.pan.label] + [masterSectionPanCentW] * Scale trackpanmode>=4 [-20 4 20 20] [-10 4 20 20]
	set master.mcp.pan.fadermode					trackpanmode==6 [-1] [1]
set master.mcp.width								master.mcp.custom.sectionPan{3}==0 [0] trackpanmode==6 + + * Scale [6 4 -12] [0 master.mcp.pan.label{3}] [master.mcp.pan.label master.mcp.pan.label master.mcp.custom.sectionPan 10] \
														trackpanmode>=4 + [master.mcp.pan master.mcp.pan] * Scale [22 0 20 20] [0]
	set master.mcp.width.fadermode					trackpanmode==6 [-1] [1]
	set master.mcp.width.label						trackpanmode>=4 !masterMcpVals{0} [0] + [master.mcp.custom.sectionPan master.mcp.custom.sectionPan master.mcp.custom.sectionPan] * Scale [0 0 0 14] [0]
	set master.mcp.width.label.font					+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set master.mcp.width.label.margin           	* [Scale Scale Scale Scale 1] [0 6 2 0 1]
	set master.mcp.width.label.color				master.mcp.pan.label.color	
custom master.mcp.custom.darkBox
	set master.mcp.custom.darkBox 					- + + * Scale [6 0 -38] [0 master.mcp.custom.sectionPan master.mcp.size{0} h] [0 master.mcp.custom.sectionPan{3}] [0 0 0 master.mcp.custom.sectionPan]
	set master.mcp.custom.darkBox.color				?visSections [0 0 0 0 255 100 255 150] [0 0 0 1 ${lower_bg.rgba()}]

custom master.mcp.custom.sectionButtons
	set master.mcp.custom.sectionButtons			+ [master.mcp.size{0}] * Scale [-32 0 32 h]
 	set master.mcp.custom.sectionButtons.color		?visSections [0 0 0 0 100 100 255 150] [0 0 0 1 0 0 0 0]
set masterMcpMonoH									?masterMcpLabels{0} 32 22	
set masterMcpIoH									?masterMcpLabels{0} 32 22
set masterMcpEnvH									?masterMcpLabels{0} 32 22
set previous										+ [master.mcp.custom.sectionButtons master.mcp.custom.sectionButtons] * Scale [6 6 0 0] ; Null object	
masterMcpFollow master.mcp.mono						20 masterMcpMonoH{0} 0 1
masterMcpFollow master.mcp.mute						20 20 -2 0
masterMcpFollow master.mcp.solo						20 20 0 1
front master.mcp.solo
masterMcpFollow master.mcp.io						20 masterMcpIoH{0} 0 0
masterMcpFollow master.mcp.fxGroup					20 36 0 0
set master.mcp.fx									master.mcp.fxGroup{3}>0 + [master.mcp.fxGroup master.mcp.fxGroup] * Scale [0 0 20 20] [0]
set master.mcp.fxbyp								master.mcp.fxGroup{3}>0 + + [master.mcp.fxGroup master.mcp.fxGroup] [0 master.mcp.fx{3}] * Scale [0 0 20 16] [0]
masterMcpFollow master.mcp.env						20 masterMcpEnvH{0} 0 0
masterMcpFollow master.mcp.menubutton				20 20 0 0

set master.mcp.volume.label							+ [master.mcp.custom.darkBox master.mcp.custom.darkBox master.mcp.custom.darkBox 0] !masterMcpVals{0} [0] * Scale [0 0 0 20]
	set master.mcp.volume.label.font				+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set master.mcp.volume.label.margin				* [Scale Scale Scale Scale 1] [0 0 0 0 0.5]
	set master.mcp.volume.label.color				* textBrightnessMult{0} [${lab::mix(lower_bg, main.lower.text, 2.0 / 3).rgb()}]
set master.mcp.meter								+ master.mcp.custom.darkBox * Scale + !masterMcpLabels{0} [0 6 -24 -12] [0 6 -24 -26] !masterMcpVals{0} [0] [0 14 0 -14]
	set master.mcp.meter.vu.div                   	* Scale [1 1]
	set master.mcp.meter.readout.color            	!masterMcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${lab::mix(lower_bg, main.lower.text, 5.0 / 6).rgb()}]
	set master.mcp.meter.scale.color.lit.bottom   	!masterMcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set master.mcp.meter.scale.color.lit.top      	!masterMcpMeterVals{0} [0 0 0 0 0 0 0 0] [0 0 0 170 0 0 0 0]
	set master.mcp.meter.scale.color.unlit.bottom 	!masterMcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]
	set master.mcp.meter.scale.color.unlit.top    	!masterMcpMeterVals{0} [0 0 0 0 0 0 0 0] * textBrightnessMult{0} [${main.lower.text.fade(2.0 / 3).rgba()} 0 0 0 0]
	set master.mcp.meter.vu.rmsdiv                	* Scale [2]
	set master.mcp.meter.rmsreadout.color         	!masterMcpMeterVals{0} [0 0 0] * textBrightnessMult{0} [42 168 116]
set master.mcp.volume								+ + [master.mcp.meter master.mcp.meter 0 master.mcp.meter] [master.mcp.meter{2}] * Scale [0 0 24]
set master.mcp.label 								+ + [master.mcp.custom.darkBox master.mcp.custom.darkBox master.mcp.custom.darkBox] [0 master.mcp.custom.darkBox{3}] ?masterMcpLabels{0} * Scale [0 -20 0 20] [0]
	set master.mcp.label.color						* textBrightnessMult{0} [${main.lower.text.rgb()}]
	set master.mcp.label.color						?selInvertLabels{0} ?track_selected [${lower_bg.rgb()}] . .
	set master.mcp.label.font						+ 3 Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
custom master.mcp.custom.masterMcpNameBg
set master.mcp.custom.masterMcpNameBg				master.mcp.label
set master.mcp.custom.masterMcpNameBg.color 		?selInvertLabels{0} ?track_selected [0 0 0 0 ${main.lower.text.fade(0.5).rgba()}] [0 0 0 0 ${lower_bg.rgb()}] [0 0 0 0 ${lower_bg.rgb()}]
front master.mcp.custom.masterMcpNameBg	master.mcp.label
set master.mcp.fxlist.font 							+ * Scale [1 18 80 80] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set master.mcp.fxlist.margin					* [Scale Scale Scale Scale 1 Scale Scale Scale] [3 0 4 6 0.5 0 20 2]
set master.mcp.sendlist.font 						+ * Scale [1 18 80 80] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]	
	set master.mcp.sendlist.margin 					* [Scale Scale Scale Scale 1 Scale Scale Scale] [2 0 0 0 0 0 0 0 2]
set master.mcp.fxparm.font 							+ * Scale [1 24] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
 	set master.mcp.fxparm.margin					* [Scale Scale Scale Scale 1 Scale Scale Scale] [3 0 4 6 0.5 0 0 2]	

custom master.mcp.custom.mcp_selectionDot 			'' 0 '' 'tcp_selectionDot'
set master.mcp.custom.mcp_selectionDot 				!selDot{0} [0] ?track_selected [0] + + [master.mcp.custom.darkBox master.mcp.custom.darkBox] [master.mcp.custom.darkBox{2} master.mcp.custom.darkBox{3}] * Scale [-4 -14 8 8]
custom master.mcp.custom.mcp_selectionDotSel		'' 0 '' 'tcp_selectionDot_sel'	
set master.mcp.custom.mcp_selectionDotSel 			!selDot{0} [0] !track_selected [0] + + [master.mcp.custom.darkBox master.mcp.custom.darkBox] [master.mcp.custom.darkBox{2} master.mcp.custom.darkBox{3}] * Scale [-4 -14 8 8]
front master.mcp.custom.mcp_selectionDot master.mcp.custom.mcp_selectionDotSel

custom master.mcp.custom.mcpBgBox
set master.mcp.custom.mcpBgBox 						[0 0 w h] 
set master.mcp.custom.mcpBgBox.color 				[0 0 0 0 masterMcpCol{0} masterMcpCol{1} masterMcpCol{2} 255]



endMacro

drawMasterMcp 1
Layout "A"
drawMasterMcp 1
endLayout

Layout "150%_A" "150"
drawMasterMcp 1.5
endLayout

Layout "200%_A" "200"
drawMasterMcp 2
endLayout

#<

#>---------------------------------- TRANSPORT ----------------------------------------

macro transFollow this thisW thisH
	
	set thisWs								* Scale thisW
	set thisHs								* Scale thisH
	set this 								- - [previous previous thisWs thisHs] [transMargin] [thisWs]  ; position it to the left of the current row
	set this 								?hide_##this{0} + [previous . 0] * Scale [0 0 0 36] ; apply hide by setting w to zero and ignoring transMargin

; -- move to next row--	
; if it WON'T fit in this row, use it to start the next row at 36 + transMargin	
	set this 								this{0}<trans.custom.sectionRight{0} - + [w previous this this] * Scale + [0 36] [0 transMargin{0}] + [this{2}] * Scale [transMargin]

; -- cull if it extends below the height of the panel --	
	set thisBS 								+ this{1} this{3}
	set this 								thisBS{0}>h [this this 0 this] !previous{3} [this this 0 0] .   ; cull method is to set width to zero
 
; -- cull if it is itself too wide for the section
	set thisWPlus2Margins 					+ this{2} * Scale + transMargin transMargin
	set this 								thisWPlus2Margins{0}>trans.custom.sectionRight{2} [this this 0 0] .
	
; -- this is the new previous	
	set previous 							this
	
endmacro

define_parameter transMargin 				'Transport Margins' 6 0 12
define_parameter transStatusWidth 			'Status Width' 450 150 700
define_parameter transRateFaderWidth 		'Rate Width' 38 38 400
define_parameter transSelectionWidth 		'Selection Width' 350 150 700


Macro drawTrans Scale

set trans.size 								* Scale [1000 36]
set trans.size.minmax 						* Scale + [100 36 2000 144] * 4 [0 0 0 transMargin{0}]
set trans.size.dockedheight 				* Scale [36]

custom trans.custom.sectionLeft
set trans.custom.sectionLeft				* Scale [0 0 1000 36] ; just to start with
set trans.custom.sectionLeft.color			?visSections [0 0 0 0 50 255 100 60] [0 0 0 0 0 0 0 0]
custom trans.custom.sectionButtons
set trans.custom.sectionButtons				+ * Scale [transMargin 4 200 30] ?trans_center - / [w] 2 * Scale [100] [0]
set trans.custom.sectionButtons.color		?visSections [0 0 0 0 100 100 255 150] [0 0 0 1 0 0 0 0]

set trans.rew 								+ [trans.custom.sectionButtons trans.custom.sectionButtons] * Scale [0 0 28 30]
set trans.fwd 								+ + [trans.rew trans.rew] * Scale [0 0 28 30] [trans.rew{2}]
set trans.rec								+ + [trans.fwd trans.fwd] * Scale [2 0 30 30] [trans.fwd{2}]
set trans.play 								+ + [trans.rec trans.rec] * Scale [-2 0 32 30] [trans.rec{2}]
set trans.repeat							+ + [trans.play trans.play] * Scale [0 0 28 30] [trans.play{2}]
set trans.stop 								+ + [trans.repeat trans.repeat] * Scale [2 0 28 30] [trans.repeat{2}]
set trans.pause 							+ + [trans.stop trans.stop] * Scale [0 0 28 30] [trans.stop{2}]

custom trans.custom.sectionStatus
set trans.custom.sectionStatus				+ ?trans_center [0] + [trans.custom.sectionButtons] [trans.custom.sectionButtons{2}] * Scale [transMargin 0 transStatusWidth{0} 36]
; set trans.custom.sectionLeft 				+ [0 0 trans.custom.sectionStatus trans.custom.sectionStatus] [0 0 trans.custom.sectionStatus{0}]

; Break section left if not enough y-space
set sectionLeftBreakW						+ + trans.custom.sectionButtons{2} trans.custom.sectionStatus{2} * 2 * Scale transMargin{0}
set trans.custom.sectionLeft 				w>sectionLeftBreakW{0} .  + * Scale [0 0 transMargin{0} transMargin{0}] \
											trans.custom.sectionStatus{2}>trans.custom.sectionButtons{2} [0 0 trans.custom.sectionStatus{2} 72] [0 0 trans.custom.sectionButtons{2} 72]
; ...and move status to the next row
set trans.custom.sectionStatus				w>sectionLeftBreakW{0} . * Scale + [transMargin{0} transMargin{0}] [0 36 transStatusWidth{0} 36]

; do the above but for centered mode
set sectionLeftBreakW						?trans_center + trans.custom.sectionStatus{2} * 2 transMargin{0} 
set trans.custom.sectionLeft				?trans_center trans.custom.sectionButtons{0}<sectionLeftBreakW{0} + [0 0 0 transMargin{0}] [. . . 72] .
set trans.custom.sectionStatus				?trans_center trans.custom.sectionButtons{0}<sectionLeftBreakW{0} + * 0.5 - [w] * Scale [transStatusWidth{0}] * Scale + [0 transMargin{0}] [0 36 transStatusWidth{0} 36] .

; populate status
set trans.status							trans.custom.sectionStatus
set trans.status.margin						* Scale [transMargin{0} 0 transMargin{0} 0]
set trans.status.color						+ + ?visSections [255 0 0 255 100 50 100 255] [0] [0 0 0 0 ${main.lower.like.rgba()}] * textBrightnessMult{0} [${lab::mix(main.lower.like, main.lower.text, 2.0 / 3).rgb()}]

custom trans.custom.sectionRight
custom trans.custom.sectionRate
custom trans.custom.sectionBpm				'' 0 '' 'transSectionBg'
custom trans.custom.sectionSig				'' 0 '' 'transSectionBg'
custom trans.custom.sectionSel				'' 0 '' 'transSectionBg'

	set rateFaderSwapW						100
	set transSectionRateW					+ transRateFaderWidth{0} transRateFaderWidth{0}>rateFaderSwapW{0} 0 60
	set sectionRightW						- w + + trans.custom.sectionButtons{2} trans.custom.sectionStatus{2} * Scale + transMargin transMargin
	set transDoubleH						* Scale + 72 transMargin
	set trans.custom.sectionRight			h>transDoubleH{0} + [0 0 w h] * Scale + [0 trans.custom.sectionLeft{3}] [0 transMargin{0}] \
															  - + [w 0 sectionRightW{0}] * Scale [0 0 0 36] [sectionRightW{0}]
	set trans.custom.sectionRight			?trans_center h>transDoubleH{0} . \
											- + [trans.custom.sectionButtons . w .] * [1 0 1] [trans.custom.sectionButtons{2} 0 trans.custom.sectionButtons{2}] [0 0 trans.custom.sectionButtons{0}]
	set trans.custom.sectionRight.color		?visSections [0 0 0 0 255 255 120 60] [0]

set previous 								+ [w trans.custom.sectionRight] * Scale [0 0 0 36]

set hide_trans.custom.sectionRate 			!trans_flags&2 1 0
transFollow trans.custom.sectionRate 		transSectionRateW{0} 36
	set trans.custom.sectionRate.color		?visSections [0 0 0 0 100 255 100 80] [0 0 0 1 0 0 0 0]
	set trans.rate.fader 					!trans.custom.sectionRate{2} [0] + [trans.custom.sectionRate trans.custom.sectionRate] \
												* Scale + [0 0 transRateFaderWidth{0}] transRateFaderWidth{0}>rateFaderSwapW{0} [0 16 0 20] [0 0 0 36]
	custom trans.custom.rateFaderBg			'' 0 '' 'transRateFaderBg'
	set trans.custom.rateFaderBg			transRateFaderWidth{0}>rateFaderSwapW{0} trans.rate.fader [0]
	set trans.rate.fader.fadermode 			transRateFaderWidth{0}>rateFaderSwapW{0} [0] [1]
	set trans.rate							!trans.custom.sectionRate{2} [0] transRateFaderWidth{0}>rateFaderSwapW{0} + + [trans.custom.sectionRate trans.custom.sectionRate] * Scale [-40 2 80 16] * 0.5 [trans.custom.sectionRate{2}] \
												+ + [trans.rate.fader trans.rate.fader] * Scale [0 0 60 36] [trans.rate.fader{2}}]
	set trans.rate.margin 					[0 0 0 0 0]
	set trans.rate.font						+ [2] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set trans.rate.color 					* textBrightnessMult{0} [${lab::mix(main.lower.like, main.lower.text, 5.0 / 6).rgb()}] 
	set trans.rate.fader.color 				[${main.lower.text.fade(2.0 / 3).rgba()}] ; pointer line of the knob

set hide_trans.automode 					0
transFollow trans.automode 					58 36
set hide_trans.custom.sectionBpm 			0
transFollow trans.custom.sectionBpm			60 36
	set trans.custom.sectionBpm.color		?visSections [0 0 0 0 100 100 255 150] [0 0 0 1 0 0 0 0]	
	set trans.bpm.tap 						+ [trans.custom.sectionBpm trans.custom.sectionBpm trans.custom.sectionBpm] * Scale [0 0 0 20]
	set trans.bpm.tap.font  				+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set trans.bpm.tap.color 				* textBrightnessMult{0} [${lab::mix(main.lower.like, main.lower.text, 2.0 / 3).rgb()}]
	set trans.bpm.tap.margin 				+ * Scale [0 2 0 0] [0 0 0 0 0.5]		
	set trans.bpm.edit 						+ + [trans.bpm.tap trans.bpm.tap trans.bpm.tap] [0 trans.bpm.tap{3}] * Scale [0 0 0 16]
	set trans.bpm.edit.font  				+ [1] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set trans.bpm.edit.color 				trans.bpm.tap.color 
	set trans.bpm.edit.margin 				+ * Scale [0 0 0 6] [0 0 0 0 0.5]	
	
set hide_trans.custom.sectionSig 			!trans_flags&4 1 0
transFollow trans.custom.sectionSig			40 36
	set trans.custom.sectionSig.color		?visSections [0 0 0 0 255 100 100 150] [0 0 0 1 0 0 0 0]
	set trans.curtimesig 					trans.custom.sectionSig
	set trans.curtimesig.font  				+ [3] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set trans.curtimesig.color 				trans.bpm.tap.color 

set hide_trans.custom.sectionSel 			0
transFollow trans.custom.sectionSel			transSelectionWidth{0} 36
	set trans.sel							+ trans.custom.sectionSel * Scale [10 10 -10 -20]						
	set trans.sel.color      	  			* textBrightnessMult{0} [${lab::mix(main.lower.like, main.lower.text, 2.0 / 3).rgb()}] 
	set trans.sel.font        	 			+ [3] Scale{0}==1 [0] Scale{0}==1.5 [5] [10]
	set trans.sel.margin					[4 30 4 10 0] ; ????

endMacro
	
	
drawTrans 1
Layout "A"
drawTrans 1
endLayout

Layout "150%_A" "150"
drawTrans 1.5
endLayout

Layout "200%_A" "200"
drawTrans 2
endLayout
	

#<	
#>------------------------------- DPI TRANSLATION -------------------------------------

; ------ DUMMY LAYOUTS ---------

Layout "50%_A"
	set tcp.label  			.
	set mcp.label  			.
	set master.mcp.label 	.
	set master.tcp.label 	.
	set trans.status 		.
EndLayout

Layout "75%_A"
	set tcp.label  			.
	set mcp.label  			.
	set master.mcp.label 	.
	set master.tcp.label 	.	
	set trans.status 		.
EndLayout

Layout "50%_B"
	set tcp.label  			.
	set mcp.label  			.
EndLayout

Layout "75%_B"
	set tcp.label  			.
	set mcp.label  			.
EndLayout

Layout "50%_C"
	set tcp.label  			.
	set mcp.label  			.
EndLayout

Layout "75%_C"
	set tcp.label  			.
	set mcp.label  			.
EndLayout

;						requested	scale >	use
layout_dpi_translate 	'50%_A' 	1.0 	'A'
layout_dpi_translate 	'75%_A' 	1.0 	'A'

layout_dpi_translate 	'50%_A' 	1.34 	'A'
layout_dpi_translate 	'75%_A' 	1.34 	'A'
layout_dpi_translate 	'A' 		1.34 	'150%_A'
layout_dpi_translate 	'150%_A' 	1.34 	'200%_A'

layout_dpi_translate 	'50%_A' 	1.74 	'A'
layout_dpi_translate 	'75%_A' 	1.74 	'150%_A'
layout_dpi_translate 	'A' 		1.74 	'200%_A'
layout_dpi_translate 	'150%_A' 	1.74 	'200%_A'

layout_dpi_translate 	'50%_B' 	1.0 	'B'
layout_dpi_translate 	'75%_B' 	1.0 	'B'

layout_dpi_translate 	'50%_B' 	1.34 	'B'
layout_dpi_translate 	'75%_B' 	1.34	'B'
layout_dpi_translate 	'B' 		1.34	'150%_B'
layout_dpi_translate 	'150%_B' 	1.34 	'200%_B'

layout_dpi_translate 	'50%_B' 	1.74 	'B'
layout_dpi_translate 	'75%_B' 	1.74 	'150%_B'
layout_dpi_translate 	'B' 		1.74 	'200%_B'
layout_dpi_translate 	'150%_B' 	1.74 	'200%_B'

layout_dpi_translate 	'50%_C' 	1.0 	'C'
layout_dpi_translate 	'75%_C' 	1.0 	'C'

layout_dpi_translate 	'50%_C' 	1.34 	'C'
layout_dpi_translate 	'75%_C' 	1.34	'C'
layout_dpi_translate 	'C' 		1.34 	'150%_C'
layout_dpi_translate 	'150%_C' 	1.34 	'200%_C'

layout_dpi_translate 	'50%_C' 	1.74 	'C'
layout_dpi_translate 	'75%_C' 	1.74 	'150%_C'
layout_dpi_translate 	'C' 		1.74 	'200%_C'
layout_dpi_translate 	'150%_C' 	1.74 	'200%_C'

; -- no layout chosen, dpi_translate as A
layout_dpi_translate 	'' 			1.34 	'150%_A'
layout_dpi_translate 	'' 			1.74 	'200%_A'
`
