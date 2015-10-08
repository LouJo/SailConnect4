
/* Minimax implementation
   Work with a generic game object
*/

#include <iostream>
#include <stdlib.h>
#include "Minimax.h"

#ifndef min
#define min(a,b) (a<b?a:b)
#endif

using namespace std;

Minimax::Minimax(MinimaxGameInterface *game, int maxNodes)
{
	this->game = game;
	this->maxNodesCurrent = this->maxNodes = maxNodes;
	nodes = new Node[maxNodes];
}

Minimax::~Minimax()
{
	delete[] nodes;
}

void Minimax::Reset()
{
	nbNodes = 0;
}

Minimax::Node* Minimax::NewNode(int depth)
{
	Node* node;
	if (nbNodes >= maxNodesCurrent) return NULL;
	node = &nodes[nbNodes++];
	node->Reset();
	node->depth = node->maxChildDepth = node->betterDepth = depth;
	return node;
}

void Minimax::NodeFindChilds(Node *node)
{
	if (node->found.childs) return;

	int depth = node->depth + 1;
	Node *child;

	node->found.childs = 1;

	for (int idx = game->PlayableBegin(); idx != game->PlayableEnd(); idx = game->PlayableNext()) {
		child = NewNode(depth);
		if (!child) return; // no more memory
		child->caseIndex = idx;
		node->childs.push_back(child);
	}
}

double Minimax::NodeOwnScore(Node *node)
{
	if (!node->found.ownScore) {
		node->ownScore = game->Score(player);
		node->found.ownScore = 1;
		if (node->ownScore == 1 || node->ownScore == 0) node->found.ended = 1;
	}
	return node->ownScore;
}

void Minimax::NodeFindScore(Node *node, int currentPlayer)
{
	if (node->found.ended) return;

	if (node->depth == maxDepth) {
		node->score = NodeOwnScore(node);
		return;
	}

	NodeFindChilds(node);

	// ended, unless a least one child not ended
	node->found.ended = 1;

	if (node->childs.size() == 0) {
		node->score = NodeOwnScore(node);
		return;
	}

	node->bestChildIndex = -1;
	node->betterDepth = node->depth;

	int nextPlayer = game->NextPlayer(currentPlayer);

	for (Node *child : node->childs) {
		game->PlayAtIndex(child->caseIndex, nextPlayer);
		NodeFindScore(child, nextPlayer);
		game->Back();

		if (node->bestChildIndex == -1 || 
			(currentPlayer == player && child->score > node->score) ||
			(currentPlayer != player && child->score < node->score))
		{
			node->bestChildIndex = child->caseIndex;
			node->score = child->score;
			node->betterDepth = child->betterDepth;
		}
		else if (currentPlayer == player && child->score == node->score) {
			if ( (child->score > 0.9 && child->betterDepth < node->betterDepth)
				|| (child->score < 0.1 && child->betterDepth > node->betterDepth)
			) {
				node->bestChildIndex = child->caseIndex;
				node->betterDepth = child->betterDepth;
			}
		}

		if (child->maxChildDepth > node->maxChildDepth) node->maxChildDepth = child->maxChildDepth;

		if (child->score == 1 && currentPlayer == player) {
			node->found.ended = 1;
			break;
		}
		else if (child->score == 0 && currentPlayer != player) {
			node->found.ended = 1;
			break;
		}

		if (!child->found.ended) node->found.ended = 0;
	}
}

int Minimax::operator() (int player, int maxDepth, int maxNodes_)
{
	maxNodesCurrent = min(maxNodes, maxNodes_);
	Reset();
	Node *root = NewNode(0);
	this->maxDepth = maxDepth;

	for (int i = 1; i <= maxDepth; i++) {
		if (root->found.ended) break;
		NodeFindScore(root, player);
	}

	cerr << "minimax: max depth " << root->maxChildDepth << " better depth " << root->betterDepth << " score " << root->score << " play " << root->bestChildIndex << endl;

	return root->bestChildIndex;
}

// Nodes struct

void Minimax::Node::Reset()
{
	childs.clear();
	bestChildIndex = -1;
	found.val = 0;
}
