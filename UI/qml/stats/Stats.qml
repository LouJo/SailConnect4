/* Copyright 2015 (C) Louis-Joseph Fournier
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0

import "."
import "../config"
import "../main"

Item {
	id: page

	property var stats
	property int winMax: 0

	property color fontColor: Style.phone_font_color
	property double widthPerWin: width / 6 / winMax

	Column {
		width: parent.width
		spacing: Style.defaultFont.pixelSize * 0.2

	Repeater {
		model: page.stats ? page.stats.length : 0

			Item {
				property var pod: page.stats[index]
				width: parent.width
				height: Style.defaultFont.pixelSize * 2

				StatsName {
					id: nameLeft
					anchors.left: parent.left
					text: parent.pod.players[0].name
					horizontalAlignment: Text.AlignHLeft
					color: fontColor
				}

				StatsBar {
					id: barEqual
					nb: pod.gamesNb - pod.players[0].winNb - pod.players[1].winNb
					x: page.width / 2 - width
					widthPerWin: page.widthPerWin
					color: Style.stat_color_equal
				}

				StatsBar {
					id: barLeft
					nb: pod.players[0].winNb
					widthPerWin: page.widthPerWin
					color: Config.player1_color
					anchors.right: barEqual.left
				}

				StatsBar {
					id: barRight
					nb: pod.players[1].winNb
					widthPerWin: page.widthPerWin
					color: Config.player2_color
					anchors.left: barEqual.right
				}

				StatsName {
					anchors.right: parent.right
					text: parent.pod.players[1].name
					horizontalAlignment: Text.AlignRight
					color: fontColor
				}
			}
		}
	}

	function setStats(s) {
		for (var i = 0; i < s.length; i++) {
			var pod = s[i];
			var p1 = pod.players[1];
			if (p1.type == 1)
				p1.name = qsTr("AI") + " " + DefaultConfig.forceNames[p1.force];

			for (var j = 0; j < 2; j++)
				if (s[i].players[j].winNb > winMax)
					winMax = s[i].players[j].winNb;
		}

		console.log("win max:", winMax);
		page.stats = s;
	}
}
