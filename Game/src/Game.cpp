
/* Game implementation
*/

#include <iostream>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "Game.h"

#ifndef min
#define min(a,b) (a<b?a:b)
#endif

#ifndef max
#define max(a,b) (a>b?a:b)
#endif

#define NB_ELT(a) (sizeof(a)/sizeof(*a))

using namespace std;


/* Scoring config */

Game::ScoreFactors Game::defaultScoreFactors = {
	"default",
	{ 0.01, 0.49, 0.5 },  // Score factors
	0.75,             // alignedMore
	{ 70, 30, 10, 5 } // maxAligned
};

Game::ScoreFactors Game::aggressiveFactors = {
	"aggressive",
	{ 0.01, 0.69, 0.3 },  // Score factors
	0.75,             // alignedMore
	{ 10, 10, 10, 5 } // maxAligned
};


Game::ScoreFactors Game::defensiveFactors = {
	"defensive",
	{ 0.01, 0.29, 0.7 },  // Score factors
	0.75,             // alignedMore
	{ 70, 30, 10, 5 } // maxAligned
};

Game::ScoreFactors *Game::strategies[] = {
	&defaultScoreFactors,
	&aggressiveFactors,
	&defensiveFactors,
};

/* IA force configuration */

Game::IAForceConfig Game::iaForceConfig[] = {
	{ 1, 1000 },
	{ 2, 1000 },
	{ 3, 1000 },
	{ 6, 10000 },
	{ 20, Game::maxNodesTree }
};

/* Scoring */

Game::Scoring::Scoring() : score(0)
{
	factors = defaultScoreFactors;
}

void Game::Scoring::Reset()
{
	score = 0;
}

void Game::ScoreFactors::operator= (const ScoreFactors &s)
{
	name = s.name;
	for (int i = 0; i < NB_SCORE_FACTOR; i++) factors[i] = s.factors[i];
	factorAlignedMore = s.factorAlignedMore;
	for (int i = 0; i < maxNbAligned; i++) maxAligned[i] = s.maxAligned[i];
}

void Game::Scoring::SetStrategie(int i)
{
	assert(i >= 0 && i < 3);
	factors = *strategies[i];
}

void Game::Scoring::SetScore(const ScoreFactor_t factorId, double s)
{
	assert(factorId >= 0 && factorId < NB_SCORE_FACTOR);
	s *= factors.factors[factorId];
	s = min(1, max(0, s));
	score += s;
}

void Game::Scoring::SetAligned(const ScoreFactor_t factorId, int *nbAligned, int align)
{
	/* score more important for aligned more
	 * maxAlignedNb is the max for every nb
	 */
	double s = 0;
	for (int i = 0; i < align; i++) {
		// max nb to take account for this nb
		int max;
		if (i < factors.maxNbAligned) max = factors.maxAligned[i];
		else max = factors.maxAligned[factors.maxNbAligned - 1];

		int nb = min(max, *(nbAligned + i));
		s = s * (1 - factors.factorAlignedMore) + (double) nb / max * factors.factorAlignedMore;
	}
	if (factorId == SCORE_ALIGN_OTHER) s = 1 - s;
	SetScore(factorId, s);
}

void Game::Scoring::SetRandom()
{
	if (factors.factors[SCORE_RANDOM] == 0) return;
	SetScore(SCORE_RANDOM, (double) (rand() % 1000) / (double) 1000);
}

double Game::Scoring::operator() ()
{
	score = min(1, max(0, score));
	return score;
}

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
	return tabCaseFromAlignement + algtIndex * align;
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

bool Game::PlayerState::PlayAlignement(int algnt)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);

	int *a = alignementState + algnt;
	if (*a == -1) return false;

	assert(*a >= 0 && *a < boardDesc->align);
	assert(nbAlignementDone[*a] > 0);

	nbAlignementDone[*a]--;
	(*a)++;
	nbAlignementDone[*a]++;
   if (*a == boardDesc->align) {
		//cerr << "game: completed algt " << algnt << endl;
		alignementCompleted = algnt;
	}
	return true;
}

