
/* UI implementation definition */

#include <QQuickView>
#include <QGuiApplication>
#include <QQuickItem>

#include "../include/UIInterface.h"

class UI : public QObject, public UIInterface {
	Q_OBJECT
	public slots:
	void SlotConfigChanged();
	void SlotNewGame();
	void SlotPlayCol(QVariant qcol);
	void SlotResetScore();
	void SlotExit();

	private:
	QGuiApplication *app;
	QQuickView *view;
	QObject *game, *main, *menu, *config, *board;

	public:
	UI(int &argc, char *argv[]);
	~UI() {}

	void ChangePlayer(int player);
	void ConfigSet(const ControllerInterface::Config &config);
	void Exit();
	void EnablePlay(bool en);
	void Launch();
	void Loop();
	bool PlayAtIndex(int player, int idx);
	void ResetBoard();
	void SetScore(int player, int score);
};
