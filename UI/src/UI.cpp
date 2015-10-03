
/* Interface for UI
   Implemented with qml
*/

#include "UI.h"

UI::UI(int argc, char* argv[])
{
	app = new QGuiApplication(argc, argv);
	engine = new QQmlApplicationEngine();
	view = new QQuickView(QUrl("qrc:///Main.qml"));
	view->setResizeMode(view->SizeRootObjectToView);

	qDebug() << "Qt: init UI";
	main = view->rootObject();
	game = main->findChild<QObject*>("game");
	menu = main->findChild<QObject*>("menu");

	qDebug() << "Qt: init UI done";
}

void UI::Launch()
{
	view->show();
}

void UI::EnablePlay(bool en)
{
	game->setProperty("canPlay", QVariant(en));
}

void UI::ChangePlayer(int player)
{
	game->setProperty("player", QVariant(player));
}

void UI::PlayAtIndex(int player, int idx)
{
}

void UI::SetScore(int player, int score)
{
}

void UI::Exit()
{
	app->quit();
}

void UI::Loop()
{
	app->exec();
}

void UI::SlotReady()
{
	qDebug() << "qt: ready ";
}

int main(int argc, char *argv[])
{
	UI *ui = new UI(argc, argv);
	ui->Launch();
	ui->EnablePlay(true);
	ui->Loop();

	qDebug() << "qt: quit";
}
