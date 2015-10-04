/* Controller implementation
 * Generic, only QT used for thread
 */

#include <iostream>
#include <fstream>

#include <QDebug>
#include <QStandardPaths>

#include "Controller.h"

using namespace std;

string Controller::configFileName = "C4config.dat";
string Controller::scoreFileName = "C4score.dat";
string Controller::gameFileName = "C4game.dat";

ControllerInterface::Config Controller::defaultConfig = {
	{ { "Bob", 2, ControllerInterface::TypeHuman },
	  { "Nemo", 2, ControllerInterface::TypeIA } },
	6, 7, 4
};

Controller::Controller(UIInterface *ui)
{
	this->ui = ui;
	score[0] = score[1] = 0;
	player = 0;
	ended = false;

	QString qDataDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
	qDebug() << "ctrl: standart config path: " << qDataDir;
	if (qDataDir == "") { configFilePath = scoreFilePath = gameFilePath = ""; }
	else {
		string path = qDataDir.toStdString();
		configFilePath = path + "/" + configFileName;
		scoreFilePath = path + "/" + scoreFileName;
		gameFilePath = path + "/" + gameFileName;
	}
	if (!LoadConfig()) config = defaultConfig;
	LoadScore();
}

void Controller::Start()
{
	ui->SetController(this);
	ui->Launch();
	LoadGame();
	ui->EnablePlay(true);
}

void Controller::ConfigChange(const Config &config)
{
	this->config = config;
	SaveConfig();
}

void Controller::ExitGame()
{
	SaveGame();
	ui->Exit();
}

void Controller::NewGame()
{
	Win(1); // TODO
	played.clear();
	player = 0;
	ended = false;
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
			PlayAtIndex(col + y * config.columns);
			ui->EnablePlay(true);
			return true;
		}
		y--;
	}
	ui->EnablePlay(true);
	return false;
}

void Controller::ResetScores()
{
	score[0] = score[1] = 0;
	ui->SetScore(0,0);
	ui->SetScore(1,0);
	SaveScore();
}

// private

void Controller::NextPlayer()
{
	player = 1 - player;
	ui->ChangePlayer(player);
}

void Controller::PlayAtIndex(int index)
{
//	ui->PlayAtIndex(player, index); TODO
	played.push_back(index);
	NextPlayer();
}

void Controller::Win(int player)
{
	ended = true;
	score[player]++;
	ui->SetScore(player, score[player]);
	SaveScore();
}

/* Load and save functions */

bool Controller::LoadConfig()
{
	if (configFilePath == "") return false;
	ifstream f(configFilePath, ios::in);
	if (!f.is_open()) return false;

	qDebug() << "ctrl: load config";

	f >> config.rows;
	f >> config.columns;
	f >> config.align;

	int type;

	for (int i = 0; i < 2; i++) {
		ConfigPlayer *p = &config.player[i];
		f >> p->name;
		f >> p->force;
		f >> type;
		p->type = (PlayerType_t) type;
	}
	f.close();

	ui->ConfigSet(config);

	return true;
}

bool Controller::SaveConfig()
{
	if (configFilePath == "") return false;
	ofstream f(configFilePath, ios::out);
	if (!f.is_open()) return false;

	qDebug() << "ctrl: save config";

	f << config.rows << endl;
	f << config.columns << endl;
	f << config.align << endl;

	for (int i = 0; i < 2; i++) {
		ConfigPlayer *p = &config.player[i];
		f << p->name << endl;
		f << p->force << endl;
		f << p->type << endl;
	}

	f.close();
	return true;
}

bool Controller::LoadScore()
{
	if (scoreFilePath == "") return false;
	ifstream f(scoreFilePath, ios::in);
	if (!f.is_open()) return false;

	qDebug() << "ctrl: load scores";

	for (int i = 0; i < 2; i++) {
		f >> score[i];
		ui->SetScore(i, score[i]);
	}

	f.close();
	return true;
}

bool Controller::SaveScore()
{
	if (scoreFilePath == "") return false;
	ofstream f(scoreFilePath, ios::out);
	if (!f.is_open()) return false;

	qDebug() << "ctrl: save scores";

	for (int i = 0; i < 2; i++) f << score[i] << endl;
	f.close();
	return true;
}

bool Controller::LoadGame()
{
	if (gameFilePath == "") return false;
	ifstream f(gameFilePath, ios::in);
	if (!f.is_open()) return false;

	int nb, index;
	f >> nb;
	if (!nb) return false;

	qDebug() << "ctrl: load game, " << nb << " plays";

	while (nb--) {
		f >> index;
		ui->PlayAtIndex(player, index); // TODO
		PlayAtIndex(index);
	}

	f.close();
	return true;
}

bool Controller::SaveGame()
{
	if (gameFilePath == "") return false;
	ofstream f(gameFilePath, ios::out);
	if (!f.is_open()) return false;

	// don't save finished game
	if (ended) played.clear();

	qDebug() << "ctrl: save game";

	f << played.size() << endl;
	for (auto idx : played) f << idx << endl;

	f.close();
	return true;
}
