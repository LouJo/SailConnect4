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
import QtGraphicalEffects 1.0

import "../config"

Rectangle {
	id: ball
	property int idx
	property int row
	property double posX
	property double posY

	property int player: 1

	property color playerColor: 
			player == 1 ? Config.player1_color : Config.player2_color
	
	property color overColor
	property real angle: 0
	property int axeX: 0
	property int axeY: 0

	color: playerColor
	radius: height

	x: posX + (board.ballLength - width) / 2
	y: posY
	width: board.ballLength
	height: board.ballLength

  transform: Rotation {
		origin { x: width / 2; y: width / 2 }
		axis { x: axeX; y: axeY; z: 0 }
		angle: ball.angle
  }

	Image {
		id: piece
		source: "../../icons/svg/piece.svg"
		sourceSize: Qt.size(parent.width, parent.height)
		smooth: true
	}
}
