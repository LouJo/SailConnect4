var player = 1

function changePlayer()
{
	player = 3 - player
}

function playCol(x) {
	if (x >= grid.columns) return false;

	board.canPlay = false
	y = grid.rows - 1
	while (y >= 0) {
		if (playIndex(x + y * grid.columns)) {
			changePlayer()
			board.canPlay = true
			return true
		}
		y--
	}
	board.canPlay = true
	return false
}

function playIndex(index) {
	if (repeater.itemAt(index).children[0].play(player)) {
		return true
	}
	else {
		return false
	}
}


