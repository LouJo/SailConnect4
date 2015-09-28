import QtQuick 2.0
import "."

Rectangle {
	id: main

	width: Style.window_width
	height: Style.window_height

	color: Style.color_bg

	property int player: 1

	function play(index) {
		if (repeater.itemAt(index).children[0].play(player)) {
			player = 3 - player
			return true
		}
		else return false
	}

	function playCol(x) {
		y = grid.rows - 1
		while (y >= 0) {
			if (play(x + y * grid.columns)) return true
			y--
		}
		return false
	}

	Grid {
		id: grid
		anchors.fill: parent
		rows: Config.rows
		columns: Config.columns

		property int cellLength: Math.min(parent.width / columns, parent.height / rows)

		Repeater {
			model: parent.rows * parent.columns
			id: repeater

			Item {
				width: parent.cellLength; height: parent.cellLength

				Rectangle {
					property int played: 0
	
					anchors.fill: parent
					anchors.margins: parent.width * 0.1
					border.color: Style.color_cell_border
					border.width: 3
					radius: width / 2
					color: Style.color_empty 

					function play(player) {
						if (played) return false
						played = player
						color = player == 1 ? Style.color_player1 : Style.color_player2

						console.log("played: " + index)
						return true
					}
				}
			}

		}
	}
	MouseArea {
		anchors.fill: parent
		onClicked: {
	//		console.log(mouse.x + " " + mouse.y + " " + ((mouse.x / grid.cellLength) | 0))
			playCol((mouse.x / grid.cellLength) | 0)
		}
	}
}
