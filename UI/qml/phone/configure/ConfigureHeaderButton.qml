/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0

import ".."

Rectangle {
	property string text

	signal triggered()

	height: parent.height
	property bool activated: false

	color: activated ? Style.header_bg_color_activated : Style.header_bg_color

	Text {
		text: parent.text
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter

		font.pixelSize: parent.height * 0.4
		color: Style.header_font_color
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			activated = true
			triggered()
		}
	}
}
