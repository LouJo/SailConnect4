import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

GroupBox {
	Layout.fillWidth: true

	ColumnLayout {
		RowLayout {
			Label { text: "Name: " }
			TextField { 
				text: name
				Layout.fillWidth: true
			}
		}
		ExclusiveGroup { id: player }
		RowLayout {
			RadioButton {
				id: human
				text: "Human"
				checked: true
				exclusiveGroup: player
			}
			RadioButton {
				id: ia
				text: "IA force:"
				checked: false
				exclusiveGroup: player
			}
		}
		Slider { 
			value: force;
			stepSize: 0.25
			tickmarksEnabled: true
			width: parent.width * 0.9
			enabled: ia.checked
			opacity: enabled ? 1 : 0.3
		}
	}
}
