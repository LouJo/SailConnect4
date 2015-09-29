import QtQuick 2.0
import "Controller.js" as Controller
import "."

Rectangle {
	id: main

	width: Style.window_width
	height: Style.window_height
	color: Style.color_main_bg

	property int board_width: Math.min(width, height * (1 - Style.infos_height) * Config.columns / Config.rows)
	property int board_height: board_width * Config.rows / Config.columns
	property int info_height: board_height / (1 - Style.infos_height) * Style.infos_height

	Rectangle {
		id: board

		width: parent.board_width
		height: parent.board_height

		property bool canPlay: true

		color: Style.color_board_bg

		Grid {
			id: grid
			rows: Config.rows
			columns: Config.columns

			property int cellLength: Math.min(parent.width / columns, parent.height / rows)
			property int cellMargin: cellLength * Style.cell_margin

			width: parent.width
			height: cellLength * columns

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
				if (!board.canPlay) {
					console.log("Cannot play for the moment")
					return
				}
		//		console.log(mouse.x + " " + mouse.y + " " + ((mouse.x / grid.cellLength) | 0))
				Controller.playCol((mouse.x / grid.cellLength) | 0)
			}
		}
	}

	Rectangle {
		id: info
		width: parent.board_width
		height: parent.info_height
		anchors.top: board.bottom
		color: Style.color_info_bg

		Item {
			id: info_player1
			property string player_name: Config.player1_default_name
			property int points: 0
			property color player_color: Style.color_player1

			anchors.left: parent.left
			anchors.top: parent.top
			width: parent.width / 2
			height: parent.height

			Text {
				width: parent.width; height: parent.height / 2
				anchors.top: parent.top
				text: parent.player_name
				font.pixelSize: width / 8 + 1
				color: parent.player_color
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			Text {
				width: parent.width; height: parent.height / 2
				color: parent.player_color
				horizontalAlignment: Text.AlignHCenter
				font.pixelSize: width / 12 + 1
				x: 0; y: parent.height / 2
				text: parent.points
			}
		}

		Item {
			id: info_player2
			property string player_name: Config.player2_default_name
			property int points: 0
			property color player_color: Style.color_player2

			anchors.left: info_player1.right
			anchors.top: parent.top
			width: parent.width / 2
			height: parent.height

			Text {
				width: parent.width; height: parent.height / 2
				anchors.top: parent.top
				text: parent.player_name
				font.pixelSize: width / 8 + 1
				color: parent.player_color
				horizontalAlignment: Text.AlignHCenter
				verticalAlignment: Text.AlignVCenter
			}

			Text {
				width: parent.width; height: parent.height / 2
				color: parent.player_color
				horizontalAlignment: Text.AlignHCenter
				font.pixelSize: width / 12 + 1
				x: 0; y: parent.height / 2
				text: parent.points
			}
		}
	}
}
