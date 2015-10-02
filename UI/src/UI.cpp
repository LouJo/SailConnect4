
/* Interface for UI
   Implemented with qml
*/

#include "UI.h"

UI::UI(int argc, char* argv[])
{
	app = new QGuiApplication(argc, argv);
	view = new view(QUrl("qrc:///Main.qml"));
	view->setResizeMode(view.SizeRootObjectToView);
}

void UI::Launch()
{
	viem->show();
	app->exec();
}

int main(int argc, char *argv[])
{
	UI ui(argc, argv);
	UI.Launch();
	return 0;
}
