import QtQuick 2.0

Image {
	property int idx
	property int row: Math.floor(idx / board.columns)
	property double posX: (idx % board.columns) * board.cellLength + board.cellMargin
	property double posY: row * board.cellLength + board.cellMargin
	property int player: 1

	x: posX
	y: posY
	width: board.ballLength
	height: board.ballLength

	source: player == 1 ? "../../icons/svg/yellow.svg" : "../../icons/svg/red.svg"
	smooth: true
}
