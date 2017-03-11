/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of uAlign4.
 *
 * uAlign4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * uAlign4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */


/* main function for Connect4 */

#include "../include/FactoryInterface.h"

#include "Controller.h"
#include "../../UI/src/UI.h"
#include "../../Game/src/Game.h"

class Factory : public FactoryInterface {
	private:
	int argc;
	char** argv;
	public:
	Factory(int &argc, char *argv[]) {
		this->argc = argc;
		this->argv = argv;
	}
	ControllerInterface *NewController() {
		return new ControllerConcurrent(this);
	}
	UIInterface *NewUI() {
		return new UI(argc, argv);
	}
	GameInterface *NewGame(const ControllerInterface::Config &config) {
		return new Game(config);
	}
};

int main(int argc, char *argv[])
{
	Factory factory(argc, argv);
	ControllerInterface *ctrl = factory.NewController();
	ctrl->Start();
	ctrl->Loop();
	return 0;
}
