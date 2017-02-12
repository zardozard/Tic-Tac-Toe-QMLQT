import QtQuick 2.0

Rectangle
{
    property var fieldStates: {"set_X":"set_X", // can be optimized there is no reason to have fieldStates in every object
                               "set_O":"set_O",
                               "empty":"empty"}

    property alias anim1: cross.anim
    property alias anim2: cross.anim2

    id:item1
    width:fieldData.w
    height:fieldData.h
    color:"transparent"
    y:fieldData.y
    x:fieldData.x

    //O
    Nought
    {
        id:circle
    }

    //X
    Cross
    {
        id:cross
    }
    state:"empty"

    states:
    [
        State{
            name:item1.fieldStates["set_X"]
            PropertyChanges {target: circle;visible:false}
            PropertyChanges {target: cross;visible:true}
            //PropertyChanges {target: textField;text:"X";opacity: 1}

            PropertyChanges {target: cross.anim;running:true}
            PropertyChanges {target: cross.anim2;running:true}
        },
        State{
            name:item1.fieldStates["set_O"]
            PropertyChanges {target: cross;visible:false}
            PropertyChanges {target: circle;visible:true}

        },
        State{
            name:item1.fieldStates["empty"]
            PropertyChanges {target: cross.lineX1;width:0}
            PropertyChanges {target: cross.lineX2;width:0}
            PropertyChanges {target: cross;visible:false}
            PropertyChanges {target: circle;visible:false}
        }
    ]

    MouseArea
    {
        hoverEnabled: true
        anchors.fill: parent
        onEntered:
        {
            if (parent.state === "empty")
            {
                cursorShape = Qt.PointingHandCursor
            }
            else
                cursorShape = Qt.ArrowCursor
        }
        onClicked:
        {
            changeFieldState(item1)
            console.log("CLICK")
        }
    }
}
