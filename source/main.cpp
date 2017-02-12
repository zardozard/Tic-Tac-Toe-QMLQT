#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "gameengine.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    GameEngine ge;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("gameEngine",&ge);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
