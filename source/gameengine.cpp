#include "gameengine.h"
#include <QDebug>

GameEngine::GameEngine(QObject *parent) : QObject(parent)
{
    int c = 0;
    for(int i = 0 ; i < FIELD_SZ*FIELD_SZ;i++)
    {
        if(i%3 == 0 && i!=0)
            ++c;
        fieldMap.push_back(Point(c%3,i%3));
    }


}

int GameEngine::MapPointToX(int point) const
{
    return fieldMap[point].x;
}

int GameEngine::MapPointToY(int point) const
{
    return fieldMap[point].y;
}


void GameEngine::editGameField(int player, int cell)
{
    gameField[fieldMap[cell].x][fieldMap[cell].y] = player;    

    getWinner();

}

void GameEngine::restartGame()
{
    functionCalls = 0;
    for(int i = 0  ; i < FIELD_SZ;i++)
        for(int y = 0 ; y < FIELD_SZ;y++)
            gameField[i][y]=0;
}

void GameEngine::getWinner()
{
    //horizontal
    bool signalSend = false;
    int winner = lineWins(TOPLEFT,TOPCENTER,TOPRIGHT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,0);
        signalSend = true;
    }

    winner = lineWins(MIDLEFT,MIDCENTER,MIDRIGHT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,1);
        signalSend = true;
    }

    winner = lineWins(BOTTOMLEFT,BOTTOMCENTER,BOTTOMRIGHT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,2);
        signalSend = true;
    }

    //Vertical
    winner = lineWins(TOPLEFT,MIDLEFT,BOTTOMLEFT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,3);
        signalSend = true;
    }

    winner = lineWins(TOPCENTER,MIDCENTER,BOTTOMCENTER);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,4);
        signalSend = true;
    }

    winner = lineWins(TOPRIGHT,MIDRIGHT,BOTTOMRIGHT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,5);
        signalSend = true;
    }


    //Diagonal

    winner = lineWins(TOPLEFT,MIDCENTER,BOTTOMRIGHT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,6);
        signalSend = true;
    }

    winner = lineWins(TOPRIGHT,MIDCENTER,BOTTOMLEFT);
    if( winner != 0 && winner != -1 )
    {
        emit wins(winner,7);
        signalSend = true;
    }

    ++functionCalls;
    if(functionCalls == 9 && !signalSend) // DRAW
        emit wins(0,-1);
}

short GameEngine::lineWins(short point1, short point2, short point3) const
{
    if( (point1 < 0 || point1 > fieldMap.size()) || (point2 < 0 || point2 > fieldMap.size()) || (point3 < 0 || point3 > fieldMap.size()))
        return -1;

    if(gameField[ MapPointToX( point1 ) ][ MapPointToY( point1 ) ] == 0) return 0;
    if(gameField[ MapPointToX( point1 ) ][ MapPointToY( point1 ) ] != gameField[ MapPointToX( point2 ) ][ MapPointToY( point2 ) ]) return 0;
    if(gameField[ MapPointToX( point2 ) ][ MapPointToY( point2 ) ] != gameField[ MapPointToX( point3 ) ][ MapPointToY( point3 ) ]) return 0;
    return gameField[ MapPointToX( point1 ) ][ MapPointToY( point1 ) ]; // player that has won

}
