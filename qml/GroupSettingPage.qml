import QtQuick 1.1

Item {
    id: groupSettingPage

    property alias titleText: settingText.text
    property alias description: closeText.text
    property alias iconSource: icon.source

    property string name : ""
    property string sourceName: ""
    property bool flipped: false // 외부에서 입력받는 변수

    signal btnCloseClicked()
    signal btnGroupNameChanged(string name)


    // 배경이 클릭되지 않도록 처리
    MouseArea{
        anchors.fill: parent
    }

    onFlippedChanged: {
        if( flipped == true )
            txtGroupNameInput.text = name;
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
        smooth: true
        anchors.top:line.bottom
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 40
        source: "qrc:/image/setting_close_64.png"

        MouseArea{
            anchors.fill:parent
            onClicked:{
                groupSettingPage.btnCloseClicked();
            }
            onPressed:{
                close.scale = 1.5
            }
            onReleased:{
                close.scale = 1
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
        target: btnGroupNameOk;
        onClicked: {
//            console.debug("btnGroupNameOk is clicked ");
            groupSettingPage.btnGroupNameChanged(txtGroupNameInput .text);
        }
    }

    Column {
        id: namePanel
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30

        width: parent.width / 2
        spacing: 10


        //////////////////////////////////////////////////////////////////
        // groupName
        Row {
            spacing: 30
            height: 40
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter

            Item{
                id: txtGroupName
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
                    text: qsTr("Group name:") + mainWindow.emptyString
                }
            }

            BorderImage{
                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3 - btnGroupNameOk.width
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: "qrc:/image/textbox.svg"

                Item {
                     anchors.fill: parent

                     TextInput {
                         id: txtGroupNameInput
                         anchors.verticalCenter: parent.verticalCenter
                         anchors.left: parent.left
                         anchors.right: parent.right
                         anchors.margins: 10
                         font.family: "Helvetica"
                         font.pointSize: 14
                         focus: true
                         text: groupSettingPage.name
                         MouseArea{
                             anchors.fill: parent
                             onClicked:{
                                 txtGroupNameInput.forceActiveFocus();
                                 cppInterface.showVirtualKeyboard(true);
                             }
                         }

                     }
                }
            }
            Button {

                id: btnGroupNameOk
                width: 40
                height: 40
                text: qsTr("OK") + mainWindow.emptyString
            }
        }




        //////////////////////////////////////////////////////////////////////////
        // Source

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
                    text: qsTr("Source:") + mainWindow.emptyString
                }
            }


            BorderImage{

                property int value: 0
                border { left: 20; top: 20; right: 20; bottom: 20 }
                width: parent.width /4 * 3
                height: parent.height

                horizontalTileMode: BorderImage.Stretch
                verticalTileMode: BorderImage.Stretch
                source: "qrc:/image/textbox.svg"

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
                         text: groupSettingPage.sourceName
                     }
                }
            }

        }


    }
}
