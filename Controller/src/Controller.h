/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#ifndef CONTROLLER_H
#define CONTROLLER_H

/* Header for controller implementation */

#include <string>
#include <vector>

#include "../include/FactoryInterface.h"

class Controller : public ControllerInterface {
	private:
	static std::string configFileName;
	static std::string scoreFileName;
	static std::string gameFileName;
	static std::string logFileName;
	static Config defaultConfig;

	protected:
	UIInterface *ui;
	GameInterface *game;

	bool isIAPlaying, toConfigChange, toNewGame, paused;

	int player, firstPlayer;
	int nGame;
	int score[2];
	bool ended;
	Config config, configToChange;
	std::string configFilePath, scoreFilePath, gameFilePath, logFilePath;
	std::vector<int> played;

	private:
	void Win(int player, int *aligned);
	void NextPlayer();
	void EnablePlay();
	void PlayAtIndex(int index);
	bool PlayPossibleAtCol(int col, int &idx);
	void PendingActions();

	bool LoadConfig();
	bool SaveConfig();
	bool LoadScore();
	bool SaveScore();
	bool LoadGame();
	bool SaveGame();
	bool LogGame(int winner);

	protected:
	virtual void IAPlay();
	void Init(FactoryInterface *factory);
	void IAFinished(int index, int currentGame);
	void ConfigChangeLocal(const Config &config);

	public:
	Controller(FactoryInterface *factory);
	Controller() {}
	~Controller() {}

	void Start();

	// methods for UI calls

	void ConfigChange(const Config &config);
	void ExitGame();
	void NewGame();
	bool PlayAtCol(int col);
	void ResetScores();
	void Loop();
	void Pause(bool pause);

  std::vector<Podium> GameStats();
};

#include <QtConcurrent>

class ControllerConcurrent : public QObject, public Controller {
	Q_OBJECT

	private:
	static const int minIntervalPlayMs = 700;

	int currentGame, idx;
	QFutureWatcher<int> *watcher;

	int IAFunc();

	private slots:
	void IAReturn();

	protected:
	void IAPlay();

	public:
	ControllerConcurrent(FactoryInterface *factory);
	~ControllerConcurrent() {}
};

#endif
