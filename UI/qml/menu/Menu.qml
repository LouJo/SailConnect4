import QtQuick 2.0

import "."
import ".."

Rectangle {
	id: menu

	property int nbButton: 3

	property bool onR: height > width

	property double buttonWidth: onR ? width * Style.buttonWidthMainRelationOnR : width * Style.buttonWidthMainRelationOnB / nbButton

	color: Style.color_menu_bg

	signal new_game()
	signal exit()

	ButtonMenu {
		property int idx: 0
		property string buttonText: "New game"

		onActivated: new_game()
	}

	ButtonMenu {
		property int idx: 1
		property string buttonText: "Configuration"
	}

	ButtonMenu {
		property int idx: 2
		property string buttonText: "Exit"

		onActivated: exit()
	}
}
