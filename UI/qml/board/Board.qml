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
import QtGraphicalEffects 1.0

import "."
import "../config"
import "../main"

Rectangle {
	id: board

	// grid holes/balls definitions
	property int rows: Config.rows
	property int columns: Config.columns
	property int nbCells: rows * columns
	property double cellLength: Math.min(width / columns, height / rows)
	property double cellMargin: cellLength * Style.cell_margin
	property double cellBorderWidth: cellLength / 40
	property double ballLength: cellLength - cellMargin * 2
	property double ballInterior: ballLength - cellBorderWidth * 2
	property double ballRadius: ballInterior / 2
	property double timeAnimationRow: Style.timeAnimationRow

	property bool canPlay: false

	property bool ended: lineAligned.showed || (balls.nbPlaced == nbCells)
	property alias toGrab: board

	property QtObject ballPlaying

	color: Config.board_transparent ? "transparent" : Style.color_board_bg

	signal playCol(int col)

	Rectangle {
		id: board_bg
		anchors.fill: parent
		color: "transparent"
		visible: false
	}

	Item {
		id: grid
		visible: false
		anchors.fill: parent

		Repeater {
			id: grid_repeater
			model: board.nbCells

			// Holes in the grid, don't covers balls border
			Case {
				idx: index
				x: posX + board.cellBorderWidth
				y: posY + board.cellBorderWidth
				width: board.ballInterior
				height: board.ballInterior
				border.color: "transparent"
				color: Style.color_empty 

				// Text { text: index }
			}
		}
	}

	Blend {
		id: board_mask
		anchors.fill: parent
		source: board_bg
		foregroundSource: grid
		mode: "normal"
	}

	Blend {
		id: board_render
		visible: false
		anchors.fill: parent
		source: board_mask
		foregroundSource: balls
		mode: "normal"
		signal updated()
	}

	// hole borders
	Item {
		id: holeBorders
		anchors.fill: parent

		Repeater {
			model: board.nbCells

			Case {
				idx: index
				color: "transparent"
				border.color: Style.color_cell_border
				border.width: board.cellBorderWidth * 1.5
			}
		}
	}

	// balls
	Item {
		id: balls

		property double ballOffset: board.cellMargin
		property int nbPlaced: 0

		visible: false
		anchors.fill: parent

		signal updated()

		property real angle: 0
		property real scaledWidth: Math.cos(angle)

		Repeater {
			model: board.nbCells
			id: balls_repeater

			Ball {
				id: ball
				idx: index

				row: Math.floor(idx / board.columns)
				posX: (idx % board.columns) * board.cellLength + board.cellMargin
				posY: row * board.cellLength + board.cellMargin

				property bool played: false
				property int timeAnimationDefault: board.timeAnimationRow * (row + 1)
				property int timeAnimation: timeAnimationDefault
				property bool bounce: true
				property bool placed: played && !yAnimation.running
				property bool parked: !played && !yAnimation.running
				property bool aligned: false

				angle: aligned ? balls.angle : 0
				axeX: lineAligned.axeX
				axeY: lineAligned.axeY
				y: played ? posY : -board.ballLength

				//color: "transparent"
				//border.color: Style.color_ball_border

				//Text { text: index; x:10; y:10; color:"red" }

				onPlacedChanged: {
					if (placed) {
						balls.nbPlaced++
						balls.updated()
						//console.log("qml: balls placed: " + balls.nbPlaced)
					}
				}
				onParkedChanged: {
					if (parked) {
						balls.nbPlaced--
						if (balls.nbPlaced == 0) balls.updated()
						//console.log("qml: balls placed: " + balls.nbPlaced)
					}
				}

				Behavior on y {
					NumberAnimation {
						id: yAnimation
						duration: Config.animation ? (bounce ? timeAnimation : timeAnimationDefault / 2) : 0
						easing.type: bounce ? Easing.OutBounce : Easing.Linear
						easing.amplitude: bounce ? 1 : 0
					}
				}


				function play(player_) {
					if (played) return false
					//color = player == 1 ? Config.player1_color : Config.player2_color
					player = player_
					bounce = true
					played = true
					timeAnimation = 0
					console.log("player " + player + " played: " + index + " col " + (index % Config.columns))

					return true
				}

				function reset() {
					bounce = false
					played = false
					aligned = false
					timeAnimation = timeAnimationDefault
				}
			}
		}

		NumberAnimation {
			id: rotate

			running: board.ended && lineAligned.showed
			loops: Animation.Infinite
			target: balls
			property: "angle"
			from: 0
			to: 180
			duration: 500
		}

		function reset() {
			for (var i = 0; i < board.nbCells; i++) 
				balls_repeater.itemAt(i).reset()

			angle = 0
		}

		function play(idx, player) {
			board.ballPlaying = balls_repeater.itemAt(idx)
			return board.ballPlaying.play(player)
		}

		Component.onCompleted: {
			onNbPlacedChanged.connect(updated)
		}
	}

	// line to show aligned balls

	Rectangle {
		id: lineAligned;

		property var item1
		property var item2
		property var ball1
		property var ball2

		property color colorLine: ball1 ? (ball1.player == 1 ? Config.player1_color : Config.player2_color) : "transparent"
		property bool showed: false

		property int axeX: 0
		property int axeY: 0

		LocalLine {
			x1: parent.item1 ? parent.item1.x + board.ballRadius : 0
			y1: parent.item1 ? parent.item1.y + board.ballRadius : 0
			x2: parent.item2 ? parent.item2.x + board.ballRadius : 0
			y2: parent.item2 ? parent.item2.y + board.ballRadius : 0
			lineWidth: Style.lineAlignedWidth
			color: parent.colorLine
		}

		visible: showed && ball1.placed && ball2.placed && board.ballPlaying.placed

		function sign(a) {
			if (a < 0) return -1
			else if (a > 0) return 1
			else return 0
		}

		function show(i1, i2) {
			item1 = grid_repeater.itemAt(i1)
			item2 = grid_repeater.itemAt(i2)
			ball1 = balls_repeater.itemAt(i1)
			ball2 = balls_repeater.itemAt(i2)

			colorLine = ball1.player == 1 ? Config.player1_color : Config.player2_color
			showed = true

			// axe for rotation
			axeX = sign(ball2.posX - ball1.posX)
			axeY = sign(ball2.posY - ball1.posY)

			// place aligned flag
			var idx = i1;
			var delta = (i2 - i1) / (Config.align - 1)
			for (var i = 0; i < Config.align; i++) {
				balls_repeater.itemAt(idx).aligned = true;
				idx += delta;
			}
		}
		function hide() {
			showed = false
		}
	}

	OpacityMask {
		anchors.fill: parent
		source: balls
		maskSource: board_mask
	}

	MouseArea {
		anchors.fill: parent
		propagateComposedEvents: !board.canPlay
		onClicked: {
			if (!board.canPlay) {
				console.log("Cannot play for the moment")
				mouse.accepted = false
				return
			}
			//console.log(mouse.x + " " + mouse.y + " " + ((mouse.x / board.cellLength) | 0))
			board.playCol((mouse.x / board.cellLength) | 0)
		}
	}

	Component.onCompleted: {
		balls.updated.connect(board_render.updated)
	}

	function reset() { balls.reset() }
	function play(idx, player) { return balls.play(idx, player); }
	function alignedShow(i1, i2) { lineAligned.show(i1, i2); }
	function alignedHide() { lineAligned.hide(); }

	function played(idx) {
		var b = balls_repeater.itemAt(idx)
		if (b.played) return b.player;
		else return 0;
	}
	function resetBall(idx) {
		balls_repeater.itemAt(idx).reset()
	}
}
