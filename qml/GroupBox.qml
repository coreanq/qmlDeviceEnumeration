import QtQuick 1.1

Rectangle {

    id: groupBox

    property color baseColor: "green"
    property string name: ""

    anchors.fill: parent
    radius: 10
    border.color: baseColor
    border.width: 6
    z: mainWnd.z-1

    Text {

        text: groupBox.name
        font.bold: true
        font.pixelSize: 15
        anchors.top: parent.top
        anchors.left: parent.left

        anchors.topMargin: 5
        anchors.leftMargin:10

    }

    opacity: 0.2
    gradient: Gradient {
           GradientStop { position: 0; color: baseColor }
           GradientStop { position: 1; color: "transparent" }
    }

}
