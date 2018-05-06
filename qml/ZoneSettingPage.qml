import QtQuick 2.0

Item {
    id: zoneSettingPage

    property string deviceType : ""
    property alias titleText: settingText.text
    property alias description: closeText.text
    property alias iconSource: icon.source

    property int    volumeSliderWidth
    property int    volume: 0
    property string name : ""
    property string danteName : ""
    property bool   loopback: false
    property string ip : ""
    property string subscription: ""
    property string channelNo : ""
    property bool flipped: false // 외부에서 연결되는 변수


    // zoneSettingPage -> mainWindow
    signal tryLoopbackSliderMove(bool on)
    signal btnCloseClicked()
    signal btnDanteNameChanged(string danteName);

    onLoopbackChanged : {
        slideSwitch.enabled = loopback;
    }

    // 배경이 클릭되지 않도록 처리
    MouseArea{
        anchors.fill: parent
    }

    onFlippedChanged: {
        if( flipped == true ){
            txtDanteNameInput.text = danteName;
            txtNameInput.text = name;
        }
    }

    Text {
        id: settingText

        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        font {
            pointSize: 19
            bold: true
        }
        color: "white"
    }

    Rectangle {
        id: line
        width: parent.width - 40
        radius: 2
        color: "white"
        height: 4
        border.color: "lightGray"
        border.width: 1
        anchors {
            top: settingText.bottom
            topMargin: 5
            left: parent.left
            leftMargin: 20
        }
    }

    Image {
        id: icon
        anchors.top:line.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 40
    }


    Image {
        id: imgClose
        smooth: true
        anchors.top:line.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
        source: "qrc:/image/setting_close_64.png"

        MouseArea{
            anchors.fill:parent
            onClicked:{
                zoneSettingPage.btnCloseClicked();
            }
            onPressed:{
                imgClose.scale = 1.5
            }
            onReleased:{
                imgClose.scale = 1
            }
        }
    }

    // refresh 버튼
    Image {
        id: imgRefresh
        smooth: true
        anchors.top: imgClose.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
         source: "qrc:/image/refresh_64.png"

        MouseArea{
            anchors.fill: parent
            onPressed:{
                imgRefresh.scale = 1.5;
                cppInterface.onBtnCheckDeviceInfoClicked();
            }
            onReleased:{
                imgRefresh.scale =1;
            }
        }
    }


    Text {
        id: closeText
        color: "white"
        font {
            pointSize: 18
            bold: false
        }
        anchors.left: icon.right
        anchors.leftMargin: 40
        anchors.top: settingText.bottom
        anchors.topMargin: 30
    }



    Connections {
        target: btnDanteNameOk;
        onClicked: {
//            console.debug("btnDanteNameOk is clicked ");
            zoneSettingPage.btnDanteNameChanged(txtDanteNameInput.text);
        }
    }
    ////////////////////////////////////////////////////////////////
    // loopback
    Column{
        visible: zoneSettingPage.deviceType == "RX"
        spacing: 30
        height: 40
        width: icon.width
        anchors.topMargin: 50
        anchors.top: icon.bottom
        anchors.horizontalCenter: icon.horizontalCenter

        Item{
            id: txtLoopback
            width: parent.width /4
            height: parent.height
            Text {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                color: "white"
                font {
                    pointSize: 18
                    bold: true
                }
                text: qsTr("Loopback") + ""
            }
        }


        Row {
            width: parent.width
            height: parent.height

            Item{
                id: txtOff
                width: parent.width /5
                height: parent.height

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 10
                        bold: true
                    }
                    text: "OFF"
                }
            }

            SlideSwitch{
                id: slideSwitch
                width: parent.width /5 *3
                height: parent.height
                anchors {
                    verticalCenter: parent.verticalCenter
                    top: parent.top
                    topMargin: (slideSwitch.height / 2) - (height / 2)
                }

                onTrySliderMove: {
                    zoneSettingPage.tryLoopbackSliderMove(on);
                }

                buttonImageOn: "qrc:/image/beryl/knob_on.svg"
                buttonImageOff: "qrc:/image/beryl/knob_off.svg"
                backgroundImageNormal: "qrc:/image/beryl/background.svg"
                backgroundImageHover: "qrc:/image/beryl/background_hover.svg"
            }


            Item{
                id: txtOn
                width: parent.width /5
                height: parent.height

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 10
                        bold: true
                    }
                    text: "ON"
                }
            }
        }
    }




    Column {
        id: namePanel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 20

        width: volumeSliderWidth // volume 슬라이더와 마찬가지로 값을 고정해야함.
        spacing: 10


        //////////////////////////////////////////////////////////////////////////
        // Name

        Item {
            height: 40
            width: parent.width
            Text {
                id: txtNameInput
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                anchors.margins: 20
                font.family: "Helvetica"
                font.pointSize: 18
                focus: true
                text: zoneSettingPage.name
                color: "yellow"
            }
        }


        //////////////////////////////////////////////////////////////////
        // danteName
        Row {
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                id: txtDanteName
                width: parent.width /4
                height: parent.height
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 18
                        bold: true
                    }
                    text: qsTr("Dante name:") + ""
                }
            }

            BorderImage{

                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3 - btnDanteNameOk.width
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: "qrc:/image/textbox.svg"

                Item {
                     anchors.fill: parent

                     TextInput {
                         id: txtDanteNameInput
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 20
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: zoneSettingPage.danteName
                         //아스키 코드내의 문자만 입력 가능하게 함.
                         // dns 스펙상
                         // A-Z, a-z, 0-9, - 만 입력 가능
                         // 스펙상 널문자 포함 32자까지 입력 가능
                         validator: RegExpValidator { regExp: /[A-Za-z0-9-]{0,31}/}

                         MouseArea{
                             anchors.fill: parent
                             onClicked:{
                                 txtDanteNameInput.forceActiveFocus();
                                 cppInterface.showVirtualKeyboard(true);
                             }
                         }
                     }
                }
            }
            Button {
                id: btnDanteNameOk
                width: 40
                height: 40
                text: qsTr("OK") + ""
            }
        }

        /////////////////////////////////////////////////////////////
        // channelNo
        Row {
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                width: parent.width /4
                height: parent.height
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 18
                        bold: true
                    }
                    text: qsTr("ChannelNo:") + ""
                }
            }

            Item{
                width: parent.width /4 * 3
                height: parent.height

                Text {
                    id: txtChannelNO
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20

                    font.family: "Helvetica"
                    font.pointSize: 14
                    text: zoneSettingPage.channelNo
                    color: "white"
                }
            }

        }
        /////////////////////////////////////////////////////////////
        // Subscription
        Row {
            visible: zoneSettingPage.deviceType == "RX"
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                width: parent.width /4
                height: parent.height
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 18
                        bold: true
                    }
                    text: qsTr("Subscription:") + ""
                }
            }

            Item{
                width: parent.width /4 * 3
                height: parent.height

                Text {
                    id: txtSubscription
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20

                    font.family: "Helvetica"
                    font.pointSize: 14
                    text: zoneSettingPage.subscription
                    color: "white"
                }
            }
        }

        ///////////////////////////////////////////////////////////////////
        // IP
        Row {
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                width: parent.width /4
                height: parent.height
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font {
                        pointSize: 18
                        bold: true
                    }
                    text: qsTr("IP&Port:") + ""
                }
            }

            Item{
                width: parent.width /4 * 3
                height: parent.height

                Text {
                    id: txtIp
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20

                    font.family: "Helvetica"
                    font.pointSize: 14
                    text: zoneSettingPage.ip
                    color: "white"
                }
            }
        }
    }
    ActualValueSlider {
        id: volumeSlider

        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: namePanel.bottom
        value : zoneSettingPage.volume
        needleVisible: false
        height: parent.height
        width: volumeSliderWidth // 이값은 고정값이여야함.
        valueSliderHeight: 54
        balloonHeight: 54
        balloonTriangleHeight: 24
        backgroundImage: "qrc:/image/slider/weathergod_scale.png"
        balloonImage: "qrc:/image/slider/balloon/balloon_minsize.svg"
        balloonTriangleImage: "qrc:/image/slider/balloon/balloon_triangle.svg"
        knobImagePressed: "qrc:/image/slider/button_pressed.svg"
        knobImageNormal: "qrc:/image/slider/button_normal.svg"
        needleImage: "qrc:/image/slider/needle.svg"

        focusVisible: false
        focusImage: "qrc:/image/slider/focus.svg"

        // Every value change will change the ballontext
        onValueChanged: {
            balloonText = value.toString();
        }
    }
}
