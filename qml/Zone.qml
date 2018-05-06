import QtQuick 2.0
import "functions.js" as Functions

// 바로 Flipable 로 시작하지 않고 Item 으로 시작하는 이유는
// GirdView 의 component 로서 parent 가 바뀔수 있기 때문에 root Item 의 Parent 가 바뀌지 않게 하기 위함.
Item{
    id: zone

    //  model 데이터를 binding 함.
    property bool   editMode        : false
    property alias  color           : frontZone.color
    property bool   flipped         : false


    property string name            : Name
    property string danteName       : DanteName
    property string deviceType      : DeviceType
    property string channelNo       : ChannelNo
    property string primaryIP       : PrimaryIP
    property string secondaryIP     : SecondaryIP
    property string selected        : Selected
    property string loopback        : Loopback
    property string connection      : Connection
    property string deviceColor     : Color
    property string disabled        : Disabled
    property string txLabels        : TxLabels
    property string rxVolume        : RxVolume
    property string rxSubscription  : RxSubscription
    property string rxProcessing    : RxProcessing
    property alias  accessFlipableZone : flipableZone


    onFlippedChanged: {
        settingPage.danteName = zone.danteName;
    }


    Rectangle{
        anchors.fill: parent
        color: "black"
        opacity: 0.5

    }

    Flipable {
        id: flipableZone
        // front 의 경우는 정렬을 위해 anchors.fill 해서 margin 을 사용
        // back 의 경우는 화면을 전체로 채워야 하며, width, height animation 을 사용해야 하므로 width 직접 지정.
        property int    cellAngle           : 0
        width: parent.width
        height: parent.height


        front : Rectangle {
            id: frontZone
            color: "lightblue"
            anchors.fill: parent
            anchors.margins: 3
            border.color: zone.selected == "true" ? "yellow" : "black"
            border.width: zone.selected == "true" ? 5 : 1
            radius: 5
            smooth: true

            MouseArea {
                id: frontZoneMouseArea
                anchors.fill: parent;
                onClicked: {
//                    console.debug( zone.deviceType + " " + index);
                    if( editMode == true ){
                        zone.flipped = !zone.flipped;
                    }
                    else{
                        if( zone.deviceType == "RX")
                            cppInterface.setRxZoneSelected(index, zone.selected == "true" ? false : true );
                        else if( zone.deviceType == "TX")
                            cppInterface.setTxZoneSelected(index, zone.selected == "true" ? false : true )
                        else{
                            cppInterface.setRegisteredTxZonesSelected(index, zone.selected == "true" ? false : true );
                        }
                    }
                }
            }
            Component.onCompleted: {
                if( zone.deviceType == "TX"  || zone.deviceType == "REGISTEREDTX")
                {
                    imgCheck.opacity = 1;
                    imgloopback.opacity = 0;
                    txtExSubscription.visible = false;
                }
                if( zone.deviceType == "RX")
                {
                    imgCheck.opacity = 0;
                    txtExSubscription.visible = true;
                }
            }

            Shine{}


            Rectangle{
                id: processing
                anchors.top: parent.top
                anchors.bottom: frontLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                radius: 5
                color: "black"
                z : zone.z + 1
                opacity: {
                    if ( zone.rxProcessing == "true" )
                        return 0.7
                    else
                        return 0
                }
                Image{
                    id: imgProcessing
                    smooth: true
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/image/clock_256.png"

                }
            }

            Rectangle{
                id: warning
                anchors.top: parent.top
                anchors.bottom: frontLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                radius: 5
                color: "black"
                z : processing.z + 3
                opacity: {
                    if ( zone.connection == "false" )
                        return 1
                    else
                        return 0
                }
                Image{
                    id: imgWarning
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "qrc:/image/warning_256.png"
                }
            }
            Rectangle{
                id: deviceConflict
                anchors.top: parent.top
                anchors.bottom: frontLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                radius: 5
                color: "black"
                z : processing.z + 2
                opacity: {
                    if( danteName.indexOf(")") == -1 )
                        return 0
                    else
                        return 1
                }
                Image{
                    id: imgDeviceConflict
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "qrc:/image/blue_warning_256.png"
                }
            }



            Rectangle{
                id: disabled
                anchors.top: parent.top
                anchors.bottom: frontLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                radius: 5
                color: "black"
                z : warning.z - 1
                opacity: {
                    if ( zone.disabled == "true" )
                        return 0.8
                    else
                        return 0
                }
                Image{
                    id: imgDisabled
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    anchors.fill: parent
                    source: "qrc:/image/disabled_256.png"
                }
            }

            Item {
                id: txtExSubscription
                anchors.top: parent.top
                anchors.bottom: frontLabel.top
                anchors.left: parent.left
                anchors.right: parent.right
                z: normal.z + 1



                Text{
                    id: subscriptionText
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: parent.width /15
                    anchors.leftMargin: parent.width /15

                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight

                    font.pointSize: {
                        if ( txtExSubscription.height / 4> 0 )
                            return txtExSubscription.height /4;
                        else
                            return 1;
                    }
                    font.bold: true
                    color: "light blue"
                    text: {
                        if ( zone.deviceType == "RX" )
                            return  zone.rxSubscription;
                        else
                            return "";
                    }

                    Rectangle{
                        radius: 5
                        z: subscriptionText.z -1
                        anchors.left: parent.left
                        anchors.right: parent.right
                        visible: zone.rxSubscription != ""
                        anchors.fill: parent
                        color: "green"
                        opacity: 0.8


                    }


                }
            }

            Rectangle{
                id: leftBand
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: parent.width / 15
                radius: 5
                color: deviceColor
            }


            Row{
                id: normal
                anchors.topMargin: 5
                anchors.top: parent.top
                anchors.left: leftBand.right
                anchors.right: parent.right
                anchors.bottom: frontLabel.top


                Item{

                    width: parent.width /3
                    height: parent.height
                    Image{
                        id: imgCheck
                        visible: zone.selected
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                        source: "qrc:/image/navigation_check_64.png"
                    }
                }

                Item{
                    width: parent.width /3
                    height: parent.height
                    Image{
                        id: imgOnAir

                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent


                        opacity: zone.deviceType == "RX" ? 0.8 : 1
                        source: {
                            if( zone.deviceType == "RX" )
                            {
                                return "qrc:/image/audio_64.png";
                            }
                            else
                            {
                                return "qrc:/image/volume_ok.png";
                            }
                        }
                    }
                }

                Item {
                    width: parent.width /3
                    height: parent.height
                    Image{
                        id: imgloopback
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent
                        opacity: {
                            if( zone.loopback == "true" )
                                return 1
                            else
                                return 0.15

                        }
                        source: {
                            return "qrc:/image/reload_64.png";
                        }
                    }
                }


            }

            Rectangle {

                id: frontLabel
                color: "black";
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height / 4
                clip: true
                radius: 5
                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight

                    color: "white";
                    font.bold: true
                    font.pointSize: frontLabel.height - 4
                    text: zone.name
                }

                Shine{
                    visible: zone.selected
                }
            }

        }

        back : Rectangle {
            id: backZone
            smooth: true
            color: "#DA111316";
            opacity: 0.7
            border.color: zone.selected == "true" ? "yellow" : "lightgray"
            border.width: 4

            width: parent.width
            height: parent.height

            anchors.margins: 3
            radius: 10

            ZoneSettingPage{
                id: settingPage
                anchors.fill: parent
                deviceType: zone.deviceType
                flipped: zone.flipped

                titleText : deviceType =="TX" ? qsTr("Setting: Source") + "" :
                                                qsTr("Setting: Zone") + ""
                description: deviceType == "TX" ?
                                 qsTr("It can be set device's name." )  + "" :
                                 qsTr("It can be set device's name, loopback.") + ""
                iconSource: deviceType == "TX" ?
                                "qrc:/image/setting_source_128.png" :
                                "qrc:/image/setting_zone_128.png"


                volumeSliderWidth: 500
                volume: zone.rxVolume
                name: zone.name

                subscription: zone.rxSubscription
                ip: zone.primaryIP
                channelNo: zone.channelNo

                loopback: zone.loopback == "true" ? true : false

                onTryLoopbackSliderMove: {
                    cppInterface.setLoopback(zone.danteName, on);
                }
                onBtnCloseClicked: {
                    zone.flipped = !zone.flipped;
                    timerSetupPanelCoverShow.start();


                }
                onBtnDanteNameChanged: {
                    zone.flipped = !zone.flipped;
                    cppInterface.setDanteName(zone.danteName, danteName);
                }
            }
        }

        transform: Rotation {
            id: rotation
            origin.x: flipableZone.width/2
            origin.y: flipableZone.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: flipableZone.cellAngle    // the default angle
        }

        states: [
            State {
                // parentChange 안에 일반 property 변경 사항을 다 적용해야함.
                name: "back"; when:zone.flipped
                ParentChange{
                    target: flipableZone;
                    parent: setupContainer;
                    width: parent.width
                    height: parent.height
                    x: 0
                    y: 0
                }
                // parent Change 하면서 cellAngle 의 경우 변경 전
                // parent 나 변경 후 parent ,에 cellAngle 가 존재 하지 않으므로 따로 처리
                PropertyChanges {
                    target: flipableZone
                    cellAngle: 180
                }
            }
        ]

        transitions: [
            Transition {
                to: "back"
                reversible: true
                ParentAnimation{
                    via: setupContainer
                    PropertyAnimation{ target: flipableZone; properties: "x,y,width,height,cellAngle"; duration: 500}
                }

            }
        ]
        state: "front"
    }


    GridView.onAdd: SequentialAnimation {
                 NumberAnimation { target: zone; property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
    }

    GridView.onRemove: SequentialAnimation {
                 PropertyAction { target: zone; property: "GridView.delayRemove"; value: true }
                 NumberAnimation { target: zone; property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
                 PropertyAction { target: zone; property: "GridView.delayRemove"; value: false }
    }
}
