pragma Singleton
import QtQuick 2.0

import "."

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

	property double board_margin: 8

	property int timeAnimationRow: 100

	// desktop buttons
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
  
	// phone
	property color phone_font_color: "#dddddd"
	property color phone_bg_color: "#444444"
	property color phone_title_color: "#f6e396"
	property color phone_link_color: "blue"

	// phone header
	property color header_bg_color: "#AAAAAA"
	property color header_bg_color_activated: "#999999"
	property color header_font_color: "#333333"
	property color header_border_color: "#777777"

	// phone menu
	property color menu_bg_color: header_bg_color
	property color menu_font_color: header_font_color
	property color menu_bg_color_activated: header_bg_color_activated
	property int menu_activated_ms: 500
	property color menu_border_color: header_border_color

	// phone configure
	property color conf_button_inside: phone_link_color
	property color conf_field_bg_color: "#666666"

  // stat page
  property color stat_color_equal: "#dddddd"

	// system font size
	property var defaultFont: DefaultText.font
}
