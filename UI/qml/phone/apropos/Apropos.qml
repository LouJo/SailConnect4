/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0

import "../../config"
import "../header"
import "../../main"
import "."

Rectangle {
	implicitWidth: 400
	implicitHeight: 640

	signal close()

	color: Style.phone_bg_color

	HeaderBack {
		id: header
	}

	Column {
		anchors.top: header.bottom
		anchors.topMargin: Style.defaultFont.pixelSize
		width: parent.width * 0.9
		anchors.horizontalCenter: parent.horizontalCenter
		spacing: Style.defaultFont.pixelSize * 0.9

		Image {
			source: "../../../icons/icon_100.png" 
			anchors.horizontalCenter: parent.horizontalCenter
		}

		Title {
			text: "SailConnect4"
		}

		AText {
			width: parent.width
			wrapMode: Text.WordWrap
			text: qsTr("Connect4 game for Sailfish OS with strong and configurable AI")
		}

		AText {
			text: "version " + Config.program_version
		}

		Title {
			text: qsTr("Copyright")
		}

		AText {
			text: Config.program_author
		}
		AText {
			text: Config.program_date
		}
		AText {
			text: qsTr("licence") + ": " + Config.program_licence
		}

		Title {
			text: qsTr("Links")
		}
		AText {
			text: "<a href=\"" + Config.program_code_url + "\">" +  Config.program_code_url + "<\a>"
			onLinkActivated: Qt.openUrlExternally(link)
		}
		AText {
			text: "<a href=\"" + Config.program_author_url + "\">" +  Config.program_author_url + "<\a>"
			onLinkActivated: Qt.openUrlExternally(link)
		}
	}

	Component.onCompleted: {
		header.close.connect(close)
	}
}
