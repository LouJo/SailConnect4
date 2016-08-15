pragma Singleton
import QtQuick 2.0

QtObject {
	
	// main
	property int window_width: 680
	property int window_height: 500

	// board
	property int cell_border_width: 3
	property double cell_margin: 0.07
	property double infos_height: 0.2

	property color color_main_bg: "#BBBBBB"
	property color color_board_bg: "#27315D"
	property color color_info_bg: "#27315D"
	property color color_cell_border: "#273140"
	property color color_ball_border: "#878787"

	property color color_empty: "#D7D7D7"

	property color color_player1: "#F3B81C"
	property color color_player2: "#DA2227"

	property double board_margin: 8

	property int timeAnimationRow: 100

	// buttons
	property double buttonHeightRelation: 0.3
	property double buttonWidthMainRelationOnR: 0.6
	property double buttonWidthMainRelationOnB: 0.8
	property double button_radius: 0.3

	property color color1_button: "#EEEEEE"
	property color color2_button: "#ADADAD"

	property color color1_button_clicked: "#b2bbe8"
	property color color2_button_clicked: "#7781b1"

	property color color_button_border: "#2c6887"
	property color color_menu_bg: "#4f5c62"
	property color color_button_text: "#2c6887"

	property int button_border_width: 1

	property int button_reset_interval: 200

	property double lineAlignedWidth: 2
  
	// phone menu
	property color header_bg_color: "#AAAAAA"
	property color header_font_color: "#333333"
	property color menu_bg_color: "#AAAAAA"
	property color menu_font_color: "#333333"
}
