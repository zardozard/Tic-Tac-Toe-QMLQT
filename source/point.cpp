#include "point.h"

Point::Point():x(0),y(0){

}
Point::Point(int x,int y):x(x),y(y){

}
Point::Point(Point & p)
{
    if(this != &p)
    {
        this->x = p.x;
        this->y = p.y;
    }
}
Point::Point(Point && p)
{
    if(this != &p)
    {
        this->x = p.x;
        this->y = p.y;
    }
}
Point Point::operator =(Point & p)
{
 if(this != &p)
 {
     this->x = p.x;
     this->y = p.y;
 }
 return *this;
}
