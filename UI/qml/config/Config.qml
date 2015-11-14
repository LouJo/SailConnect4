pragma Singleton
import QtQuick 2.0
import "."

QtObject {
	property string programTitle: DefaultConfig.programTitle
	property int rows: DefaultConfig.rows
	property int columns: DefaultConfig.columns
	property int align: DefaultConfig.align

	property string player1_name: DefaultConfig.player1_name
	property string player2_name: DefaultConfig.player2_name

	property int player1_force: DefaultConfig.player1_force
	property int player2_force: DefaultConfig.player2_force

	property int player1_points: 0
	property int player2_points: 0

	property int player1_type: DefaultConfig.player1_type
	property int player2_type: DefaultConfig.player2_type

	property bool animation: DefaultConfig.animation

	property string program_author: "Louis-Joseph Fournier"
	property string program_date: "10-2015"
	property string program_version: "0.2.1"
	property string program_licence: "GPL v3"
	property string program_code_url: "https://github.com/LouJo/SailConnect4"
	property string program_author_url: "http://legolas.vefblog.net"

	property bool board_transparent: DefaultConfig.board_transparent
}
