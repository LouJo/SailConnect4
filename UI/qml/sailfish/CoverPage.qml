import QtQuick 2.0
import Sailfish.Silica 1.0

import "../board"
import "../config"

CoverBackground {
	property QtObject objectToGrab

	Label {
		id: label
		text: DefaultConfig.programTitle
		anchors.centerIn: parent
		y: 10
	}

	Image {
		id: previewImage
		anchors.centerIn: parent
		y: 20 + label.height
		width: parent.width - 20
		height: objectToGrab.height * width / objectToGrab.width

		function updatePreview() {
			objectToGrab.grabToImage(function(res) {
				previewImage.source = res.url; },
				Qt.size(width, height)
			);
			console.log("cover changed");
		}
	}

	Component.onCompleted: {
//		previewImage.updatePreview()
		console.log("cover complete")
	}
	onStatusChanged: {
		console.log("cover status " + status + " active: " + Cover.Active);
		if (status == Cover.Active) previewImage.updatePreview()
	}
}
