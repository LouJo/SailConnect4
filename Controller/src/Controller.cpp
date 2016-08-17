/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

/* Controller implementation
 * Generic, only QT used for thread
 */

#include <iostream>
#include <fstream>

#include <QDebug>
#include <QStandardPaths>
#include <QTime>

#include "Controller.h"
#include "../../Game/include/GameInterface.h"

using namespace std;

#define name_(x) #x
#define name(x) name_(x)
#define NAME name(TARGET)

string Controller::configFileName = "config.dat";
string Controller::scoreFileName = "score.dat";
string Controller::gameFileName = "game.dat";

ControllerInterface::Config Controller::defaultConfig = {
	{ { "Bob", 2, ControllerInterface::TypeHuman, "#C48C09"},
	  { "Nemo", 1, ControllerInterface::TypeIA, "#AE1A22"} },
	6, 7, 4,
	false, // not transparent
};

Controller::Controller(FactoryInterface *factory)
{
	Init(factory);
}

void Controller::Init(FactoryInterface *factory)
{
	score[0] = score[1] = 0;
	player = firstPlayer = 0;
	ended = paused = false;

	isIAPlaying = toNewGame = toConfigChange = false;

	nGame = 0; // identify the game number

	QString qDataDir = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
	qDebug() << "ctrl: standart config path: " << qDataDir;
	if (qDataDir == "") { configFilePath = scoreFilePath = gameFilePath = ""; }
	else {
		// create config path if needed
		QDir dir(qDataDir);
		dir.mkpath(NAME);

		string path = qDataDir.toStdString() + "/" NAME;
		configFilePath = path + "/" + configFileName;
		scoreFilePath = path + "/" + scoreFileName;
		gameFilePath = path + "/" + gameFileName;
	}

	config = defaultConfig;
	LoadConfig();

	this->ui = factory->NewUI();
	this->game = factory->NewGame(config);

	ui->ConfigSet(config);
	game->SetPlayer(player);
	LoadScore();
}

void Controller::Start()
{
	ui->SetController(this);
	ui->Launch();
	LoadGame();
	EnablePlay();
}

void Controller::ConfigChangeLocal(const Config &config)
{
	if (isIAPlaying) {
		cerr << "ctrl: delay config change after IA play" << endl;
		configToChange = config;
		toConfigChange = true;
		return;
	}
	ui->EnablePlay(false);

	if (this->config.columns != config.columns
		|| this->config.rows != config.rows
		|| this->config.align != config.align
	)
		game->ConfigSet(config);
	else
		for (int i = 0; i < 2; i++) game->SetIAForce(config.player[i].force, i);

	this->config = config;
	SaveConfig();
}

void Controller::ConfigChange(const Config &config)
{
	ConfigChangeLocal(config);
	EnablePlay();
}

void Controller::ExitGame()
{
	SaveGame();
	ui->Exit();
}

void Controller::NewGame()
{
	if (isIAPlaying) {
		cerr << "ctrl: delay new game after IA playing" << endl;
		toNewGame = true;
		return;
	}

	// change first player
	nGame++;
	played.clear();
	firstPlayer = 1 - firstPlayer;
	player = firstPlayer;
	ended = false;

	game->NewGame();
	game->SetPlayer(player);

	ui->EnablePlay(false);
	ui->HideAligned();
	ui->ResetBoard();
	ui->ChangePlayer(player);
	EnablePlay();
}

bool Controller::PlayAtCol(int col)
{
	if (col >= config.columns) return false;

	int idx;
	ui->EnablePlay(false);

	if (game->PlayPossibleAtCol(col, idx)) {
		PlayAtIndex(idx);
		if (!ended) EnablePlay();
		return true;
	}
	else {
		ui->EnablePlay(true);
		return true;
	}
}

void Controller::ResetScores()
{
	score[0] = score[1] = 0;
	ui->SetScore(0,0);
	ui->SetScore(1,0);
	SaveScore();
}

void Controller::Loop()
{
	ui->Loop();
}

void Controller::Pause(bool pause)
{
	cerr << "ctrl: " << (pause ? "pause" : "restart");
	this->paused = pause;
	if (pause) ui->EnablePlay(false);
	else EnablePlay();
}

// private

void Controller::NextPlayer()
{
	player = 1 - player;
	// game does it by itself
	ui->ChangePlayer(player);
}

void Controller::EnablePlay()
{
	if (ended || paused) return;
	if (config.player[player].type == TypeHuman) {
		ui->EnablePlay(true);
	}
	else {
		IAPlay();
	}
}

void Controller::IAPlay()
{
	const int currentGame = nGame;
	if (isIAPlaying) {
		cerr << "ctrl: IA already playing" << endl;
		return;
	}
	isIAPlaying = true;
	int idx = game->IAPlay();
	IAFinished(idx, currentGame);
}

