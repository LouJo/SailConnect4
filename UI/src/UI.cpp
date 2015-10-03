
/* Interface for UI
   Implemented with qml
*/

#include "UI.h"

UI::UI(int &argc, char* argv[])
{
	app = new QGuiApplication(argc, argv);
	view = new QQuickView();
	view->setResizeMode(view->SizeRootObjectToView);
	view->setSource(QUrl("qrc:///Main.qml"));

	qDebug() << "Qt: init UI";
	main = view->rootObject();
	game = main->findChild<QObject*>("game");
	menu = main->findChild<QObject*>("menu");
	config = main->findChild<QObject*>("config");
	board = game->findChild<QObject*>("board");
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

bool UI::PlayAtIndex(int player, int idx)
{
	QVariant ret;
	QVariant qplayer = player;
	QVariant qindex = idx;

	QMetaObject::invokeMethod(board, "play", Q_RETURN_ARG(QVariant, ret), Q_ARG(QVariant, qindex), Q_ARG(QVariant, player));

	return ret.toBool();
}

void UI::SetScore(int player, int score)
{
	if (player == 1) config->setProperty("player1_points", score);
	else config->setProperty("player2_points", score);
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
