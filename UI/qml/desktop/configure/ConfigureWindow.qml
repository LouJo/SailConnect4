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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

import "."
import "../../config"

ApplicationWindow {
	id: mainWindow
	property int margin: 10
	title: Config.programTitle + " " + qsTr("configuration")

	width: configure.implW + 2 * margin
	height: configure.implH + 2 * margin
	minimumWidth: configure.minW + 2 * margin
	minimumHeight: configure.minH + 2 * margin

	signal configChanged()
	signal resetScores()

	Configure {
		id: configure
	}
	Component.onCompleted: {
		configure.configChanged.connect(configChanged)
		configure.resetScores.connect(resetScores)
	}
	onConfigChanged: close()
}
