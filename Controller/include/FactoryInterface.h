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

#ifndef FACTORY_H
#define FACTORY_H

#include "ControllerInterface.h"
#include "../../UI/include/UIInterface.h"
#include "../../Game/include/GameInterface.h"

class FactoryInterface {
	public:
	virtual ControllerInterface* NewController() = 0;
	virtual UIInterface* NewUI() = 0;
	virtual GameInterface* NewGame(const ControllerInterface::Config &config) = 0;
};


#endif
