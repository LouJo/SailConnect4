
/* UI derivated for Sailfish */

#include <sailfishapp.h>
#include "UISailfish.h"

UISailfish::UISailfish(int &argc, char* argv[])
{
	qDebug() << "ui: init UISailfish";
	app = SailfishApp::application(argc, argv);

	translator = new QTranslator();
	if (translator->load(":/langs/Connect4_" + QLocale::system().name())) {
		qDebug() << "ui: load translation";
		app->installTranslator(translator);
	}

	view = SailfishApp::createView();
	view->setSource(QUrl("qrc:///qml/sailfish/Sailfish.qml"));

	main = view->rootObject();
	if (!main) {
		qDebug() << "ui error: main is NULL";
		return;
	}
	PostInit();
}

void UISailfish::PostInit()
{
	// TODO remove if same as UI
	qDebug() << "ui: post init";

	game = main->findChild<QObject*>("game");
	board = game->findChild<QObject*>("board");
	menu = main->findChild<QObject*>("menu");

	config = qvariant_cast<QObject*> (main->property("config"));

	QObject::connect(view, SIGNAL(closing(QQuickCloseEvent*)), this, SLOT(SlotExit()));
	QObject::connect(game, SIGNAL(playCol(const QVariant&)), this, SLOT(SlotPlayCol(const QVariant&)));
	QObject::connect(menu, SIGNAL(exit()), this, SLOT(SlotExit()));
	QObject::connect(menu, SIGNAL(newGame()), this, SLOT(SlotNewGame()));
	QObject::connect(menu, SIGNAL(resetScores()), this, SLOT(SlotResetScore()));
	QObject::connect(menu, SIGNAL(configChanged()), this, SLOT(SlotConfigChanged()));
}

void UISailfish::Launch()
{
	qDebug() << "ui: Launch";
	view->showFullScreen();
//	view->setTitle(config->property("programTitle").toString());
}
