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

	property int game_width: board_width
	property int game_height: board_height + info_height
	property bool menuOnRight: height - game_height < width - game_width

	Component.onCompleted: {
		Controller.begin()
	}
	
	Case {
	}

	Rectangle {
		id: board

		width: parent.board_width
		height: parent.board_height

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
				Controller.playCol((mouse.x / board.cellLength) | 0)
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

	Rectangle {
		id: menu

		property bool onR: main.menuOnRight
		property int nbButton: 3
	
		x: onR ? main.game_width : 0
		y: onR ? 0 : main.game_height
		width: onR ? main.width - main.game_width : main.width
		height: onR ? main.height : main.height - main.game_height

		color: Style.color_menu_bg

		property double buttonWidth: onR ? width * Style.buttonWidthMainRelationOnR : width * Style.buttonWidthMainRelationOnB / nbButton

		ButtonMenu {
			property int idx: 0
			property string buttonText: "New game"

			onActivated: Controller.new_game()
		}

		ButtonMenu {
			property int idx: 1
			property string buttonText: "Configuration"
		}

		ButtonMenu {
			property int idx: 2
			property string buttonText: "Exit"

			onActivated: Controller.exit()
		}
	}
}
