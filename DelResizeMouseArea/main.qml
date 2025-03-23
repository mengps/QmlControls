import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: window
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelResizeMouseArea")

    Rectangle {
        width: 100
        height: 100
        color: "orange"

        Text {
            anchors.centerIn: parent
            text: qsTr("Move")
            font.pointSize: 11
        }

        DelMoveMouseArea {
            target: parent
            anchors.fill: parent
            minimumX: 0
            maximumX: window.width - width
            minimumY: 0
            maximumY: window.height - height
        }
    }

    Rectangle {
        x: 300
        y: 300
        width: 150
        height: 150
        color: "#0ed145"

        Text {
            anchors.centerIn: parent
            text: qsTr("Resize & Move")
            font.pointSize: 11
        }

        DelResizeMouseArea {
            target: parent
            anchors.fill: parent
            movable: true
            minimumWidth: 150
            maximumWidth: 300
            minimumHeight: 150
            maximumHeight: 300
            minimumX: 0
            maximumX: window.width - width
            minimumY: 0
            maximumY: window.height - height
        }
    }
}
