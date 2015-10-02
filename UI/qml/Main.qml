import QtQuick 2.0
import QtGraphicalEffects 1.0

import "Controller.js" as Controller

import "board"
import "config"
import "menu"

Rectangle {
	id: main

	width: Style.window_width
	height: Style.window_height
	color: Style.color_main_bg

	property int board_width: Math.min(width, height * (1 - Style.infos_height) * Config.columns / Config.rows)
	property int board_height: board_width * Config.rows / Config.columns
	property int info_height: board_height / (1 - Style.infos_height) * Style.infos_height

	property int game_width: board_width
	property int game_height: board_height + info_height
	property bool menuOnRight: height - game_height < width - game_width

	Item {
		id: game
		x: 0
		y: 0
		width: game_width
		height: game_height

		property bool canPlay: false
		property int player: 1

		Board {
			id: board
			width: main.board_width
			height: main.board_height
			canPlay: game.canPlay

			onPlayCol: console.log(col)
		}

		Infos {
			id: info
			width: main.board_width
			height: main.info_height
			anchors.top: board.bottom
			playerPlaying: game.canPlay ? game.player : 0
		}
	}
	
	Menu {
	}

	Component.onCompleted: {
//		Controller.begin()
		game.canPlay = true
	}
}
