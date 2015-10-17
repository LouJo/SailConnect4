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
		text: qsTr("IA force") + " " + sliderForce.value
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

	function submitAll() {
		nameEdited(nameField.text)
		submit()
	}

	function getType() {
		return ia.checked ? DefaultConfig.typeIA : DefaultConfig.typeHuman
	}
}