void Controller::IAFinished(int idx, int currentGame)
{
	isIAPlaying = false;
	PendingActions();

	if (paused) {
		cerr << "ctrl: game paused while IA thouthed. Do not play" << endl;
		return;
	}

	// do not apply if player not more IA or new game launched
	if (config.player[player].type == TypeHuman) {
		cerr << "ctrl: current IA canceled" << endl;
		ui->EnablePlay(true);
		return;
	}
	else if (nGame  != currentGame) {
		cerr << "ctrl: current IA canceled" << endl;
		return;
	}

	if (idx == -1) {
		cerr << "ctrl: IA answered nothing !!!" << endl;
		ui->EnablePlay(true);
	}
	else {
		PlayAtIndex(idx);
		if (!ended) EnablePlay(); // next turn
	}
}

void Controller::PendingActions()
{
	if (isIAPlaying) return;

	if (toConfigChange) {
		toConfigChange = false;
		ConfigChangeLocal(configToChange);
	}

	if (toNewGame) {
		toNewGame = false;
		NewGame();
	}
}

void Controller::PlayAtIndex(int index)
{
	int winner, *caseAligned;
	if (paused) {
		qDebug() << "Ctrl error: play not permitted while paused";
		return;
	}

	ui->PlayAtIndex(player, index);
	game->PlayAtIndex(index);
	played.push_back(index);

	if (game->IsEnded(winner, caseAligned)) {
		if (winner != -1) Win(winner, caseAligned);
		else ended = true;

		// loop play when 2 IA
//		if (config.player[0].type == TypeIA && config.player[1].type == TypeIA) NewGame();
	}
	else {
		NextPlayer();
	}
}

bool Controller::PlayPossibleAtCol(int col, int &idx)
{
	// local version of game rule. Should be asked to game.

	int y = config.rows - 1;

	while (y >= 0) {
		idx = col + y * config.columns;
		if (played.end() == find(played.begin(), played.end(), idx)) return true;
		y--;
	}
	return false;
}

void Controller::Win(int player, int *aligned)
{
	qDebug() << "ctrl: player " << player << " win";
	//qDebug() << "ctrl: aligned " << *aligned << " - " << *(aligned + config.align - 1);

	ended = true;
	score[player]++;
	ui->SetScore(player, score[player]);
	ui->ShowAligned(aligned);
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

	string sample;

	for (int i = 0; i < 2; i++) {
		ConfigPlayer *p = &config.player[i];

		// first getline to get end-line before name
		getline(f, sample);
		getline(f, p->name);
		f >> p->force;
		f >> type;
		p->type = (PlayerType_t) type;
	}

	int t;
	f >> t;
	// to avoid false detection on old files, 12 = true
	config.board_transparent = (t == 12);

	for (int i = 0; i < 2; i++) {
		f >> sample;
		if (sample == "")
			break;
		config.player[i].color = sample;
	}
	f.close();

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
	// to avoid false detection on old files, 12 = true
	int t = config.board_transparent ? 12 : 0;
	f << t << endl;

	for (int i = 0; i < 2; i++)
		f << config.player[i].color << endl;

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
	f >> firstPlayer;
	if (firstPlayer < 0 || firstPlayer > 1) firstPlayer = 0;
	player = firstPlayer;
	game->SetPlayer(player);

	f >> nb;
	if (!nb) return false;

	qDebug() << "ctrl: load game, " << nb << " plays";

	while (nb--) {
		f >> index;
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
	f << firstPlayer << endl;

	f << played.size() << endl;
	for (auto idx : played) f << idx << endl;

	f.close();
	return true;
}

/* IA play concurrent
 * in another thread
 */

#include <QtConcurrent>

ControllerConcurrent::ControllerConcurrent(FactoryInterface *factory)
{
	Init(factory);
	watcher = new QFutureWatcher<int>;
	connect(watcher, SIGNAL(finished()), this, SLOT(IAReturn()));
}

int ControllerConcurrent::IAFunc()
{
	QTime finishTime = QTime::currentTime().addMSecs(minIntervalPlayMs);
	idx = game->IAPlay();
	QTime currentTime = QTime::currentTime();
	if (currentTime < finishTime) QThread::msleep(currentTime.msecsTo(finishTime));
	return idx;
}

void ControllerConcurrent::IAPlay()
{
	if (isIAPlaying) {
		cerr << "ctrl: IA already playing" << endl;
		return;
	}
	isIAPlaying = true;
	currentGame = nGame;
	QFuture<int> idx = QtConcurrent::run(this, &ControllerConcurrent::IAFunc);
	watcher->setFuture(idx);
}

void ControllerConcurrent::IAReturn()
{
	cerr << "ctrl: IAReturn " << idx << endl;
	IAFinished(idx, currentGame);
}
