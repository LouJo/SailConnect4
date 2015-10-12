import QtQuick 2.0
import Sailfish.Silica 1.0

import "../board"
import "../config"

CoverBackground {
	signal playCol(variant col);

	Board {
		id: board
		objectName: "board"
		x: Style.board_margin
		y: Style.board_margin
		width: parent.width - Style.board_margin * 2
		height: parent.width * Config.rows / Config.columns
		canPlay: false
	}
	Label {
		text: qsTr("Connect 4")
	}

	function play(index, player) { 
		console.log("Cover play")
		return board.play(index, player)
	}
	function reset() { board.reset(); }
}
