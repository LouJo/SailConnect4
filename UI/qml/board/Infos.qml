import QtQuick 2.0
import QtGraphicalEffects 1.0

import "."
import "../config"
import "../menu"
import "../main"

Rectangle {
	id: info
	color: Style.color_info_bg

	property int playerPlaying: 0

	InfosPlayer {
		id: info_player1
		player_name: Config.player1_name
		points: Config.player1_points
		player_color: Style.color_player1

		anchors.left: parent.left
		anchors.top: parent.top
		width: parent.width / 2
		height: parent.height

		playing: parent.playerPlaying == 1
	}

	InfosPlayer {
		id: info_player2
		player_name: Config.player2_name
		points: Config.player2_points
		player_color: Style.color_player2

		anchors.left: info_player1.right
		anchors.top: parent.top
		width: parent.width / 2
		height: parent.height

		playing: parent.playerPlaying == 2
	}
}
