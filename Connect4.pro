QT += qml quick gui concurrent
TARGET = Connect4

CONFIG += c++11

SOURCES += \
	UI/src/UI.cpp \
	Controller/src/Controller.cpp \
	Game/src/Game.cpp \
	Game/src/Minimax.cpp \
	Controller/src/main.cpp

RESOURCES += \
	UI/qml/qml.qrc \
	UI/i18n/translations.qrc

HEADERS += \
	UI/include/UIInterface.h \
	UI/src/UI.h \
	Controller/include/ControllerInterface.h \
	Controller/include/FactoryInterface.h \
	Controller/src/Controller.h \
	Game/include/GameInterface.h \
	Game/src/Game.h \
	Game/src/Minimax.h

TRANSLATIONS += \
	UI/i18n/Connect4_fr.ts \
	UI/i18n/Connect4_es.ts \
	UI/i18n/Connect4_de.ts

lupdate_only {
SOURCES = \
		UI/qml/menu/*.qml \
		UI/qml/board/*.qml \
		UI/qml/config/*.qml \
		UI/qml/*.qml \
}
