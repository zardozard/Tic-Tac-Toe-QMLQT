#ifndef GAMEENGINE_H
#define GAMEENGINE_H

#include <QObject>
#include <QVector>
#include "point.h"


class GameEngine : public QObject
{
    Q_OBJECT
public:
    explicit GameEngine(QObject *parent = 0);
    int MapPointToX(int point) const ;
    int MapPointToY(int point) const ;
signals:
    void wins(int player,int animation);
public slots:
    void editGameField(int player,int cell);
    void restartGame();
    void getWinner();
    short lineWins(short point1,short point2,short point3)const;

private:
    enum POINTS{TOPLEFT,TOPCENTER,TOPRIGHT,
                MIDLEFT,MIDCENTER,MIDRIGHT,
                BOTTOMLEFT,BOTTOMCENTER,BOTTOMRIGHT};
    static const short FIELD_SZ = 3;
    QVector<Point> fieldMap;
    short gameField[FIELD_SZ][FIELD_SZ] = {{0}};
    int functionCalls = 0;
};

#endif // GAMEENGINE_H
