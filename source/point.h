#ifndef POINT_H
#define POINT_H


struct Point
{
    short x,y = 0;
    Point();
    Point(int x,int y);
    Point(Point & p);
    Point(Point && p);
    Point operator =(Point & p);
};

#endif // POINT_H
