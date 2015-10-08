#ifndef GAME_H
#define GAME_H

/* Game implementation headers */

#include <stdint.h>
#include <string>
#include <vector>

#include "../include/GameInterface.h"

class Game : public GameInterface {
	private:

	// score factors
	typedef enum {
		SCORE_RANDOM,
		SCORE_ALIGN_PLAYER,
		SCORE_ALIGN_OTHER,
		NB_SCORE_FACTOR
	} ScoreFactor_t;

	struct ScoreFactors {
		static const int maxNbAligned = 4;
		const char* name;
		double factors[NB_SCORE_FACTOR];
		double factorAlignedMore;
		int maxAligned[maxNbAligned];

		void operator= (const ScoreFactors &s);
	};

	static ScoreFactors defaultScoreFactors;
	static ScoreFactors aggressiveFactors, defensiveFactors;
	static ScoreFactors* strategies[];

	class Scoring {
		public:
		ScoreFactors factors;

		Scoring();
		void SetStrategie(int i);
		void Reset();
		void SetScore(const ScoreFactor_t factorId, double s);
		void SetAligned(const ScoreFactor_t factorId, int *nbAligned, int align);
		void SetRandom();
		double operator() ();

		private:
		double score;
	};

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

	class GameState {
		public:
		GameState(BoardDescription*);
		~GameState();
		void Reset();

		bool PlayAtIndex(int idx, int player);
		bool PlayPossibleAtColumn(int col, int &idx);
		bool IsEnded(int &winner, int* &caseAligned);
		bool Back();

		double Score(int player);
		void DebugNbAligned();
		int BestPlay(int player);

		// iterate playable
		struct PlayableRangeIterator {
			int col, idx;

			PlayableRangeIterator(GameState *game, int col);
			void operator++ ();
			int& operator* ();
			bool operator!= (const PlayableRangeIterator &it);
			private:
			GameState *game;
		};

		struct PlayableRange {
			PlayableRange(GameState *game);
			PlayableRangeIterator begin();
			PlayableRangeIterator end();
			private:
			GameState *game;
		};

		PlayableRange Playable();

		private:
		Scoring *scoring;
		int8_t *board;
		int *columnNbPlayed;
		PlayerState **playerState;
		BoardDescription *boardDesc;
		std::vector<GameDiff> gameDiff;
		PlayableRange *playable;

		void ApplyDiff(const GameDiff &diff);
		inline int OtherPlayer(int p) { return 1 - p; }
	};

	static const int defaultIAForce = 2;

	BoardDescription *boardDesc;
	GameState *gameState;
	int currentPlayer, nbPlayed, iaForce;

	public:
	Game();
	Game(int rows, int columns, int align);
	~Game();

	// API funcs
	void NewGame();
	void ConfigSet(const ControllerInterface::Config &config);
	int IAPlay();
	bool IsEnded(int &winner, int* &caseAligned);
	bool PlayAtIndex(int index);
	bool PlayPossibleAtCol(int col, int &index);
	void SetIAForce(int force);
	void SetPlayer(int player);
};


#endif
