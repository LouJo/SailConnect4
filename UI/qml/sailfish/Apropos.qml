import QtQuick 2.0
import Sailfish.Silica 1.0

import "../config"

Page {
	allowedOrientations: Orientation.All

	Column {
		width: parent.width
		spacing: 10

		PageHeader {
			title: qsTr("About")
		}

		Image {
			anchors.horizontalCenter: parent.horizontalCenter
			source: "../../icons/icon_100.png" 
		}

		SectionHeader {
			anchors.horizontalCenter: parent.horizontalCenter
			text: "SailConnect4"
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			width: parent.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			color: Theme.primaryColor
			text: qsTr("Connect4 game for Sailfish OS with strong and configurable IA")
		}

		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: "version " + Config.program_version
		}

		SectionHeader {
			anchors.horizontalCenter: parent.horizontalCenter
			text: qsTr("Copyright")
		}

		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: Config.program_author
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: Config.program_date
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: qsTr("licence") + ": " + Config.program_licence
		}

		SectionHeader {
			anchors.horizontalCenter: parent.horizontalCenter
			text: qsTr("Links")
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: "<a href=\"" + Config.program_code_url + "\">" +  Config.program_code_url + "<\a>"
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: "<a href=\"" + Config.program_author_url + "\">" +  Config.program_author_url + "<\a>"
		}
	}
}
