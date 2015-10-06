
/* Game implementation
*/

#include <iostream>
#include <assert.h>

#include "Game.h"

#ifndef min
#define min(a,b) (a<b?a:b)
#endif

#ifndef max
#define max(a,b) (a>b?a:b)
#endif

using namespace std;


/* Game state */

Game::BoardDescription::BoardDescription(int rows, int columns, int align)
{
	this->rows = rows;
	this->columns = columns;
	this->align = align;

	nbCase = rows * columns;

	int c = max(0, columns - align + 1);
	int r = max(0, rows - align + 1);

	nbAlignement = c * rows + r * columns + c * r * 2;

	nbCaseAlignement = nbAlignement * align;

	cerr << "game: nbAlignement = " << nbAlignement << endl;

	tabCaseFromAlignement = new int[nbCaseAlignement];
	alignementFromCase = new vector<int>[nbCase];

	int nCaseAlignement = 0;
	int nAlignement = 0;
	int caseIndex, idx, i;

	// tab construction
	for (int y = 0; y < rows; y++) {
		for (int x = 0; x < columns; x++) {
			caseIndex = x + y * columns;
			// horizontal
			if (x < c) {
				for (i = 0; i < align; i++) {
					idx = caseIndex + i;
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// vertical
			if (y < r) {
				for (i = 0; i < align; i++) {
					idx = caseIndex + i * columns;
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// diag down right
			if (x < c && y < r) {
				for (i = 0; i < align; i++) {
					idx = caseIndex + i * (columns + 1);
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// diag down left
			if (x >= align - 1 && y < r) {
				for (i = 0; i < align; i++) {
					idx = caseIndex + i * (columns - 1);
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
		}
	}
	assert(nAlignement == nbAlignement);
	assert(nCaseAlignement == nbCaseAlignement);
}

Game::BoardDescription::~BoardDescription()
{
	delete[] alignementFromCase;
	delete[] tabCaseFromAlignement;
}

int Game::BoardDescription::CaseFromAlignement(int algtIndex, int i)
{
	assert(algtIndex >= 0 && algtIndex < nbAlignement);
	const int p = algtIndex * align + i;
	assert(p >= 0 && p < nbCaseAlignement);
	return tabCaseFromAlignement[p];
}

int* Game::BoardDescription::CaseArrayFromAlignement(int algtIndex)
{
	assert(algtIndex >= 0 && algtIndex < nbAlignement);
	return tabCaseFromAlignement + algtIndex;
}


/* Player state */

Game::PlayerState::PlayerState(BoardDescription *desc)
{
	this->boardDesc = desc;
	alignementState = new int[boardDesc->nbAlignement];
	nbAlignementDone = new int[boardDesc->align + 1];
	Reset();
}

Game::PlayerState::~PlayerState()
{
	delete[] alignementState;
	delete[] nbAlignementDone;
}

void Game::PlayerState::Reset()
{
	fill(alignementState, alignementState + boardDesc->nbAlignement, 0);
	nbAlignementDone[0] = boardDesc->nbAlignement;
	fill(nbAlignementDone + 1, nbAlignementDone + boardDesc->align + 1, 0);
}

// play in alignement

void Game::PlayerState::PlayAlignement(int algnt)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);

	int *a = alignementState + algnt;
	if (*a == -1) return;

	assert(*a >= 0 && *a < boardDesc->align);
	assert(nbAlignementDone[*a] > 0);

	nbAlignementDone[*a]--;
	(*a)++;
	if (nbAlignementDone[*a]++ == boardDesc->align) alignementCompleted = algnt;
}

bool Game::PlayerState::LooseAlignement(int algnt)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);
	int *a = alignementState + algnt;
	if (*a == -1) return false;
	nbAlignementDone[*a]--;
	*a = -1; // disable alignement with -1
	return true;
}

// Revert play

void Game::PlayerState::RevertPlayAlignement(int algnt)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);

	int *a = alignementState + algnt;

	assert(*a > 0 && *a <= boardDesc->align);
	assert(nbAlignementDone[*a] > 0);

	nbAlignementDone[*a]--;
	(*a)--;
	nbAlignementDone[*a]++;
}

void Game::PlayerState::RevertLooseAlignement(int algnt, int previousNb)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);
	int *a = alignementState + algnt;
	*a = previousNb;
	nbAlignementDone[*a]++;
}

