import QtQuick 2.0

Rectangle {
	property double x1
	property double x2
	property double y1
	property double y2
	property double lineWidth

	property double dx: x2 - x1
	property double dy: y2 - y1
	property double d: Math.sqrt(dx * dx + dy * dy)

	property double wx: dx / d
	property double wy: dy / d

	transformOrigin: Item.TopLeft

	x: x1 - wx
	y: y1 - wy

	width: d
	height: lineWidth
	rotation: Math.abs(dx) < 0.1 ? 90 : Math.atan(dy / dx) * 180 / Math.PI + (dx > 0 ? 0 : 180)

	//onXChanged: console.log(x + " " + y + " " + rotation)
}
