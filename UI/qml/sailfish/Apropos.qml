/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

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
			text: "uAlign4"
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			width: parent.width
			wrapMode: Text.WordWrap
			horizontalAlignment: Text.AlignHCenter
			color: Theme.primaryColor
			text: qsTr("Align 4 game for Sailfish OS with strong and configurable AI")
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
			onLinkActivated: Qt.openUrlExternally(link)
		}
		Label {
			anchors.horizontalCenter: parent.horizontalCenter
			font.pixelSize: Theme.fontSizeSmall
			text: "<a href=\"" + Config.program_author_url + "\">" +  Config.program_author_url + "<\a>"
			onLinkActivated: Qt.openUrlExternally(link)
		}
	}
}
