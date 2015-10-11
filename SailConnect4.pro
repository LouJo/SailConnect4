QT += qml quick gui concurrent
TARGET = SailConnect4

CONFIG += c++11 sailfishapp

CONFIG += sailfishapp_i18n

SOURCES += \
	UI/src/UI.cpp \
	UI/src/UISailfish.cpp \
	Controller/src/Controller.cpp \
	Game/src/Game.cpp \
	Game/src/Minimax.cpp \
	Controller/src/sailfish.cpp

RESOURCES += \
	UI/qml/qml.qrc \
	UI/qml/sailfish/sailfish.qrc \
	UI/icons/icons.qrc \
	UI/i18n/translations.qrc

RC_FILE = UI/icons/icons.rc

HEADERS += \
	UI/include/UIInterface.h \
	UI/src/UI.h \
	UI/src/UISailfish.h \
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
SOURCES += \
		UI/qml/menu/*.qml \
		UI/qml/apropos/*.qml \
		UI/qml/board/*.qml \
		UI/qml/config/*.qml \
		UI/qml/*.qml
}
