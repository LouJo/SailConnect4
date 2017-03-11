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

import "../../config"
import "../header"
import "../../main"
import "."
import ".."

SamplePage {
	id: page
	implicitWidth: 400
	implicitHeight: 640

	signal close()

	HeaderBack {
		id: header
	}

	ScrollContent {
		id: scroll
		anchors.top: header.bottom

		Column {
			id: column
			spacing: Style.defaultFont.pixelSize * 0.9
			width: scroll.width

			Image {
				source: "../../../icons/icon_100.png"
				anchors.horizontalCenter: parent.horizontalCenter
			}

			Title {
				text: "uAlign4"
			}

			AText {
				width: parent.width
				wrapMode: Text.WordWrap
				text: qsTr("Align 4 game, originally for Sailfish OS with strong and configurable AI")
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
	}

	Component.onCompleted: {
		header.close.connect(close)
	}
}
