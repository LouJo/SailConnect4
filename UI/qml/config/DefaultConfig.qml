pragma Singleton
import QtQuick 2.0

QtObject {
	property string programTitle: qsTr("Connect4")
	property int rows: 6
	property int columns: 7
	property int align: 4

	property string player1_name: "Nemo"
	property string player2_name: "Bob"

	property int player1_force: 3
	property int player2_force: 1

	property int typeHuman: 0
	property int typeIA: 1

	property int player1_type: typeHuman
	property int player2_type: typeIA

	property bool animation: true

	property bool board_transparent: false

	property var forceNames: [
		qsTr("Beginner"),
		qsTr("Capable"),
		qsTr("Strong"),
		qsTr("Expert"),
		qsTr("Vicious")
	]
}
