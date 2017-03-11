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

Rectangle {
	property double x1
	property double x2
	property double y1
	property double y2
	property double lineWidth

	property double dx: x2 - x1
	property double dy: y2 - y1
	property double d: Math.sqrt(dx * dx + dy * dy)

	property double wx: dx / d
	property double wy: dy / d

	transformOrigin: Item.TopLeft

	x: x1 - wx
	y: y1 - wy

	width: d
	height: lineWidth
	rotation: Math.abs(dx) < 0.1 ? 90 : Math.atan(dy / dx) * 180 / Math.PI + (dx > 0 ? 0 : 180)

	//onXChanged: console.log(x + " " + y + " " + rotation)
}
