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

	Board {
		id: board
		property alias main: main
	}

	Infos {
		id: info
	}
	
	Menu {
		property alias main: main
	}

	Component.onCompleted: {
		Controller.begin()
	}
}
