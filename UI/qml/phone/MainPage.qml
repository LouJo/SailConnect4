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

import "../main/Controller.js" as Controller

import "."
import "../main"
import "../board"
import "menu"
import "header"

SamplePage {
	id: main
	objectName: "main"

	width: 400
	height: 640

	signal launchApropos()
	signal launchConfigure()
	signal launchStats()

	property bool menuVisible: false

	property var board: game.board // for js controller

	// adaptative style

	HeaderMain {
		id: header
		menuVisible: parent.menuVisible
	}

	Game {
		id: game
		objectName: "game"
		x: 0
		y: 0
		width:  Math.min(parent.width, height * 0.9)
		height: Math.min(Math.max(parent.height - header.height * 3,
										          parent.height * 0.8),
		                 parent.width * 1.2)
		anchors.top: header.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: (parent.height - height - header.height) * 0.3

		touchActive: !parent.menuVisible
		paused: parent.menuVisible || confirm_newgame.visible
	}

	/**
	 * MouseArea to close menu
	 */
	MouseArea {
		id: menu_exterior
		enabled: menuVisible
		onClicked: menuVisible = false

		anchors.fill: parent
	}

	Menu {
		id: menu
		objectName: "menu"
		displayed: parent.menuVisible
	}

	MessageDialog {
		id: confirm_newgame
		title: qsTr("New game")
		text: qsTr("Are you sure to stop current game ?")
		standardButtons: StandardButton.Ok | StandardButton.Cancel
	}

	Component.onCompleted: {
		console.log("qml: ready")

		// C++ will connect to menu for new game slot
		header.newGame.connect(newGame)
		header.switchMenu.connect(switchMenu)
		menu.launchApropos.connect(launchApropos)
		menu.launchConfigure.connect(launchConfigure)
		menu.launchStats.connect(launchStats)
		confirm_newgame.accepted.connect(menu.newGame)

		if (Controller.isQmlScene()) {
			game.playCol.connect(Controller.playCol)
			menu.newGame.connect(Controller.new_game)
			menu.exit.connect(Controller.exit)

			Controller.begin()
		}
	}

	function switchMenu() {
		menuVisible = menuVisible ^ true
	}

	function newGame() {
		if (game.ended)
			menu.newGame()
		else
			confirm_newgame.visible = true
	}
}
