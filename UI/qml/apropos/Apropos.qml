import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "."

ApplicationWindow {
	property int margin: 10
	title: Config.programTitle + " " + qsTr("apropos")
	width: mainLayout.implicitWidth + 2 * margin
	height: mainLayout.implicitHeight + 2 * margin
	minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
	minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

	RowLayout {
		id: mainLayout
		anchors.fill: parent
		anchors.margins: margin
		spacing: 10

		Image {
			source: "../../icons/icon_100.png" 

			MouseArea {
				anchors.fill: parent
				onClicked: close()
			}
		}

		ColumnLayout {
			Text {
				text: qsTr("Connect 4")
				font.bold: true
				font.pixelSize: 32
				color: "#444444"
			}
			Text {
				text: qsTr("A smart program to play Connect 4 with.")
			}
			Text {
				text: qsTr("Author") + ": " + Config.program_author
			}
			Text {
				text: qsTr("Date") + ": " + Config.program_date
			}
			Text {
				text: "<a href=\"http://https://github.com/LouJo/SailConnect4\">http://https://github.com/LouJo/SailConnect4</a>"
				font.pixelSize: 10
			}
		}
	}
}
