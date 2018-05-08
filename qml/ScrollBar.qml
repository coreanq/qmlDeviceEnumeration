import QtQuick 2.0


BorderImage {
    property variant target

    source: qmlAssetsPath + "scrollbar.png"
    border {left: 0; top: 3; right: 0; bottom: 3}
    width: 30


    anchors {top: target.top; bottom: target.bottom; right: target.right }
    visible: (track.height == slider.height) ? false : true //TODO: !visible -> width: 0 (but creates a binding loop)

    Item {
        anchors {fill: parent; }

        Image {
            id: upArrow
            source: qmlAssetsPath + "up-arrow.png"
            fillMode: Image.PreserveAspectFit
            anchors.top: parent.top
            width: 30
            height: 30
            smooth: true

            MouseArea {
            visible: false
                anchors.fill: parent
                onPressed: {
                    timer.scrollAmount = -20
                    timer.running = true;
                }
                onReleased: {
                    timer.running = false;
                }
                onClicked: {
                    target.contentY = Math.max(
                            0, Math.min(
                            target.contentY + scrollAmount,
                            target.contentHeight - target.height));
                }
            }
        }

        Timer {
            property int scrollAmount

            id: timer
            repeat: true
            interval: 50
            onTriggered: {
                target.contentY = Math.max(
                        0, Math.min(
                        target.contentY + scrollAmount,
                        target.contentHeight - target.height));
            }
        }

        Item {
            id: track
            anchors {top: upArrow.bottom; topMargin: 1; bottom: dnArrow.top;}
            width: parent.width

            MouseArea {
            visible: false
                anchors.fill: parent
                onPressed: {
                    timer.scrollAmount = target.height * (mouseY < slider.y ? -1 : 1)	// scroll by a page
                    timer.running = true;
                }
                onReleased: {
                    timer.running = false;
                }
            }

            BorderImage {
                id:slider

                source: qmlAssetsPath + "slider.png"
                border {left: 0; top: 3; right: 0; bottom: 3}
                width: parent.width

                height: Math.min(target.height / target.contentHeight * track.height, track.height)
                y: target.visibleArea.yPosition * track.height

                MouseArea {
                    anchors.fill: parent
            visible: false
                    drag.target: parent
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: track.height - height

                    onPositionChanged: {
                        if (pressedButtons == Qt.LeftButton) {
                            target.contentY = slider.y * target.contentHeight / track.height
                        }
                    }
                }
            }
        }
        Image {
            id: dnArrow
            width: 30
            height: 30
            fillMode: Image.PreserveAspectFit
            source: qmlAssetsPath + "dn-arrow.png"
            anchors.bottom: parent.bottom
            smooth: true
            MouseArea {
            visible: false
                anchors.fill: parent
                onPressed: {
                    timer.scrollAmount = 20
                    timer.running = true;
                }
                onReleased: {
                    timer.running = false;
                }
            }
        }
    }
}
