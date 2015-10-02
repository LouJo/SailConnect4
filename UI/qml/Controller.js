/*
 * Controller for Main
 */

function changePlayer()
{
	game.player = 3 - game.player;
}

function enablePlay(e)
{
	game.canPlay = e;
}

function begin()
{
	enablePlay(true)
}

function playCol(x) {
	if (x >= board.columns) return false;

	enablePlay(false)
	var y = board.rows - 1
	while (y >= 0) {
		if (playIndex(x + y * board.columns)) {
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
	if (board.play(index, game.player)) {
		return true
	}
	else {
		return false
	}
}

function new_game()
{
	console.log("new game")
	win(Math.floor(Math.random()*2) + 1);
	reset();
}

function reset() {
	enablePlay(false)
	board.reset()
	game.player = 1
	enablePlay(true)
}

function win(player) {
	if (player == 1) Config.player1_points++
	else Config.player2_points++
}

function exit() {
	Qt.quit()
}
