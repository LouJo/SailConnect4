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

Item {
	id: menu

	property bool displayed: false

	signal newGame()
	signal resetScores()
	signal exit()

	signal launchApropos()
	signal launchConfigure()
	signal launchStats()

	property int wantedWidth: Style.defaultFont.pixelSize * (qsTr("Reset scores").length + 2 ) * 0.6
	width: displayed ? wantedWidth : 0

	anchors.top: header.bottom
	anchors.right: parent.right
	anchors.topMargin: 4
	anchors.rightMargin: 2
	visible: width > 0

	Rectangle {
		// background
		id: bg
		color: Style.menu_bg_color
		border.width: 1
		border.color: Style.menu_border_color
		width: parent.width
		height: column.height + 2
		anchors.top: parent.top
		anchors.left: parent.left
	}

	Column {
		id: column

		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.topMargin: 1
		anchors.leftMargin: 1
		anchors.rightMargin: 1

		MenuItem {
			title: qsTr("Configuration")
			onTriggered: launchConfigure()
		}

		MenuItem {
			title: qsTr("Reset scores")
			onTriggered: confirm_resetScores.visible = true
		}

		MenuItem {
			title: qsTr("Stats")
			onTriggered: launchStats()
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

	Behavior on width {
		NumberAnimation {
			duration: 100
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
