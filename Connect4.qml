import QtQuick 2.0

Rectangle {
	id: main

	width: 600
	height: 400

	color: "#27315D"

	property color color_player1: "#E6D82E"
	property color color_player2: "#E63B2E"
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
		rows: 6
		columns: 7

		property int cellLength: Math.min(parent.width / columns, parent.height / rows)

		Repeater {
			model: parent.rows * parent.columns
			id: repeater

			Item {
				width: parent.cellLength; height: parent.cellLength

				Rectangle {
					property color normal: "#D7D7D7"
					property color hover: "#ACACAC"

					property int played: 0
	
					anchors.fill: parent
					anchors.margins: parent.width * 0.1
					border.color: "#273140"
					border.width: 3
					radius: width / 2
					color: normal 

					function play(player) {
						if (played) return false
						played = player
						normal = player == 1 ? main.color_player1 : color_player2
						color = normal
						hover = normal

						console.log("played: " + index)
						return true
					}

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true

						onEntered: { 
							parent.color = parent.hover
						}
						onExited: {
							parent.color = parent.normal
						}
						onClicked: {
							main.playCol(index % grid.columns)
						}
					}
				}
			}
		}
	}
}
