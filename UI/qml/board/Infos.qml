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
import QtGraphicalEffects 1.0

import "."
import "../config"
import "../main"

Rectangle {
	id: info
	color: Config.board_transparent ? "transparent" : Style.color_info_bg

	property int playerPlaying: 0

	InfosPlayer {
		id: info_player1
		player_name: Config.player1_name
		points: Config.player1_points
		player_color: Config.player1_color

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
		player_color: Config.player2_color

		anchors.left: info_player1.right
		anchors.top: parent.top
		width: parent.width / 2
		height: parent.height

		playing: parent.playerPlaying == 2
	}
}
