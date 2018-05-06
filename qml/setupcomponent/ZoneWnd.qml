import QtQuick 2.0
import "../"
import "../functions.js" as Functions

Item {
    id: zoneWnd
    property bool visibleMouseArea : true
    property bool enableGroupControl : false
    property bool editMode : false

    property int pressDelay : 10 // flick 와 click 동작을 모두 구현하기 위함
    property int currentCellWidth: 240
    property int currentCellHeight: 135
    property int minimumWidth : 80
    property int maximumWidth : 240
    property double scale : 1


    GridView {
        id: viewGroups
        pressDelay: zoneWnd.pressDelay


        width: cellWidth
        anchors.top : parent.top
        anchors.bottom: btnGroupControl.top
        anchors.left: parent.left

        cacheBuffer: cellHeight * 2
        cellWidth: zoneWnd.currentCellWidth * zoneWnd.scale
        cellHeight: zoneWnd.currentCellHeight * zoneWnd.scale
        model: qmlModelGroups
        delegate: Group {
            id: group
            editMode: zoneWnd.editMode
            width: viewGroups.cellWidth; height: viewGroups.cellHeight
            cellColor: "lightgreen"
        }
//        MouseArea {
//            anchors.fill: parent
//            id: viewRegisteredTxMouseArea
//            visible: viewRegisteredTxZones.mode == "setup"

//            onReleased: {
//                // drag 시 잔상이 남는 현상을 제거 하기 위해 화면 강제 업데이트 시킴
//                viewRegisteredTxZonesWnd.clip = false;
//                viewRegisteredTxZonesWnd.clip = true;
//                setupWnd.clip = false;
//                setupWnd.clip = true;


//                if( Functions.isPtInRegisteredTxZones(viewRegisteredTxZones, mouseX, mouseY) != true ){
//    //                console.debug("remove release index " + viewRegisteredTxZones.indexDrag);
//                    cppInterface.removeTxRegisteredZones(viewRegisteredTxZones.indexDrag);
//                }
//                else{
//                    var targetIndex = viewRegisteredTxZones.indexAt(mouseX, mouseY);
//    //                console.debug( "target index " + targetIndex + " indexDrag " + viewRegisteredTxZones.indexDrag + " " + mouseX + " " + mouseY );
//                    cppInterface.moveTxRegisteredZones(viewRegisteredTxZones.indexDrag, targetIndex);
//                }

//                // 지울때 제대로 첫번째 row 가 제대로 지워지지 않는 문제가 있어서 다음과 같은 방법 사용
//                viewRegisteredTxZones.model = 0;
//                viewRegisteredTxZones.model = qmlModelRegisteredTxChannels;

//                viewRegisteredTxZones.interactive = true;
//                viewRegisteredTxZones.indexDrag = -1;
//            }

//            onPressed: {
//                viewRegisteredTxZones.interactive = false;
//                // 아래 루틴엔 버그 있음.
//    //            viewRegisteredTxZones.indexDrag = viewRegisteredTxZones.indexAt(mouseX +( viewRegisteredTxZones.visibleArea.xPosition * viewRegisteredTxZones.contentWidth),
//    //                                                                             mouseY +(viewRegisteredTxZones.visibleArea.yPosition * viewRegisteredTxZones.contentHeight));
//                viewRegisteredTxZones.indexDrag = viewRegisteredTxZones.indexAt(mouseX + viewRegisteredTxZones.contentX,
//                                                                                mouseY +viewRegisteredTxZones.contentY);
//            }

//        }

    }
    Connections {
        target: btnGroupAdd;
        onClicked: cppInterface.onBtnGroupAddClicked();
    }
    Connections {
        target: btnGroupRemove;
        onClicked: cppInterface.onBtnGroupRemoveClicked();
    }
    Connections {
        target: btnSelAll;
        onClicked: cppInterface.onBtnSelAllClicked();
    }
    Connections {
        target: btnDeselAll;
        onClicked: cppInterface.onBtnDeselAllClicked();
    }

    Item {
        id: btnGroupControl
        clip: true
        height: zoneWnd.enableGroupControl == true ? btnGroupAdd.height *4 + 30 : 0
        width: viewGroups.width
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        Rectangle {
            anchors.fill: parent
            color: "white"
            radius: 5
        }

        Column {
            spacing: 5
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width

            Button {
                id: btnGroupAdd
                height: 30
                width: parent.width
                text: qsTr("Add") + ""
            }
            Button {
                id: btnGroupRemove
                height: 30
                width: parent.width
                text: qsTr("Remove") + ""
            }

            Button {
                id: btnSelAll
                height: 30
                width: parent.width
                text: qsTr("Sel. all") + ""

            }
            Button {
                id: btnDeselAll
                height: 30
                width: parent.width
                text: qsTr("Desel. all") + ""

            }

        }
    }


    Rectangle{
        id: groupZoneSperator
        color: "black"
        radius: 2
        anchors.left: viewGroups.right
        anchors.leftMargin: 20
        width: 5
        height: parent.height
    }

    GridView {
        id: viewRxZones
        pressDelay: zoneWnd.pressDelay

        anchors.top : parent.top
        anchors.bottom: parent.bottom
        anchors.left: viewGroups.right
        anchors.right: parent.right
        anchors.leftMargin: 40
        anchors.rightMargin: 40

        cacheBuffer: cellHeight * 2
        cellWidth: zoneWnd.currentCellWidth * zoneWnd.scale
        cellHeight: zoneWnd.currentCellHeight * zoneWnd.scale

        model: qmlModelRxZones
        delegate: Zone {
            editMode: zoneWnd.editMode
            id: rxZone
            width: viewRxZones.cellWidth; height: viewRxZones.cellHeight
            color: "white"

        }
   }
}
