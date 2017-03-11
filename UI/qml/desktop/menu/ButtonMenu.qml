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

import "."

ButtonGeneric {
	property int idx

	x: parent.onR ? parent.width / 2 - width / 2 : (parent.width - width * parent.nbButton) / (parent.nbButton + 1) * (idx + 1) + width * idx
	y: parent.onR ? Math.min((parent.height - height * parent.nbButton) / (parent.nbButton + 1), height /  2) * (idx + 1) + height * idx : height / 2
}
