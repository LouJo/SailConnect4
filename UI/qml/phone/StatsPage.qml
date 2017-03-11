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

import "header"
import "../main"
import "../stats"
import "."

SamplePage {
	implicitWidth: 400
	implicitHeight: 640
	color: Style.phone_bg_color

	signal close()
	function setStats(obj) { stats.setStats(obj) }

	HeaderBack {
		id: header
	}

	Stats {
		id: stats
		anchors.top: header.bottom
		anchors.topMargin: Style.defaultFont.pixelSize * 0.6
		anchors.left: parent.left
		anchors.right: parent.right
	}

	Component.onCompleted: {
		header.close.connect(close)
	}
}
