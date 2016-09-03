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

import "../main"

Item {
	property int nb: 0
	property double widthPerWin: 0
	property color color
	visible: nb

	anchors.top: parent.top
	anchors.bottom: parent.bottom

	width: nb * widthPerWin

	Text {
		color: parent.color
		horizontalAlignment: Text.AlignCenter
		text: parent.nb
		anchors.horizontalCenter: parent.horizontalCenter
	}

	Rectangle {
		color: parent.color
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		anchors.topMargin: parent.height * 0.6
		anchors.left: parent.left
		anchors.right: parent.right
	}
}
