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

	property bool canPlay: false

	property bool ended: lineAligned.showed || (balls.nbPlaced == nbCells)
	property alias toGrab: board_render

	color: Style.color_board_bg

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
		property int nbPlaced: parent.nbCells

		visible: false
		anchors.fill: parent

		signal updated()

		Repeater {
			model: board.nbCells
			id: balls_repeater

			Case {
				idx: index
				property bool played: false 

				property int timeAnimationDefault: Style.timeAnimationRow * (row + 1)
				property int timeAnimation: timeAnimationDefault
				property bool bounce: true
				property bool placed: played && !yAnimation.running
				property bool parked: !played && !yAnimation.running

				y: played ? posY : -board.ballLength

				color: "transparent"
				border.color: Style.color_ball_border

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

				function play(player) {
					if (played) return false
					color = player == 1 ? Style.color_player1 : Style.color_player2
					bounce = true
					played = true
					timeAnimation = 0
					console.log("player " + player + " played: " + index + " col " + (index % Config.columns))

					return true
				}

				function reset() {
					bounce = false
					played = false
					timeAnimation = timeAnimationDefault
				}
			}
		}

		function reset() {
			for (var i = 0; i < board.nbCells; i++) 
				balls_repeater.itemAt(i).reset()
		}

		function play(idx, player) {
			return balls_repeater.itemAt(idx).play(player)
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

		property color colorLine: ball1 ? ball1.color : "white"
		property bool showed: false

		LocalLine {
			x1: parent.item1 ? parent.item1.x + board.ballRadius : 0
			y1: parent.item1 ? parent.item1.y + board.ballRadius : 0
			x2: parent.item2 ? parent.item2.x + board.ballRadius : 0
			y2: parent.item2 ? parent.item2.y + board.ballRadius : 0
			lineWidth: Style.lineAlignedWidth
			color: parent.colorLine
		}

		visible: showed && ball1.placed && ball2.placed

		function show(i1, i2) {
			item1 = grid_repeater.itemAt(i1)
			item2 = grid_repeater.itemAt(i2)
			ball1 = balls_repeater.itemAt(i1)
			ball2 = balls_repeater.itemAt(i2)

			colorLine = ball1.color
			showed = true
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
		onClicked: {
			if (!board.canPlay) {
				console.log("Cannot play for the moment")
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
}
