QT += qml quick
TARGET = Connect4

CONFIG += c++11 debug

SOURCES += UI/src/UI.cpp

RESOURCES += UI/qml/qml.qrc

HEADERS += \
	UI/include/UIInterface.h \
	Controller/include/ControllerInterface.h
