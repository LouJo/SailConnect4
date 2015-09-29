var player = 1

function setPlayerPlaying(e)
{
	var item = player == 1 ? info_player1 : info_player2;
	item.setPlaying(e);
}

function changePlayer()
{
	player = 3 - player;
}

function enablePlay(e)
{
	setPlayerPlaying(e);
	board.canPlay = e;
}

function begin()
{
	enablePlay(true)
}

function playCol(x) {
	if (x >= grid.columns) return false;

	enablePlay(false)
	var y = grid.rows - 1
	while (y >= 0) {
		if (playIndex(x + y * grid.columns)) {
			changePlayer()
			enablePlay(true)
			return true
		}
		y--
	}
	enablePlay(true)
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
