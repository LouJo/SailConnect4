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

import "../main/Controller.js" as Controller

import "../main"
import "../board"
import "../config"

Item {
	id: main
	objectName: "main"

	property var config: Config // for UI.cpp
	property var board: game.board // for js controller

	// adaptative style

	Header {
		id: menu
		objectName: "menu"
		width: parent.width
		height: Math.min(parent.width, parent.height) * 0.15
	}

	Game {
		id: game
		objectName: "game"
		x: 0
		y: 0
		width:  Math.min(parent.width, height * 0.9)
		height: Math.min(Math.max(parent.height - menu.height * 3, 
										          parent.height * 0.8),
		                 parent.width * 1.2)
		anchors.top: menu.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: (parent.height - height - menu.height) * 0.3
	}

	Component.onCompleted: {
		console.log("qml: ready")

		if (Controller.isQmlScene()) {
			game.playCol.connect(Controller.playCol)
			menu.newGame.connect(Controller.new_game)

			Controller.begin()
		}
	}
}
