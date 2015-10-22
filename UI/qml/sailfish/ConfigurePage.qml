import QtQuick 2.0
import Sailfish.Silica 1.0

import "../config"
import "./configure"

Dialog {
	id: configurePage

    allowedOrientations: Orientation.All

	signal configChanged()

	Column {
		width: parent.width

		DialogHeader {
			id: header
		}

		PageHeader {
			title: qsTr("Configuration")
		}

		ControlPlayerSailfish {
			id: player1
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player1_name
			force: Config.player1_force
			type: Config.player1_type

			onNameEdited: Config.player1_name = new_name
			onSubmit: {
				Config.player1_force = force
				Config.player1_type = getType()
			}
		}

		ControlPlayerSailfish {
			id: player2
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player2_name
			force: Config.player2_force
			type: Config.player2_type

			onNameEdited: Config.player2_name = new_name
			onSubmit: {
				Config.player2_force = force
				Config.player2_type = getType()
			}
		}
	}

	onAccepted: {
		player1.submitAll()
		player2.submitAll()
		configChanged()
	}
}
