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

import ".."
import "../../main"

Rectangle {
	property string title

	signal triggered()

	property bool activated: false
	property alias fontSize: sampleText.fontSize

	width: parent.width
	height: fontSize * 2.5

	Text {
		// get sample font size
		id: sampleText
		visible: false
		property int fontSize: font.pixelSize
	}

	color: activated ? Style.menu_bg_color_activated : Style.menu_bg_color

	Text {
		text: parent.title
		color: Style.menu_font_color
		//font.pixelSize: parent.height * 0.45

		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 10
		anchors.right: parent.right
		anchors.rightMargin: 10
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			activated = true
			parent.triggered()
			timer.start()
		}
	}

	Timer {
		id: timer
		repeat: false
		interval: Style.menu_activated_ms
		running: false
		onTriggered: { activated = false }
	}
}
