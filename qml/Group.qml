import QtQuick 1.1
import "functions.js" as Functions
// 바로 Flipable 로 시작하지 않고 Item 으로 시작하는 이유는
// GirdView 의 component 로서 parent 가 바뀔수 있기 때문에 root Item 의 Parent 가 바뀌지 않게 하기 위함.
Item{
    id: group

    property alias  cellColor       : frontGroup.color

    //  model 데이터를 binding 함.
    property string groupId         : ID
    property string name            : Name
    property string source          : Source
    property string rxDanteNameList : RxDanteNameList
    property string rxChannelList   : RxChannelList
    property string selected        : Selected
    property string processing      : Processing
    property bool   editMode        : false
    property bool   flipped         : false

    onFlippedChanged:{
        settingPage.name = group.name;
    }

    Flipable {
        id: flipableGroup

        // front 의 경우는 정렬을 위해 anchors.fill 해서 margin 을 사용
        // back 의 경우는 화면을 전체로 채워야 하며, width, height animation 을 사용해야 하므로 width 직접 지정.
        property int    cellAngle    : 0

        width: parent.width
        height: parent.height

        front : Rectangle {
            id: frontGroup
            color: "gray"

            anchors.fill: parent
            anchors.margins: 3
            border.color: group.selected == "true" ? "yellow" : "black"
            border.width: group.selected == "true" ? 5 : 1
            radius: 10

            MouseArea {
                anchors.fill: parent;
                onClicked: {
                    if( editMode == true ){
                        group.flipped = !group.flipped;
                    }
                    else{
                        cppInterface.setGroupSelected(index);
                    //          console.log("clicked group selected? " + group.name + " " +
                    //                      group.selected + " " +
                    //                      group.rxDanteNameList + " " +
                    //                      group.rxChannelList + " ");
                    }
                }
            }
            Shine{}
            Row{
                id: normal
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: frontLabel.top
                anchors.margins: 5

                // zone 과 배열을 맞추기 위해 더미로 넣음.
                Item{

                    width: parent.width /3
                    height: parent.height
                    Image{
                        id: imgVolume
                        visible: group.selected
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
                        id: imgFolderMusic
                        smooth: true
                        fillMode: Image.PreserveAspectFit
                        anchors.fill: parent

                        source: {
                                return "qrc:/image/folder_music_64.png";
                        }
                    }
                }
                Item{
                    width: parent.width /3
                    height: parent.height
                }
            }
            Rectangle {
                id: frontLabel
                color: "black"
                radius: 5
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height /4
                Text {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight

                    color: "white"
                    font.bold: true
                    font.pointSize: frontLabel.height - 3
                    text: group.name
                }
            }

        }

        back : Rectangle {
            id: backGroup
            smooth: true
            color: "#DA111316";
            opacity: 0.7
            border.color: group.selected == "true" ? "yellow" : "lightgray"
            border.width: 4

            width: parent.width
            height: parent.height

            anchors.margins: 3
            radius: 10

            GroupSettingPage{
                id: settingPage
                anchors.fill: parent
                flipped: group.flipped

                titleText : qsTr("Setting: Group") + mainWindow.emptyString
                description: qsTr("It can be set group's name") + mainWindow.emptyString
                iconSource:  "qrc:/image/setting_group_128.png"
                name: group.name
                sourceName: group.source

                onBtnCloseClicked: {
                    group.flipped = false;
                    timerSetupPanelCoverShow.start();
                }
                onBtnGroupNameChanged: {
                    cppInterface.setGroupName(group.groupId, name);
                    group.flipped = false;
                }
            }
        }

        transform: Rotation {
            id: rotation
            origin.x: flipableGroup.width/2
            origin.y: flipableGroup.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: flipableGroup.cellAngle
        }

        // parentChange 안에 일반 property 변경 사항을 다 적용해야함.
        states: [
            State {
                name: "back"; when:group.flipped
                ParentChange{
                    target: flipableGroup;
                    parent: setupContainer;
                    width: parent.width
                    height: parent.height
                    x: parent.x
                    y: parent.y
                }
                // Parent Change 하면서 cellAngle 의 경우 변경전
                // parent 변경 후 parent에 cellAngle 이 존재 하지 않으므로 따로 처리
                PropertyChanges {
                    target: flipableGroup
                    cellAngle: 180
                }
            }
        ]


        transitions: [
            Transition {
                ParentAnimation{
                    via: setupContainer
                    PropertyAnimation{ target: flipableGroup; properties: "x,y,width,height,cellAngle"; duration: 500}
                }
            }
        ]
        state: "front"


        GridView.onAdd: SequentialAnimation {
                     NumberAnimation { target: group; property: "scale"; from: 0; to: 1; duration: 250; easing.type: Easing.InOutQuad }
        }

        GridView.onRemove: SequentialAnimation {
                     PropertyAction { target: group; property: "GridView.delayRemove"; value: true }
                     NumberAnimation { target: group; property: "scale"; to: 0; duration: 250; easing.type: Easing.InOutQuad }
                     PropertyAction { target: group; property: "GridView.delayRemove"; value: false }
        }
    }

}

