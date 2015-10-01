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

		ConfigurePlayer {
			title: "Player 1"
			property string name: Config.player1_default_name
			property double force: Config.player1_force
		}

		ConfigurePlayer {
			title: "Player 2"
			property string name: Config.player2_default_name
			property double force: Config.player2_force
		}

		Button {
			text: "Erase scores"
			Layout.alignment: Qt.AlignCenter
		}
		Button {
			text: "Close"
			Layout.alignment: Qt.AlignCenter
			onClicked: close()
		}
	}
}
