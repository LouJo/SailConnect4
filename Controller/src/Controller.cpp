/* Controller implementation
 * Generic, only QT used for thread
 */

#include "Controller.h"

Controller::Controller(UIInterface *ui)
{
	this->ui = ui;
	score[0] = score[1] = 0;
	player = 0;

	// default size
	config.rows = 6;
	config.columns = 7;
}

void Controller::Start()
{
	ui->SetController(this);
	ui->EnablePlay(true);
	ui->Launch();
}

void Controller::ConfigChange(const Config &config)
{
}

void Controller::ExitGame()
{
	ui->Exit();
}

void Controller::NewGame()
{
	Win(1); // TODO
	player = 0;
	ui->EnablePlay(false);
	ui->ResetBoard();
	ui->ChangePlayer(player);
	ui->EnablePlay(true);
}

bool Controller::PlayAtCol(int col)
{
	if (col >= config.columns) return false;
	ui->EnablePlay(false);
	int y = config.rows - 1;

	while (y >= 0) {
		if (ui->PlayAtIndex(player, col + y * config.columns)) {
			NextPlayer();
			ui->EnablePlay(true);
			return true;
		}
		y--;
	}
}

void Controller::ResetScores()
{
	score[0] = score[1] = 0;
	ui->SetScore(0,0);
	ui->SetScore(1,0);
}

// private

void Controller::NextPlayer()
{
	player = 1 - player;
	ui->ChangePlayer(player);
}

void Controller::Win(int player)
{
	score[player]++;
	ui->SetScore(player, score[player]);
}
