import QtQuick 2.0
import QtGraphicalEffects 1.0

import "."
import "../config"
import "../menu"

Rectangle {
	id: info
	color: Style.color_info_bg

	property int playerPlaying: 0

	Item {
		id: info_player1
		property string player_name: Config.player1_name
		property int points: 0
		property color player_color: Style.color_player1

		anchors.left: parent.left
		anchors.top: parent.top
		width: parent.width / 2
		height: parent.height

		Text {
			width: parent.width; height: parent.height / 2
			anchors.top: parent.top
			text: parent.player_name
			font.pixelSize: width / 8 + 1
			color: parent.player_color
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			font.underline: playerPlaying == 1
		}

		Text {
			width: parent.width; height: parent.height / 2
			color: parent.player_color
			horizontalAlignment: Text.AlignHCenter
			font.pixelSize: width / 12 + 1
			x: 0; y: parent.height / 2
			text: parent.points
		}
	}

	Item {
		id: info_player2
		property string player_name: Config.player2_name
		property int points: 0
		property color player_color: Style.color_player2

		anchors.left: info_player1.right
		anchors.top: parent.top
		width: parent.width / 2
		height: parent.height

		Text {
			width: parent.width; height: parent.height / 2
			anchors.top: parent.top
			text: parent.player_name
			font.pixelSize: width / 8 + 1
			color: parent.player_color
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter

			font.underline: playerPlaying == 2
		}

		Text {
			width: parent.width; height: parent.height / 2
			color: parent.player_color
			horizontalAlignment: Text.AlignHCenter
			font.pixelSize: width / 12 + 1
			x: 0; y: parent.height / 2
			text: parent.points
		}
	}
}
