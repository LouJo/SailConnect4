
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

	qDebug() << "ui: init UI";
	main = view->rootObject();
	game = main->findChild<QObject*>("game");
	menu = main->findChild<QObject*>("menu");
	board = game->findChild<QObject*>("board");

	config = qvariant_cast<QObject*> (main->property("config"));

	QObject::connect(menu, SIGNAL(exit()), this, SLOT(SlotExit()));
	QObject::connect(menu, SIGNAL(newGame()), this, SLOT(SlotNewGame()));
	QObject::connect(menu, SIGNAL(resetScores()), this, SLOT(SlotResetScore()));
	QObject::connect(menu, SIGNAL(configChanged()), this, SLOT(SlotConfigChanged()));
	QObject::connect(game, SIGNAL(playCol(QVariant)), this, SLOT(SlotPlayCol(QVariant)));
}

/* Methods callable by game controller */

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

void UI::SetConfig(const ControllerInterface::Config &config)
{
}

void UI::SetScore(int player, int score)
{
	if (player == 1) config->setProperty("player1_points", score);
	else config->setProperty("player2_points", score);
}

void UI::ResetBoard()
{
	QMetaObject::invokeMethod(board, "reset");
}

void UI::Exit()
{
	app->quit();
}

void UI::Loop()
{
	app->exec();
}

/* signals receptors from qml */

void UI::SlotConfigChanged()
{
	qDebug() << "ui: config changed";
}

void UI::SlotNewGame()
{
	qDebug() << "ui: new game";
	EnablePlay(false);
	ResetBoard();
	ChangePlayer(2);
	SetScore(1,10);
	EnablePlay(true);
}

void UI::SlotPlayCol(QVariant qcol)
{
	qDebug() << "ui: play col " << qcol;
}

void UI::SlotResetScore()
{
	qDebug() << "ui: reset scores";
}

void UI::SlotExit()
{
	qDebug() << "ui: exit from UI";
	Exit();
}

//

int main(int argc, char *argv[])
{
	UI *ui = new UI(argc, argv);
	ui->Launch();
	ui->EnablePlay(true);
	ui->Loop();

	qDebug() << "ui: quit";
}
