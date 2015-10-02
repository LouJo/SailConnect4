
/* Interface for UI
   Implemented with qml
*/

#include <QQuickView>
#include <QGuiApplication>

#include "../include/UIInterface.h"

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	QQuickView view(QUrl("qrc:///Main.qml"));

	view.setResizeMode(view.SizeRootObjectToView);

	view.show();
	app.exec();

	return 0;
}
