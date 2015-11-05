
/* UI implementation definition */

#include <QQuickView>
#include <QGuiApplication>
#include <QQuickItem>
#include <QTranslator>

#include "../include/UIInterface.h"

class UI : public QObject, public UIInterface {
	Q_OBJECT
	private slots:
	void SlotConfigChanged();
	void SlotNewGame();
	void SlotPlayCol(const QVariant &qcol);
	void SlotResetScore();
	void SlotExit();

   protected:
	QGuiApplication *app;
	QQuickView *view;
	QObject *game, *main, *menu, *config, *board;
	QTranslator *translator;

	virtual void PostInit();

	public:
	UI(int &argc, char *argv[]);
    UI() {}
	~UI() {}

	void ChangePlayer(int player);
	void ConfigSet(const ControllerInterface::Config &config);
	void Exit();
	void EnablePlay(bool en);
	virtual void Launch();
	void Loop();
	bool PlayAtIndex(int player, int idx);
	void ResetBoard();
	void SetScore(int player, int score);

	void ShowAligned(int* aligned);
	void HideAligned();
};
