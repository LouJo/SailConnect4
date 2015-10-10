
/* Interface for UI
   Implemented with qml
*/

#include "UI.h"

ControllerNull ControllerInterface::controllerNull;

UI::UI(int &argc, char* argv[])
{
	app = new QGuiApplication(argc, argv);

	translator = new QTranslator();
	if (translator->load(":/langs/Connect4_" + QLocale::system().name())) {
		qDebug() << "ui: load translation";
		app->installTranslator(translator);
	}

	view = new QQuickView();
	view->setResizeMode(view->SizeRootObjectToView);
	view->setSource(QUrl("qrc:///qml/Main.qml"));


	qDebug() << "ui: init UI";
	main = view->rootObject();
	game = main->findChild<QObject*>("game");
	menu = main->findChild<QObject*>("menu");
	board = game->findChild<QObject*>("board");

	config = qvariant_cast<QObject*> (main->property("config"));

	QObject::connect(view, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(SlotExit()));
	QObject::connect(menu, SIGNAL(exit()), this, SLOT(SlotExit()));
	QObject::connect(menu, SIGNAL(newGame()), this, SLOT(SlotNewGame()));
	QObject::connect(menu, SIGNAL(resetScores()), this, SLOT(SlotResetScore()));
	QObject::connect(menu, SIGNAL(configChanged()), this, SLOT(SlotConfigChanged()));
	QObject::connect(game, SIGNAL(playCol(const QVariant&)), this, SLOT(SlotPlayCol(const QVariant&)));
}

/* Methods callable by game controller */

void UI::Launch()
{
	view->show();
	view->setTitle(config->property("programTitle").toString());
}

void UI::EnablePlay(bool en)
{
	game->setProperty("canPlay", QVariant(en));
}

void UI::ChangePlayer(int player)
{
	game->setProperty("player", QVariant(player + 1));
}

bool UI::PlayAtIndex(int player, int idx)
{
	QVariant ret;
	QVariant qplayer = player + 1;
	QVariant qindex = idx;

	QMetaObject::invokeMethod(board, "play", Q_RETURN_ARG(QVariant, ret), Q_ARG(QVariant, qindex), Q_ARG(QVariant, qplayer));

	return ret.toBool();
}

void UI::ConfigSet(const ControllerInterface::Config &conf)
{
	config->setProperty("player1_name", conf.player[0].name.c_str());
	config->setProperty("player2_name", conf.player[1].name.c_str());
	config->setProperty("player1_force", conf.player[0].force);
	config->setProperty("player2_force", conf.player[1].force);
	config->setProperty("player1_type", conf.player[0].type);
	config->setProperty("player2_type", conf.player[1].type);
	config->setProperty("rows", conf.rows);
	config->setProperty("columns", conf.columns);
	config->setProperty("align", conf.align);
}

void UI::SetScore(int player, int score)
{
	if (player == 0) config->setProperty("player1_points", score);
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

void UI::ShowAligned(int* aligned)
{
	QVariant ret;
	QVariant i1 = *aligned;
	QVariant i2 = *(aligned + config->property("align").toInt() - 1);
	QMetaObject::invokeMethod(board, "alignedShow", Q_ARG(QVariant, i1), Q_ARG(QVariant, i2));
}

void UI::HideAligned()
{
	QMetaObject::invokeMethod(board, "alignedHide");
}

/* signals receptors from qml */

void UI::SlotConfigChanged()
{
	qDebug() << "ui: config changed";
	ControllerInterface::Config conf;

	conf.player[0].name = config->property("player1_name").toString().toStdString().c_str();
	conf.player[1].name = config->property("player2_name").toString().toStdString().c_str();
	conf.player[0].force = config->property("player1_force").toInt();
	conf.player[1].force = config->property("player2_force").toInt();
	conf.player[0].type = (ControllerInterface::PlayerType_t) config->property("player1_type").toInt();
	conf.player[1].type = (ControllerInterface::PlayerType_t) config->property("player2_type").toInt();

	conf.rows = config->property("rows").toInt();
	conf.columns = config->property("columns").toInt();
	conf.align = config->property("align").toInt();

	controller->ConfigChange(conf);
}

void UI::SlotNewGame()
{
	qDebug() << "ui: new game";
	controller->NewGame();
}

void UI::SlotPlayCol(const QVariant &qcol)
{
	const int col = qcol.toInt();
	qDebug() << "ui: play col " << col;
	controller->PlayAtCol(col);
}

void UI::SlotResetScore()
{
	qDebug() << "ui: reset scores";
	controller->ResetScores();
}

void UI::SlotExit()
{
	qDebug() << "ui: exit from UI";
	controller->ExitGame();
}

//
