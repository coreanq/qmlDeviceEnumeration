import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
//import "functions.js" as Functions
import VPlayApps 1.0

App{
    id: mainWnd
    // zone, source, txRegisteredzone 의 크기를 결정하기 위함.
    visible: true
    width: 1024
    height: 640
    licenseKey: "2295246592E1DC90A8F79AC5C38BC3FED4B97543419BB1E3F73B6799BE66308C1342E93AC3D85279A4F049BEEBC6217C6B56570617E15FA177454DCA65DFF992A12176D7494055F91762C62E20F6BF70685169CA49C90663AD242E70346AB5153CDA66D095A64CD9552DA8F24F6E6AC7357D23490329021B00CAACFAFFA1882F4F430EC1548A2FE131E8CD63EA732410D4D0085988C2845DB9E02382E23F03FAAF7142B91F7330499333921D7F3183173FCC0EE20590CAD6910A96B01214D163B70F037BC941818BE58ACC7AB9FD04C58BF0DB7C0C348154177DD4E697F605194F9EBF4C456A0A756F29846E24B763B58A22270D9A6DBB1BFCE63E6C6BBFFE729FF04F4948A5F1DEB0902F0E6B1394725F392B3BCC6B5C1AC599496C14A92C00D2FF4507E4D114F3931D485134090522D720BEE50570F557BB46E71B4BECDD94"

    property int pressDelay : 50 // flick 와 click 동작을 모두 구현하기 위함
    property int currentCellWidth: 240
    property int currentCellHeight: 102
    property int minimumWidth : 80
    property int maximumWidth : 240
    property double scale : 1

    property int anchorsMargins : 20

    property color groupBoxColor : "green"
    Constant {
        id: constant
    }


    Component.onCompleted: {
        var size;
//        size = cppInterface.zoneRectSize();
//        console.debug("size x " + size.x + " size y " + size.y );
//        currentCellWidth = size.x;
//        currentCellHeight = size.y;
    }

    onCurrentCellWidthChanged: {
        cppInterface.setZoneRectWidth(mainWnd.currentCellWidth );
    }
    onCurrentCellHeightChanged: {
        cppInterface.setZoneRectHeight(mainWnd.currentCellHeight);
    }

    // zone 이 flip 할때 gridview 가 움직이는 경우 제대로 된 곳에 위치가 안되기 때문에
    // 그걸 막기 위해 setupPanel 을 flip 하는 동안에 못움직이게 막기 위한 용도
    Timer {
        id: timerSetupPanelCoverShow
        interval: 700; running: true; repeat: false
        triggeredOnStart: true
        onTriggered:{
            timerSetupPanelCoverHide.stop();
            setupWnd.accessSetupPanelCoverId.visible = true;
            timerSetupPanelCoverHide.start();
        }
    }
    Timer {
        id: timerSetupPanelCoverHide
        interval: 500; running: true; repeat: false
        onTriggered:{
            timerSetupPanelCoverShow.stop();
            setupWnd.accessSetupPanelCoverId.visible = false;
        }
    }


    // drag & drop 시 이미지가 깨지지 않게 parent via 부분에 넣어 주기 위함.
    Item{
        id: mainContainer
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        z: parent.z + 1
    }


    Item{
        id: navigationWnd
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: logoWnd.left
        width: parent.width /5 * 4
        // 내부 윈도우의 margin 을 추가해줘야함.
        height: navigation.imgSize + mainWnd.anchorsMargins*2

        NavigationWnd{
            id: navigation
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins

            onStateChanged: {
                switch (state )
                {
                case "control":
                    mainWnd.groupBoxColor = "green"
                    break;
                case "setup":
                    mainWnd.groupBoxColor = "pink"
                    break;
                case "log":
                    mainWnd.groupBoxColor = "yellow"
                    break;
                case "help":
                    mainWnd.groupBoxColor = "blue"
                    break;

                }
            }
        }
        GroupBox{
            anchors.fill: parent
        }
    }

    Item {
        id: viewRegisteredTxZonesWnd
        anchors.top: navigationWnd.bottom
        anchors.left: parent.left
        width: parent.width /5 * 4
        // 내부 윈도우의 margin 을 추가해줘야함.
        height: viewRegisteredTxZones.currentCellHeight + mainWnd.anchorsMargins*2


        RegisteredTxZones{
            id: viewRegisteredTxZones
            clip: true
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins
            pressDelay :  mainWnd.pressDelay
            currentCellWidth: mainWnd.currentCellWidth
            currentCellHeight: mainWnd.currentCellHeight
            minimumWidth : mainWnd.minimumWidth
            maximumWidth: mainWnd.maximumWidth
            scale : mainWnd.scale
        }
        GroupBox{
            anchors.fill: parent
        }

    }

    Item {
        id: logoWnd
        anchors.top: parent.top
        anchors.bottom: controlWnd.top
        anchors.left: viewRegisteredTxZonesWnd.right
        anchors.right: parent.right

        Logo{
            anchors.centerIn: parent
            anchors.margins: mainWnd.anchorsMargins
        }
        GroupBox{
            anchors.fill: parent
        }
    }



    Item {
        id: controlWnd
        x: parent.x
        width: parent.width
        anchors.top: viewRegisteredTxZonesWnd.bottom
        anchors.bottom:parent.bottom


        ControlWnd{
            id: controlWndMain
            clip: true
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins

            pressDelay :  mainWnd.pressDelay
            currentCellWidth: mainWnd.currentCellWidth
            currentCellHeight: mainWnd.currentCellHeight
            minimumWidth : mainWnd.minimumWidth
            maximumWidth: mainWnd.maximumWidth
            scale : mainWnd.scale
        }
        GroupBox{
            anchors.fill: parent
        }
    }

    Item {
        id: setupWnd
        property alias accessSetupPanelCoverId: setupWndChild.accessSetupPanelCoverId

        width: parent.width
        x: controlWnd.x + controlWnd.width

        anchors.top: viewRegisteredTxZonesWnd.bottom
        anchors.bottom: parent.bottom

        SetupWnd {
            id: setupWndChild
            clip: true
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins

            pressDelay :  mainWnd.pressDelay
            currentCellWidth: mainWnd.currentCellWidth
            currentCellHeight: mainWnd.currentCellHeight
            minimumWidth : mainWnd.minimumWidth
            maximumWidth: mainWnd.maximumWidth
            scale : mainWnd.scale
        }
        GroupBox{
            anchors.fill: parent
        }
    }

    Item{
        id: logWnd
        clip: true
        width: parent.width
        x: setupWnd.x + setupWnd.width
        anchors.top: viewRegisteredTxZonesWnd.bottom
        anchors.bottom: parent.bottom

        LogWnd{
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins
        }

        GroupBox{
            anchors.fill: parent
        }

    }



    Item{
        id: helpWnd
        width: parent.width
        x: logWnd.x + logWnd.width
        anchors.top: viewRegisteredTxZonesWnd.bottom
        anchors.bottom: parent.bottom



        Row{
            spacing: 20
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 40
            z : webViewBase.z + 1

            Column{
                Image {
                    id: imgZoomIn
                    source: "qrc:/image/zoom_in_64.png"
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                    width: 48
                    height: 48
                    opacity: 0.7
                    MouseArea{
                        anchors.fill: parent
                        onPressed:{
                            imgZoomIn.scale = 1.3
                        }
                        onReleased:{
                            imgZoomIn.scale =1
                            if( webView.contentsScale > 3 )
                                return;
                            webView.contentsScale += 0.1
                        }
                    }
                }
            }

            Column{
                Image {
                    id: imgZoomOut
                    source: "qrc:/image/zoom_out_64.png"
                    smooth: true
                    width: 48
                    height: 48
                    fillMode: Image.PreserveAspectFit
                    opacity: 0.7
                    MouseArea{
                        anchors.fill: parent
                        onPressed:{
                            imgZoomOut.scale = 1.3
                        }
                        onReleased:{
                            imgZoomOut.scale =1
                            if( webView.contentsScale < 0.5 )
                                return;
                            webView.contentsScale -= 0.1

                        }
                    }
                }
            }
        }


        Flickable{
            id: webViewBase
            clip:true
            anchors.fill: parent
            anchors.margins: mainWnd.anchorsMargins
            pressDelay: mainWnd.pressDelay

//            contentWidth: Math.max(parent.width,webView.width)
//            contentHeight: Math.max(parent.height,webView.height)

//            Connections { target: mainWindow
//                onSgLanguageChanged: {
//                    if( mainWindow.language == "Korean" )
//                        webView.url = "file:///" + korManualFullPath ;
//                    else
//                        webView.url = "file:///" + EngManualFullPath ;
//                }
//            }


        }
    }
}


