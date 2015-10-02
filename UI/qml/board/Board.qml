import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import "../config"
import "../menu"

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

	property bool canPlay: false

	color: Style.color_board_bg

	signal playCol()

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
		id: "board_mask"
		anchors.fill: parent
		source: board_bg
		foregroundSource: grid
		mode: "normal"
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

		visible: false
		anchors.fill: parent

		Repeater {
			model: board.nbCells
			id: balls_repeater

			Case {
				idx: index
				property bool played: false 

				property int timeAnimationDefault: Style.timeAnimationRow * (row + 1)
				property int timeAnimation: timeAnimationDefault
				property bool bounce: true

				y: played ? posY : -board.ballLength

				color: "transparent"
				border.color: Style.color_ball_border

				//Text { text: index; x:10; y:10; color:"red" }

				Behavior on y {
					NumberAnimation {
						duration: bounce ? timeAnimation : timeAnimationDefault / 2
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
					console.log("played: " + index)

					return true
				}

				function reset() {
					bounce = false
					played = false
					timeAnimation = timeAnimationDefault
				}
			}
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
}
