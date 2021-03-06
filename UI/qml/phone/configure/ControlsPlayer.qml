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
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2

import ".."
import "../../config"
import "../../main"

Column {
	id: controls

	spacing: fontSize

	signal submit()
	signal nameEdited(string new_name)

	property alias force: sliderForce.value
	property int type
	property string title
	property string name
	property color userColor

	property alias fontSize: text_title.fontSize

	Item {
		height: 6
		width: parent.width
	}

  Rectangle {
    width: parent.width
    height: 1
    color: Style.phone_font_color
  }

	Text {
		id: text_title
		text: parent.title
    color: Style.phone_title_color
		font.bold: true
		property int fontSize: font.pixelSize
	}

	Row {
		Label {
			text: qsTr("Name") + ": "
			anchors.verticalCenter: parent.verticalCenter
      color: Style.phone_font_color
		}
		TextField {
			anchors.verticalCenter: parent.verticalCenter
			id: nameField
			text: controls.name
			style: text_field_style

			function submit() { controls.nameEdited(text) }
		}
	}

	Row {
		ExclusiveGroup { id: player }
		spacing: 10
		RadioButton {
			id: human
			text: qsTr("Human")
			checked: controls.type == 0
			exclusiveGroup: player
			style: radio_style
		}
		RadioButton {
			id: ia
			text: qsTr("AI") + ": " + DefaultConfig.forceNames[sliderForce.value]
			checked: controls.type == 1
			exclusiveGroup: player
			style: radio_style
		}
	}

	Slider {
		id: sliderForce
		stepSize: 1
		minimumValue: 0
		maximumValue: 4
		tickmarksEnabled: true
		width: parent.width * 0.9
		opacity: enabled ? 1 : 0.3
		enabled: ia.checked
		style: slider_style
	}

	Row {
		spacing: Style.defaultFont.pixelSize * 0.5

		Text {
			text: qsTr("Color") + ": "
      color: Style.phone_font_color
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

	ColorDialog {
		id: colorDialog
		title: qsTr("Choose a color")
		onAccepted: controls.userColor = currentColor
		color: controls.userColor
		visible: false
	}


	function submitAll() {
		nameField.submit()
		submit()
	}

	function getType() {
		return human.checked ? 0 : 1
	}

  Component {
    id: radio_style

    RadioButtonStyle {
        label: Text {
          color: Style.phone_font_color
          text: control.text
        }
        indicator: Rectangle {
          width: fontSize
          height: width
          radius: width * 0.5

          Rectangle {
            anchors.fill: parent
            visible: control.checked
            anchors.margins: 3
            color: Style.conf_button_inside
            radius: width * 0.5
          }
        }
				spacing: fontSize * 0.6
     }
   }

	Component {
	 	id: text_field_style

		TextFieldStyle {
			textColor: Style.phone_font_color
			background: Rectangle {
				color: Style.conf_field_bg_color
				implicitHeight: fontSize * 2
				implicitWidth: fontSize * 15
			}
		}
	}

	Component {
		id: slider_style

		SliderStyle {
			handle: Rectangle {
				anchors.centerIn: parent
				color: control.enabled ? Style.conf_button_inside : Style.phone_font_color
				implicitWidth: fontSize * 0.8
				implicitHeight: implicitWidth
				radius: width * 0.5
			}
		}
	}
}
