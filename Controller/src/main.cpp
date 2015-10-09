
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
