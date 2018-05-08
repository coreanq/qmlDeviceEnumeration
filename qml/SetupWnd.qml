import QtQuick 2.0
import "setupcomponent"
import "functions.js" as Functions

Item {
    id:setupWnd
    property bool editMode: false

    property int pressDelay : 10 // flick 와 click 동작을 모두 구현하기 위함
    property int currentCellWidth: 240
    property int currentCellHeight: 135
    property int minimumWidth : 80
    property int maximumWidth : 240
    property double scale : 1
    property alias accessSetupPanelCoverId : setupPanelCover
    property alias setupCotainer : setupWnd.setupCotainer

    PinchArea {
        id: pinchArea
        anchors.fill: parent
        visible: setupWnd.editMode
        property double oldHeight: 0
        property double oldWidth: 0

        property double oldZoom
        onPinchFinished: {
    //           console.log( "PinchArea onPinchFinished" + "\n" );
        }
        onPinchStarted: {
            pinchArea.oldZoom =  pinch.scale
            pinchArea.oldHeight = mainWnd.currentCellHeight;
            pinchArea.oldWidth = mainWnd.currentCellWidth;
        }
        onPinchUpdated: {
    //               console.log ( "PinchArea onPinchUpdated" + pinch.scale);
            if( oldZoom == pinch.scale )
                return;
            var scale = pinch.scale
            if ( mainWnd.currentCellWidth * scale  <= mainWnd.minimumWidth ||
                    mainWnd.currentCellWidth * scale  >= mainWnd.maximumWidth )
                return;
            mainWnd.currentCellHeight =  pinchArea.oldHeight * pinch.scale;
            mainWnd.currentCellWidth = pinchArea.oldWidth * pinch.scale;
       }
    }

    Item{
        id: setupContainer

        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        z: parent.z + 1
    }



    //메뉴 이동을 위해서 anchors top bottom 는 하지 않음.
    SourceWnd{
        id: sourceWnd
        clip: true
        width: parent.width / 5 * 4
        height: parent.height
        anchors.left: parent.left

        editMode : parent.editMode
        pressDelay : parent.pressDelay
        currentCellHeight: parent.currentCellHeight
        currentCellWidth: parent.currentCellWidth
        minimumWidth: parent.minimumWidth
        maximumWidth: parent.maximumWidth
        scale : parent.scale

    }
    ZoneWnd{
        id: zoneWnd
        clip: true
        width: parent.width / 5 * 4
        height: parent.height
        anchors.left: parent.left

        editMode : parent.editMode
        pressDelay : parent.pressDelay
        currentCellHeight: parent.currentCellHeight
        currentCellWidth: parent.currentCellWidth
        minimumWidth: parent.minimumWidth
        maximumWidth: parent.maximumWidth
        scale : parent.scale
        enableGroupControl : true

    }
    DbWnd{
        id: dbWnd
        clip: true
        width: parent.width / 5 * 4
        height: parent.height
    }

    MouseArea{
        id: setupPanelCover

        visible: false
        anchors.fill: parent
        z: columnContainer.z + 1
    }

   Item {
       id: setupPanel;
       width: parent.width / 5

       anchors.top: parent.top
       anchors.bottom: parent.bottom
       anchors.left : sourceWnd.right
       anchors.right: parent.right
       anchors.leftMargin: 20



       Column {
           id: columnContainer
           anchors.fill: parent
           spacing: 4

           Button {
               id: btnSourceSetting
               focus: true
               text: qsTr("Source") + ""
               anchors.left: parent.left
               anchors.right: parent.right
               onClicked:{
                   setupWnd.state = "sourceSetting";
               }
               Image{
                   anchors.top: parent.top
                   anchors.left: parent.left
                   anchors.topMargin: 5
                   anchors.leftMargin: 20
                   width: 32
                   height: 32
                   source: qmlAssetsPath + "navigation_check_64.png"
                   smooth: true
                   opacity: setupWnd.state == "sourceSetting" ? 0.8 : 0
               }
           }

           Button {
               id: btnZoneSetting
               focus: true
               text: qsTr("Zone/Group") + ""
               anchors.left: parent.left
               anchors.right: parent.right
               onClicked:{
                   setupWnd.state = "zoneSetting";
               }
               Image{
                   anchors.top: parent.top
                   anchors.left: parent.left
                   anchors.topMargin: 5
                   anchors.leftMargin: 20

                   width: 32
                   height: 32
                   source: qmlAssetsPath + "navigation_check_64.png"
                   smooth: true
                   opacity: setupWnd.state == "zoneSetting" ? 0.8 : 0
               }
           }
           Button {
               id: btnEtcSetting
               focus: true
               text: qsTr("Other setting") + ""
               anchors.left: parent.left
               anchors.right: parent.right
               onClicked:{
                   setupWnd.state = "dbSetting";
               }

               Image{
                   anchors.top: parent.top
                   anchors.left: parent.left
                   anchors.topMargin: 5
                   anchors.leftMargin: 20
                   width: 32
                   height: 32
                   source: qmlAssetsPath + "navigation_check_64.png"
                   smooth: true
                   opacity: setupWnd.state == "dbSetting" ? 0.8 : 0
               }
           }

           //빈공간
           Item {
               width: parent.width
               height: btnZoneSetting.height
               opacity: 0.01
           }

           Item {
               width: parent.width
               height: textEdit.height
               Rectangle{
                   anchors.fill: parent
                   color: "white"
                   radius: 10
                   Shine{}
                   Text {
                       id: textEdit
                       anchors.centerIn: parent
                       text: qsTr("Detail setting") + ""
                       font {
                           pointSize: 14
                           bold: true
                       }
                   }
               }
           }


           Row {
               spacing: 10
               width: parent.width
               height: btnZoneSetting.height

               Item{
                   id: txtOff
                   width: parent.width /4
                   height: parent.height

                   Text {
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.right: parent.right
                       color: "black"
                       font {
                           pointSize: 14
                           bold: true
                       }
                       text: qsTr("OFF") + ""
                   }
               }


               SlideSwitch{
                   id: sliderEditMode
                   enabled: setupWnd.editMode
                   width: parent.width /2
                   height: parent.height
                   anchors {
                       verticalCenter: parent.verticalCenter
                       top: parent.top
                       topMargin: (sliderEditMode.height / 2) - (height / 2)
                   }

                   onTrySliderMove: {
                       enabled = on;
                       setupWnd.editMode = enabled;

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
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.left: parent.left
                       color: "black"
                       font {
                           pointSize: 14
                           bold: true
                       }
                       text: qsTr("ON") + ""
                   }
               }
           }


           Item {
               visible: false
               width: parent.width
               height: textEdit2.height
               Rectangle{
                   anchors.fill: parent
                   color: "white"
                   radius: 10
                   Shine{}
                   Text {
                       id: textEdit2
                       anchors.centerIn: parent
                       text: qsTr("Virtual Keyboard") + ""
                       font {
                           pointSize: 14
                           bold: true
                       }
                   }
               }
           }


           // virtual on / off
           Row {
               visible: false
               spacing: 10
               width: parent.width
               height: btnZoneSetting.height

               Item{
                   id: txtOff2
                   width: parent.width /4
                   height: parent.height

                   Text {
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.right: parent.right
                       color: "black"
                       font {
                           pointSize: 14
                           bold: true
                       }
                       text: qsTr("OFF") + ""
                   }
               }


               SlideSwitch{
                   id: slilderVirtualKB
                   enabled: false
                   width: parent.width /2
                   height: parent.height
                   anchors {
                       verticalCenter: parent.verticalCenter
                       top: parent.top
                       topMargin: (slilderVirtualKB.height / 2) - (height / 2)
                   }

                   Component.onCompleted: {
                       enabled = cppInterface.isEnableVirtualKeyboard();
                   }

                   onTrySliderMove: {
                       enabled = on;
                       cppInterface.setEnableVirtualKeyboard(enabled);
                   }

                   buttonImageOn: qmlAssetsPath + "beryl/knob_on.svg"
                   buttonImageOff: qmlAssetsPath + "beryl/knob_off.svg"
                   backgroundImageNormal: qmlAssetsPath + "beryl/background.svg"
                   backgroundImageHover: qmlAssetsPath + "beryl/background_hover.svg"
               }
               Item{
                   id: txtOn2
                   width: parent.width /4
                   height: parent.height

                   Text {
                       anchors.verticalCenter: parent.verticalCenter
                       anchors.left: parent.left
                       color: "black"
                       font {
                           pointSize: 14
                           bold: true
                       }
                       text: qsTr("ON") + ""
                   }
               }
           }



           //빈공간
           Item {
               width: parent.width
               height: btnZoneSetting.height
               opacity: 0.01
           }






//           ProgressBar{
//               width: parent.width
//               height: btnZoneSetting.height
//               NumberAnimation on value { duration: 5000; from: 0; to: 100; loops: Animation.Infinite }
//               ColorAnimation on color { duration: 5000; from: "lightsteelblue"; to: "thistle"; loops: Animation.Infinite }
//               ColorAnimation on secondColor { duration: 5000; from: "steelblue"; to: "#CD96CD"; loops: Animation.Infinite }

//           }


       }
   }


   state : "sourceSetting"

   states: [
       State {
           name: "sourceSetting"

           PropertyChanges{
               target: sourceWnd
               y: 0
           }
           PropertyChanges {
               target:  zoneWnd
               y: sourceWnd.height + setupWnd.anchors.margins

           }
           PropertyChanges{
               target: dbWnd
               y: sourceWnd.height + dbWnd.height
           }

           StateChangeScript {
               name: "sourceSettingScript"
               script: {
//                   cppInterface.showVirtualKeyboard(false);
//                   console.log("state: " + state.toString())
               }
           }
       },
       State {
           name: "zoneSetting"

           PropertyChanges{
               target: sourceWnd
               y: - sourceWnd.height - setupWnd.anchors.margins
           }
           PropertyChanges {
               target:  zoneWnd
               y: 0
           }
           PropertyChanges{
               target: dbWnd
               y: dbWnd.height + setupWnd.anchors.margins
           }

           StateChangeScript {
               name: "zoneSettingScript"
               script: {
                   cppInterface.showVirtualKeyboard(false);
//                   console.log("state: " + state.toString()  );
               }
           }
       },
       State {
           name: "dbSetting"

           PropertyChanges{
               target: sourceWnd
               y: - sourceWnd.height - zoneWnd.height - setupWnd.anchors.margins*2
           }
           PropertyChanges {
               target:  zoneWnd
               y: -zoneWnd.height - setupWnd.anchors.margins
           }
           PropertyChanges{
               target: dbWnd
               y: 0
           }
           StateChangeScript {
               name: "dbSettingScript"
               script: {
//                   console.log("state: " + state.toString()  );
               }
           }
       }
   ]

   transitions: [
       Transition {
           PropertyAnimation{
               properties: "y"
               duration: 500
               easing.type: Easing.OutQuad

           }
       }
   ]
}
