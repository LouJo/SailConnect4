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

Rectangle {
	property int idx
	property int row: Math.floor(idx / board.columns)
	property double posX: (idx % board.columns) * board.cellLength + board.cellMargin
	property double posY: row * board.cellLength + board.cellMargin

	x: posX
	y: posY
	width: board.ballLength
	height: board.ballLength
	radius: width / 2
	border.width: board.cellBorderWidth
}
