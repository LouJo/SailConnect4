/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#ifndef GAME_H
#define GAME_H

/* Game implementation headers */

#include <stdint.h>
#include <string>
#include <vector>

#include "../include/GameInterface.h"
#include "Minimax.h"

class Game : public GameInterface {

	public:

	// Range of data management
	template<typename A> class Range {
		public:
		A min, max;
		Range(const A &min_, const A &max_) :  min(min_), max(max_) {}
		A operator() () const;
	};

	private:

	/* score factors
	 * manage configuration for score computation
	 */

	typedef enum {
		SCORE_RANDOM,
		SCORE_ALIGN_PLAYER,
		SCORE_ALIGN_OTHER,
		NB_SCORE_FACTOR
	} ScoreFactor_t;

	struct ScoreFactors {
		static const int maxNbAligned = 4;
		double factors[NB_SCORE_FACTOR];
		double factorAlignedMore;
		int maxAligned[maxNbAligned];

		void operator= (const ScoreFactors &s);
		void Debug();
	};

	struct ScoreFactorsRange {
		Range<double> factors[NB_SCORE_FACTOR];
		Range<double> factorAlignedMore;
		Range<int> maxAligned[ScoreFactors::maxNbAligned];

		ScoreFactors operator() () const;
	};

	static ScoreFactorsRange scoreFactorRangesForce[];

	class Scoring {
		public:
		ScoreFactors factors;
		ScoreFactorsRange *range;

		Scoring();
		void SetStrategie();
		void Reset();
		void SetScore(const ScoreFactor_t factorId, double s);
		void SetAligned(const ScoreFactor_t factorId, int *nbAligned, int align);
		void SetRandom();
		double operator() ();
		/// identify the scoring factors in a string 
		std::string Identifier();

		private:
		double score;
	};

	/* IA forces configuration
	 * Structures to configure IA forces
	 */

	struct IAForceConfig {
		int maxDepth, maxNodes;
	};

	static IAForceConfig iaForceConfig[];

	/* object to describe a board, given cols, rows and align
	 * once constructed, does not change.
	 */

	class BoardDescription {
		public:
		static const int nbPlayer = 2;
		int columns, rows, align;
		int nbCase, nbAlignement, nbCaseAlignement;
		std::vector<int> *alignementFromCase;

		BoardDescription(int rows, int columns, int align);
		~BoardDescription();

		// return the case id for alignement algntIndex, case number i
		inline int CaseFromAlignement(int algtIndex, int i);
		// return the adress of cases array for one alignement
		inline int* CaseArrayFromAlignement(int algtIndex);

		private:
		int *tabCaseFromAlignement;
	};

	class PlayerState {
		public:
		// number of align done 0, 1, 2, 3, 4
		int *nbAlignementDone;
		//
		PlayerState(BoardDescription*);
		~PlayerState();
		void Reset();
		// play in an alignement
		bool PlayAlignement(int algnt);
		bool LooseAlignement(int algnt, int &previousNb);
		// revert play in alignement
		void RevertPlayAlignement(int algnt);
		void RevertLooseAlignement(int algnt, int previousNb);
		// status read
		inline int NbAlignementDone(int nbDone);
		inline int AlignementState(int algnt);
		bool HasWon();
		int* CaseArrayAligned();

		void DebugNbAligned();

		private:
		BoardDescription *boardDesc;
		// -1 if align is not possible, nb of cases done if possible
		int *alignementState;
		int alignementCompleted;
	};

	struct GameDiff {
		struct PlayAlignt_t { int player, algnt; };
		struct LooseAlignt_t { int player, algnt, previousNb; };

		std::vector<PlayAlignt_t> aligntPlayed;
		std::vector<LooseAlignt_t> aligntLoosed;
		int casePlayed;

		void Clear();
	};

	class GameState : public MinimaxGameInterface {
		public:
		GameState(BoardDescription*);
		~GameState();
		void Reset();

		// minimax client
		bool PlayAtIndex(int idx, int player);
		bool Back();
		int NextPlayer(int player);
		double Score(int player);
		// playable iterator
		int PlayableBegin();
		int PlayableNext();
		int PlayableEnd();

		// Game client
		bool PlayPossibleAtColumn(int col, int &idx);
		bool IsEnded(int &winner, int* &caseAligned);
		bool IsEnded();
		int BestPlay(int player);
		void SetScoringRange(int player, ScoreFactorsRange *range);
		std::string GetIdentifier(int player);

		void DebugNbAligned();

		private:
		Scoring *scoring;
		int8_t *board;
		int playableCol;
		int *columnNbPlayed;
		PlayerState **playerState;
		BoardDescription *boardDesc;
		std::vector<GameDiff> gameDiff;

		void ApplyDiff(const GameDiff &diff);
		inline int OtherPlayer(int p) { return 1 - p; }
	};

	static const int defaultIAForce = 2;
	static const int maxNodesTree = 50000;

	BoardDescription *boardDesc;
	GameState *gameState;
	int currentPlayer, nbPlayed, *iaForce;
	Minimax *minimax;

	public:
	Game(const ControllerInterface::Config &config);
	~Game();

	// API funcs
	void NewGame();
	void ConfigSet(const ControllerInterface::Config &config);
	int IAPlay();
	bool IsEnded(int &winner, int* &caseAligned);
	bool PlayAtIndex(int index);
	bool PlayPossibleAtCol(int col, int &index);
	void SetIAForce(int force, int player);
	void SetPlayer(int player);
	std::string GetIAIdentifier(int player);
};


#endif
