import QtQuick 2.0

import "."
import ".."

Rectangle {
	id: menu

	property int nbButton: 3

	property bool onR: height > width

	property double buttonWidth: onR ? width * Style.buttonWidthMainRelationOnR : width * Style.buttonWidthMainRelationOnB / nbButton

	color: Style.color_menu_bg

	signal configChanged()
	signal newGame()
	signal resetScores()
	signal exit()

	ButtonMenu {
		property int idx: 0
		property string buttonText: qsTr("New game")

		onActivated: newGame()
	}

	ButtonMenu {
		property int idx: 1
		property string buttonText: qsTr("Configuration")

		onActivated: {
			var conf = Qt.createComponent("../config/ConfigureWindow.qml")
			var win = conf.createObject(menu)
			win.configChanged.connect(menu.configChanged)
			win.resetScores.connect(menu.resetScores)
			win.show()
		}
	}

	ButtonMenu {
		property int idx: 2
		property string buttonText: qsTr("Apropos")

		onActivated: {
			var apropos = Qt.createComponent("../apropos/Apropos.qml")
			var win = apropos.createObject(apropos)
			win.show()
		}
	}

	ButtonMenu {
		property int idx: 3
		property string buttonText: qsTr("Exit")

		onActivated: exit()
	}
}
