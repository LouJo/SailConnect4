
/* UI implementation definition */

#include <QQuickView>
#include <QGuiApplication>
#include <QQuickItem>

#include "../include/UIInterface.h"

class UI : public UIInterface {
	private:
	QGuiApplication *app;
	QQuickView *view;
	QObject *game, *main;

	public:
	UI(int argc, char *argv[]);

	void Launch();
	void EnablePlay(bool en);
	void ChangePlayer(int player);
	void PlayAtIndex(int player, int idx);
	void SetScore(int player, int score);
	void Exit();
};
