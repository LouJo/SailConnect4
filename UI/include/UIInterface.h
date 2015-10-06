#ifndef UIINTERFACE_H
#define UIINTERFACE_H

/* Generic interface for UI */

#include "../../Controller/include/ControllerInterface.h"

// player is [0,1]

class UIInterface {
	protected:
	ControllerInterface *controller;

	public:
	UIInterface() : controller(&ControllerInterface::controllerNull) {}

	virtual void ChangePlayer(int player) = 0;
	virtual void ConfigSet(const ControllerInterface::Config &config) = 0;
	virtual void EnablePlay(bool en) = 0;
	virtual void Exit() = 0;
	virtual void Launch() = 0;
	virtual void Loop() = 0;
	virtual bool PlayAtIndex(int player, int idx) = 0;
	virtual void ResetBoard() = 0;
	virtual void SetScore(int player, int score) = 0;

	virtual void ShowAligned(int* aligned) = 0;
	virtual void HideAligned() = 0;

	void SetController(ControllerInterface *controller) { this->controller = controller; }
};

#endif
