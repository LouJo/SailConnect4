import QtQuick 2.0
import Sailfish.Silica 1.0

import "../main"
import "../config"

ApplicationWindow {
	property var config: Config
	property var board: game.board

	initialPage: Game {
		objectName: "game"
		anchors.fill: parent
	}
}
