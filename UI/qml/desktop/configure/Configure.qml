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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "."
import "../../config"

Item {
	signal resetScores()
	signal close()

	property double minW: mainLayout.Layout.minimumWidth
	property double minH: mainLayout.Layout.minimumHeight
	property double implW: mainLayout.implicitWidth
	property double implH: mainLayout.implicitHeight

	anchors.fill: parent

	ColumnLayout {
		id: mainLayout
		anchors.fill: parent
		anchors.margins: margin
		spacing: 10

		ControlsPlayer {
			id: p1
			title: qsTr("Player %1").arg(1)
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

		ControlsPlayer {
			id: p2
			title: qsTr("Player %1").arg(2)
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

		Button {
			text: qsTr("Erase scores")
			Layout.alignment: Qt.AlignCenter

			onClicked: {
				Config.player1_points = 0
				Config.player2_points = 0
				resetScores()
			}
		}

		Button {
			text: qsTr("Submit")
			Layout.alignment: Qt.AlignCenter
			onClicked: {
				p1.submitAll()
				p2.submitAll()
				Config.changed()
				close()
			}
		}
	}
}
