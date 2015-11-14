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
