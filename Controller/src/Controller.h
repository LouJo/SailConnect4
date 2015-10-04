#ifndef CONTROLLER_H
#define CONTROLLER_H

/* Header for controller implementation */

#include "../../UI/include/UIInterface.h"

class Controller : public ControllerInterface {
	private:
	UIInterface *ui;
	int player;
	int score[2];
	Config config;

	void Win(int player);
	void NextPlayer();

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
