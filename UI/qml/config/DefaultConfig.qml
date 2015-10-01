pragma Singleton
import QtQuick 2.0

QtObject {
	property string programTitle: "Connect4"
	property int rows: 6
	property int columns: 7

	property string player1_name: "Nemo"
	property string player2_name: "Bob"

	property double player1_force: 0.7
	property double player2_force: 0.2
}
