import QtQuick 2.0
import Sailfish.Silica 1.0

import "."
import "../main"
import "../config"

ApplicationWindow {
	id: app

	property var config: Config // for UISailfish.cpp
	property QtObject boardToGrab

	initialPage: Component { Page {
		id: page

		SilicaFlickable {
		anchors.fill: parent


		PullDownMenu {
			id: menu
			objectName: "menu"

			RemorsePopup { id: remorse }

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
				text: qsTr("Reset scores")
				onClicked: {
					remorse.execute("Reseting scores", function() { menu.resetScores() })
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
				title: DefaultConfig.programTitle
				id: header
			}
			Game {
				id: game
				objectName: "game"
				width: page.width
				height: page.height - header.height * 3
				extra_margin: 20
				Component.onCompleted: {
					game.grabOk.connect(app.setBoardToGrab)
				}
			}
		}
	}}}

	function setBoardToGrab(obj) {
		app.boardToGrab = obj;
	}

	allowedOrientations: Orientation.Portrait

	cover: Component {
		CoverPage {
			id: myCover
			objectToGrab: app.boardToGrab
		}
	}
}
