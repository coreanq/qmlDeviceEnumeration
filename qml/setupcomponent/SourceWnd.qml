import QtQuick 2.0
import "../"
import "../functions.js" as Functions

Item {
    id: sourceWnd

    property bool editMode : false
    property int pressDelay : 10 // flick 와 click 동작을 모두 구현하기 위함
    property int currentCellWidth: 80
    property int currentCellHeight: 45
    property int minimumWidth : 80
    property int maximumWidth : 240
    property double scale : 1


    GridView {
        id: viewTxZones
        property int indexDrag: -1

        pressDelay: sourceWnd.pressDelay
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        cacheBuffer: cellHeight * 2
        cellWidth: sourceWnd.currentCellWidth * sourceWnd.scale
        cellHeight: sourceWnd.currentCellHeight * sourceWnd.scale
        model: qmlModelTxZones

        delegate: Zone {
            id: txZones
            color: "lightyellow"
            editMode: sourceWnd.editMode
            width: viewTxZones.cellWidth; height: viewTxZones.cellHeight
            states: [
                State {
                    name: "inDrag"
                    when: index == viewTxZones.indexDrag;
//                    ParentChange {

//                        target: txZones.accessFlipableZone
//                        parent: mainContainer

//                    }
                    PropertyChanges {
                        target: txZones.accessFlipableZone;
                        opacity: 0.7;
                        parent: mainContainer
                        width: txZones.width;
                        height: txZones.height
                        x: viewTxZonesArea.mapToItem(mainContainer, viewTxZonesArea.mouseX, 0).x - txZones.width/2
                        y: viewTxZonesArea.mapToItem(mainContainer, 0, viewTxZonesArea.mouseY).y - txZones.height/2

                    }
                }
            ]


        }

        MouseArea {
            anchors.fill: parent
            id: viewTxZonesArea
            visible: !sourceWnd.editMode
            onReleased: {

                // drag 시 잔상이 남는 현상을 제거 하기 위해 화면 강제 업데이트 시킴
                viewRegisteredTxZonesWnd.clip = false;
                viewRegisteredTxZonesWnd.clip = true;
                setupWnd.clip = false;
                setupWnd.clip = true;


                if( viewTxZones.interactive == true )
                    return;
                if( Functions.isPtInRegisteredTxZones(viewTxZones, mouseX, mouseY) == true ){
                    var targetIndex = Functions.indexInRegisteredTxZones(viewTxZones, mouseX, mouseY);
                    cppInterface.insertTxRegisteredZones(viewTxZones.indexDrag, targetIndex);
                }
                viewTxZones.indexDrag = -1;
                viewTxZones.interactive = true;
            }

            onPressed: {
                viewTxZones.interactive = false;
                // 아래 루틴엔 버그 있음.
//                viewTxZones.indexDrag = viewTxZones.indexAt(mouseX +( viewTxZones.visibleArea.xPosition * viewTxZones.contentWidth ),
//                                                        mouseY +(viewTxZones.visibleArea.yPosition * viewTxZones.contentHeight));
                viewTxZones.indexDrag = viewTxZones.indexAt(mouseX +( viewTxZones.contentX),
                                                            mouseY +(viewTxZones.contentY));


//                console.debug( "mouse X " + mouseX + " mouse Y " + mouseY + " tx zones index " + viewTxZones.indexDrag
//                              + " visibleArea.xPosition " + viewTxZones.visibleArea.xPosition + " viewTxZones.visibleArea.yPosition " + viewTxZones.visibleArea.yPosition
//                              + " viewTxZones.x " + viewTxZones.contentX + " viewTxZones.y " + viewTxZones.contentY
//                              + " viewTxZones.contentWidth " + viewTxZones.contentWidth + " viewTxZones.contentHeight " + viewTxZones.contentHeight
//                              + " xBeginning " + viewTxZones.atXBeginning + " xEnd " + viewTxZones.atXEnd + " YBeginning " + viewTxZones.atYBeginning + " yEnd " + viewTxZones.atYEnd
//                              );
            }
        }
    }
}
