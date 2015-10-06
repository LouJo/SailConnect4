#ifndef GAMEINTERFACE_H
#define GAMEINTERFACE_H

/* Generic game interface
 *
*/

class GameInterface {
	public:
	// set rows, columns and aligned on construction

	// reset game
	virtual void NewGame() = 0;
	// return index played by IA for current player
	virtual int IAPlay() = 0;
	// return true if ended, and set winner var
	virtual bool IsEnded(int &winner, int *caseAligned) = 0;
	// just say if play col is possible, and set index var
	virtual bool PlayPossibleAtCol(int col, int &index) = 0;
	// play at index if possible
	virtual bool PlayAtIndex(int index) = 0;
	// set force for IA
	virtual void SetIAForce(int force) = 0;
	// set next player (not needed after played, only for beginning)
	virtual void SetPlayer(int player) = 0;
};


#endif
