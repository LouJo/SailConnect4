#ifndef CONTROLLER_H
#define CONTROLLER_H

/* Header for controller implementation */

#include <string>
#include "../../UI/include/UIInterface.h"

class Controller : public ControllerInterface {
	private:
	static std::string configFileName;
	static std::string scoreFileName;
	static Config defaultConfig;

	UIInterface *ui;
	int player;
	int score[2];
	Config config;
	std::string configFilePath, scoreFilePath;

	void Win(int player);
	void NextPlayer();

	bool LoadConfig();
	bool SaveConfig();
	bool LoadScore();
	bool SaveScore();

	public:
	Controller(UIInterface *ui);

	void Start();

	// methods for UI calls

	void ConfigChange(const Config &config);
	void ExitGame();
	void NewGame();
	bool PlayAtCol(int col);
	void ResetScores();
};


#endif
