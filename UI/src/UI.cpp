
/* Interface for UI
   Implemented with qml
*/

#include "UI.h"

UI::UI(int argc, char* argv[])
{
	app = new QGuiApplication(argc, argv);
	view = new QQuickView(QUrl("qrc:///Main.qml"));
	view->setResizeMode(view->SizeRootObjectToView);

	main = game = NULL;
}

void UI::Launch()
{
	view->show();
	app->exec();

	main = view->rootObject();
	game = main->findChild<QObject*>("game");
}

void UI::EnablePlay(bool en)
{
	if (game) game->setProperty("canPlay", QVariant(true));
}

void UI::ChangePlayer(int player)
{
}

void UI::PlayAtIndex(int player, int idx)
{
}

void UI::SetScore(int player, int score)
{
}

void UI::Exit()
{
}

int main(int argc, char *argv[])
{
	UI *ui = new UI(argc, argv);
	ui->Launch();

	ui->EnablePlay(true);
	return 0;
}
