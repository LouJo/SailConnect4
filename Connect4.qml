import QtQuick 2.0

Rectangle {
	id: main

	width: 600
	height: 400

	color: "#27315D"

	Grid {
		id: grid
		anchors.fill: parent
		rows: 6
		columns: 7

		property int cellLength: Math.min(parent.width / columns, parent.height / rows)

		Repeater {
			model: parent.rows * parent.columns

			Item {
				width: parent.cellLength; height: parent.cellLength

				Rectangle {
					property color normal: "#D7D7D7"
					property color hover: "#ACACAC"
	
					anchors.fill: parent
					anchors.margins: parent.width * 0.1
					border.color: "#273140"
					border.width: 3
					radius: width / 2
					color: normal 

					MouseArea {
						anchors.fill: parent
						hoverEnabled: true

						onEntered: { 
							parent.color = parent.hover
						}
						onExited: {
							parent.color = parent.normal
						}
					}
				}
			}
		}
	}
}
