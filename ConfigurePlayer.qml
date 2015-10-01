import QtQuick 2.0
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0

GroupBox {
	Layout.fillWidth: true

	RowLayout {
		Label { text: "Name" }
		TextField { text: name }
		CheckBox {
			text: "IA"
		}
	}
}

