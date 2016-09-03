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
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.2

import "../../config"
import "../../main"

GroupBox {
	id: controlPlayer

	Layout.fillWidth: true

	signal submit()
	signal nameEdited(string new_name)

	property alias force: sliderForce.value
	property int type
	property string name

	property color userColor

	ColumnLayout {
		RowLayout {
			Label { text: qsTr("Name") + ": " }
			TextField { 
				id: nameField
				text: name
				Layout.fillWidth: true
				function submit() { controlPlayer.nameEdited(text) }
			}
		}
		ExclusiveGroup { id: player }
		RowLayout {
			RadioButton {
				id: human
				text: qsTr("Human")
				checked: controlPlayer.type == 0
				exclusiveGroup: player
			}
			RadioButton {
				id: ia
				text: qsTr("AI") + ": " + DefaultConfig.forceNames[sliderForce.value]
				checked: controlPlayer.type == 1
				exclusiveGroup: player
			}
		}
		Slider {
			id: sliderForce
			stepSize: 1
			minimumValue: 0
			maximumValue: 4
			tickmarksEnabled: true
			width: parent.width * 0.9
			enabled: ia.checked
			opacity: enabled ? 1 : 0.3
			updateValueWhileDragging: false
		}

		RowLayout {
			Text {
				text: qsTr("Color") + ": "
			}

			Rectangle {
				color: userColor
				width: height * 3
				height: Style.defaultFont.pixelSize * 1.2

				MouseArea {
					anchors.fill: parent
					onClicked: colorDialog.visible = true
				}
			}
		}
	}

	ColorDialog {
		id: colorDialog
		title: qsTr("Choose a color")
		onAccepted: controlPlayer.userColor = currentColor
		visible: false
		color: controlPlayer.userColor
	}

	function submitAll() {
		nameField.submit()
		submit()
	}

	function getType() {
		return human.checked ? 0 : 1
	}
}
