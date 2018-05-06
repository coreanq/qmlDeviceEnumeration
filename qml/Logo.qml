import QtQuick 1.1

Flipable {
    id: logo

    width: imgCona.width
    height: imgCona.height


    property bool flipped: false
    property int xAxis: 0
    property int yAxis: 1
    property int zAxis: 0
    property int angle: 0


    front: Image {
        id: imgCona;
        fillMode: Image.PreserveAspectFit
        source: "qrc:/image/logo_interm_128.png";
        smooth: true
    }
    back: Image {
        fillMode: Image.PreserveAspectFit
        source: "qrc:/image/logo_interm_128.png";
        smooth: true
    }


    state: "front"
    MouseArea { anchors.fill: parent; onClicked: logo.flipped = !logo.flipped }

    transform: Rotation {
        id: rotation; origin.x: logo.width / 2; origin.y: logo.height / 2
        axis.x: logo.xAxis; axis.y: logo.yAxis; axis.z: logo.zAxis
        angle: logo.angle
    }

    states: State {
        name: "back"; when:!logo.flipped
        PropertyChanges { target: logo; angle: 180 }
    }

    Timer{
        interval: 2000
        repeat: true
        running: true
        onTriggered: {
            logo.flipped = !logo.flipped;
        }
    }

    transitions: Transition {
        ParallelAnimation {
            NumberAnimation { target: logo; properties: "angle"; duration: 600 }
            SequentialAnimation {
                NumberAnimation { target: logo; property: "scale"; to: 0.75; duration: 300 }
                NumberAnimation { target: logo; property: "scale"; to: 1.0; duration: 300 }
            }
        }
    }

}
