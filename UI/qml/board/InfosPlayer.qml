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

Item {
	id: info

	property string player_name
	property int points
	property color player_color
	property bool playing: false
	property bool iaPlaying: false


	Text {
		id: name
		width: parent.width; height: parent.height / 2
		anchors.top: parent.top
		text: parent.player_name
		font.pixelSize: width / (Math.max(parent.player_name.length+1, 9)) * 1.8 
		color: parent.player_color
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font.underline: playing
		property real angle: 0

		transform: Rotation {
			origin { x: name.width / 2; y: name.height / 2 }
			axis { x: 1; y: 0; z: 0 }
			angle: name.angle
		}
	}

	Text {
		width: parent.width; height: parent.height / 2
		color: parent.player_color
		horizontalAlignment: Text.AlignHCenter
		font.pixelSize: width / 8 + 1
		x: 0; y: parent.height / 2
		text: parent.points
	}

	SequentialAnimation {
		running: iaPlaying

		NumberAnimation {
			target: name
			property: "angle"
			from: 0
			to: 360
			duration: 800
		}

		onRunningChanged: {
			if (!running) name.angle = 0
		}
	}
}
