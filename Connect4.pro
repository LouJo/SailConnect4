QT += qml quick
TARGET = Connect4

CONFIG += c++11

SOURCES += UI/src/UI.cpp

RESOURCES += UI/qml/qml.qrc

HEADERS += \
	UI/include/UIInterface.h \
	Controller/include/ControllerInterface.h
