import QtQuick 2.0
import "Controller.js" as Controller
import "."

Rectangle {
	id: main

	property bool canPlay: true

	width: Style.window_width
	height: Style.window_height

	color: Style.color_bg

	Grid {
		id: grid
		anchors.fill: parent
		rows: Config.rows
		columns: Config.columns

		property int cellLength: Math.min(parent.width / columns, parent.height / rows)
		property int cellMargin: cellLength * Style.cell_margin

		Repeater {
			model: parent.rows * parent.columns
			id: repeater

			Item {
				width: parent.cellLength; height: parent.cellLength

				Rectangle {
					property int played: 0
	
					anchors.fill: parent
					anchors.margins: grid.cellMargin
					border.color: Style.color_cell_border
					border.width: Style.cell_border_width
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
			if (!canPlay) {
				console.log("Cannot play for the moment")
				return
			}
	//		console.log(mouse.x + " " + mouse.y + " " + ((mouse.x / grid.cellLength) | 0))
			Controller.playCol((mouse.x / grid.cellLength) | 0)
		}
	}
}
