import QtQuick 2.0

Rectangle
{
    property alias anim: anim
    height: fieldMargin * 0.5
    color:"#F2EBD3"
    NumberAnimation on width {
        id:anim
        duration: 500
        running: false
    }
    z:1
}
