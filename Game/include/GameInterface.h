#ifndef GAMEINTERFACE_H
#define GAMEINTERFACE_H

/* Generic game interface
 *
*/

#include <vector>

class GameInterface {
	public:
	// set rows, columns and aligned on construction

	// reset game
	virtual void NewGame() = 0;
	// return index played by IA for current player
	virtual int IAPlay() = 0;
	// return true if ended, and set winner var
	virtual bool IsEnded(int &winner, std::vector<int> &aligned) = 0;
	// play col if possible, and set index var
	virtual bool PlayAtCol(int col, int &index) = 0;
	// play at index if possible
	virtual bool PlayAtIndex(int index) = 0;
	// set force for IA
	virtual void SetIAForce(int force) = 0;
	// set next player (not needed after played, only for beginning)
	virtual void SetPlayer(int player) = 0;
};


#endif
