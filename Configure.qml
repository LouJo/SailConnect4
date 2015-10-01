import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

import "."

ApplicationWindow {
	title: Config.programTitle + " configuration"

	ColumnLayout {
		ConfigurePlayer {
			title: "Player 1"
			property string name: Config.player1_default_name
		}

		ConfigurePlayer {
			title: "Player 2"
			property string name: Config.player2_default_name
		}
	}
}
