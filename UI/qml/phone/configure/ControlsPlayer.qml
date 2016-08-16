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
import QtQuick.Controls.Styles 1.4

import ".."

Column {
	id: controls

	spacing: 18

	signal submit()
	signal nameEdited(string new_name)

	property int force
	property int type
	property string title
	property string name

	Item {
		height: 6
		width: parent.width
	}

  Rectangle {
    width: parent.width
    height: 1
    color: Style.conf_font_color
  }

	Text {
		text: parent.title
    color: Style.conf_font_color
		font.bold: true
	}

	Row {
		Label {
			text: qsTr("Name") + ": "
			anchors.verticalCenter: parent.verticalCenter
      color: Style.conf_font_color
		}
		TextField {
			anchors.verticalCenter: parent.verticalCenter
			id: nameField
			text: controls.name
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
			text: qsTr("IA force") + ":"
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
          color: Style.conf_font_color
          text: control.text
        }
        indicator: Rectangle {
          width: 14
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
				spacing: 4
     }
   }

}
