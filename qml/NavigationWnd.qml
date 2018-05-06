import QtQuick 1.1

Item {
    id: navigationWnd

    property int imgSize;

    Component.onCompleted:{
        navigationWnd.state = "control"
        imgSize = imgControl.height + txtControl.height;
        cppInterface.onBtnCheckDeviceInfoClicked();
    }

    Timer {
        id: timerReload;
        property int count : 10
        interval: 1000;
        running: false;
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if( count > 0 )
                txtCount.text = count.toString();
            else
            {
                count = 10;
                txtCount.text = "";
                timerReload.stop();
            }
            count--;
        }
    }

    Row{
        spacing: 20
        anchors.left: parent.left
        Column{
            Image {
                id: imgControl
                source: "qrc:/image/navigation_control_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgControl.scale = 1.3
                        navigationWnd.state = "control";
                    }
                    onReleased:{
                        imgControl.scale =1
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    smooth: true
                    radius: 10
                    color: "lightgreen";
                    opacity: {
                        if( navigationWnd.state == "control")
                            return 0.5;
                        else
                            return 0;
                    }
                }
            }

            Text{
                id: txtControl
                anchors.horizontalCenter: imgControl.horizontalCenter
                text: qsTr("CONTROL") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }
        }
        Column{
            Image{
                id: imgSetup
                source: "qrc:/image/navigation_setup_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgSetup.scale = 1.3;
                        navigationWnd.state = "setup";

                    }
                    onReleased:{
                        imgSetup.scale =1
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    smooth: true
                    color: "lightgreen";
                    opacity: {
                        if( navigationWnd.state == "setup")
                            return 0.5
                        else
                            return 0
                    }
                }
            }
            Text{
                anchors.horizontalCenter: imgSetup.horizontalCenter
                text: qsTr("SETUP") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }

        }

        Column{
            visible: false
            Image {
                id: imgLog
                source: "qrc:/image/navigation_log_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgLog.scale = 1.3
                        navigationWnd.state = "log";
                    }
                    onReleased:{
                        imgLog.scale =1
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    smooth: true
                    color: "lightgreen";
                    opacity: {
                        if( navigationWnd.state == "log")
                            return 0.5
                        else
                            return 0
                    }
                }
            }

            Text{
                id: txtLog
                anchors.horizontalCenter: imgLog.horizontalCenter
                text: qsTr("LOG") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }
        }
        Column{
            Image{
                id: imgHelp
                source: "qrc:/image/navigation_help_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgHelp.scale = 1.3;
                        navigationWnd.state = "help";

                    }
                    onReleased:{
                        imgHelp.scale =1
                    }
                }
                Rectangle {
                    anchors.fill: parent
                    radius: 10
                    smooth: true
                    color: "lightgreen";
                    opacity: {
                        if( navigationWnd.state == "help")
                            return 0.5
                        else
                            return 0
                    }
                }
            }
            Text{
                anchors.horizontalCenter: imgHelp.horizontalCenter
                text: qsTr("HELP") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }
        }

        Column{
            Image {
                id: imgZoomIn
                source: "qrc:/image/zoom_in_64.png"
                smooth: true
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgZoomIn.scale = 1.3
                    }
                    onReleased:{
                        imgZoomIn.scale =1
                        if( mainWnd.currentCellWidth * 1.1 >= mainWnd.maximumWidth )
                            return;
                        mainWnd.currentCellWidth = mainWnd.currentCellWidth * 1.1;
                        mainWnd.currentCellHeight = mainWnd.currentCellHeight * 1.1;

                    }
                }
            }

            Text{
                id: txtZoomIn
                anchors.horizontalCenter: imgZoomIn.horizontalCenter
                text: qsTr("ZOOM IN") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }

        }

        Column{
            Image {
                id: imgZoomOut
                source: "qrc:/image/zoom_out_64.png"
                smooth: true
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgZoomOut.scale = 1.3
                    }
                    onReleased:{
                        imgZoomOut.scale =1
                        if( mainWnd.currentCellWidth * 0.9 <= mainWnd.minimumWidth )
                            return;
                        mainWnd.currentCellWidth = mainWnd.currentCellWidth * 0.9
                        mainWnd.currentCellHeight = mainWnd.currentCellHeight * 0.9;
                    }
                }
            }

            Text{
                id: txtZoomOut
                anchors.horizontalCenter: imgZoomOut.horizontalCenter
                text: qsTr("ZOOM OUT") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }
        }
        Column{
            Image {
                id: imgReload
                source: "qrc:/image/navigation_reload_64.png"
                smooth: true
                fillMode: Image.PreserveAspectFit
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgReload.scale = 1.3
                        timerReload.count = 10;
                        cppInterface.reloadDevices();
                        timerReload.stop();
                        timerReload.start();
                    }
                    onReleased:{
                        imgReload.scale =1
                    }
                }
                Text {
                    id: txtCount
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignHCenter

                    width: 15
                    height: 15
                    font.pointSize: 12
                    font.bold: true
                    text: ""
                }
            }

            Text{
                id: txtReload
                anchors.horizontalCenter: imgReload.horizontalCenter
                text: qsTr("RELOAD") + mainWindow.emptyString
                color: "black"
                font.bold: true
            }
        }
    }

    Row{
        spacing: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        width: imgKorea.width + imgEnglish.width + spacing
        height: imgKorea.height + txtKorea.height


        Item{
            width: parent.width /2 - 10
            height: parent.height
            Image {
                id: imgKorea
                source: "qrc:/image/navigation_korea_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgKorea.scale = 1.3
                        mainWindow.language = "Korean"
                    }
                    onReleased:{
                        imgKorea.scale =1
                    }
                }
            }
            Image{
                anchors.fill: imgKorea
                anchors.margins: 10
                source: "qrc:/image/navigation_check_64.png"
                smooth: true
                opacity: mainWindow.language == "Korean" ? 0.5 : 0
            }

            Text{
                id: txtKorea
                anchors.top: imgKorea.bottom
                anchors.horizontalCenter: imgKorea.horizontalCenter
                text: qsTr("Korean") + mainWindow.emptyString
                color: "black"
                font.bold: {
                    if ( mainWindow.language  == "Korean")
                        return true;
                    else
                        return false;
                }
            }
        }
        Item{
            width: parent.width /2 - 10
            height: parent.height
            Image {
                id: imgEnglish
                source: "qrc:/image/navigation_english_64.png"
                smooth: true
                MouseArea{
                    anchors.fill: parent
                    onPressed:{
                        imgEnglish.scale = 1.3
                        mainWindow.language = "English";
                    }
                    onReleased:{
                        imgEnglish.scale =1
                    }
                }
            }
            Image{
                anchors.fill: imgEnglish
                anchors.margins: 10
                source: "qrc:/image/navigation_check_64.png"
                smooth: true
                opacity: mainWindow.language == "English" ? 0.5 : 0
            }

            Text{
                id: txtEnglish
                anchors.top: imgEnglish.bottom
                anchors.horizontalCenter: imgEnglish.horizontalCenter
                text: qsTr("English") + mainWindow.emptyString
                color: "black"
                font.bold: {
                    if ( mainWindow.language == "English")
                        return true;
                    else
                        return false;
                }
            }
        }

    }

    states: [
        State {
           name: "setup"
           PropertyChanges {
               target: controlWnd
               x: -mainWnd.width
               opacity: 1
           }
           StateChangeScript {
               name: "setupScript"
               script: {
//                   console.log("state: " + state.toString())
                   viewRegisteredTxZones.mode = "setup";
               }
           }
        },
        State {
           name: "control"
           PropertyChanges {
               target: controlWnd
               x: 0
               opacity: 1
           }


           StateChangeScript {
               name: "controlScript"
               script: {
//                   console.log("state: " + state.toString()  );
                   cppInterface.onBtnCheckDeviceInfoClicked();
                   viewRegisteredTxZones.mode = "control";
               }
           }
        },
        State {
            name: "log"
            PropertyChanges {
                target: controlWnd
                x: -mainWnd.width* 2
                opacity: 1
            }


            StateChangeScript {
                name: "logScript"
                script: {
//                    console.log("state: " + state.toString()  );
                    viewRegisteredTxZones.mode = "log";
                }
            }
        },
        State {
            name: "help"
            PropertyChanges {
                target: controlWnd
                x: -mainWnd.width* 3
                opacity: 1
            }


            StateChangeScript {
                name: "helpScript"
                script: {
//                    console.log("state: " + state.toString()  );
                    viewRegisteredTxZones.mode = "help";
                }
            }
        }

   ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "x,opacity"
                duration: 500
                easing.type: Easing.OutQuad
            }

        }
    ]

}
