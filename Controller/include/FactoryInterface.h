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
