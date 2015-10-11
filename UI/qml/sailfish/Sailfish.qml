import QtQuick 2.0
import Sailfish.Silica 1.0

import "."
import "../main"
import "../config"

ApplicationWindow {
	property var config: Config // for UISailfish.cpp

	initialPage: Component { Page {
		id: page

		SilicaFlickable {
		anchors.fill: parent

		PullDownMenu {
			id: menu
			objectName: "menu"

			signal configChanged()
			signal resetScores()
			signal newGame()
			signal exit()

			MenuItem {
				text: qsTr("New game")
				onClicked: menu.newGame()
			}
			MenuItem {
				text: qsTr("Configuration")
				onClicked: {
					var confpage = pageStack.push(Qt.resolvedUrl("ConfigurePage.qml"))
					confpage.configChanged.connect(menu.configChanged)
					confpage.resetScores.connect(menu.resetScores)
				}
			}
			MenuItem {
				text: qsTr("Exit")
				onClicked: menu.exit()
			}
		}
		Column {
         width: page.width
         spacing: Theme.paddingLarge

			PageHeader {
				title: qsTr("Connect 4")
				id: header
			}
			Game {
				id: game
				objectName: "game"
				width: page.width
				height: page.height - header.height * 2
			}
		}
	}}}

	/*Component.onCompleted: {
		Style.color_board_bg = "transparent"
		Style.color_info_bg = "transparent"
	}*/

	allowedOrientations: Orientation.Portrait
}
