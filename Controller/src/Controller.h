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
	static Config defaultConfig;

	protected:
	UIInterface *ui;
	GameInterface *game;

	bool isIAPlaying, toConfigChange, toNewGame;

	int player, firstPlayer;
	int nGame;
	int score[2];
	bool ended;
	Config config, configToChange;
	std::string configFilePath, scoreFilePath, gameFilePath;
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
};

#include <QtConcurrent>

class ControllerConcurrent : public QObject, public Controller {
	Q_OBJECT

	private:
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
