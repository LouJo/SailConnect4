import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

GroupBox {
	id: controlPlayer

	Layout.fillWidth: true

	signal submit()
	signal nameEdited(string new_name)

	property alias force: sliderForce.value
	property int type
	property string name

	ColumnLayout {
		RowLayout {
			Label { text: "Name: " }
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
				text: "Human"
				checked: controlPlayer.type == 0
				exclusiveGroup: player
			}
			RadioButton {
				id: ia
				text: "IA force:"
				checked: controlPlayer.type == 1
				exclusiveGroup: player
			}
		}
		Slider {
			id: sliderForce
			stepSize: 0.25
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
	}
}
