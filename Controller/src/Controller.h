#ifndef CONTROLLER_H
#define CONTROLLER_H

/* Header for controller implementation */

#include <string>
#include <vector>

#include "../../UI/include/UIInterface.h"
#include "../../Game/include/GameInterface.h"

class Controller : public ControllerInterface {
	private:
	static std::string configFileName;
	static std::string scoreFileName;
	static std::string gameFileName;
	static Config defaultConfig;

	UIInterface *ui;
	GameInterface *game;

	int player, firstPlayer;
	int score[2];
	bool ended;
	Config config;
	std::string configFilePath, scoreFilePath, gameFilePath;
	std::vector<int> played;

	void Win(int player, int *aligned);
	void NextPlayer();
	void PlayAtIndex(int index);
	bool PlayPossibleAtCol(int col, int &idx);

	bool LoadConfig();
	bool SaveConfig();
	bool LoadScore();
	bool SaveScore();
	bool LoadGame();
	bool SaveGame();

	public:
	Controller(UIInterface *ui, GameInterface *game);

	void Start();

	// methods for UI calls

	void ConfigChange(const Config &config);
	void ExitGame();
	void NewGame();
	bool PlayAtCol(int col);
	void ResetScores();
};


#endif
