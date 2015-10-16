import QtQuick 2.0
import Sailfish.Silica 1.0

import "../config"
import "./configure"

Dialog {
	id: configurePage

	signal configChanged()
	signal resetScores()

	Column {
		width: parent.width

		DialogHeader {
			id: header
			title: qsTr("Configuration")
		}

		ControlPlayerSailfish {
			id: player1
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player1_name
			force: Config.player1_force
			type: Config.player1_type
		}

		ControlPlayerSailfish {
			id: player2
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player2_name
			force: Config.player2_force
			type: Config.player2_type
		}
	}

	onConfigChanged: pageStack.pop()
}
