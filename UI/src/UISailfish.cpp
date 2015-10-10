
/* UI derivated for Sailfish */

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
	view->setSource(SailfishApp::pathTo("qml/sailfish/Sailfish.qml"));

	main = view->rootObject();
	PostInit();
}

void UISailfish::Launch()
{
	view->showFullScreen();
//	view->setTitle(config->property("programTitle").toString());
}
