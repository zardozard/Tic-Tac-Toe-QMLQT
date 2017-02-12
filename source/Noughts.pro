TEMPLATE = app

QT += qml quick
CONFIG += c++14
QMAKE_LFLAGS_RELEASE += -static -static-libgcc
SOURCES += main.cpp \
    gameengine.cpp \
    point.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    gameengine.h \
    point.h
