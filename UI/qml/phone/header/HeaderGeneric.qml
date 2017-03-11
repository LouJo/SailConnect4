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
	color: Style.header_bg_color

	anchors.top: parent.top
	anchors.left: parent.left
	anchors.right: parent.right
	anchors.topMargin: -1
	anchors.leftMargin: -1
	anchors.rightMargin: -1

	height: Math.min(parent.width, parent.height) * 0.12

	border.color: Style.header_border_color
	border.width: 1
/*
	Image {
		visible: Style.phone_bg_header
		source: Style.phone_bg_header
		fillMode: Image.Tile
		anchors.fill: parent
	}
*/
}
