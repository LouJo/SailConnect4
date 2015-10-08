#ifndef MINIMAX_H
#define MINIMAX_H

/* Headers for minimax tree search
*/

#include <stdint.h>
#include <vector>

// Interface for minimax game client

class MinimaxGameInterface {
	public:
	virtual ~MinimaxGameInterface() {}
	virtual bool Back() = 0;
	virtual int NextPlayer(int player) = 0;
	virtual bool PlayAtIndex(int idx, int player) = 0;
	virtual double Score(int player) = 0;
	// playable iterator.
	virtual int PlayableBegin() = 0;
	virtual int PlayableNext() = 0;
	virtual int PlayableEnd() = 0;
};

// Minimax headers

class Minimax {
	public:
	Minimax(MinimaxGameInterface *game, int maxNodes);
	~Minimax();
	int operator() (int player, int maxDepth, int maxNodes); // search

	private:
	struct Node {
		double score, ownScore;
		std::vector<Node*> childs;
		int caseIndex, bestChildIndex, depth, maxChildDepth, betterDepth;

		union {
			struct {
				uint16_t childs : 1;
				uint16_t ownScore: 1;
				uint16_t ended: 1;
			};
			uint16_t val;
		} found;

		void Reset();
	};

	MinimaxGameInterface *game;
	int maxNodes, maxNodesCurrent, nbNodes, maxDepth;
	Node *nodes;
	int player;

	void Reset();
	Node* NewNode(int depth);
	inline void NodeFindChilds(Node *node);
	inline double NodeOwnScore(Node *node);
	void NodeFindScore(Node *node, int currentPlayer);
};

#endif
