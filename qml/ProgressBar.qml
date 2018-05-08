/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.00

Item {
    id: progressbar

    property int minimum: 0
    property int maximum: 100
    property int value: 0
    property alias color: gradient1.color
    property alias secondColor: gradient2.color

    width: 250; height: 23

    Rectangle{
        border.color : "black"
        border.width: 2
    }

    Item{
        id: container
        anchors.fill: parent
        anchors.leftMargin: 25
        anchors.rightMargin: 25
        Rectangle {
            id: highlight

            property int widthDest: (( (parent.width) * (progressbar.value - minimum)) / (maximum - minimum) )

            width: highlight.widthDest
            Behavior on width { SmoothedAnimation { velocity: 1200 } }

            anchors { left: parent.left; top: parent.top; bottom: parent.bottom;}
            radius: 1
            gradient: Gradient {
                GradientStop { id: gradient1; position: 0.0 }
                GradientStop { id: gradient2; position: 1.0 }
            }
        }
    }

    Rectangle{
        id: knob
        radius: 10
        opacity: 0.5
        anchors { top: container.top ; bottom:container.bottom}
        x: highlight.width
        width: 50
        color: "black"

        MouseArea {
            visible: false
            anchors.fill: parent
            drag.target: knob
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: container.width
        }
        onXChanged: {
            highlight.width = x;

        }
    }

    Text {
        anchors { verticalCenter: parent.verticalCenter }
        x: knob.x + knob.width/2

        color: "white"
        font.bold: true
        text: Math.floor((progressbar.value - minimum) / (maximum - minimum) * 100) + '%'
    }
}
