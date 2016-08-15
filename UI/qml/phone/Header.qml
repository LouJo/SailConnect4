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

import "../config"

Rectangle {
	color: "grey"

	Text {
		id: header
		text: DefaultConfig.programTitle
		width: parent.width
		anchors.verticalCenter: parent.verticalCenter
		anchors.left: parent.left
		anchors.leftMargin: 10
		font.pixelSize: Style.menu_font_size
	}

	Image {
		id: menu_icon
		height: parent.height * 0.9
		source: "../../icons/menu/menu.svg"
		anchors.right: parent.right
		anchors.rightMargin: (parent.height - height) / 2
		anchors.verticalCenter: parent.verticalCenter
	}

	Image {
		id: renew_icon
		height: parent.height * 0.7
		width: height
		source: "../../icons/menu/renew.svg"
		anchors.right: menu_icon.left
		anchors.rightMargin: height * 0.2
		anchors.verticalCenter: parent.verticalCenter
	}
}
