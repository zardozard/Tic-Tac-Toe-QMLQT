import QtQuick 2.0

Rectangle
{
    property alias text: text
    property alias mouseArea: mouseArea

    id:root

    Text {
        id:text
    }
    MouseArea
    {
        id:mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered:
        {
            parent.color = colorGray
            cursorShape = Qt.PointingHandCursor
        }
        onExited: parent.color = "white"
    }
}
