import QtQuick 1.1


Item {
    id:logWnd

//    Column{
//        width: parent.width
//        height: parent.height

//        Row{
//            width: parent.width
//            height: parent.height /2


//            Flickable {
//                id: lastLog
//                height: parent.height
//                width: parent.width / 4 * 3
//                contentWidth: edit.paintedWidth
//                contentHeight: edit.paintedHeight
//                clip: true

//                function ensureVisible(r)
//                {
//                    if (contentX >= r.x)
//                        contentX = r.x;
//                    else if (contentX+width <= r.x+r.width)
//                        contentX = r.x+r.width-width;
//                    if (contentY >= r.y)
//                        contentY = r.y;
//                    else if (contentY+height <= r.y+r.height)
//                        contentY = r.y+r.height-height;
//                }

//                Rectangle{
//                    anchors.fill: parent
//                    radius: 10
//                    border.color: "black"
//                    border.width: 2

//                    TextEdit {
//                        id: edit
//                        anchors.fill: parent
//                        anchors.margins: 10
//                        text: "park"
//                        focus: true
//                        wrapMode: TextEdit.Wrap
//                        onCursorRectangleChanged: lastLog.ensureVisible(cursorRectangle)
//                    }

//                }


//            }

//            Rectangle{
//                id: logList
//                height: parent.height /2
//                width: parent.width /4
//                color: "black"

//            }

//        }

//        Row{

//        }
//    }

}
