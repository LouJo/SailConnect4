
/* UI implementation definition */

#include <QQuickView>
#include <QGuiApplication>

#include "../include/UIInterface.h"

class UI : public UIInterface {
	private:
	QGuiApplication *app;
	QQuickView *view;

	public:
	UI(int argc, char *argv[]);

	void Launch();
};
