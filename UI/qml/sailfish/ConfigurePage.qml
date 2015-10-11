import QtQuick 2.0
import Sailfish.Silica 1.0

import "../config"

Page {
	signal configChanged()
	signal resetScores()

	SilicaFlickable {
		Configure {
			id: configure
		}
	}
	Component.onCompleted: {
		configure.configChanged.connect(configChanged)
		configure.resetScores.connect(resetScores)
	}
	onConfigChanged: pageStack.pop()
}
