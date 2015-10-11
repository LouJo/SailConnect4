import QtQuick 2.0

import "Controller.js" as Controller

import "."
import "../board"
import "../config"
import "../menu"

Item {
	id: main
	objectName: "main"

	width: Style.window_width
	height: Style.window_height

	property var config: Config
	property var board: game.board

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
		board_height: main.board_height
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
