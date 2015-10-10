
/* main function for Connect4 */

#include "../include/FactoryInterface.h"

#include "Controller.h"
#include "../../UI/src/UISailfish.h"
#include "../../Game/src/Game.h"

class FactorySailfish : public FactoryInterface {
	private:
	int argc;
	char** argv;
	public:
	FactorySailfish(int &argc, char *argv[]) {
		this->argc = argc;
		this->argv = argv;
	}
	ControllerInterface *NewController() {
		return new ControllerConcurrent(this);
	}
	UIInterface *NewUI() {
		return new UISailfish(argc, argv);
	}
	GameInterface *NewGame(const ControllerInterface::Config &config) {
		return new Game(config);
	}
};

int main(int argc, char *argv[])
{
	FactorySailfish factory(argc, argv);
	ControllerInterface *ctrl = factory.NewController();
	ctrl->Start();
	ctrl->Loop();
	return 0;
}
