
/* UI derivated for Sailfish */

#include <sailfishapp.h>
#include "UISailfish.h"

UISailfish::UISailfish(int &argc, char* argv[])
{
	qDebug() << "ui: init UISailfish";
	app = SailfishApp::application(argc, argv);

	translator = new QTranslator();
	if (translator->load(":/langs/Connect4_" + QLocale::system().name())) {
		qDebug() << "ui: load translation for lang " << QLocale::system().name();
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
	UI::PostInit();
//	cover = qvariant_cast<QObject*> (main->property("sailCover"));
	cover = main->findChild<QObject*>("myCover");
	if (cover) qDebug() << "cover is not null";
	else qDebug() << "cover is null";
}

void UISailfish::Launch()
{
	qDebug() << "ui: Launch";
	view->showFullScreen();
//	view->setTitle(config->property("programTitle").toString());
}

bool UISailfish::PlayAtIndex(int player, int idx)
{
	QVariant ret;
	QVariant qplayer = player + 1;
	QVariant qindex = idx;

	QMetaObject::invokeMethod(board, "play", Q_RETURN_ARG(QVariant, ret), Q_ARG(QVariant, qindex), Q_ARG(QVariant, qplayer));

	bool r = ret.toBool();
	QMetaObject::invokeMethod(cover, "play", Q_RETURN_ARG(QVariant, ret), Q_ARG(QVariant, qindex), Q_ARG(QVariant, qplayer));

	return r;
}

void UISailfish::ResetBoard()
{
	QMetaObject::invokeMethod(board, "reset");
	QMetaObject::invokeMethod(cover, "reset");
}

