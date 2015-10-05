QT += qml quick gui
TARGET = Connect4

CONFIG += c++11

SOURCES += \
	UI/src/UI.cpp \
	Controller/src/Controller.cpp \
	Controller/src/main.cpp

RESOURCES += UI/qml/qml.qrc

HEADERS += \
	UI/include/UIInterface.h \
	UI/src/UI.h \
	Controller/include/ControllerInterface.h \
	Controller/src/Controller.h \
	Game/include/GameInterface.h
