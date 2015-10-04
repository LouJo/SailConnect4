
/* main function for Connect4 */

#include "Controller.h"
#include "../../UI/src/UI.h"


int main(int argc, char *argv[])
{
	UI *ui = new UI(argc, argv);
	Controller *ctrl = new Controller(ui);
	ctrl->Start();
	ui->Loop();
	return 0;
}
