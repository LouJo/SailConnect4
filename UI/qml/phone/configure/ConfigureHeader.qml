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
import ".."
import "../header"

HeaderGeneric {
	id: header

	signal accept()
	signal cancel()

	HeaderButton {
		id: cancel_button
		text: qsTr("Cancel")
		width: parent.width / 2
		anchors.left: parent.left
	}

	HeaderButton {
		id: accept_button
		text: qsTr("Accept")
		width: parent.width / 2
		anchors.left: cancel_button.right
	}

	Component.onCompleted: {
		cancel_button.triggered.connect(cancel)
		accept_button.triggered.connect(accept)
	}
}
