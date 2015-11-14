import QtQuick 2.0
import Sailfish.Silica 1.0

import "."
import "../main"
import "../config"

ApplicationWindow {
	id: app

	property var config: Config // for UISailfish.cpp
   property QtObject boardToGrab

   allowedOrientations: (Screen.sizeCategory > Screen.Medium) ? Orientation.All : Orientation.Portrait

	initialPage: Component { Page {
		id: page

        allowedOrientations: Orientation.All

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
				text: qsTr("Exit")
				onClicked: menu.exit()
			}
			MenuItem {
				text: qsTr("About")
				onClicked: pageStack.push(Qt.resolvedUrl("Apropos.qml"))
			}
			MenuItem {
				text: qsTr("Reset scores")
				onClicked: {
					remorse.execute(qsTr("Reseting scores"), function() { menu.resetScores() })
				}
			}
			MenuItem {
				text: qsTr("Configuration")
				onClicked: {
					var confpage = pageStack.push(Qt.resolvedUrl("ConfigurePage.qml"))
					confpage.configChanged.connect(menu.configChanged)
				}
			}
			MenuItem {
				text: qsTr("New game")
				onClicked: {
					if (game.ended) {
						menu.newGame()
					}
					else {
						remorse.execute(qsTr("Stop this game"), function() { menu.newGame() })
					}
				}
			}
		}
		Item {
         width: page.width
			height: page.height
         //spacing: Theme.paddingLarge

			PageHeader {
				anchors.top: parent.top
				width: parent.width

				title: DefaultConfig.programTitle
				id: header
			}
			Game {
				id: game
				objectName: "game"
                width: page.orientation & Orientation.PortraitMask ? parent.width : parent.width / 2

                anchors.horizontalCenter: parent.horizontalCenter
				anchors.top: header.bottom
				anchors.topMargin: header.height / 2
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

	cover: Component {
		CoverPage {
			id: myCover
			objectName: "myCover"
			objectToGrab: app.boardToGrab
		}
	}
}
