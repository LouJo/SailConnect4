QT += qml quick gui concurrent
TARGET = harbour-sailconnect4

CONFIG += c++11 sailfishapp
CONFIG += sailfishapp_i18n

DEFINES += TARGET=\""$(TARGET")\"

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
