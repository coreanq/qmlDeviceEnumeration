import QtQuick 2.0

Item {
    id: settingPage

    property string deviceType : ""
    property alias titleText: settingText.text
    property alias description: closeText.text
    property alias iconSource: icon.source
    property string type : ""

    property int    volumeSliderWidth
    property int    volume: 0
    property string name : ""
    property string danteName : ""
    property bool   loopback: false
    property string ip : ""
    property string subscription: ""
    property string channelNo : ""


    // settingPage -> mainWindow
    signal tryLoopbackSliderMove(bool on)
    signal btnCloseClicked()
    signal btnNameChanged(string name);
    signal btnDanteNameChanged(string danteName);

    onLoopbackChanged : {
        slideSwitch.enabled = loopback;
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
        id: close
        anchors.top:line.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
        source: qmlAssetsPath + "setting_close_64.png"

        MouseArea{
            anchors.fill:parent
            onClicked:{
                settingPage.btnCloseClicked();
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
            settingPage.btnDanteNameChanged(txtDanteNameInput.text);
        }
    }
    Connections {
        target: btnNameOk;
        onClicked: {
//            console.debug("btnNameOk is clicked ");
            settingPage.btnNameChanged(txtNameInput.text);
        }
    }

    Column {
        id: namePanel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30


        width: volumeSliderWidth // volume 슬라이더와 마찬가지로 값을 고정해야함.
        spacing: 10


        //////////////////////////////////////////////////////////////////////////
        // Name
        Row {
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                id: txtName
                width: parent.width
                height: parent.height
                Text {
                    anchors.centerIn: parent
                    color: "lightblue"
                    font {
                        pointSize: 18
                        bold: true
                    }
                    text: settingPage.name
                }
            }

            Button {
                id: btnNameOk
                visible: false
                width: 40
                height: 40
                text: "OK"
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
                    text: "Dante name:"
                }
            }

            BorderImage{

                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3 - btnDanteNameOk.width
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: qmlAssetsPath + "textbox.svg"

                Item {
                     anchors.fill: parent

                     TextInput {
                         id: txtDanteNameInput
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 10
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: settingPage.danteName
                     }
                }
            }
            Button {

                id: btnDanteNameOk
                width: 40
                height: 40
                text: "OK"
            }
        }

        /////////////////////////////////////////////////////////////
        // channel no
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
                    text: "Channel No.:"
                }
            }

            BorderImage{

                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: qmlAssetsPath + "textbox.svg"

                Item {
                     anchors.fill: parent
                     Text {
                         id: txtSubscription
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 10
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: settingPage.channelNo
                     }
                }
            }

        }




        /////////////////////////////////////////////////////////////
        // Subscription
        Row {
            visible: settingPage.deviceType == "RX"
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
                    text: "Subscription:"
                }
            }

            BorderImage{

                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: qmlAssetsPath + "textbox.svg"

                Item {
                     anchors.fill: parent
                     Text {
                         id: txtChannelNo
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 10
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: settingPage.subscription
                     }
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
                    text: "IP&Port:"
                }
            }

            BorderImage{

                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: qmlAssetsPath + "textbox.svg"

                Item {
                     anchors.fill: parent
                     Text {
                         id: txtIp
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 10
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: settingPage.ip
                     }
                }
            }
        }



        ////////////////////////////////////////////////////////////////
        // loopback
        Row {
            visible: settingPage.deviceType == "RX"
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

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
                    text: "Loopback:"
                }
            }


            Row {
                width: parent.width /4 * 3
                height: parent.height

                Item{
                    id: txtOff
                    width: parent.width /4
                    height: parent.height

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        font {
                            pointSize: 18
                            bold: true
                        }
                        text: "OFF"
                    }
                }

                SlideSwitch{
                    id: slideSwitch
                    width: parent.width /2
                    height: parent.height
                    anchors {
                        verticalCenter: parent.verticalCenter
                        top: parent.top
                        topMargin: (slideSwitch.height / 2) - (height / 2)
                    }

                    onTrySliderMove: {
                        settingPage.tryLoopbackSliderMove(on);
                    }

                    buttonImageOn: qmlAssetsPath + "beryl/knob_on.svg"
                    buttonImageOff: qmlAssetsPath + "beryl/knob_off.svg"
                    backgroundImageNormal: qmlAssetsPath + "beryl/background.svg"
                    backgroundImageHover: qmlAssetsPath + "beryl/background_hover.svg"
                }


                Item{
                    id: txtOn
                    width: parent.width /4
                    height: parent.height

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        color: "white"
                        font {
                            pointSize: 18
                            bold: true
                        }
                        text: "ON"
                    }
                }
            }
        }
    }


    ActualValueSlider {
        id: volumeSlider
        visible: settingPage.deviceType == "RX"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: namePanel.bottom
        value : settingPage.volume
        needleVisible: false
        height: parent.height
        width: volumeSliderWidth // 이값은 고정값이여야함.
        valueSliderHeight: 54

        balloonHeight: 54
        balloonTriangleHeight: 24
        backgroundImage: qmlAssetsPath + "slider/weathergod_scale.png"
        balloonImage: qmlAssetsPath + "slider/balloon/balloon_minsize.svg"
        balloonTriangleImage: qmlAssetsPath + "slider/balloon/balloon_triangle.svg"
        knobImagePressed: qmlAssetsPath + "slider/button_pressed.svg"
        knobImageNormal: qmlAssetsPath + "slider/button_normal.svg"
        needleImage: qmlAssetsPath + "slider/needle.svg"

        focusVisible: false
        focusImage: qmlAssetsPath + "slider/focus.svg"

        // Every value change will change the ballontext
        onValueChanged: {
            balloonText = value.toString();
        }
    }

}