bool Game::PlayerState::LooseAlignement(int algnt, int &previousNb)
{
	assert(algnt >= 0 && algnt < boardDesc->nbAlignement);
	int *a = alignementState + algnt;
	if (*a == -1) return false;

	previousNb = *a;
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

void Game::PlayerState::DebugNbAligned()
{
	for (int i = 0; i < boardDesc->align; i++)
		cerr << *(nbAlignementDone + i) << " ";
	cerr << endl;
}

/* Game diff */

void Game::GameDiff::Clear()
{
	aligntPlayed.clear();
	aligntLoosed.clear();
	casePlayed = -1;
}

/* Game state */

Game::GameState::GameState(BoardDescription *desc)
{
	boardDesc = desc;
	board = new int8_t[boardDesc->nbCase];
	columnNbPlayed = new int[boardDesc->columns];
	playerState = new PlayerState*[boardDesc->nbPlayer];
	for (int i = 0; i < boardDesc->nbPlayer; i++) playerState[i] = new PlayerState(boardDesc);
	scoring = new Scoring[boardDesc->nbPlayer];

	Reset();
}

Game::GameState::~GameState()
{
	delete[] scoring;
	for (int i = 0; i < boardDesc->nbPlayer; i++) delete playerState[i];
	delete[] playerState;
	delete[] columnNbPlayed;
	delete[] board;
}

void Game::GameState::Reset()
{
	fill(board, board + boardDesc->nbCase, -1);
	fill(columnNbPlayed, columnNbPlayed + boardDesc->columns, 0);

	for (int i = 0; i < boardDesc->nbPlayer; i++) {
		playerState[i]->Reset();
	//	scoring[i].SetStrategie(0); // TODO
		scoring[i].SetStrategie(rand() % NB_ELT(strategies));
		cerr << "game: player " << i << " strategie " << scoring[i].factors.name << endl;
	}
	gameDiff.clear();
}

bool Game::GameState::PlayAtIndex(int idx, int player)
{
	assert(idx >= 0 && idx < boardDesc->nbCase);
	assert(player >= 0 && player < boardDesc->nbPlayer);

	GameDiff diff;

	if (board[idx] != -1) return false;

	int otherPlayer = 1 - player;
	int previousNb;

	PlayerState *stateMe = playerState[player];
	PlayerState *stateOther = playerState[otherPlayer];

	for (int &algt : boardDesc->alignementFromCase[idx]) {
		if (stateMe->PlayAlignement(algt)) {
			diff.aligntPlayed.push_back({ player, algt });
		}
		if (stateOther->LooseAlignement(algt, previousNb)) {
			diff.aligntLoosed.push_back({ otherPlayer, algt, previousNb });
		}
	}
	board[idx] = player;
	columnNbPlayed[idx % boardDesc->columns]++;
	diff.casePlayed = idx;

	gameDiff.push_back(diff);

	return true;
}

void Game::GameState::DebugNbAligned()
{
	for (int i = 0; i < boardDesc->nbPlayer; i++) {
		cerr << "game: player " << i << " aligned ";
		playerState[i]->DebugNbAligned();
	}
}

bool Game::GameState::PlayPossibleAtColumn(int col, int &idx)
{
	assert(col >= 0 && col < boardDesc->columns);
	if (columnNbPlayed[col] == boardDesc->rows) return false;
	idx = col + (boardDesc->rows - columnNbPlayed[col] - 1) * boardDesc->columns;
	return true;
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

bool Game::GameState::IsEnded()
{
	int winner, *aligned;
	return IsEnded(winner, aligned);
}

bool Game::GameState::Back()
{
	if (gameDiff.size() == 0) return false;
	GameDiff diff = gameDiff.back();
	ApplyDiff(diff);
	gameDiff.pop_back();
	return true;
}

void Game::GameState::ApplyDiff(const GameDiff &diff)
{
	board[diff.casePlayed] = -1;
	columnNbPlayed[diff.casePlayed % boardDesc->columns]--;

	for (auto &loosed : diff.aligntLoosed) playerState[loosed.player]->RevertLooseAlignement(loosed.algnt, loosed.previousNb);
	for (auto &played : diff.aligntPlayed) playerState[played.player]->RevertPlayAlignement(played.algnt);
}

int Game::GameState::BestPlay(int player)
{
	// find the best play
	int bestIdx = -1;
	double bestScore = 0, s;

	for (int idx = PlayableBegin(); idx != PlayableEnd(); idx = PlayableNext()) {
		PlayAtIndex(idx, player);
		s = Score(player);
		if (s > bestScore) bestScore = s, bestIdx = idx;
//		cerr << "IA: col " << col << " score " << s << endl;
		Back();
	}
	return bestIdx;
}

int Game::GameState::NextPlayer(int player)
{
	return (player + 1) % boardDesc->nbPlayer;
}

// playable iterotor

int Game::GameState::PlayableBegin()
{
	int idx = -1;
	if (IsEnded()) return idx;
	playableCol = 0;
	while (playableCol < boardDesc->columns && !PlayPossibleAtColumn(playableCol, idx)) playableCol++;
	return idx;
}

int Game::GameState::PlayableNext()
{
	int idx = -1;
	playableCol++;
	while (playableCol < boardDesc->columns && !PlayPossibleAtColumn(playableCol, idx)) playableCol++;
	return idx;
}

int Game::GameState::PlayableEnd()
{
	return -1;
}

// score of the game

double Game::GameState::Score(int player)
{
	int other = OtherPlayer(player);

	if (playerState[player]->HasWon()) return 1;
	if (playerState[other]->HasWon()) return 0;

	Scoring *sc = &scoring[player];

	sc->Reset();
	sc->SetAligned(SCORE_ALIGN_PLAYER, playerState[player]->nbAlignementDone, boardDesc->align);
	sc->SetAligned(SCORE_ALIGN_OTHER, playerState[other]->nbAlignementDone, boardDesc->align);
	sc->SetRandom();

	return (*sc)();
}

/* main game class with public api
 * wait ConfigSet to construct objects
*/

Game::Game(const ControllerInterface::Config &config)
{
	srand (time(NULL));

	boardDesc = new BoardDescription(config.rows, config.columns, config.align);
	gameState = new GameState(boardDesc);
	minimax = new Minimax(gameState, maxNodesTree);
	iaForce = new int[boardDesc->nbPlayer];
	nbPlayed = 0;

	for (int i = 0; i < boardDesc->nbPlayer; i++) SetIAForce(config.player[i].force, i);
}

Game::~Game()
{
	delete[] iaForce;
	delete minimax;
	delete gameState;
	delete boardDesc;
}

void Game::ConfigSet(const ControllerInterface::Config &config)
{
	// reset everything to continue with new config

	delete[] iaForce;
	if (minimax) delete minimax;
	delete gameState;
	delete boardDesc;

	boardDesc = new BoardDescription(config.rows, config.columns, config.align);
	gameState = new GameState(boardDesc);
	minimax = new Minimax(gameState, maxNodesTree);
	iaForce = new int[boardDesc->nbPlayer];

	for (int i = 0; i < boardDesc->nbPlayer; i++) SetIAForce(config.player[i].force, i);
}

void Game::NewGame()
{
	gameState->Reset();
	nbPlayed = 0;
}

int Game::IAPlay()
{
	if (minimax) return (*minimax)(currentPlayer, iaForceConfig[iaForce[currentPlayer]].maxDepth, iaForceConfig[iaForce[currentPlayer]].maxNodes);

	else return gameState->BestPlay(currentPlayer);
}

bool Game::IsEnded(int &winner, int* &caseAligned)
{
	if (gameState->IsEnded(winner, caseAligned)) return true;
	else if (nbPlayed == boardDesc->nbCase) {
		// no winner
		winner = -1;
		return true;
	}
	else return false;
}

bool Game::PlayAtIndex(int index)
{
	if (gameState->PlayAtIndex(index, currentPlayer)) {
		currentPlayer = 1 - currentPlayer;
		nbPlayed++;

		//gameState->DebugNbAligned();

		cerr << "game: score ";
		for (int i = 0; i < boardDesc->nbPlayer; i++)
			cerr << "player " << i << ": " << gameState->Score(i) << " ";
		cerr << endl;

		return true;
	}
	else {
		return false;
	}
}

bool Game::PlayPossibleAtCol(int col, int &index)
{
	// find the lowest fee case in col
	return gameState->PlayPossibleAtColumn(col, index);
}

void Game::SetIAForce(int force, int player)
{
	assert(player >= 0 && player < boardDesc->nbPlayer);
	iaForce[player] = min((unsigned int ) force, NB_ELT(iaForceConfig));
	cerr << "game: set IA force " << iaForce[player] << " for player " << player << endl;
}

void Game::SetPlayer(int player)
{
	currentPlayer = player;
}
