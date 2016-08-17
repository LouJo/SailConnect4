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
import QtQuick.Dialogs 1.2

import "../../config"
import "../../main"
import "."

Rectangle {
	id: menu
	visible: true

	color: Style.menu_bg_color

	signal newGame()
	signal resetScores()
	signal exit()

	signal launchApropos()
	signal launchConfigure()

	Column {
		anchors.fill: parent

		MenuItem {
			title: qsTr("Configuration")
			onTriggered: launchConfigure()
		}

		MenuItem {
			title: qsTr("Reset scores")
			onTriggered: confirm_resetScores.visible = true
		}

		MenuItem {
			title: qsTr("About")
			onTriggered: launchApropos()
		}

		MenuItem {
			title: qsTr("Exit")
			onTriggered: exit()
		}
	}

	MessageDialog {
		id: confirm_resetScores
		title: qsTr("Reset scores")
		text: qsTr("Are you sure to reset scores ?")
		standardButtons: StandardButton.Ok | StandardButton.Cancel

		onAccepted: resetScores()
	}

	function switchVisible() {
		menu.visible ^= true;
	}
}
