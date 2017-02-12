import QtQuick 2.7
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Window {
    id:window
    visible: true
    color:"#14BDAC"
    width: 600
    height: 600
    title: qsTr("Noughts and Crosses")
    property var fieldData: {"w":0,"h":0,"x":0,"y":0}

    property int fieldW: window.width/4
    property int fieldH: window.height/4
    property int fieldMargin: window.width/100 * 3

    property int x_PLAYER_ID: 1
    property int o_PLAYER_ID: 2

    property int  current_playerID: x_PLAYER_ID //1 for x 2 for O
    property string lineBorderColor: "#0DA192"
    property string colorGray: "#F2EBD3"
    property var gameFieldList: [item1,item2,item3,item4,item5,item6,item7,item8,item9]
    property var gameFieldListToIDMap: {[]}

    property var animationList: [anim0,anim1,anim2,anim3,anim4,anim5,anim6,anim7]
    property var gameAnimListToIDMap: {0:anim0,1:anim1,2:anim2,3:anim3,4:anim4,5:anim5,6:anim6,7:anim7}

    property bool gameFieldBlocked: false
    property bool recalcGUI: false
    //=================================================================================================

    onBeforeRendering: if(recalcGUI)calcGUIPosAndSz()
    onWidthChanged: recalcGUI = true
    onHeightChanged: recalcGUI = true




    Connections
    {
        target: gameEngine
        onWins://WIN SIGNAL FROM CPP GAME ENGINE
        {
            console.log("WINS PLAYER:"+player+" anim:"+animation)
            if(player === x_PLAYER_ID)
            {
                gameAnimListToIDMap[animation].color = "black"
                ++xScore.scoreCounter
                winnerLogo.state = winnerLogo.fieldStates["empty"]
                winnerLogo.state = winnerLogo.fieldStates["set_X"]
                winnerText.text = qsTr("Wins!")
            }
            else if (player === o_PLAYER_ID)
            {
                gameAnimListToIDMap[animation].color = colorGray
                ++oScore.scoreCounter
                winnerLogo.state = winnerLogo.fieldStates["empty"]
                winnerLogo.state = winnerLogo.fieldStates["set_O"]
                winnerText.text = qsTr("Wins!")
            }
            else if(player === 0)
            {
                winnerLogo.state = winnerLogo.fieldStates["empty"]
                winnerText.text = qsTr("Draw!")
            }
            gameFieldBlocked = true
            if(animation < 8 && animation >= 0)
                gameAnimListToIDMap[animation].anim.running = true

            delayWinMenu.restart()
        }
    }

    function calcGUIPosAndSz()
    {
        if(window.width > window.height)
            window.height = window.width
        else
            window.width = window.height
        var topAndBotMargin = (window.height / 100) * 12
        var leftAndRightMargin = (window.width / 100) * 12


        fieldData.w = (window.width - leftAndRightMargin*2)/3 - fieldMargin*2
        fieldData.h = (window.height - topAndBotMargin*2)/3 -fieldMargin*2

        item1.width = fieldData.w
        item1.height = fieldData.h


        item1.x = leftAndRightMargin+fieldMargin*2;
        item1.y = topAndBotMargin+(window.height - topAndBotMargin*2)/2 - item1.height*1.5;
        recalcGUI = false

        //RESIZE WIN LINES
        for(var i = 0 ; i < animationList.length ; i++)
        {
            if(animationList[i].width > 0)
            {
                animationList[i].anim.running = true
                break
            }
        }
        //RESIZE CROSSES
        for(i = 0 ; i < gameFieldList.length ;i++)
        {
            if(gameFieldList[i].state === gameFieldList[i].fieldStates["set_X"])
            {
                gameFieldList[i].anim1.running = true
                gameFieldList[i].anim2.running = true
            }
        }

        //RESIZE CROSS ON WIN MENU
        if(gameFieldBlocked)
        {
            winField.y = 0
            if(winnerLogo.state === winnerLogo.fieldStates["set_X"])
            {
                winnerLogo.anim1.running = true
                winnerLogo.anim2.running = true
            }

        }
//        back.x = leftAndRightMargin
//        back.y = topAndBotMargin
//        back.width = (window.width - leftAndRightMargin*2)
//        back.height = (window.height - topAndBotMargin*2)
        //console.log("w:"+item1.width+" h:"+item1.height)
        //console.log("field w:"+back.width+" field h:"+back.height)
//        anim.running = true
//        anim2.running = true
    }

    //INIT GAME FIELD
    Component.onCompleted:
    {
        calcGUIPosAndSz()
        for(var i = 0; i < 9 ; i++)
            gameFieldListToIDMap[gameFieldList[i]] = i
        if(current_playerID == x_PLAYER_ID)
            xGlow.visible = true
        else
            oGlow.visible = true
    }

    function highlight_O_Player()
    {
        oGlow.visible = true
        xGlow.visible = false
    }
    function highlight_X_Player()
    {
        oGlow.visible = false
        xGlow.visible = true
    }

    function changeFieldState(fieldID)
    {
        if(fieldID.state !== fieldID.fieldStates["set_X"] && fieldID.state !== fieldID.fieldStates["set_O"] && !gameFieldBlocked)
        {
            if(current_playerID === x_PLAYER_ID)
            {
                fieldID.state = fieldID.fieldStates["set_X"]

                gameEngine.editGameField(current_playerID,gameFieldListToIDMap[fieldID])

                console.log("SETX "+gameFieldListToIDMap[fieldID])
                current_playerID = current_playerID === 1? 2: 1
                highlight_O_Player()

            }
            else
            {
                fieldID.state = fieldID.fieldStates["set_O"]

                gameEngine.editGameField(current_playerID,gameFieldListToIDMap[fieldID])


                console.log("SETO "+gameFieldListToIDMap[fieldID])
                current_playerID = current_playerID === 1? 2: 1

                highlight_X_Player()
            }
        }

    }

//WIN FIELD
    Rectangle
    {


        function revange()
        {
            for (var i = 0 ; i <  gameFieldList.length; i++)
            {
                console.log("j:"+i)
                gameFieldList[i].state = "empty"
            }
            for (i = 0 ; i <  animationList.length; i++)
            {
                console.log("i:"+i)
                animationList[i].width = 0
            }

            winMenuGoUp.running = true
            gameFieldBlocked = false
            current_playerID = 1;
            highlight_X_Player()
            gameEngine.restartGame()
        }

        function restart()
        {
            revange()
            xScore.scoreCounter = 0;
            oScore.scoreCounter = 0;

        }
        Timer
        {
            id:delayWinMenu
            interval: 1500
            running: false
            onTriggered: winMenuGoDown.running = true
        }
        id:winField
        width: parent.width
        height: parent.height
        color:"#14BDE1"
        y:-winField.height
        z:2
        GameRect
        {
            id:winnerLogo
            x:parent.width/2 - width/2
            y:parent.height*0.25
            width: item1.width
            height: item1.height
            state:winnerLogo.fieldStates["empty"]
        }
        Text {
            id: winnerText
            text: qsTr("Wins!")
            font.pixelSize: window.height*0.1
            x:winnerLogo.x - (width - winnerLogo.width)/2
            y:winnerLogo.y+winnerLogo.height
        }

        MenuItem
        {
            id:revangeBtn
            anchors.topMargin: parent.height*0.10
            anchors.top:winnerText.bottom
            height: winnerText.height
            width: window.height
            text.text:qsTr("Revange")
            text.font.pixelSize: winnerText.font.pixelSize
            text.x:winnerLogo.x - (text.width - winnerLogo.width)/2
            mouseArea.onClicked: parent.revange()
        }
        MenuItem
        {
            id:restartBtn
            anchors.top:revangeBtn.bottom
            height: winnerText.height
            width: window.height
            text.font.pixelSize: winnerText.font.pixelSize
            text.text: qsTr("Restart")
            text.x:winnerLogo.x - (text.width - winnerLogo.width)/2
            mouseArea.onClicked: parent.restart()
        }
        NumberAnimation on y
        {
            id:winMenuGoUp
            to:-winField.height
            duration:500
            running:false

        }
        NumberAnimation on y
        {
            id:winMenuGoDown
            to:0
            duration:500
            running:false
        }

    }

//WIN ANIMATIONS

    //HORIZONTAL
    WinLine
    {
        id:anim0
        anchors.left:item1.left
        anchors.top:item1.top
        anchors.topMargin:item1.height/2 - height/2
        anim.to:item1.width*3+fieldMargin*2

    }
    WinLine
    {
        id:anim1
        anchors.left:item4.left
        anchors.top:item4.top
        anchors.topMargin:item1.height/2 - height/2
        anim.to:item1.width*3+fieldMargin*2

    }
    WinLine
    {
        id:anim2
        anchors.left:item7.left
        anchors.top:item7.top
        anchors.topMargin:item1.height/2 - height/2
        anim.to:item1.width*3+fieldMargin*2

    }

    //VERTICAL
    WinLine
    {
        id:anim3
        x:item4.x+item4.width/2-width/2
        y:item4.y+item4.height/2-height/2
        rotation:90
        anim.to:item1.width*3+fieldMargin*2

    }
    WinLine
    {
        id:anim4
        x:item5.x+item5.width/2-width/2
        y:item5.y+item5.height/2-height/2
        rotation:90
        anim.to:item1.width*3+fieldMargin*2

    }
    WinLine
    {
        id:anim5
        x:item6.x+item6.width/2-width/2
        y:item6.y+item6.height/2-height/2
        rotation:90
        anim.to:item1.width*3+fieldMargin*2

    }

    //DIAGONAL
    WinLine
    {
        id:anim6
        x:item5.x+item5.width/2-width/2
        y:item5.y+item5.height/2-height/2
        rotation:45
        anim.to:item1.width*3+fieldMargin*12

    }
    WinLine
    {
        id:anim7
        x:item5.x+item5.width/2-width/2
        y:item5.y+item5.height/2-height/2
        rotation:135
        anim.to:item1.width*3+fieldMargin*12

    }
//=====================================================
    //xWIN COUNTER
    Rectangle
    {
        property int scoreCounter: 0
        id:xScore
        width: item2.width*2
        height: 20
        color:"white"
        x:item2.x+item2.width/2 - width
        y:fieldMargin
        z:3
        Text {
            text: qsTr("X")

            anchors.left: parent.left
            anchors.leftMargin: 1
            font.pointSize: parent.height/1.5
            //anchors.horizontalCenter: xScore.horizontalCenter
        }
        Text
        {
            id:xScoreCounter
            text:qsTr(parent.scoreCounter.toString())
            font.pointSize: parent.height/1.5
            x:parent.width - width - 10
            y:parent.height/2-height/2

        }
        Rectangle
        {
            anchors.fill: parent
            z:-1
            RectangularGlow {
                    id: xGlow
                    anchors.fill: parent
                    glowRadius: 10
                    spread: 0.2
                    color: "#55ff55"
                    cornerRadius:20
                    visible:false
                }

        }

        //shadow
//        Rectangle
//        {
//            width: xScore.width
//            height: xScore.height
//            color:"#12A896"
//            x:+10
//            y:+8
//            z:-1
//        }

    }

    //O WIN COUNTER
    Rectangle
    {
        property int scoreCounter: 0
        id:oScore
        width: xScore.width
        height: xScore.height
        color:  xScore.color
        x: xScore.x+xScore.width+10
        y:fieldMargin
        z:3
        Text {
            text: qsTr("O")

            anchors.left: parent.left
            anchors.leftMargin: 1
            font.pointSize: parent.height/1.5
            //anchors.horizontalCenter: xScore.horizontalCenter
        }
        Text
        {
            id:oScoreCounter
            text:qsTr(parent.scoreCounter.toString())
            font.pointSize: parent.height/1.5
            x:parent.width - width - 10
            y:parent.height/2-height/2

        }
        Rectangle
        {
            anchors.fill: parent
            z:-1
            RectangularGlow {
                    id: oGlow
                    anchors.fill: parent
                    glowRadius: 10
                    spread: 0.2
                    color: "#55ff55"
                    cornerRadius:20
                    visible: false
                }
        }
    }

//====================================================


    //linesInsideTable
    Rectangle
    {
        color:lineBorderColor
        anchors.left: item1.right
        anchors.right: item2.left
        anchors.top:item1.top
        anchors.bottom: item7.bottom
    }
    Rectangle
    {
        color:lineBorderColor
        anchors.left: item2.right
        anchors.right: item3.left
        anchors.top:item2.top
        anchors.bottom: item8.bottom
    }
    Rectangle
    {
        color:lineBorderColor
        anchors.left: item1.left
        anchors.right: item3.right
        anchors.top:item1.bottom
        anchors.bottom: item6.top
    }
    Rectangle
    {
        color:lineBorderColor
        anchors.left: item4.left
        anchors.right: item6.right
        anchors.top:item4.bottom
        anchors.bottom: item9.top
    }

    //GAME FIELDS
    GameRect
    {

        id:item1
        width:fieldData.w
        height:fieldData.h

        y:fieldData.y
        x:fieldData.x

    }
    GameRect
    {
        id:item2
        anchors.top: item1.top
        anchors.left: item1.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
        //color:"blue"

    }
    GameRect
    {
        id:item3
        anchors.top: item2.top
        anchors.left: item2.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
        //color:"green"

    }
    GameRect
    {
        id:item4
        //color:"yellow"
        anchors.left: item1.left
        anchors.top: item1.bottom
        anchors.topMargin: fieldMargin
        width:item1.width
        height:item1.height
    }
    GameRect
    {
        id:item5
        anchors.top: item4.top
        anchors.left: item4.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
        //color:"red"

    }
    GameRect
    {
        id:item6
        anchors.top: item5.top
        anchors.left: item5.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
        //color:"black"

    }
    GameRect
    {
        id:item7
        //color:"yellow"
        anchors.left: item4.left
        anchors.top: item4.bottom
        anchors.topMargin: fieldMargin
        width:item1.width
        height:item1.height
    }
    GameRect
    {
        id:item8
        anchors.top: item7.top
        anchors.left: item7.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
        //color:"yellow"

    }
    GameRect
    {
        id:item9
        anchors.top: item8.top
        anchors.left: item8.right
        anchors.leftMargin: fieldMargin
        width:item1.width
        height:item1.height
       // color:"red"

    }

}
