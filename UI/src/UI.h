
/* UI implementation definition */

#include <QQuickView>
#include <QGuiApplication>
#include <QQuickItem>
#include <QString>

#include "../include/UIInterface.h"

class UI : public QObject, public UIInterface {
	Q_OBJECT
	public slots:
	void SlotReady();

	private:
	QGuiApplication *app;
	QQuickView *view;
	QQmlApplicationEngine *engine;
	QObject *game, *main, *menu;

	public:
	UI(int argc, char *argv[]);
	~UI() {}

	void Launch();
	void EnablePlay(bool en);
	void ChangePlayer(int player);
	void PlayAtIndex(int player, int idx);
	void SetScore(int player, int score);
	void Exit();
	void Loop();
};
