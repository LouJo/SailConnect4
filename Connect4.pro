QT += qml quick gui
TARGET = Connect4

CONFIG += c++11 debug

SOURCES += \
	UI/src/UI.cpp \
	Controller/src/Controller.cpp \
	Game/src/Game.cpp \
	Game/src/Minimax.cpp \
	Controller/src/main.cpp

RESOURCES += UI/qml/qml.qrc

HEADERS += \
	UI/include/UIInterface.h \
	UI/src/UI.h \
	Controller/include/ControllerInterface.h \
	Controller/src/Controller.h \
	Game/include/GameInterface.h \
	Game/src/Game.h \
	Game/src/Minimax.h
