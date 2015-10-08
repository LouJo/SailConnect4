
/* Minimax implementation
   Work with a generic game object
*/

#include <stdlib.h>
#include "Minimax.h"

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
	}
	return node->ownScore;
}

void Minimax::NodeFindScore(Node *node, int currentPlayer, int maxDepth)
{
	if (node->depth == maxDepth) {
		node->score = NodeOwnScore(node);
		return;
	}

	NodeFindChilds(node);

	if (node->childs.size() == 0) {
		node->score = NodeOwnScore(node);
		return;
	}

	node->bestChildIndex = -1;
	node->betterDepth = node->depth;

	for (Node *child : node->childs) {
		NodeFindScore(child, game->NextPlayer(currentPlayer), maxDepth);
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
	}
}

// Nodes struct

void Minimax::Node::Reset()
{
	childs.clear();
	bestChildIndex = -1;
	found.val = 0;
}
