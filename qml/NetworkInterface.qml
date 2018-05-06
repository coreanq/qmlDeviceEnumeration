import QtQuick 2.0

Item {
    id: networkInterface

    Component.onCompleted: {
    }

    //  qmlModelNetworkInterfaces model 데이터를 binding 함.
    property string name: Name
    property string ip : IP
    property string netmask: Netmask
    property string mac : MAC
    property string linkSpeed : LinkSpeed
    property string isUp : IsUp
    property string selected : Selected

    height: imgNetworkInterface.height + container.anchors.margins *2
    width: parent.width

    MouseArea {
        anchors.fill: parent;
        onClicked: {
            // ip 가 존재해야만 클릭 할 수 잇도록 수정.
            if( ip != "" )
                cppInterface.setNetworkInterfaceSelected(index);
        }
    }

    Rectangle {
        anchors.fill: parent;
        visible: networkInterface.selected == "true" ? true : false
        color: "steelblue";
        radius: 5
    }

    Rectangle{
        id: container
        anchors.fill: parent
        anchors.margins: 5
        Shine{}
        Rectangle{
            visible: ip == "" ? true : false
            anchors.fill: parent
            color: "black"
            opacity: 0.7
            radius: 10
        }

        Image{
            id: imgNetworkInterface
            anchors.top: parent.top
            anchors.left: parent.left
            width: sourceSize.width
            height: sourceSize.height

            source: {
                // network 링크가 on 인 상태에서
                if( networkInterface.isUp == "true" ){
                    if( linkSpeed == "100" )
                        return "qrc:/image/nic_normal_64.png";
                    else
                        return "qrc:/image/nic_normal_64.png";
                }
                else {
                    return "qrc:/image/nic_normal_64.png";
                }
            }

        }
        // 이미지 옆 IP, MAC, netmask text
        Column {
            id: descriptionOfInterface
            anchors.top: parent.top
            anchors.left: imgNetworkInterface.right
            anchors.topMargin: 5
            anchors.leftMargin: 10
            width: parent.width - imgNetworkInterface.width
            height: imgNetworkInterface.height

            Text {
                text: "NAME: " + networkInterface.name
                font.pointSize: 10
                width: parent.width
            }
            Text{
                text: "IP: " + networkInterface.ip
                font.pointSize: 10
                width: parent.width
            }
            Text{
                text: "MAC: " + networkInterface.mac
                font.pointSize: 10
                width: parent.width
            }
            Text{
                text: "SUBNET: " + networkInterface.netmask
                font.pointSize: 10
                width: parent.width
            }
        }


    }



}
