import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

import "."

ApplicationWindow {
	property int margin: 10
	title: Config.programTitle + " configuration"
	width: mainLayout.implicitWidth + 2 * margin
	height: mainLayout.implicitHeight + 2 * margin
	minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
	minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

	ColumnLayout {
		id: mainLayout
		anchors.fill: parent
		anchors.margins: margin
		spacing: 10

		ControlsPlayer {
			id: p1
			title: "Player 1"
			name: Config.player1_name
			force: Config.player1_force
			type: Config.player1_type

			onNameEdited: Config.player1_name = new_name
			onSubmit: {
				Config.player1_force = force
				Config.player1_type = getType()
			}
		}

		ControlsPlayer {
			id: p2
			title: "Player 2"
			name: Config.player2_name
			force: Config.player2_force
			type: Config.player2_type

			onNameEdited: Config.player2_name = new_name
			onSubmit: {
				Config.player2_force = force
				Config.player2_type = getType()
			}
		}

		Button {
			text: "Erase scores"
			Layout.alignment: Qt.AlignCenter

			onClicked: {
				Config.player1_points = 0
				Config.player2_points = 0
			}
		}

		Button {
			text: "Submit"
			Layout.alignment: Qt.AlignCenter
			onClicked: {
				p1.submitAll()
				p2.submitAll()
				close()
			}
		}
	}
}
