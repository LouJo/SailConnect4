import QtQuick 2.0

Rectangle {
	property int idx
	property int row: Math.floor(idx / board.columns)
	property double posX: (idx % board.columns) * board.cellLength + board.cellMargin
	property double posY: row * board.cellLength + board.cellMargin

	x: posX
	y: posY
	width: board.ballLength
	height: board.ballLength
	radius: width / 2
	border.width: board.cellBorderWidth
}
