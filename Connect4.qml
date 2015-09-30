import QtQuick 2.0
import QtGraphicalEffects 1.0
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

	Component.onCompleted: {
		Controller.begin()
	}

	Rectangle {
		id: board

		width: parent.board_width
		height: parent.board_height
		antialiasing: true

		property bool canPlay: false
		color: Style.color_board_bg

		Rectangle {
			id: board_bg
			anchors.fill: parent
			color: "transparent"
			visible: false
		}

		Grid {
			id: grid
			rows: Config.rows
			columns: Config.columns
			visible: false

			property double cellLength: Math.min(parent.width / columns, parent.height / rows)
			property double cellMargin: cellLength * Style.cell_margin
			property double borderWidth: cellLength / 40

			anchors.fill: parent

			Repeater {
				model: parent.rows * parent.columns
				id: repeater

				// Holes in the grid
				Item {
					width: parent.cellLength; height: parent.cellLength

					Rectangle {
						anchors.fill: parent
						anchors.margins: grid.cellMargin
						border.color: Style.color_cell_border
						border.width: grid.borderWidth
						radius: width / 2
						color: Style.color_empty 

						// Text { text: index }
					}
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

		// balls
		Item {
			id: balls

			property double ballLength: grid.cellLength - grid.cellMargin * 2
			property double ballOffset: grid.cellMargin

			visible: false
			anchors.fill: parent

			Repeater {
				model: grid.rows * grid.columns
				id: balls_repeater

				Rectangle {
					property bool played: false 
					width: parent.ballLength; height: parent.ballLength

					property int row: Math.floor(index / grid.columns)
					property double posX: (index % grid.columns) * grid.cellLength + parent.ballOffset
					property double posY: row * grid.cellLength + parent.ballOffset
					property int timeAnimation: Style.timeAnimationRow * (row + 1)
					property double currentY: 0

					x: posX
					y: played ? posY : -parent.ballLength
					radius: width / 2
					color: "transparent"
					border.color: Style.color_ball_border
					border.width: grid.borderWidth

					//Text { text: index; x:10; y:10; color:"red" }

					Behavior on y {
						NumberAnimation { duration: timeAnimation }
					}

					function play(player) {
						if (played) return false
						color = player == 1 ? Style.color_player1 : Style.color_player2
						played = true
						timeAnimation = 0
						console.log("played: " + index)

						return true
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

			function setPlaying(e) {
				children[0].font.underline = e
			}

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

			function setPlaying(e) {
				children[0].font.underline = e
			}

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
