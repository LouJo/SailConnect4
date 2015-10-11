import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "."

ApplicationWindow {
	id: mainWindow
	property int margin: 10
	title: Config.programTitle + " " + qsTr("configuration")

	width: configure.implW + 2 * margin
	height: configure.implH + 2 * margin
	minimumWidth: configure.minW + 2 * margin
	minimumHeight: configure.minH + 2 * margin

	signal configChanged()
	signal resetScores()

	Configure {
		id: configure
	}
	Component.onCompleted: {
		configure.configChanged.connect(configChanged)
		configure.resetScores.connect(resetScores)
	}
	onConfigChanged: close()
}
