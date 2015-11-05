import QtQuick 2.0
import QtGraphicalEffects 1.0
import Sailfish.Silica 1.0

import "../board"
import "../config"

CoverBackground {
	property QtObject objectToGrab
	signal coverActive(bool active)

	property bool active: status == Cover.Active

	Label {
		id: label
		text: DefaultConfig.programTitle
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: parent.top
		anchors.topMargin: Theme.paddingLarge
		anchors.bottomMargin: Theme.paddingLarge
	}

	Rectangle {
		anchors.fill: parent
		visible: false
		color: "transparent"
		id: bg
	}

	Image {
		id: previewImage
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top: label.bottom
		anchors.topMargin: Theme.paddingLarge
		anchors.left: parent.left
		anchors.leftMargin: Theme.paddingSmall

		height: objectToGrab.height * width / objectToGrab.width

		function updatePreview() {
			objectToGrab.grabToImage(function(res) {
				previewImage.source = res.url;
			}, Qt.size(width, height))
		}
	}

	Component.onCompleted: {
		objectToGrab.updated.connect(previewImage.updatePreview)
		previewImage.updatePreview()
	}

	onActiveChanged: {
		console.log("Cover active: " + active)
		coverActive(active)
	}
}
