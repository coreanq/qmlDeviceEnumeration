import QtQuick 2.0


Item {
    id: picker

    property int backImgWidth : 0
    property int leftCurrentIndex: leftBarrel.currentIndex
    property int rightCurrentIndex: rightBarrel.currentIndex

    property string leftCaption: ""
    property string rightCaption: ""

    property alias leftBarrelModel: leftBarrel.model
    property alias rightBarrelModel: rightBarrel.model

    property alias leftDelegate: leftBarrel.delegate
    property alias rightDelegate: rightBarrel.delegate

    Image{
        id: background
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height
        width: backImgWidth
        source: "qrc:/image/picker/double_picker_background.svg"


        Row {
            anchors.top : parent.top
            anchors.margins: 5
            width: parent.width

            height: 30

            Item {
                width: parent.width /2
                height: parent.height

                Text {
                    // 가운데 정렬하기 위함.
                    anchors.horizontalCenterOffset: 20
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: picker.leftCaption
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
            }
            Item {
                width: parent.width /2
                height: parent.height
                Text {
                    // 가운데 정렬하기 위함.
                    anchors.horizontalCenterOffset: -20
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: picker.rightCaption
                    font.pixelSize: 20
                    font.bold: true
                    color: "white"
                }
            }
        }

        Row{
            anchors.fill: parent

            PathView {
                id: leftBarrel
                clip: true
                property real itemHeight: 17
                y: 30
                width: parent.width /2
                height: parent.height - 40
                // current index 가 path view 가운데 위치하기 위함 .
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                pathItemCount: height/itemHeight
                delegate: picker.leftDelegate

//                dragMargin: leftBarrel.width
                model: leftBarrelModel

                path: Path {
                    startX: leftBarrel.x ; startY: -leftBarrel.itemHeight/2
                    PathLine { x: leftBarrel.x; y: leftBarrel.pathItemCount*leftBarrel.itemHeight + leftBarrel.itemHeight }
                }

                MouseArea {
                    id: leftTopArea
                    x: 57
                    y: 0
                    width:  parent.width - 65
                    height: 60
                    onClicked: {
                        leftBarrel.incrementCurrentIndex();
                    }

                }
                MouseArea {
                    id: leftBottomArea
                    x: 57
                    y: 82
                    width:  parent.width - 65
                    height: 60
                    onClicked: leftBarrel.decrementCurrentIndex()
                }


            }

            PathView {
                id: rightBarrel
                clip: true
                y: 30
                property real itemHeight: 17
                width: parent.width /2
                height: parent.height - 40

                // current index 가 path view 가운데 위치하기 위함 .
                preferredHighlightBegin: 0.5
                preferredHighlightEnd: 0.5
                pathItemCount: height/itemHeight
                delegate: picker.rightDelegate

//                dragMargin: rightBarrel.width
                model: rightBarrelModel

                path: Path {
                    startX: rightBarrel.x; startY: -rightBarrel.itemHeight/2
                    PathLine { x: rightBarrel.x; y: rightBarrel.pathItemCount*rightBarrel.itemHeight + rightBarrel.itemHeight }
                }

                MouseArea {
                    id: rightTopArea
                    x: 0
                    y: 0
                    width:  parent.width - 65
                    height: 60
                    onClicked: {
                        rightBarrel.incrementCurrentIndex();
                    }

                }
                MouseArea {
                    id: rightBottomArea
                    x: 0
                    y: 82
                    width:  parent.width - 65
                    height: 60
                    onClicked: rightBarrel.decrementCurrentIndex()
                }



            }
        }
        Image {
            id: reflex
            anchors.fill: parent
            source: "qrc:/image/picker/double_picker_reflex.svg"
        }
    }




}
