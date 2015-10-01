import QtQuick 2.0

import "../Controller.js" as Controller

import "."
import ".."

Rectangle {
	id: menu

	property bool onR: main.menuOnRight
	property int nbButton: 3

	x: onR ? main.game_width : 0
	y: onR ? 0 : main.game_height
	width: onR ? main.width - main.game_width : main.width
	height: onR ? main.height : main.height - main.game_height

	color: Style.color_menu_bg

	property double buttonWidth: onR ? width * Style.buttonWidthMainRelationOnR : width * Style.buttonWidthMainRelationOnB / nbButton

	ButtonMenu {
		property int idx: 0
		property string buttonText: "New game"

		onActivated: Controller.new_game()
	}

	ButtonMenu {
		property int idx: 1
		property string buttonText: "Configuration"
	}

	ButtonMenu {
		property int idx: 2
		property string buttonText: "Exit"

		onActivated: Controller.exit()
	}
}
