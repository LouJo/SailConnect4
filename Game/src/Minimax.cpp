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
	Node *child, *prevChild = NULL;

	node->found.childs = 1;

	for (int idx = game->PlayableBegin(); idx != game->PlayableEnd(); idx = game->PlayableNext()) {
		child = NewNode(depth);
		if (!child) return; // no more memory
		child->caseIndex = idx;

		if (prevChild) prevChild->nextSibling = child;
		else node->firstChild = child;

		prevChild = child;
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
		/*
		cerr << " final node depth " << node->depth << " current player " << currentPlayer
			<< " own score " << node->ownScore
			<< " ended " << node->found.ended << endl;
		*/
		return;
	}

	//cerr << " node depth " << node->depth << " current player " << currentPlayer << " ended " << node->found.ended << endl;

	NodeFindChilds(node);

	// ended, unless a least one child not ended
	node->found.ended = 1;

	if (!node->firstChild) {
		node->score = NodeOwnScore(node);
		return;
	}

	node->bestChildIndex = -1;
	node->betterDepth = node->depth;

	int nextPlayer = game->NextPlayer(currentPlayer);

	for (Node *child = node->firstChild; child; child = child->nextSibling) {
		game->PlayAtIndex(child->caseIndex, currentPlayer);
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
	int bestIndex = -1;
	maxNodesCurrent = min(maxNodes, maxNodes_);
	Reset();
	Node *root = NewNode(0);
	//this->maxDepth = maxDepth;
	this->player = player;

	for (this->maxDepth = 1; this->maxDepth <= maxDepth; this->maxDepth++) {
		if (root->found.ended) break;
		NodeFindScore(root, player);
		if (nbNodes < maxNodesCurrent) bestIndex = root->bestChildIndex;
	}

	cerr
		<< "minimax: max depth " << root->maxChildDepth
		<< " nb nodes " << nbNodes
		<< " better depth " << root->betterDepth
		<< " score " << root->score
		<< " play " << root->bestChildIndex
		<< endl;

	return bestIndex;
}

// Nodes struct

void Minimax::Node::Reset()
{
	firstChild = nextSibling = NULL;
	bestChildIndex = -1;
	found.val = 0;
}
