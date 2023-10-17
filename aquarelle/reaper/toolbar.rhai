/*
 * SPDX-FileCopyrightText: 2023 Eduardo Javier Alvarado Aarón <eduardo.javier.alvarado.aaron@gmail.com>
 *
 * SPDX-License-Identifier: Apache-2.0
 */

const   main = cfg::scheme("main");
const accent = cfg::option("accent");

private fn icon(name, on, scale) {
	const color = if on { global::main[global::accent].like } else { global::main.lower.text };
	const on = if on { 0.2 } else { 0.0 };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 90 30" width="${90 * scale}" height="${30 * scale}">
		<rect fill=${color.fade(0.0 + on).out()} width="28" height="28" x="1" y="1" rx="3" ry="3"/>
		<rect fill=${color.fade(0.1 + on).out()} width="28" height="28" x="31" y="1" rx="3" ry="3"/>
		<rect fill=${color.fade(0.2 + on).out()} width="28" height="28" x="61" y="1" rx="3" ry="3"/>
		${if name == "dock" {
			`<path fill=${color.fade(0.2).out()} d="M 5,6V 19H 25V 6ZM 35,6V 19H 55V 6ZM 65,6V 19H 85V 6Z"/>
			<path fill=${global::main.lower.like.shadow(1)} d="m 9,7v 3H 6.5v 1l 6,7.5 6,-7.5V 10H 16V 7Zm 30,0v 3h -2.5v 1l 6,7.5 6,-7.5V 10H 46V 7Zm 30,0v 3h -2.5v 1l 6,7.5 6,-7.5V 10H 76V 7ZM 10,8h 5v 3h 2L 12.5,17 8,11h 2zm 30,0h 5v 3h 2L 42.5,17 38,11h 2zm 30,0h 5v 3h 2L 72.5,17 68,11h 2z"/>`
		}}
		<path fill=${color.out()} d="${switch name {
			"dock" => `m 10,8v 3H 8l 4.5,6 4.5,-6H 15V 8Zm 30,0v 3h -2l 4.5,6 4.5,-6H 45V 8Zm 30,0v 3h -2l 4.5,6 4.5,-6H 75V 8ZM 5,19v 1l 4,5h 7.5l 4,-5H 25v -1zm 30,0v 1l 4,5h 7.5l 4,-5H 55v -1zm 30,0v 1l 4,5h 7.5l 4,-5H 85v -1z`,
			"envitem" => `M 14,6V 8.25L 11.25,11H 9v 3h 3V 11.75L 14.75,9h 1.5L 18,10.75V 13h 3V 10H 18.75L 17,8.25V 6ZM 44,6V 8.25L 41.25,11H 39v 3h 3V 11.75L 44.75,9h 1.5L 48,10.75V 13h 3V 10H 48.75L 47,8.25V 6ZM 74,6V 8.25L 71.25,11H 69v 3h 3V 11.75L 74.75,9h 1.5L 78,10.75V 13h 3V 10H 78.75L 77,8.25V 6ZM 9.5,18A 3.5,3.5 0 0 0 6,21.5 3.5,3.5 0 0 0 9.5,25H 13V 24H 9.5A 2.5,2.5 0 0 1 7,21.5 2.5,2.5 0 0 1 9.5,19H 13v -1zm 7.5,0v 1h 3.5A 2.5,2.5 0 0 1 23,21.5 2.5,2.5 0 0 1 20.5,24H 17v 1h 3.5A 3.5,3.5 0 0 0 24,21.5 3.5,3.5 0 0 0 20.5,18Zm 22.5,0A 3.5,3.5 0 0 0 36,21.5 3.5,3.5 0 0 0 39.5,25H 43V 24H 39.5A 2.5,2.5 0 0 1 37,21.5 2.5,2.5 0 0 1 39.5,19H 43v -1zm 7.5,0v 1h 3.5A 2.5,2.5 0 0 1 53,21.5 2.5,2.5 0 0 1 50.5,24H 47v 1h 3.5A 3.5,3.5 0 0 0 54,21.5 3.5,3.5 0 0 0 50.5,18Zm 22.5,0A 3.5,3.5 0 0 0 66,21.5 3.5,3.5 0 0 0 69.5,25H 73V 24H 69.5A 2.5,2.5 0 0 1 67,21.5 2.5,2.5 0 0 1 69.5,19H 73v -1zm 7.5,0v 1h 3.5A 2.5,2.5 0 0 1 83,21.5 2.5,2.5 0 0 1 80.5,24H 77v 1h 3.5A 3.5,3.5 0 0 0 84,21.5 3.5,3.5 0 0 0 80.5,18Zm -66,3v 1h 8v -1zm 30,0v 1h 8v -1zm 30,0v 1h 8v -1z`,
			"filter" => `m 6,7v 1l 7,7v 6l 4,4V 15L 24,8V 7Zm 30,0v 1l 7,7v 6l 4,4V 15L 54,8V 7Zm 30,0v 1l 7,7v 6l 4,4V 15L 84,8V 7ZM 8,8h 14l -6,6v 8l -2,-2v -6zm 30,0h 14l -6,6v 8l -2,-2v -6zm 30,0h 14l -6,6v 8l -2,-2v -6z`,
			"grid" => `m 7,7v 4H 8V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 15,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 15,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7Zm 5,0v 4h 1V 7ZM 7,13v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 15,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 15,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1V 13ZM 7,19v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 15,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 15,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4zm 5,0v 4h 1v -4z`,
			"group" => `M 8.5,11A 4.5,4.5 0 0 0 4,15.5 4.5,4.5 0 0 0 8.5,20H 13V 19H 8.5A 3.5,3.5 0 0 1 5,15.5 3.5,3.5 0 0 1 8.5,12H 13v -1zm 8.5,0v 1h 4.5A 3.5,3.5 0 0 1 25,15.5 3.5,3.5 0 0 1 21.5,19H 17v 1h 4.5A 4.5,4.5 0 0 0 26,15.5 4.5,4.5 0 0 0 21.5,11Zm 21.5,0A 4.5,4.5 0 0 0 34,15.5 4.5,4.5 0 0 0 38.5,20H 43V 19H 38.5A 3.5,3.5 0 0 1 35,15.5 3.5,3.5 0 0 1 38.5,12H 43v -1zm 8.5,0v 1h 4.5A 3.5,3.5 0 0 1 55,15.5 3.5,3.5 0 0 1 51.5,19H 47v 1h 4.5A 4.5,4.5 0 0 0 56,15.5 4.5,4.5 0 0 0 51.5,11Zm 21.5,0A 4.5,4.5 0 0 0 64,15.5 4.5,4.5 0 0 0 68.5,20H 73V 19H 68.5A 3.5,3.5 0 0 1 65,15.5 3.5,3.5 0 0 1 68.5,12H 73v -1zm 8.5,0v 1h 4.5A 3.5,3.5 0 0 1 85,15.5 3.5,3.5 0 0 1 81.5,19H 77v 1h 4.5A 4.5,4.5 0 0 0 86,15.5 4.5,4.5 0 0 0 81.5,11Zm -67,4v 1h 10v -1zm 30,0v 1h 10v -1zm 30,0v 1h 10v -1z`,
			"load" => `m 8,7v 16h 5V 22H 9V 8h 8v 4h 4v 3h 1V 11L 18,7Zm 30,0v 16h 5V 22H 39V 8h 8v 4h 4v 3h 1V 11L 48,7Zm 30,0v 16h 5V 22H 69V 8h 8v 4h 4v 3h 1V 11L 78,7Zm -54,9v 7h 8v -6h -3l -1,-1zm 30,0v 7h 8v -6h -3l -1,-1zm 30,0v 7h 8v -6h -3l -1,-1zm -57,2h 4v 4h -6v -3h 1zm 30,0h 4v 4h -6v -3h 1zm 30,0h 4v 4h -6v -3h 1z`,
			"lock" => `m 15,7a 5,5 0 0 0 -5,5v 3H 8v 8H 22V 15H 20V 12A 5,5 0 0 0 15,7Zm 30,0a 5,5 0 0 0 -5,5v 3h -2v 8H 52V 15H 50V 12A 5,5 0 0 0 45,7Zm 30,0a 5,5 0 0 0 -5,5v 3h -2v 8H 82V 15H 80V 12A 5,5 0 0 0 75,7ZM 15,9a 3,3 0 0 1 3,3v 3h -6v -3a 3,3 0 0 1 3,-3zm 30,0a 3,3 0 0 1 3,3v 3h -6v -3a 3,3 0 0 1 3,-3zm 30,0a 3,3 0 0 1 3,3v 3h -6v -3a 3,3 0 0 1 3,-3z`,
			"metro" => `M 12,6 8,24h 14l -1.78,-8h -1.25l 0.66,3h -9.25L 13,7h 4l 0.88,4h 1.24L 18,6Zm 30,0 -4,18h 14l -1.78,-8h -1.25l 0.66,3h -9.25L 43,7h 4l 0.88,4h 1.24L 48,6Zm 30,0 -4,18h 14l -1.78,-8h -1.25l 0.66,3h -9.25L 73,7h 4l 0.88,4h 1.24L 78,6ZM 14,9v 1h 2V 9ZM 22.75,9 14.5,17.25 15.25,18 23.5,9.75ZM 44,9v 1h 2V 9ZM 52.75,9 44.5,17.25 45.25,18 53.5,9.75ZM 74,9v 1h 2V 9ZM 82.75,9 74.5,17.25 75.25,18 83.5,9.75ZM 14,11v 1h 2v -1zm 30,0v 1h 2v -1zm 30,0v 1h 2v -1zm -60,2v 1h 2v -1zm 30,0v 1h 2v -1zm 30,0v 1h 2v -1zm -63.84,7h 9.69L 20.5,23h -11zm 30,0h 9.69L 50.5,23h -11zm 30,0h 9.69L 80.5,23h -11z`,
			"midi_itemsel" => `M 4,6V 7H 5V 6ZM 6,6V 7H 7V 6ZM 8,6V 7H 9V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 8,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 8,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6Zm 2,0v 1h 1V 6ZM 6,10v 3h 14v -3zm 30,0v 3h 14v -3zm 30,0v 3H 80V 10ZM 7,11h 12v 1H 7Zm 30,0h 12v 1H 37Zm 30,0h 12v 1H 67Zm -57,4v 3h 14v -3zm 30,0v 3h 14v -3zm 30,0v 3H 84V 15ZM 7,20v 3h 17v -3zm 30,0v 3h 17v -3zm 30,0v 3H 84V 20ZM 8,21h 15v 1H 8Zm 30,0h 15v 1H 38Zm 30,0h 15v 1H 68Z`,
			"midi_tracksel" => `M 5,6V 25H 25V 6ZM 35,6V 25H 55V 6ZM 65,6V 25H 85V 6ZM 6,7H 24V 24H 6ZM 36,7H 54V 24H 36ZM 66,7H 84V 24H 66ZM 18,8v 1h 5V 8Zm 30,0v 1h 5V 8Zm 30,0v 1h 5V 8Zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1zm -60,2v 1h 5v -1zm 30,0v 1h 5v -1zm 30,0v 1h 5v -1z`,
			"new" => `m 8,7v 16h 9V 22H 9V 8h 8v 4h 4v 6h 1V 11L 18,7Zm 30,0v 16h 9V 22H 39V 8h 8v 4h 4v 6h 1V 11L 48,7Zm 30,0v 16h 9V 22H 69V 8h 8v 4h 4v 6h 1V 11L 78,7ZM 19,18v 2h -2v 1h 2v 2h 1v -2h 2v -1h -2v -2zm 30,0v 2h -2v 1h 2v 2h 1v -2h 2v -1h -2v -2zm 30,0v 2h -2v 1h 2v 2h 1v -2h 2v -1h -2v -2z`,
			"projprop" => `M 14.5,6A 9.5,9.5 0 0 0 5,15.5 9.5,9.5 0 0 0 14.5,25 9.5,9.5 0 0 0 24,15.5 9.5,9.5 0 0 0 14.5,6Zm 30,0A 9.5,9.5 0 0 0 35,15.5 9.5,9.5 0 0 0 44.5,25 9.5,9.5 0 0 0 54,15.5 9.5,9.5 0 0 0 44.5,6Zm 30,0A 9.5,9.5 0 0 0 65,15.5 9.5,9.5 0 0 0 74.5,25 9.5,9.5 0 0 0 84,15.5 9.5,9.5 0 0 0 74.5,6Zm -60,1A 8.5,8.5 0 0 1 23,15.5 8.5,8.5 0 0 1 14.5,24 8.5,8.5 0 0 1 6,15.5 8.5,8.5 0 0 1 14.5,7Zm 30,0A 8.5,8.5 0 0 1 53,15.5 8.5,8.5 0 0 1 44.5,24 8.5,8.5 0 0 1 36,15.5 8.5,8.5 0 0 1 44.5,7Zm 30,0A 8.5,8.5 0 0 1 83,15.5 8.5,8.5 0 0 1 74.5,24 8.5,8.5 0 0 1 66,15.5 8.5,8.5 0 0 1 74.5,7ZM 14,10v 2h 2v -2zm 30,0v 2h 2v -2zm 30,0v 2h 2v -2zm -62,3v 1h 2v 5h -2v 1h 6v -1h -2v -5 -1zm 30,0v 1h 2v 5h -2v 1h 6v -1h -2v -5 -1zm 30,0v 1h 2v 5h -2v 1h 6v -1h -2v -5 -1z`,
			"redo" => `m 77.75,7 3.5,3.5L 77.75,14 77,13.25 79.25,11H 75.5A 5.5,5.5 0 0 0 70,16.5 5.5,5.5 0 0 0 75.5,22H 77v 1H 75.5A 6.5,6.5 0 0 1 69,16.5 6.5,6.5 0 0 1 75.5,10h 3.75L 77,7.75Zm -30,0 3.5,3.5L 47.75,14 47,13.25 49.25,11H 45.5A 5.5,5.5 0 0 0 40,16.5 5.5,5.5 0 0 0 45.5,22H 47v 1H 45.5A 6.5,6.5 0 0 1 39,16.5 6.5,6.5 0 0 1 45.5,10h 3.75L 47,7.75Zm -30,0 3.5,3.5L 17.75,14 17,13.25 19.25,11H 15.5A 5.5,5.5 0 0 0 10,16.5 5.5,5.5 0 0 0 15.5,22H 17v 1H 15.5A 6.5,6.5 0 0 1 9,16.5 6.5,6.5 0 0 1 15.5,10h 3.75L 17,7.75Z`,
			"relsnap" => `M 5,7V 9H 7V 7Zm 13,0v 2h 2.5A 3.5,3.5 0 0 1 24,12.5 3.5,3.5 0 0 1 20.5,16H 18v 2h 2.5A 5.5,5.5 0 0 0 26,12.5 5.5,5.5 0 0 0 20.5,7Zm 17,0v 2h 2V 7Zm 13,0v 2h 2.5A 3.5,3.5 0 0 1 54,12.5 3.5,3.5 0 0 1 50.5,16H 48v 2h 2.5A 5.5,5.5 0 0 0 56,12.5 5.5,5.5 0 0 0 50.5,7Zm 17,0v 2h 2V 7Zm 13,0v 2h 2.5A 3.5,3.5 0 0 1 84,12.5 3.5,3.5 0 0 1 80.5,16H 78v 2h 2.5A 5.5,5.5 0 0 0 86,12.5 5.5,5.5 0 0 0 80.5,7ZM 5,16v 2h 2v -2zm 30,0v 2h 2v -2zm 30,0v 2h 2v -2zm -55,4 -4,2.5 4,2.5v -2h 5v 2L 19,22.5 15,20v 2h -5zm 30,0 -4,2.5 4,2.5v -2h 5v 2L 49,22.5 45,20v 2h -5zm 30,0 -4,2.5 4,2.5v -2h 5v 2L 79,22.5 75,20v 2h -5z`,
			"ripple_all" => `m 6,7v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7ZM 7,8h 3v 2H 7Zm 30,0h 3v 2h -3zm 30,0h 3v 2H 67ZM 6,13v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 13ZM 7,14h 3v 2H 7Zm 30,0h 3v 2h -3zm 30,0h 3v 2H 67ZM 6,19v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 19ZM 7,20h 3v 2H 7Zm 30,0h 3v 2h -3zm 30,0h 3v 2h -3z`,
			"ripple_off" => `m 6,7v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7ZM 7,8h 3v 2H 7Zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2H 81ZM 6,13v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 13ZM 7,14h 3v 2H 7Zm 14,0h 3v 2h -3zm 16,0h 3v 2h -3zm 14,0h 3v 2h -3zm 16,0h 3v 2h -3zm 14,0h 3v 2H 81ZM 6,19v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 19ZM 7,20h 3v 2H 7Zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3z`,
			"ripple_one" => `m 6,7v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 16,0v 4h 5V 7Zm 7,0v 4h 5V 7Zm 7,0v 4h 5V 7ZM 7,8h 3v 2H 7Zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2H 81ZM 6,13v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 13ZM 7,14h 3v 2H 7Zm 30,0h 3v 2h -3zm 30,0h 3v 2H 67ZM 6,19v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5v -4zm 16,0v 4h 5v -4zm 7,0v 4h 5v -4zm 7,0v 4h 5V 19ZM 7,20h 3v 2H 7Zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3zm 16,0h 3v 2h -3zm 7,0h 3v 2h -3zm 7,0h 3v 2h -3z`,
			"save" => `M 7,7V 23H 23V 22 10.3L 19.7,7H 19ZM 37,7V 23H 53V 22 10.3L 49.7,7H 49ZM 67,7V 23H 83V 22 10.3L 79.7,7H 79ZM 8,8h 3v 5h 8V 8h 0.3L 22,10.7V 22H 20V 15H 10v 7H 8Zm 4,0h 4v 4h -4zm 26,0h 3v 5h 8V 8h 0.3L 52,10.7V 22H 50V 15H 40v 7h -2zm 4,0h 4v 4h -4zm 26,0h 3v 5h 8V 8h 0.3L 82,10.7V 22H 80V 15H 70v 7h -2zm 4,0h 4v 4h -4zm -61,8h 8v 6h -8zm 30,0h 8v 6h -8zm 30,0h 8v 6h -8z`,
			"snap" => `m 7,7v 3H 9V 7Zm 4,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4a 8,8 0 0 0 8,-8 8,8 0 0 0 -8,-8zm 26,0v 3h 2V 7Zm 4,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4a 8,8 0 0 0 8,-8 8,8 0 0 0 -8,-8zm 26,0v 3h 2V 7Zm 4,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4A 8,8 0 0 0 83,15 8,8 0 0 0 75,7ZM 7,20v 3h 2v -3zm 30,0v 3h 2v -3zm 30,0v 3h 2v -3z`,
			"undo" => `M 12.25,7 8.75,10.5 12.25,14 13,13.25 10.75,11H 14.5A 5.5,5.5 0 0 1 20,16.5 5.5,5.5 0 0 1 14.5,22H 13v 1h 1.5A 6.5,6.5 0 0 0 21,16.5 6.5,6.5 0 0 0 14.5,10H 10.75L 13,7.75Zm 30,0 -3.5,3.5 3.5,3.5L 43,13.25 40.75,11H 44.5A 5.5,5.5 0 0 1 50,16.5 5.5,5.5 0 0 1 44.5,22H 43v 1h 1.5A 6.5,6.5 0 0 0 51,16.5 6.5,6.5 0 0 0 44.5,10H 40.75L 43,7.75Zm 30,0 -3.5,3.5 3.5,3.5L 73,13.25 70.75,11H 74.5A 5.5,5.5 0 0 1 80,16.5 5.5,5.5 0 0 1 74.5,22H 73v 1h 1.5A 6.5,6.5 0 0 0 81,16.5 6.5,6.5 0 0 0 74.5,10H 70.75L 73,7.75Z`,
			"xfade" => `m 4,7v 1h 7l 2.25,4 0.5,-1L 11.5,7ZM 18.5,7 9.5,22.75 10.25,23.5 19,8h 7V 7ZM 34,7v 1h 7l 2.25,4 0.5,-1 -2.25,-4zm 14.5,0 -9,15.75 0.75,0.75L 49,8h 7V 7ZM 64,7v 1h 7l 2.25,4 0.5,-1 -2.25,-4zm 14.5,0 -9,15.75 0.75,0.75L 79,8h 7V 7Zm -61.5,9.5 -0.5,1 3.25,6 0.75,-0.75zm 30,0 -0.5,1 3.25,6 0.75,-0.75zm 30,0 -0.5,1 3.25,6 0.75,-0.75z`,
			// "" => ``,
		}}"/>
	</svg>`
}

private fn icon_150(name, on) {
	const color = if on { global::main.lower.text } else { global::main[global::accent].like };
	const on = if on { 0.2 } else { 0.0 };
	
	`<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 135 45">
		<rect fill=${color.fade(0.0 + on).out()} width="43" height="43" x="1" y="1" rx="6" ry="6"/>
		<rect fill=${color.fade(0.1 + on).out()} width="43" height="43" x="46" y="1" rx="6" ry="6"/>
		<rect fill=${color.fade(0.2 + on).out()} width="43" height="43" x="91" y="1" rx="6" ry="6"/>
		${if name == "dock" {
			`<path fill=${color.fade(0.2).out()} d="M 7,9V 29H 38V 9ZM 52,9V 29H 83V 9Zm 45,0v 20h 31V 9Z"/>
			<path fill=${global::main.lower.like.shadow(1)} d="m 13.5,10.5v 5H 9L 18,28h 2l 9,-12.5h -4.5v -5zm 45,0v 5H 54L 63,28h 2l 9,-12.5h -4.5v -5zm 45,0v 5H 99l 9,12.5h 2l 9,-12.5h -4.5v -5zM 15,12h 8v 5h 3l -7,9 -7,-9h 3zm 45,0h 8v 5h 3l -7,9 -7,-9h 3zm 45,0h 8v 5h 3l -7,9 -7,-9h 3z"/>`
		}}
		<path fill=${color.out()} d="${switch name {
			"dock" => `m 15,12v 5h -3l 7,9 7,-9h -3v -5zm 45,0v 5h -3l 7,9 7,-9h -3v -5zm 45,0v 5h -3l 7,9 7,-9h -3V 12ZM 7,29v 1l 6,7h 11l 6,-7h 8v -1zm 45,0v 1l 6,7h 11l 6,-7h 8v -1zm 45,0v 1l 6,7h 11l 6,-7h 8v -1z`,
			"envitem" => `m 21,9v 4.2L 17.2,16H 13v 5h 5V 16.8L 21.8,14h 3.4L 27,15.8V 20h 5V 15H 27.8L 26,13.2V 9Zm 45,0v 4.2L 62.2,16H 58v 5h 5V 16.8L 66.8,14h 3.4L 72,15.8V 20h 5V 15H 72.8L 71,13.2V 9Zm 45,0v 4.2L 107.2,16H 103v 5h 5V 16.8L 111.8,14h 3.4L 117,15.8V 20h 5v -5h -4.2L 116,13.2V 9ZM 14.5,26A 5.5,5.5 0 0 0 9,31.5 5.5,5.5 0 0 0 14.5,37H 20V 36H 14.5A 4.5,4.5 0 0 1 10,31.5 4.5,4.5 0 0 1 14.5,27H 20V 26ZM 26,26v 1h 4.5c 2.5,0 4.5,2 4.5,4.5 0,2.5 -2,4.5 -4.5,4.5H 26v 1h 4.5C 33.5,37 36,34.5 36,31.5 36,28.5 33.5,26 30.5,26Zm 33.5,0A 5.5,5.5 0 0 0 54,31.5 5.5,5.5 0 0 0 59.5,37H 65V 36H 59.5A 4.5,4.5 0 0 1 55,31.5 4.5,4.5 0 0 1 59.5,27H 65V 26ZM 71,26v 1h 4.5c 2.5,0 4.5,2 4.5,4.5 0,2.5 -2,4.5 -4.5,4.5H 71v 1h 4.5C 78.5,37 81,34.5 81,31.5 81,28.5 78.5,26 75.5,26Zm 33.5,0a 5.5,5.5 0 0 0 -5.5,5.5 5.5,5.5 0 0 0 5.5,5.5h 5.5v -1h -5.5A 4.5,4.5 0 0 1 100,31.5 4.5,4.5 0 0 1 104.5,27h 5.5v -1zm 11.5,0v 1h 4.5c 2.5,0 4.5,2 4.5,4.5 0,2.5 -2,4.5 -4.5,4.5H 116v 1h 4.5c 3,0 5.5,-2.5 5.5,-5.5 0,-3 -2.5,-5.5 -5.5,-5.5zm -99,5v 1h 12v -1zm 45,0v 1h 12v -1zm 45,0v 1h 12v -1z`,
			"filter" => `m 8,10v 2l 11,11v 9l 7,6V 23L 37,12v -2zm 45,0v 2l 11,11v 9l 7,6V 23L 82,12v -2zm 45,0v 2l 11,11v 9l 7,6V 23L 127,12V 10ZM 11,12H 34L 24,22V 33.5L 21,31v -9zm 45,0H 79L 69,22V 33.5L 66,31v -9zm 45,0h 23L 114,22V 33.5L 111,31v -9z`,
			"grid" => `m 10,11v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1V 11ZM 10,20v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1V 20ZM 10,29v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 21,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6zm 8,0v 6h 1v -6z`,
			"group" => `m 13,16c -3.9,0 -7,3.1 -7,7 0,3.9 3.1,7 7,7h 7v -2h -7c -2.7,0 -4.9,-2.3 -5,-5 0,-2.8 2.2,-5 5,-5h 7v -2zm 12,0v 2h 7c 2.8,0 5,2.2 5,5 -0.1,2.7 -2.3,5 -5,5h -7v 2h 7c 3.9,0 7,-3.1 7,-7 0,-3.9 -3.1,-7 -7,-7zm 33,0c -3.9,0 -7,3.1 -7,7 0,3.9 3.1,7 7,7h 7v -2h -7c -2.7,0 -4.9,-2.3 -5,-5 0,-2.8 2.2,-5 5,-5h 7v -2zm 12,0v 2h 7c 2.8,0 5,2.2 5,5 -0.1,2.7 -2.3,5 -5,5h -7v 2h 7c 3.9,0 7,-3.1 7,-7 0,-3.9 -3.1,-7 -7,-7zm 33,0c -3.9,0 -7,3.1 -7,7 0,3.9 3.1,7 7,7h 7v -2h -7c -2.7,0 -4.9,-2.3 -5,-5 0,-2.8 2.2,-5 5,-5h 7v -2zm 12,0v 2h 7c 2.8,0 5,2.2 5,5 -0.1,2.7 -2.3,5 -5,5h -7v 2h 7c 3.9,0 7,-3.1 7,-7 0,-3.9 -3.1,-7 -7,-7zM 15,22v 2h 15v -2zm 45,0v 2h 15v -2zm 45,0v 2h 15v -2z`,
			"load" => `m 11,10v 24h 7V 33H 12V 11h 11v 7h 7v 4h 1v -5l -7,-7h -1zm 45,0v 24h 7V 33H 57V 11h 11v 7h 7v 4h 1v -5l -7,-7h -1zm 45,0v 24h 7v -1h -6V 11h 11v 7h 7v 4h 1v -5l -7,-7h -1zM 19,22v 11 1H 31V 24h -5l -2,-2zm 45,0v 11 1H 76V 24h -5l -2,-2zm 45,0v 11 1h 12V 24h -5l -2,-2zm -89,1h 3.6l 1,1H 24l -2,2h -2zm 45,0h 3.6l 1,1H 69l -2,2h -2zm 45,0h 3.6l 1,1H 114l -2,2h -2zm -90,4h 10v 6H 20Zm 45,0h 10v 6H 65Zm 45,0h 10v 6h -10z`,
			"lock" => `M 22.5,10A 7.5,7.5 0 0 0 15,17.5V 23H 12V 35H 33V 23H 30V 17.5A 7.5,7.5 0 0 0 22.5,10Zm 45,0A 7.5,7.5 0 0 0 60,17.5V 23H 57V 35H 78V 23H 75V 17.5A 7.5,7.5 0 0 0 67.5,10Zm 45,0A 7.5,7.5 0 0 0 105,17.5V 23h -3v 12h 21V 23h -3V 17.5A 7.5,7.5 0 0 0 112.5,10Zm -90,3A 4.5,4.5 0 0 1 27,17.5V 23H 18V 17.5A 4.5,4.5 0 0 1 22.5,13Zm 45,0A 4.5,4.5 0 0 1 72,17.5V 23H 63V 17.5A 4.5,4.5 0 0 1 67.5,13Zm 45,0a 4.5,4.5 0 0 1 4.5,4.5V 23h -9v -5.5a 4.5,4.5 0 0 1 4.5,-4.5z`,
			"metro" => `M 18,9 12,36H 33L 30.11,23h -1.25l 1.32,6H 14.82L 19,10h 7l 1.54,7h 1.24L 27,9ZM 63,9 57,36H 78L 75.11,23h -1.25l 1.32,6H 59.82L 64,10h 7l 1.54,7h 1.24L 72,9Zm 45,0 -6,27h 21l -2.89,-13h -1.25l 1.32,6H 104.82L 109,10h 7l 1.54,7h 1.24L 117,9ZM 36.25,12 22,26.25 22.75,27 37,12.75Zm 45,0L 67,26.25 67.75,27 82,12.75Zm 45,0L 112,26.25 112.75,27 127,12.75ZM 21,13v 1h 3v -1zm 45,0v 1h 3v -1zm 45,0v 1h 3v -1zm -90,3v 1h 3v -1zm 45,0v 1h 3v -1zm 45,0v 1h 3v -1zm -90,3v 1h 3v -1zm 45,0v 1h 3v -1zm 45,0v 1h 3V 19ZM 14.6,30H 30.4L 31.5,35h -18zm 45,0H 75.4L 76.5,35h -18zm 45,0h 15.8L 121.5,35h -18z`,
			"midi_itemsel" => `m 6,9v 1H 7V 9Zm 2,0v 1H 9V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 11,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 11,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9Zm 2,0v 1h 1V 9ZM 9,14v 5h 21v -5zm 45,0v 5h 21v -5zm 45,0v 5h 21v -5zm -89,1h 19v 3H 10Zm 45,0h 19v 3H 55Zm 45,0h 19v 3h -19zm -85,7v 5h 21v -5zm 45,0v 5h 21v -5zm 45,0v 5h 21v -5zm -95,8v 5h 26v -5zm 45,0v 5h 26v -5zm 45,0v 5h 26v -5zm -89,1h 24v 3H 11Zm 45,0h 24v 3H 56Zm 45,0h 24v 3h -24z`,
			"midi_tracksel" => `M 8,8V 37H 37V 8ZM 53,8V 37H 82V 8Zm 45,0v 29h 29V 8ZM 9,9H 36V 36H 9ZM 54,9H 81V 36H 54Zm 45,0h 27V 36H 99Zm -73,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1zm -90,2v 1h 8v -1zm 45,0v 1h 8v -1zm 45,0v 1h 8v -1z`,
			"new" => `m 11,10v 24h 9V 33H 12V 11h 11v 7h 7v 5h 1v -6l -7,-7zm 45,0v 24h 9V 33H 57V 11h 11v 7h 7v 5h 1v -6l -7,-7zm 45,0v 24h 9v -1h -8V 11h 11v 7h 7v 5h 1v -6l -7,-7zM 25,23v 5h -5v 1h 5v 5h 1v -5h 5v -1h -5v -5zm 45,0v 5h -5v 1h 5v 5h 1v -5h 5v -1h -5v -5zm 45,0v 5h -5v 1h 5v 5h 1v -5h 5v -1h -5v -5z`,
			"projprop" => `M 21.5,9A 14.5,14.5 0 0 0 7,23.5 14.5,14.5 0 0 0 21.5,38 14.5,14.5 0 0 0 36,23.5 14.5,14.5 0 0 0 21.5,9Zm 45,0A 14.5,14.5 0 0 0 52,23.5 14.5,14.5 0 0 0 66.5,38 14.5,14.5 0 0 0 81,23.5 14.5,14.5 0 0 0 66.5,9Zm 45,0A 14.5,14.5 0 0 0 97,23.5 14.5,14.5 0 0 0 111.5,38 14.5,14.5 0 0 0 126,23.5 14.5,14.5 0 0 0 111.5,9Zm -90,1.5a 13,13 0 0 1 13,13 13,13 0 0 1 -13,13 13,13 0 0 1 -13,-13 13,13 0 0 1 13,-13zm 45,0a 13,13 0 0 1 13,13 13,13 0 0 1 -13,13 13,13 0 0 1 -13,-13 13,13 0 0 1 13,-13zm 45,0a 13,13 0 0 1 13,13 13,13 0 0 1 -13,13 13,13 0 0 1 -13,-13 13,13 0 0 1 13,-13zM 20,15v 3h 3v -3zm 45,0v 3h 3v -3zm 45,0v 3h 3v -3zm -93,5v 2h 3v 6h -3v 2h 9v -2h -3v -6 -2zm 45,0v 2h 3v 6h -3v 2h 9v -2h -3v -6 -2zm 45,0v 2h 3v 6h -3v 2h 9v -2h -3v -6 -2z`,
			"redo" => `m 116,9.5 5,5 -5,5 -0.75,-0.75L 119,15h -8a 9,9 0 0 0 -9,9 9,9 0 0 0 9,9h 1v 1h -1A 10,10 0 0 1 101,24 10,10 0 0 1 111,14h 8l -3.75,-3.75zm -45,0 5,5 -5,5L 70.25,18.75 74,15h -8a 9,9 0 0 0 -9,9 9,9 0 0 0 9,9h 1v 1H 66A 10,10 0 0 1 56,24 10,10 0 0 1 66,14h 8l -3.75,-3.75zm -45,0 5,5 -5,5L 25.25,18.75 29,15h -8a 9,9 0 0 0 -9,9 9,9 0 0 0 9,9h 1v 1H 21A 10,10 0 0 1 11,24 10,10 0 0 1 21,14h 8l -3.75,-3.75z`,
			"relsnap" => `m 7,11v 3h 3v -3zm 20,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4a 8,8 0 0 0 8,-8 8,8 0 0 0 -8,-8zm 25,0v 3h 3v -3zm 20,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4a 8,8 0 0 0 8,-8 8,8 0 0 0 -8,-8zm 25,0v 3h 3v -3zm 20,0v 3h 4a 5,5 0 0 1 5,5 5,5 0 0 1 -5,5h -4v 3h 4a 8,8 0 0 0 8,-8 8,8 0 0 0 -8,-8zM 7,24v 3h 3v -3zm 45,0v 3h 3v -3zm 45,0v 3h 3v -3zm -82,6 -6,3.5 6,4.5v -3h 7v 3L 28,33.5 22,30v 3h -7zm 45,0 -6,3.5 6,4.5v -3h 7v 3L 73,33.5 67,30v 3h -7zm 45,0 -6,3.5 6,4.5v -3h 7v 3l 6,-4.5 -6,-3.5v 3h -7z`,
			"ripple_all" => `m 9,11v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 11ZM 10,12h 6v 4h -6zm 45,0h 6v 4h -6zm 45,0h 6v 4h -6zM 9,20v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 20ZM 10,21h 6v 4h -6zm 45,0h 6v 4h -6zm 45,0h 6v 4h -6zM 9,29v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 29ZM 10,30h 6v 4h -6zm 45,0h 6v 4h -6zm 45,0h 6v 4h -6z`,
			"ripple_off" => `m 9,11v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 11ZM 10,12h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zM 9,20v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 20ZM 10,21h 6v 4h -6zm 21,0h 6v 4h -6zm 24,0h 6v 4h -6zm 21,0h 6v 4h -6zm 24,0h 6v 4h -6zm 21,0h 6v 4h -6zM 9,29v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 29ZM 10,30h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6z`,
			"ripple_one" => `m 9,11v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 11ZM 10,12h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zM 9,20v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 20ZM 10,21h 6v 4h -6zm 45,0h 6v 4h -6zm 45,0h 6v 4h -6zM 9,29v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8v -6zm 24,0v 6h 8v -6zm 10,0v 6h 8v -6zm 11,0v 6h 8V 29ZM 10,30h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6zm 24,0h 6v 4h -6zm 10,0h 6v 4h -6zm 11,0h 6v 4h -6z`,
			"save" => `M 9,10V 34H 33V 16l -6,-6zm 45,0V 34H 78V 16l -6,-6zm 45,0v 24h 24V 16l -6,-6zm -89,1h 5v 8h 11v -8h 0.6L 32,16.4V 33H 28V 25H 14v 8h -4zm 6,0h 6v 7h -6zm 39,0h 5v 8h 11v -8h 0.6L 77,16.4V 33H 73V 25H 59v 8h -4zm 6,0h 6v 7h -6zm 39,0h 5v 8h 11v -8h 0.6L 122,16.4V 33h -4v -8h -14v 8h -4zm 6,0h 6v 7h -6zM 15,26h 12v 7H 15Zm 45,0h 12v 7H 60Zm 45,0h 12v 7h -12z`,
			"snap" => `m 11,10v 5h 3v -5zm 5,0v 5h 6c 4.1,0 7.5,3.4 7.5,7.5 0,4.1 -3.4,7.5 -7.5,7.5h -6v 5h 6C 28.9,35 34.5,29.4 34.5,22.5 34.5,15.6 28.9,10 22,10Zm 40,0v 5h 3v -5zm 5,0v 5h 6c 4.1,0 7.5,3.4 7.5,7.5 0,4.1 -3.4,7.5 -7.5,7.5h -6v 5h 6C 73.9,35 79.5,29.4 79.5,22.5 79.5,15.6 73.9,10 67,10Zm 40,0v 5h 3v -5zm 5,0v 5h 6c 4.1,0 7.5,3.4 7.5,7.5 0,4.1 -3.4,7.5 -7.5,7.5h -6v 5h 6c 6.9,0 12.5,-5.6 12.5,-12.5C 124.5,15.6 118.9,10 112,10ZM 11,30v 5h 3v -5zm 45,0v 5h 3v -5zm 45,0v 5h 3v -5z`,
			"undo" => `m 16,9.5 -5,5 5,5 0.75,-0.75L 13,15h 8a 9,9 0 0 1 9,9 9,9 0 0 1 -9,9h -1v 1h 1A 10,10 0 0 0 31,24 10,10 0 0 0 21,14h -8l 3.75,-3.75zm 45,0 -5,5 5,5 0.75,-0.75L 58,15h 8a 9,9 0 0 1 9,9 9,9 0 0 1 -9,9h -1v 1h 1A 10,10 0 0 0 76,24 10,10 0 0 0 66,14h -8l 3.75,-3.75zm 45,0 -5,5 5,5 0.75,-0.75L 103,15h 8a 9,9 0 0 1 9,9 9,9 0 0 1 -9,9h -1v 1h 1A 10,10 0 0 0 121,24 10,10 0 0 0 111,14h -8l 3.75,-3.75z`,
			"xfade" => `m 6,10v 2h 10l 3.5,5.9 1.6,-1.1L 17,10Zm 22,0 -14,23.5 1.5,1.5L 29,12h 10v -2zm 23,0v 2h 10l 3.5,5.9 1.6,-1.1L 62,10Zm 22,0 -14,23.5 1.5,1.5L 74,12h 10v -2zm 23,0v 2h 10l 3.5,5.9 1.6,-1.1L 107,10Zm 22,0 -14,23.5 1.5,1.5L 119,12h 10V 10ZM 25.6,24.5 24,25.6l 5.5,9.4 1.5,-1.5zm 45,0L 69,25.6l 5.5,9.4 1.5,-1.5zm 45,0 -1.6,1.1 5.5,9.4 1.5,-1.5z`,
			// "" => ``,
		}}"/>
	</svg>`
}

export const map = #{
	toolbar_blank: icon("blank", false, 1),
	toolbar_blank_150: icon_150("blank", false),
	toolbar_blank_200: icon("blank", false, 2),
	toolbar_dock_off: icon("dock", false, 1),
	toolbar_dock_off_150: icon_150("dock", false),
	toolbar_dock_off_200: icon("dock", false, 2),
	toolbar_dock_on: icon("dock", true, 1),
	toolbar_dock_on_150: icon_150("dock", true),
	toolbar_dock_on_200: icon("dock", true, 2),
	toolbar_envitem_off: icon("envitem", false, 1),
	toolbar_envitem_off_150: icon_150("envitem", false),
	toolbar_envitem_off_200: icon("envitem", false, 2),
	toolbar_envitem_on: icon("envitem", true, 1),
	toolbar_envitem_on_150: icon_150("envitem", true),
	toolbar_envitem_on_200: icon("envitem", true, 2),
	toolbar_filter_off: icon("filter", false, 1),
	toolbar_filter_off_150: icon_150("filter", false),
	toolbar_filter_off_200: icon("filter", false, 2),
	toolbar_filter_on: icon("filter", true, 1),
	toolbar_filter_on_150: icon_150("filter", true),
	toolbar_filter_on_200: icon("filter", true, 2),
	toolbar_grid_off: icon("grid", false, 1),
	toolbar_grid_off_150: icon_150("grid", false),
	toolbar_grid_off_200: icon("grid", false, 2),
	toolbar_grid_on: icon("grid", true, 1),
	toolbar_grid_on_150: icon_150("grid", true),
	toolbar_grid_on_200: icon("grid", true, 2),
	toolbar_group_off: icon("group", false, 1),
	toolbar_group_off_150: icon_150("group", false),
	toolbar_group_off_200: icon("group", false, 2),
	toolbar_group_on: icon("group", true, 1),
	toolbar_group_on_150: icon_150("group", true),
	toolbar_group_on_200: icon("group", true, 2),
	toolbar_load: icon("load", false, 1),
	toolbar_load_150: icon_150("load", false),
	toolbar_load_200: icon("load", false, 2),
	toolbar_lock_off: icon("lock", false, 1),
	toolbar_lock_off_150: icon_150("lock", false),
	toolbar_lock_off_200: icon("lock", false, 2),
	toolbar_lock_on: icon("lock", true, 1),
	toolbar_lock_on_150: icon_150("lock", true),
	toolbar_lock_on_200: icon("lock", true, 2),
	toolbar_metro_off: icon("metro", false, 1),
	toolbar_metro_off_150: icon_150("metro", false),
	toolbar_metro_off_200: icon("metro", false, 2),
	toolbar_metro_on: icon("metro", true, 1),
	toolbar_metro_on_150: icon_150("metro", true),
	toolbar_metro_on_200: icon("metro", true, 2),
	toolbar_midi_itemsel_off: icon("midi_itemsel", false, 1),
	toolbar_midi_itemsel_off_150: icon_150("midi_itemsel", false),
	toolbar_midi_itemsel_off_200: icon("midi_itemsel", false, 2),
	toolbar_midi_itemsel_on: icon("midi_itemsel", true, 1),
	toolbar_midi_itemsel_on_150: icon_150("midi_itemsel", true),
	toolbar_midi_itemsel_on_200: icon("midi_itemsel", true, 2),
	toolbar_midi_tracksel_off: icon("midi_tracksel", false, 1),
	toolbar_midi_tracksel_off_150: icon_150("midi_tracksel", false),
	toolbar_midi_tracksel_off_200: icon("midi_tracksel", false, 2),
	toolbar_midi_tracksel_on: icon("midi_tracksel", true, 1),
	toolbar_midi_tracksel_on_150: icon_150("midi_tracksel", true),
	toolbar_midi_tracksel_on_200: icon("midi_tracksel", true, 2),
	toolbar_new: icon("new", false, 1),
	toolbar_new_150: icon_150("new", false),
	toolbar_new_200: icon("new", false, 2),
	toolbar_projprop: icon("projprop", false, 1),
	toolbar_projprop_150: icon_150("projprop", false),
	toolbar_projprop_200: icon("projprop", false, 2),
	toolbar_redo: icon("redo", false, 1),
	toolbar_redo_150: icon_150("redo", false),
	toolbar_redo_200: icon("redo", false, 2),
	toolbar_relsnap_off: icon("relsnap", false, 1),
	toolbar_relsnap_off_150: icon_150("relsnap", false),
	toolbar_relsnap_off_200: icon("relsnap", false, 2),
	toolbar_relsnap_on: icon("relsnap", true, 1),
	toolbar_relsnap_on_150: icon_150("relsnap", true),
	toolbar_relsnap_on_200: icon("relsnap", true, 2),
	toolbar_ripple_all: icon("ripple_all", true, 1),
	toolbar_ripple_all_150: icon_150("ripple_all", true),
	toolbar_ripple_all_200: icon("ripple_all", true, 2),
	toolbar_ripple_off: icon("ripple_off", false, 1),
	toolbar_ripple_off_150: icon_150("ripple_off", false),
	toolbar_ripple_off_200: icon("ripple_off", false, 2),
	toolbar_ripple_one: icon("ripple_one", true, 1),
	toolbar_ripple_one_150: icon_150("ripple_one", true),
	toolbar_ripple_one_200: icon("ripple_one", true, 2),
	toolbar_save: icon("save", false, 1),
	toolbar_save_150: icon_150("save", false),
	toolbar_save_200: icon("save", false, 2),
	toolbar_snap_off: icon("snap", false, 1),
	toolbar_snap_off_150: icon_150("snap", false),
	toolbar_snap_off_200: icon("snap", false, 2),
	toolbar_snap_on: icon("snap", true, 1),
	toolbar_snap_on_150: icon_150("snap", true),
	toolbar_snap_on_200: icon("snap", true, 2),
	toolbar_undo: icon("undo", false, 1),
	toolbar_undo_150: icon_150("undo", false),
	toolbar_undo_200: icon("undo", false, 2),
	toolbar_xfade_off: icon("xfade", false, 1),
	toolbar_xfade_off_150: icon_150("xfade", false),
	toolbar_xfade_off_200: icon("xfade", false, 2),
	toolbar_xfade_on: icon("xfade", true, 1),
	toolbar_xfade_on_150: icon_150("xfade", true),
	toolbar_xfade_on_200: icon("xfade", true, 2),
}
