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
import QtQuick.Controls 1.0

import "."
import ".."
import "../../config"

Rectangle {
	width: 400
	height: 640

  color: Style.conf_bg_color

	signal configChanged()
	signal exit()

  ConfigureHeader {
    id: header
  }

	Column {
		spacing: 15
		
		anchors.top: header.bottom
    anchors.left: parent.left
    anchors.right: parent.right
		anchors.topMargin: 10
		anchors.leftMargin: 10
		anchors.rightMargin: 10

		ControlsPlayer {
				id: p1
				title: qsTr("Player %1").arg(1)
				name: Config.player1_name
				force: Config.player1_force
				type: Config.player1_type

        width: parent.width
	
				onNameEdited: Config.player1_name = new_name
				onSubmit: {
					Config.player1_force = force
					Config.player1_type = getType()
				}
		}
	
		ControlsPlayer {
				id: p2
				title: qsTr("Player %1").arg(2)
				name: Config.player2_name
				force: Config.player2_force
				type: Config.player2_type

        width: parent.width
	
				onNameEdited: Config.player2_name = new_name
				onSubmit: {
					Config.player2_force = force
					Config.player2_type = getType()
				}
		}
	}

	Component.onCompleted: {
		header.accept.connect(accept)
		header.cancel.connect(exit)
	}

	function accept() {
		p1.submitAll()
		p2.submitAll()
		configChanged()
		exit()
  }
}
