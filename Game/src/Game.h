#ifndef GAME_H
#define GAME_H

/* Game implementation headers */

#include <stdint.h>
#include <array>

#include "../include/GameInterface.h"

class Game : public GameInterface {
	private:

	class Case {
		public:
		uint16_t index;
		uint8_t played;
		Case() : index(0), played(0) {}
	};

	int rows, columns, aligned, force, player, nbCase;
	Case *board;

	public:
	Game(int rows, int columns, int aligned);
	~Game();

	// API funcs
	void NewGame();
	int IAPlay();
	bool IsEnded(int &winner, std::vector<int> &aligned);
	bool PlayAtCol(int col, int &index);
	void SetIAForce(int force);
	void SetPlayer(int player);
};


#endif
