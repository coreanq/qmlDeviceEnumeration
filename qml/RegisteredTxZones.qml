import QtQuick 2.0
import "functions.js" as Functions

GridView {
    id: viewRegisteredTxZones

    property string mode
    property int indexDrag: -1
    property int currentCellWidth: 80
    property int currentCellHeight: 45
    property int minimumWidth : 80
    property int maximumWidth : 240
    property int scale : 1

    pressDelay: 10
    flow: GridView.TopToBottom
    width: parent.width / 5 * 4
    anchors.top: parent.top

    contentWidth: viewRegisteredTxZones.width

    cacheBuffer: cellWidth * 2

    cellWidth: viewRegisteredTxZones.currentCellWidth * viewRegisteredTxZones.scale
    cellHeight: viewRegisteredTxZones.currentCellHeight * viewRegisteredTxZones.scale
    model: qmlModelRegisteredTxChannels
    delegate: Zone {
        id: registeredZone
        color: "lightyellow"
        width: viewRegisteredTxZones.cellWidth; height: viewRegisteredTxZones.cellHeight
        states: [
            State {
                name: "inDrag"
                when: index == viewRegisteredTxZones.indexDrag;
                PropertyChanges { target: registeredZone.accessFlipableZone; parent: mainWnd }
                PropertyChanges {
                    target: registeredZone.accessFlipableZone
                    opacity: 0.7
                    width: registeredZone.width
                    height: registeredZone.height
                    x: viewRegisteredTxMouseArea.mapToItem(mainWnd, viewRegisteredTxMouseArea.mouseX, 0).x - registeredZone.width/2
                    y: viewRegisteredTxMouseArea.mapToItem(mainWnd, 0, viewRegisteredTxMouseArea.mouseY).y - registeredZone.height/2
                }
            }
        ]

        // zone 내의 mouseArea 삭제
        MouseArea{
            onClicked:{

            }
        }


    }

    MouseArea {
        anchors.fill: parent
        id: viewRegisteredTxMouseArea
        visible: viewRegisteredTxZones.mode == "setup"

        onReleased: {
            // drag 시 잔상이 남는 현상을 제거 하기 위해 화면 강제 업데이트 시킴
            viewRegisteredTxZonesWnd.clip = false;
            viewRegisteredTxZonesWnd.clip = true;
            setupWnd.clip = false;
            setupWnd.clip = true;


            if( Functions.isPtInRegisteredTxZones(viewRegisteredTxZones, mouseX, mouseY) != true ){
//                console.debug("remove release index " + viewRegisteredTxZones.indexDrag);
                cppInterface.removeTxRegisteredZones(viewRegisteredTxZones.indexDrag);
            }
            else{
                var targetIndex = viewRegisteredTxZones.indexAt(mouseX, mouseY);
//                console.debug( "target index " + targetIndex + " indexDrag " + viewRegisteredTxZones.indexDrag + " " + mouseX + " " + mouseY );
                cppInterface.moveTxRegisteredZones(viewRegisteredTxZones.indexDrag, targetIndex);
            }

            // 지울때 제대로 첫번째 row 가 제대로 지워지지 않는 문제가 있어서 다음과 같은 방법 사용
            viewRegisteredTxZones.model = 0;
            viewRegisteredTxZones.model = qmlModelRegisteredTxChannels;

            viewRegisteredTxZones.interactive = true;
            viewRegisteredTxZones.indexDrag = -1;
        }

        onPressed: {
            viewRegisteredTxZones.interactive = false;
            // 아래 루틴엔 버그 있음.
//            viewRegisteredTxZones.indexDrag = viewRegisteredTxZones.indexAt(mouseX +( viewRegisteredTxZones.visibleArea.xPosition * viewRegisteredTxZones.contentWidth),
//                                                                             mouseY +(viewRegisteredTxZones.visibleArea.yPosition * viewRegisteredTxZones.contentHeight));
            viewRegisteredTxZones.indexDrag = viewRegisteredTxZones.indexAt(mouseX + viewRegisteredTxZones.contentX,
                                                                            mouseY +viewRegisteredTxZones.contentY);
        }

    }

}
