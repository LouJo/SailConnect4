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

#ifndef CONTROLLERINTERFACE_H
#define CONTROLLERINTERFACE_H

/* Generic interface for Controller */

#include <string>

class ControllerNull;

class ControllerInterface {
	public:

	// types definitions for game config

	typedef enum { TypeHuman, TypeIA } PlayerType_t;

	struct ConfigPlayer {
		std::string name;
		int force;
		PlayerType_t type;
		std::string color;
	};

	struct Config {
		ConfigPlayer player[2];
		int rows, columns, align;
		bool board_transparent;
	};

	virtual void Start() = 0;

	// methods for UI calls

	virtual void ConfigChange(const Config &config) = 0;
	virtual void ExitGame() = 0;
	virtual void NewGame() = 0;
	virtual bool PlayAtCol(int col) = 0;
	virtual void ResetScores() = 0;
	virtual void Loop() = 0;
	virtual void Pause(bool pause) = 0;

	// null controller

	static ControllerNull controllerNull;
};

// null implementation of controller

class ControllerNull : public ControllerInterface {
	public:

	virtual void ConfigChange(const Config &config __attribute__((unused))) {}
	virtual void ExitGame() {}
	virtual void NewGame() {}
	virtual bool PlayAtCol(int col __attribute__((unused))) { return false; }
	virtual void ResetScores() {}
	virtual void Start() {}
	virtual void Loop() {}
	virtual void Pause(bool pause __attribute__((unused))) {}
};
#endif
