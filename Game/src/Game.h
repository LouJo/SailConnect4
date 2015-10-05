#ifndef GAME_H
#define GAME_H

/* Game implementation headers */

#include <stdint.h>
#include <vector>

#include "../include/GameInterface.h"

class Game : public GameInterface {
	private:

	/* object to describe a board, given cols, rows and aligned
	 * once constructed, does not change.
	 */

	class BoardDescription {
		public:
		int columns, rows, aligned;
		int nbCase, nbAlignement, nbCaseAlignement;
		std::vector<int> *alignementFromCase;

		BoardDescription(int rows, int columns, int aligned);

		// return the case id for alignement algntIndex, case number i
		inline int CaseFromAlignement(int algtIndex, int i);

		private:
		int *tabCaseFromAlignement;
	};

	class Case {
		public:
		uint16_t index;
		uint8_t played;
		Case() : index(0), played(0) {}
	};

	BoardDescription *boardDesc;

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
