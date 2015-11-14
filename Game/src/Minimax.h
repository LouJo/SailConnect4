/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

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
		Node *firstChild, *nextSibling;
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
