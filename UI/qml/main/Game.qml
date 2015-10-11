import QtQuick 2.0

import "."
import "../board"
import "../config"
import "../menu"

Rectangle {
	id: game
	color: Style.color_board_bg

	property bool canPlay: false
	property int player: 1
	property double extra_margin: 0

	signal playCol(variant col);

	Board {
		id: board
		objectName: "board"
		x: Style.board_margin
		y: Style.board_margin + extra_margin
		width: parent.width - Style.board_margin * 2
		height: parent.width * Config.rows / Config.columns
		canPlay: game.canPlay
	}

	Infos {
		id: info
		x: Style.board_margin
		width: board.width
		height: parent.height - board.height - extra_margin
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
