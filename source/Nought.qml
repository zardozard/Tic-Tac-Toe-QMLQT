import QtQuick 2.0

Rectangle
{
     id:circle
     x:parent.width/2-width/2
     y:parent.height/2-height/2
     width: parent.width*0.9
     height: parent.height*0.9
     //anchors.horizontalCenter: parent.horizontalCenter
     //anchors.bottom: parent.bottom
     color: "transparent"
     border.color: "#F2EBD3"
     border.width:10
     radius: width*0.5
     visible: false
}
