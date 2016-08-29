/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0

import "."
import ".."
import "../../main"

Rectangle {
	id: menu

	property int nbButton: 3

	property bool onR: height > width

	property double buttonWidth: onR ? width * Style.buttonWidthMainRelationOnR : width * Style.buttonWidthMainRelationOnB / nbButton

	color: Style.color_menu_bg

	signal newGame()
	signal resetScores()
	signal exit()
	signal getStats(QtObject obj)

	ButtonMenu {
		idx: 0
		buttonText: qsTr("New game")

		onActivated: newGame()
	}

	ButtonMenu {
		idx: 1
		buttonText: qsTr("Configuration")

		onActivated: {
			var conf = Qt.createComponent("../configure/ConfigureWindow.qml")
			var win = conf.createObject(menu)
			win.resetScores.connect(menu.resetScores)
			win.show()
		}
	}

	ButtonMenu {
		idx: 2
		buttonText: qsTr("Stats")
		onActivated: {
			var stats = Qt.createComponent("../StatsPage.qml")
			var win = stats.createObject(stats)
			menu.getStats(win)
			win.show()
		}
	}

	ButtonMenu {
		idx: 3
		buttonText: qsTr("Apropos")

		onActivated: {
			var apropos = Qt.createComponent("../apropos/Apropos.qml")
			var win = apropos.createObject(apropos)
			win.show()
		}
	}

	ButtonMenu {
		idx: 4
		buttonText: qsTr("Exit")

		onActivated: exit()
	}
}
