pragma Singleton
import QtQuick 2.0

QtObject {
	property string programTitle: "Connect4"
	property int rows: 6
	property int columns: 7

	property string player1_name: "Nemo"
	property string player2_name: "Bob"

	property double player1_force: 0.75
	property double player2_force: 0.25

	property int typeHuman: 0
	property int typeIA: 1

	property int player1_type: typeHuman
	property int player2_type: typeIA
}
