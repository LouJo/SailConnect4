#ifndef UISAILFISH_H
#define UISAILFISH_H

#include "UI.h"

class UISailfish : public UI {
	public:
	UISailfish(int &argc, char *argv[]);
	void PostInit();
	void Launch();
};

#endif
