import QtQuick 2.0
import Sailfish.Silica 1.0

import "."
import "../main"
import "../config"

ApplicationWindow {
	property var config: Config // for UISailfish.cpp

	initialPage: Page { SilicaFlickable {
		PullDownMenu {
			id: menu
			objectName: "menu"

			signal configChanged()
			signal resetScores()
			signal newGame()
			signal exit()

			MenuItem {
				text: qsTr("New game")
				onClicked: newGame()
			}
			MenuItem {
				text: gsTr("Configuration")
				onClicked: {
					var confpage = pageStack.push(Qt.resolvedUrl("ConfigurePage.qml"))
					confpage.configChanged.connect(configChanged)
					confpage.resetScores.connect(resetScores)
				}
			}
			MenuItem {
				text: qsTr("Exit")
				onClicked: exit()
			}
		}

		Game {
			id: game
			objectName: "game"
			anchors.fill: parent
		}
	}}

	allowedOrientations: Orientation.Portrait
}
