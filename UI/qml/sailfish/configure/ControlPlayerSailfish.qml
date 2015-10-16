import QtQuick 2.0
import Sailfish.Silica 1.0

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

		function submit() { controlPlayer.nameEdited(text) }
	}

	TextSwitch {
		id: ia
		text: "IA"
		checked: controlPlayer.type == 1
		width: parent.width
	}

	Slider {
			id: sliderForce
//			label: qsTr("IA force")
			stepSize: 1
			minimumValue: 0
			maximumValue: 4
			valueText: qsTr("IA force") + " " + value
			//tickmarksEnabled: true
			width: parent.width
			enabled: ia.checked
			value: force
		//	opacity: enabled ? 1 : 0.3
		//	updateValueWhileDragging: false
	}

/*
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
				text: qsTr("IA force") + ":"
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
	}

	function submitAll() {
		nameField.submit()
		submit()
	}

	function getType() {
		return human.checked ? 0 : 1
	}*/
}
