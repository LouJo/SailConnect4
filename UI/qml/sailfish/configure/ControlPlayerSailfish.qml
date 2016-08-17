import QtQuick 2.0
import Sailfish.Silica 1.0

import "../../config"

Column {
	id: controlPlayer

	signal submit()
	signal nameEdited(string new_name)

	property alias force: sliderForce.value
	property int type
	property string name
	property color userColor

	width: parent.width

	TextField {
		id: nameField
		text: name
		label: qsTr("Name")
		placeholderText: qsTr("Player name")
		width: parent.width
	}

	TextSwitch {
		id: ia
		text: qsTr("IA") + ": " + DefaultConfig.forceNames[sliderForce.value]
		checked: controlPlayer.type == 1
		width: parent.width
	}

	Slider {
			id: sliderForce
//			label: qsTr("IA force")
			stepSize: 1
			minimumValue: 0
			maximumValue: 4
			//tickmarksEnabled: true
			enabled: ia.checked
			value: force
			width: parent.width

			opacity: enabled ? 1 : 0.3
		//	updateValueWhileDragging: false
	}

	Row {
		Label {
			id: colorLabel
			text: "  " + qsTr("Color") + "  "
			anchors.verticalCenter: parent.verticalCenter
		}
		Rectangle {
			color: userColor	
			width: height * 2.5
			height: Theme.fontSizeMedium
			anchors.verticalCenter: parent.verticalCenter

			MouseArea {
				anchors.fill: parent
				onClicked: {
					var dialog = pageStack.push("Sailfish.Silica.ColorPickerDialog")
					dialog.accepted.connect(function() {
						controlPlayer.userColor = dialog.color
          })
				}
			}
		}
	}

	Item {
		width: parent.width
		height: 40
	}

	function submitAll() {
		nameEdited(nameField.text)
		submit()
	}

	function getType() {
		return ia.checked ? DefaultConfig.typeIA : DefaultConfig.typeHuman
	}
}
