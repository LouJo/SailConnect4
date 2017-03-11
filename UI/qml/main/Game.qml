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
import "../board"
import "../config"

Rectangle {
	id: game
	color: Config.board_transparent ? "transparent" : Style.color_board_bg

	property QtObject boardObject
	property alias ended: board.ended

	property bool canPlay: false
	property bool touchActive: true // false when menu over board
	property int player: 1
	property double extra_margin: 0
	property bool paused: false

	signal playCol(variant col)
	signal grabOk(QtObject obj)
	signal pause(variant p)

	Board {
		id: board
		objectName: "board"
		x: Style.board_margin
		y: Style.board_margin + extra_margin
		width: parent.width - Style.board_margin * 2
		height: parent.width * Config.rows / Config.columns
		canPlay: game.canPlay && game.touchActive

		Component.onCompleted: {
			game.grabOk(toGrab)
		}
	}

	Infos {
		id: info
		x: Style.board_margin
		width: board.width
		height: parent.height - board.height - extra_margin - Style.board_margin
		anchors.top: board.bottom
		playerPlaying: game.canPlay ? game.player : 0
		iaPlaying: (playerPlaying == 0 && !ended && !paused) ? game.player : 0
	}

	Component.onCompleted: {
		board.playCol.connect(game.playCol)
	}

	// for js controller
	function play(index, player) { return board.play(index, player) }
	function reset() { board.reset(); }

	onPausedChanged: pause(paused)
}
