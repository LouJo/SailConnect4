
/* main function for Connect4 */

#include "Controller.h"
#include "../../UI/src/UI.h"
#include "../../Game/src/Game.h"


int main(int argc, char *argv[])
{
	Game *game = new Game();
	UI *ui = new UI(argc, argv);

	Controller *ctrl = new ControllerConcurrent(ui, game);
	//Controller *ctrl = new Controller(ui, game);
	ctrl->Start();
	ui->Loop();
	return 0;
}
