/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */


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

void UISailfish::Launch()
{
	qDebug() << "ui: Launch";
	view->showFullScreen();
//	view->setTitle(config->property("programTitle").toString());
}

void UISailfish::SlotPause(const QVariant &pause)
{
	qDebug() << "ui: SlotPause " << pause;
	controller->Pause(pause.toBool());
}
