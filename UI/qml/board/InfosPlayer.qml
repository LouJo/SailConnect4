import QtQuick 2.0

Item {
	property string player_name
	property int points
	property color player_color
	property bool playing

	Text {
		width: parent.width; height: parent.height / 2
		anchors.top: parent.top
		text: parent.player_name
		font.pixelSize: width / (Math.max(parent.player_name.length+1, 9)) * 1.8 
		color: parent.player_color
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter

		font.underline: playing
	}

	Text {
		width: parent.width; height: parent.height / 2
		color: parent.player_color
		horizontalAlignment: Text.AlignHCenter
		font.pixelSize: width / 8 + 1
		x: 0; y: parent.height / 2
		text: parent.points
	}
}
