pragma Singleton
import QtQuick 2.0

QtObject {
	property int window_width: 600
	property int window_height: 400
	property int cell_border_width: 3
	property double cell_margin: 0.07

	property color color_bg: "#27315D"
	property color color_cell_border: "#273140"
	property color color_empty: "#D7D7D7"

	property color color_player1: "#E6D82E"
	property color color_player2: "#E63B2E"
}
