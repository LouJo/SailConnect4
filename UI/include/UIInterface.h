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