// get alignement status

int Game::PlayerState::NbAlignementDone(int nbDone)
{
	assert(nbDone >= 0 && nbDone <= boardDesc->align);
	return nbAlignementDone[nbDone];
}

int Game::PlayerState::AlignementState(int algnt)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);
	return alignementState[algnt];
}

bool Game::PlayerState::HasWon()
{
	// won if at least one alignement completed
	return NbAlignementDone(boardDesc->align);
}

int* Game::PlayerState::CaseArrayAligned()
{
	return boardDesc->CaseArrayFromAlignement(alignementCompleted);
}


/* Game state */

Game::GameState::GameState(BoardDescription *desc)
{
	boardDesc = desc;
	board = new int8_t[boardDesc->nbCase];
	playerState = new PlayerState*[boardDesc->nbPlayer];
	for (int i = 0; i < boardDesc->nbPlayer; i++) playerState[i] = new PlayerState(boardDesc);

	Reset();
}

Game::GameState::~GameState()
{
	for (int i = 0; i < boardDesc->nbPlayer; i++) delete playerState[i];
	delete[] playerState;
	delete[] board;
}

void Game::GameState::Reset()
{
	fill(board, board + boardDesc->nbCase, -1);
	for (int i = 0; i < boardDesc->nbPlayer; i++) playerState[i]->Reset();
}

bool Game::GameState::PlayAtIndex(int idx, int player)
{
	assert(idx >= 0 && idx < boardDesc->nbCase);
	assert(player >= 0 && player < boardDesc->nbPlayer);

	if (board[idx] != -1) return false;

	PlayerState *stateMe = playerState[player];
	PlayerState *stateOther = playerState[1-player];

	for (int &algt : boardDesc->alignementFromCase[idx]) {
		stateMe->PlayAlignement(algt);	
		stateOther->LooseAlignement(algt);
	}
	board[idx] = player;
	return true;
}

bool Game::GameState::PlayPossibleAtIndex(int idx)
{
	assert(idx >= 0 && idx < boardDesc->nbCase);
	return board[idx] == -1;
}

bool Game::GameState::IsEnded(int &winner, int* &caseAligned)
{
	for (int i = 0; i < boardDesc->nbPlayer; i++)
	if (playerState[i]->HasWon()) {
		winner = i;
		caseAligned = playerState[i]->CaseArrayAligned();
		return true;
	}
	return false;
}


/* main game class with public api
 * wait ConfigSet to construct objects
*/

Game::Game()
{
	// minimal before receiving config
	boardDesc = new BoardDescription(0,0,1);
	gameState = new GameState(boardDesc);
	nbPlayed = 0;
}

Game::Game(int rows, int columns, int align)
{
	// minimal before receiving config
	boardDesc = new BoardDescription(rows, columns, align);
	gameState = new GameState(boardDesc);
	nbPlayed = 0;
	iaForce = defaultIAForce;
}

Game::~Game()
{
	delete gameState;
	delete boardDesc;
}

void Game::ConfigSet(const ControllerInterface::Config &config)
{
	delete gameState;
	delete boardDesc;

	boardDesc = new BoardDescription(config.rows, config.columns, config.align);
	gameState = new GameState(boardDesc);
}

void Game::NewGame()
{
	gameState->Reset();
	nbPlayed = 0;
}

int Game::IAPlay()
{
	return 0;
}

bool Game::IsEnded(int &winner, int* &caseAligned)
{
	if (nbPlayed == boardDesc->nbCase) {
		// no winner
		winner = -1;
		return true;
	}
	return gameState->IsEnded(winner, caseAligned);
}

bool Game::PlayAtIndex(int index)
{
	if (gameState->PlayAtIndex(index, currentPlayer)) {
		currentPlayer = 1 - currentPlayer;
		nbPlayed++;
		return true;
	}
	else {
		return false;
	}
}

bool Game::PlayPossibleAtCol(int col, int &index)
{
	// find the lowest fee case in col
	int y = boardDesc->rows - 1;

	while (y >= 0) {
		index = y * boardDesc->columns + col;
		if (gameState->PlayPossibleAtIndex(index)) return true;
		y--;
	}

	return false;
}

void Game::SetIAForce(int force)
{
	iaForce = force;
}

void Game::SetPlayer(int player)
{
	currentPlayer = player;
}
