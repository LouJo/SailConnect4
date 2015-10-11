import QtQuick 2.0

import "."
import "../board"
import "../config"
import "../menu"

Rectangle {
	id: game
	color: Style.color_main_bg

	property bool canPlay: false
	property int player: 1
	property double board_height

	property var columns: board.columns
	property var rows: board.rows

	signal playCol(variant col);

	Board {
		id: board
		objectName: "board"
		width: parent.width
		height: parent.board_height
		canPlay: game.canPlay
	}

	Infos {
		id: info
		width: parent.width
		height: parent.height - parent.board_height
		anchors.top: board.bottom
		playerPlaying: game.canPlay ? game.player : 0
	}

	Component.onCompleted: {
		board.playCol.connect(game.playCol)
	}

	// for js controller
	function play(index, player) { return board.play(index, player) }
	function reset() { board.reset(); }
}
