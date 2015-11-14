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
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

import "../board"
import "../config"

CoverBackground {
	property QtObject objectToGrab
	signal coverActive(bool active)

	property bool active: status == Cover.Active

	Label {
		id: label
		text: DefaultConfig.programTitle
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: Theme.paddingLarge
		anchors.bottomMargin: Theme.paddingLarge
	}

	Rectangle {
		anchors.fill: parent
		visible: false
		color: "transparent"
		id: bg
	}

	Board {
		id: previewImage
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: label.bottom
		anchors.topMargin: Theme.paddingLarge
		anchors.left: parent.left
		anchors.leftMargin: Theme.paddingSmall
		color: "transparent"

		height: objectToGrab.height * width / objectToGrab.width

		function updatePreview() {
			for (var i = 0; i < objectToGrab.nbCells; i++) {
				var n = objectToGrab.played(i)
				if (n) previewImage.play(i, n)
				else previewImage.resetBall(i)
			}
		}
	}

	Component.onCompleted: {
		//objectToGrab.updated.connect(previewImage.updatePreview)
		previewImage.updatePreview()
	}

	onActiveChanged: {
		console.log("Cover active: " + active)
		coverActive(active)
		if (active) previewImage.updatePreview()
	}
}
