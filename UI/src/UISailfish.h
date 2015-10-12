#ifndef UISAILFISH_H
#define UISAILFISH_H

#include "UI.h"

class UISailfish : public UI {
	private:
	QObject *cover;
	public:
	UISailfish(int &argc, char *argv[]);
	void PostInit();
	void Launch();
	bool PlayAtIndex(int player, int idx);
	void ResetBoard();
};

#endif
