import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelScrollBar")

    Rectangle {
        width: 200
        height: 200
        anchors.centerIn: parent
        border.width: 1

        Flickable {
            anchors.fill: parent
            anchors.margins: parent.border.width
            contentWidth: txt.implicitWidth
            contentHeight: txt.implicitHeight
            ScrollBar.vertical: DelScrollBar { }
            ScrollBar.horizontal: DelScrollBar { }
            clip: true

            Text {
                id: txt
                font.pixelSize: 400
                text: "🌟"
            }
        }
    }
}
