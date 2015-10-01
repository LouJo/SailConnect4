import QtQuick 2.0
import QtGraphicalEffects 1.0
import "."
import ".."

Rectangle {
	width: parent.buttonWidth
	height: width * Style.buttonHeightRelation

	border.width: Style.button_border_width
	border.color: Style.color_button_border
	radius: height * Style.button_radius

	property color color1: Style.color1_button
	property color color2: Style.color2_button

	signal activated()

	gradient: Gradient {
		GradientStop { position: 0.0; color: color1 }
		GradientStop { position: 1.0; color: color2 }
	}

	Text {
		anchors.fill: parent
		text: parent.buttonText
		color: Style.color_button_text
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
	}

	MouseArea {
		anchors.fill: parent
		onClicked: {
			parent.color1 = Style.color1_button_clicked
			parent.color2 = Style.color2_button_clicked
			buttonTimer.start()
			parent.activated()
		}
	}

	Timer {
		id: buttonTimer
		repeat: false
		interval: Style.button_reset_interval
		running: false
		onTriggered: reset()
	}

	function reset() {
		color1 = Style.color1_button
		color2 = Style.color2_button
	}
}
