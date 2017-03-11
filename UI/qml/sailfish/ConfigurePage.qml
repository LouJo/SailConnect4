/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0
import Sailfish.Silica 1.0

import "../config"
import "./configure"

Dialog {
	id: configurePage

	allowedOrientations: Orientation.All

	DialogHeader {
		id: header
		anchors.top: parent.top
	}

	Flickable {
		width: parent.width
		anchors.top: header.bottom
		anchors.bottom: parent.bottom
		contentWidth: width
		contentHeight: column.height

	Column {
		id: column
		width: parent.width
		anchors.top: parent.top

		PageHeader {
			title: qsTr("Configuration")
		}

		ControlPlayerSailfish {
			id: player1
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player1_name
			force: Config.player1_force
			type: Config.player1_type
			userColor: Config.player1_color

			onNameEdited: Config.player1_name = new_name
			onSubmit: {
				Config.player1_force = force
				Config.player1_type = getType()
				Config.player1_color = userColor
			}
		}

		ControlPlayerSailfish {
			id: player2
			anchors.margins: Theme.paddingLarge
			width: parent.width
			name: Config.player2_name
			force: Config.player2_force
			type: Config.player2_type
			userColor: Config.player2_color

			onNameEdited: Config.player2_name = new_name
			onSubmit: {
				Config.player2_force = force
				Config.player2_type = getType()
				Config.player2_color = userColor
			}
		}

		TextSwitch {
			id: bgTransparentButton
			text: qsTr("Transparent background")
			checked: Config.board_transparent
			anchors.margins: Theme.paddingLarge

			signal submit()
			onSubmit: Config.board_transparent = checked
		}
	}
	}

	onAccepted: {
		player1.submitAll()
		player2.submitAll()
		bgTransparentButton.submit()
		Config.changed()
	}
}
