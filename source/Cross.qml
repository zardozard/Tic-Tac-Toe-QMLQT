import QtQuick 2.0

Rectangle
{
    id:root
    anchors.fill: parent
    color:"transparent"

    property alias anim: anim
    property alias anim2: anim2
    property alias lineX1: lineX1
    property alias lineX2: lineX2

    Rectangle
    {
        id:lineX1
        z:10

        x:parent.width/2 - width/2
        y:parent.height/2 - height/2
        height: 0
        width: 0
        color:"black"
        rotation:45
        radius:10
        NumberAnimation on width {
            id:anim
            to:root.width
            duration: 300
            onRunningChanged:{
                if(running)
                    lineX1.height = 10
            }
        }
    }
    Rectangle
    {
        id:lineX2
        z:1
        x:parent.width/2 - width/2
        y:parent.height/2 - height/2
        height: 0
        width: 0
        color:"#000000"
        rotation:135
        radius:10
        NumberAnimation on width {
            id:anim2
            to:root.width
            duration: 300
            onRunningChanged:{
                if(running)
                    lineX2.height = 10
            }
        }
    }
}
