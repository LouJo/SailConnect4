import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

GroupBox {
	Layout.fillWidth: true

	ColumnLayout {
		RowLayout {
			Label { text: "Name" }
			TextField { text: name }
		}
		ExclusiveGroup { id: player }
		RowLayout {
			RadioButton {
				text: "Human"
				checked: true
				exclusiveGroup: player
			}
			RadioButton {
				text: "IA"
				checked: false
				exclusiveGroup: player
			}
		}
	}
}
