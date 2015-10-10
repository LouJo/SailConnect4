import QtQuick 2.0

import "."

ButtonGeneric {
	x: parent.onR ? parent.width / 2 - width / 2 : (parent.width - width * parent.nbButton) / (parent.nbButton + 1) * (idx + 1) + width * idx
	y: parent.onR ? Math.min((parent.height - height * parent.nbButton) / (parent.nbButton + 1), height /  2) * (idx + 1) + height * idx : height / 2
}
