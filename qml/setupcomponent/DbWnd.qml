import QtQuick 2.0
import "../"

Item {
    id: dbWnd

    ////////////////////////////////////////////////////
    // 텍스트 라벨과 텍스트 input ui 를 구현하기 위한 템플릿
    Component {
         id: comLblTxt
         Rectangle{
             id: lblTxt
             property alias text : lbl.text
             radius: 10
             color: "darkblue"
             smooth: true

             Text {
                 id: lbl
                 color: "white"
                 anchors.centerIn: parent
                 font.family: "Helvetica"
                 font.pointSize: 12
             }
             Shine{}
         }
    }

    Component {
         id: comTxtInput
         Rectangle{
             id: txtInput
             property alias echoMode : txt.echoMode
             property alias text     : txt.text
             property alias validator : txt.validator
             signal editingFinished(string data)
             smooth: true
             radius: 10
             color: "palegreen"

             TextInput {
                 id: txt
                 anchors.verticalCenter: parent.verticalCenter
                 anchors.left: parent.left
                 anchors.right: parent.right
                 anchors.margins: 10

                 font.family: "Helvetica"
                 font.pointSize: 12
                 focus: true

                 MouseArea{
                     anchors.fill: parent
                     onClicked:{
//                         console.debug("mouse area clicked" );
                         txt.forceActiveFocus();
//                         cppInterface.showVirtualKeyboard(true);
                     }
                 }

                 onActiveFocusChanged: {
                     if( activeFocus ){
//                         console.debug("gain focus " );
                     }
                     else {
//                         console.debug("lose focus " + txt.text )
                         txtInput.editingFinished(txt.text);
                     }
                 }
             }
             Shine{}
         }
    }


    // 초기 db 에서 로딩된 값을 qml 로 읽어 오기 위함.
//    Connections {
//        target: cppInterface
//        onSgServerIPChanged:{
////               console.debug("serverip changed");
//            txtServerIP.item.text = str;
//        }
//    }


    Connections {
        target: btnDBDownload;
        onClicked: {
            // 에디트 박스 포커스를 잃게 해서 데이터가 저장되도록 함.
            btnDBDownload.focus = true;
            cppInterface.onBtnDBDownloadClicked();
        }
    }
    Connections {
        target: btnLogShow;
        onClicked: {
            // 에디트 박스 포커스를 잃게 해서 데이터가 저장되도록 함.
            focus = true;
            cppInterface.onBtnLogShowClicked();
        }
    }
    Connections {
        target: txtServerIP.item
        onEditingFinished: {
            cppInterface.onTxtServerIPEditingFinished(data);
        }
    }
    Connections {
        target: btnDbManagement;
        onClicked: {
            focus = true
            cppInterface.onBtnDbManagementClicked();
        }
    }
    Connections {
        target: btnDBInitialize
        onClicked: {
            focus = true
            cppInterface.onBtnDbInitializeClicked();
        }
    }

    Connections {
        target: btnDBSave
        onClicked: {
            focus = true
            cppInterface.onBtnDbBackupClicked();
        }
    }

    Connections {
        target: btnDBLoad
        onClicked: {
            focus = true
            cppInterface.onBtnDbRestoreClicked();
        }
    }








    // 기타 설정 창
    Item{
        id: etcSettingWnd
        anchors.fill: parent


        Item {
            id: networkInterfacesWnd

            anchors.leftMargin: (parent.width- networkInterfacesWnd.width - dbManagementWnd.width) /2
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: (parent.height - networkInterfacesWnd.height) /2

            Rectangle{
                anchors.fill: parent
                opacity: 0.5
            }

            // dante api 에서 지원이 안되므로 잠정 삭제
            width: parent.width /5 *2
//            width: 0
            height: parent.height /3 *2


            // description
            Row {
                id: descriptionWnd
                height: imgRefresh.height + 20// 이미지와 같은 높이로 만듬.
                width: parent.width

                Text{
                    id: description
                    anchors.top: parent.top
                    height: parent.height
                    width: parent.width - imgRefresh.width
                    font.pointSize: 12
                    font.bold: true
                    wrapMode : Text.WordWrap
                    text: qsTr("Select the network interface(for primary interface) that the s-con will use to communicate with other DAC-288 devices:") + ""
                }
                Image{
                    id: imgRefresh
                    smooth: true
                    anchors.top: parent.top
                    width: sourceSize.width
                    height: sourceSize.height
                    source: "../" + qmlAssetsPath + "refresh_64.png"
                    MouseArea{
                        anchors.fill:parent
                        onClicked:{
                            cppInterface.refreshNetworkInterfaces();
                        }
                        onPressed:{
                            imgRefresh.scale = 1.5
                        }
                        onReleased:{
                            imgRefresh.scale = 1
                        }
                    }
                }
            }

            ListView {
                id: viewNetworkInterfaces
                clip: true
                pressDelay: zoneWnd.pressDelay

                width: parent.width
                height: parent.height - descriptionWnd.height
                anchors.top : descriptionWnd.bottom
                anchors.left: parent.left
                model: qmlModelNetworkInterfaces
                delegate: NetworkInterface{}
            }
        }


        Rectangle{
            anchors.left : networkInterfacesWnd.right
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: (parent.height - dbManagementWnd.height) /2
            width: parent.width /5 * 2
            height: parent.height /3 * 2
            opacity: 0.5
        }

        Column {
            id: dbManagementWnd
            anchors.left : networkInterfacesWnd.right
            anchors.leftMargin: 50
            anchors.top: parent.top
            anchors.topMargin: (parent.height - dbManagementWnd.height) /2
            width: parent.width /5 * 2
            height: parent.height /3 * 2
            spacing: 4

            Button {
                id: btnDBDownload
                focus: true
                text: qsTr("DB Download from server") + ""

                height: 50
                width: parent.width - parent.spacing

            }

            // ServerIP
            Row {
                spacing: 4
                height: 50
                width: parent.width

                Loader{
                    id: lblServerIP
                    height: parent.height
                    width: parent.width /3  - parent.spacing
                    sourceComponent: comLblTxt
                    onLoaded:{
                        item.text = qsTr("Server IP") + ""
                    }
                }
                // serverip 입력창.
                Loader{
                    id: txtServerIP
                    height: parent.height
                    width: parent.width /3 * 2  - parent.spacing
                    sourceComponent: comTxtInput
                    onLoaded:{
//                        txtServerIP.item.validator =  cppInterface.ipValidator();
                    }



                 }
            }

            Row {
                spacing: 4
                height: 50
                width: parent.width
                // DB management 버튼
                Button {
                    id: btnDbManagement
                    width: parent.width / 2  - parent.spacing
                    text: qsTr("DB Management") + ""
                }

                // 로그 확인 버튼
                Button {
                    id: btnLogShow
                    width: parent.width / 2  - parent.spacing
                    text: qsTr("Log View") + ""
                }
            }


            Text{
                height: 50
                wrapMode : Text.WordWrap
                font.bold : true
                font.pointSize: 12
                color: "red"
                width: parent.width
                text: qsTr("It is for a computer that the database is installed. Clicking of this button will initialize the data and database setting.") + ""
            }
            // DB initialize button
            Button {
                id: btnDBInitialize
                focus: true
                text: qsTr("DB Initialize") + ""
                height: 50
                width: parent.width - parent.spacing
            }

            Row {
                spacing: 4
                height: 50
                width: parent.width
                // DB Save 버튼
                Button {
                    id: btnDBSave
                    width: parent.width / 2  - parent.spacing
                    text: qsTr("DB Backup") + ""
                }

                // DB Load 버튼
                Button {
                    id: btnDBLoad
                    width: parent.width / 2  - parent.spacing
                    text: qsTr("DB Restore") + ""
                }
            }







        }
    }
}
