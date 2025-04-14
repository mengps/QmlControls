import QtQuick 2.15
import QtQuick.Window 2.15

import DelegateUI.Controls 1.0

Window {
    visible: true
    width: 640
    height: 480
    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"
    title: qsTr("Magic Fish~~~")

    Rectangle {
        anchors.fill: parent
        color: "#1109A3DC"
    }

    MagicPool {
        id: magicPool
        anchors.fill: parent
        Component.onCompleted: randomMove();

        function randomMove() {
            var r_x = Math.random() * width;
            var r_y = Math.random() * height;
            magicPool.moveFish(r_x, r_y, false);
        }

        Timer {
            interval: 1500
            repeat: true
            running: true
            onTriggered: {
                if (Math.random() > 0.6 && !magicPool.moving) magicPool.randomMove();
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: magicPool.moveFish(mouse.x, mouse.y, true);
        }
    }
}
