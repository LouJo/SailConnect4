
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

Game::BoardDescription::BoardDescription(int rows, int columns, int aligned)
{
	this->rows = rows;
	this->columns = columns;
	this->aligned = aligned;

	nbCase = rows * columns;

	int c = max(0, columns - aligned + 1);
	int r = max(0, rows - aligned + 1);

	nbAlignement = c * rows + r * columns + c * r * 2;

	nbCaseAlignement = nbAlignement * aligned;

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
				for (i = 0; i < aligned; i++) {
					idx = caseIndex + i;
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// vertical
			if (y < r) {
				for (i = 0; i < aligned; i++) {
					idx = caseIndex + i * columns;
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// diag down right
			if (x < c && y < r) {
				for (i = 0; i < aligned; i++) {
					idx = caseIndex + i * (columns + 1);
					tabCaseFromAlignement[nCaseAlignement++] = idx;
					alignementFromCase[idx].push_back(nAlignement);
				}
				nAlignement++;
			}
			// diag down left
			if (x >= aligned - 1 && y < r) {
				for (i = 0; i < aligned; i++) {
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

int Game::BoardDescription::CaseFromAlignement(int algtIndex, int i)
{
	assert(i >= 0 && i < nbCaseAlignement);
	return tabCaseFromAlignement[algtIndex * aligned + i];
}
