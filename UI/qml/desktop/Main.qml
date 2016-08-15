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
import "menu"

Item {
	id: main
	objectName: "main"

	width: Style.window_width
	height: Style.window_height

	property var config: Config // for UI.cpp
	property var board: game.board // for js controller

	// adaptative style
	property int board_width: Math.min(width, height * (1 - Style.infos_height) * Config.columns / Config.rows)
	property int board_height: board_width * Config.rows / Config.columns
	property int info_height: board_height / (1 - Style.infos_height) * Style.infos_height

	property int game_width: board_width
	property int game_height: board_height + info_height
	property bool menuOnRight: height - game_height < width - game_width

	Game {
		id: game
		objectName: "game"
		x: 0
		y: 0
		width: main.game_width
		height: main.game_height
	}

	Menu {
		id: menu
		objectName: "menu"
		x: main.menuOnRight ? main.game_width : 0
		y: main.menuOnRight ? 0 : main.game_height
		width: main.menuOnRight ? main.width - main.game_width : main.width
		height: main.menuOnRight ? main.height : main.height - main.game_height
	}

	Component.onCompleted: {
		console.log("qml: ready")

		if (Controller.isQmlScene()) {
			game.playCol.connect(Controller.playCol)
			menu.exit.connect(Controller.exit)
			menu.newGame.connect(Controller.new_game)

			Controller.begin()
		}
	}
}
