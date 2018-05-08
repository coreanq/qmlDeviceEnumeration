import QtQuick 2.0
import "setupcomponent"

Item {
    id: controlWnd

    property int pressDelay : 10 // flick 와 click 동작을 모두 구현하기 위함
    property int currentCellWidth: 240
    property int currentCellHeight: 135
    property int minimumWidth : 80
    property int maximumWidth : 240
    property double scale : 1


    ZoneWnd{
        id: zoneWnd
        editMode: true
        width: parent.width / 5 * 4
        anchors.top: parent.top
        anchors.bottom: loopbackPanel.top
        anchors.left: parent.left

        pressDelay :  controlWnd.pressDelay
        currentCellWidth: controlWnd.currentCellWidth
        currentCellHeight: controlWnd.currentCellHeight
        minimumWidth : controlWnd.minimumWidth
        maximumWidth: controlWnd.maximumWidth
        scale : controlWnd.scale
    }

   Item {
       id: controlPanel
       width: parent.width / 5
       anchors.margins: 20
       anchors.top: parent.top
       anchors.bottom: parent.bottom
       anchors.left: zoneWnd.right
       anchors.right: parent.right



       Connections {
           target: btnSubscriptionOn;
           onClicked: cppInterface.onBtnSubsOnClicked();
       }
       Connections {
           target: btnSubscriptionOff;
           onClicked: cppInterface.onBtnSubsOffClicked();
       }
       Connections {
           target: btnLoopbackPanel
           onClicked:{
               if( loopbackPanel.opacity == 0 )
               {
                   loopbackPanel.height = 200;
                   loopbackPanel.opacity = 1
               }
               else
               {
                   loopbackPanel.height = 0;
                   loopbackPanel.opacity = 0;
               }
           }
       }
       Connections {
           target: btnCheckStatus;
           onClicked: cppInterface.onBtnCheckDeviceInfoClicked();
       }

       Connections {
           target: btnSelAll;
           onClicked: cppInterface.onBtnSelAllClicked();
       }
       Connections {
           target: btnDeselAll;
           onClicked: cppInterface.onBtnDeselAllClicked();
       }

       Column {
           anchors.fill: parent
           spacing: 10

           Row {
               spacing: 10
               width: parent.width
               Button{
                   id: btnSubscriptionOn
                   width: parent.width /2 - parent.spacing
                   text: qsTr("Subs. on") + ""
               }
               Button {
                   id: btnSubscriptionOff
                   width: parent.width /2 - parent.spacing
                   text: qsTr("Subs. off") + ""
               }
           }
           Button {
               id: btnCheckStatus
               text: qsTr("Check status") + ""
               width: parent.width - parent.spacing
           }

           Row {
               spacing: 10
               width: parent.width
               Button {
                   id: btnSelAll
                   text: qsTr("Sel. all") + ""
                   width: parent.width /2 - parent.spacing
               }
               Button {
                   id: btnDeselAll
                   text: qsTr("Desel. all") + ""
                   width: parent.width /2 - parent.spacing
               }
           }
           //빈공간
           Rectangle{
               height: btnDeselAll.height
               opacity: 0.01
               width: parent.width
           }


           Button {
               id: btnLoopbackPanel
               text: qsTr("Loopback panel") + ""
               width: parent.width - parent.spacing
           }
       }
   }


   // loopback picker
   Rectangle{
       id: loopbackPanel
       height: 0
       opacity: 0
       anchors.left: parent.left
       anchors.right: controlPanel.left
       anchors.bottom: parent.bottom


       Behavior on opacity {
           NumberAnimation { duration: 500 }
       }
       Behavior on height {
           NumberAnimation { duration: 500 }
       }

       border.color: "black"
       color: "lightgray"
       Shine{}


       Connections {
           target: btnLoopbackOn;
           onClicked: cppInterface.onBtnLoopbackOnClicked(loopbackPicker.leftCurrentIndex, loopbackPicker.rightCurrentIndex);
       }
       Connections {
           target: btnLoopbackOff;
           onClicked: cppInterface.onBtnLoopbackOffClicked(loopbackPicker.leftCurrentIndex, loopbackPicker.rightCurrentIndex);
       }

       MouseArea{
           anchors.fill: parent
       }

       Row {

           anchors.fill: parent;
           anchors.margins: 10
           width: parent.width
           spacing: 10

           Column {
               y: 10
               spacing: 10
               width: parent.width /4

               Button {
                  id: btnLoopbackOn
                  text: qsTr("Loopback on") + ""
                  width: parent.width /2
               }
               Button {
                   id: btnLoopbackOff
                   text: qsTr("Loopback off") + ""
                   width: parent.width /2
               }
           }

           Picker {
               id: loopbackPicker
               height: parent.height
               width: 600

               backImgWidth: 600
               leftBarrelModel: qmlModelRxZones
               rightBarrelModel: qmlModelRegisteredTxChannels
               rightCaption: qsTr("Destination") + ""
               leftCaption: qsTr("Source") + ""
               leftDelegate: Text {

                   anchors.left: parent.left
                   anchors.right:parent.right
                   anchors.rightMargin: 10
                   anchors.leftMargin: 60

                   font.pixelSize: 15
                   font.bold: true
                   color: "black"
                   elide: Text.ElideRight
                   horizontalAlignment: Text.AlignHCenter
                   text:{
                       if( Name == undefined ) return "";
                       else Name;
                   }
               }

               rightDelegate: Text {

                   anchors.left: parent.left
                   anchors.right:parent.right
                   anchors.rightMargin: 60
                   anchors.leftMargin: 10

                   font.pixelSize: 15
                   font.bold: true
                   color: "black"
                   elide: Text.ElideRight
                   horizontalAlignment: Text.AlignHCenter
                   text:{
                       if( Name == undefined ) return "";
                       else Name;
                   }
               }
           }

       }
   }
}








