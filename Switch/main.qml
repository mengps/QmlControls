import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Switch Test")

    Column {
        anchors.centerIn: parent
        spacing: 20

        DelSwitch { }

        DelSwitch {
            checked: true
            enabled: false
        }

        DelSwitch {
            enabled: false
        }

        DelSwitch {
            checkedText: qsTr("开启")
            uncheckedText: qsTr("关闭")
        }

        DelSwitch {
            id: switch2
            radiusBg: 2
            handleDelegate: Rectangle {
                radius: 2
                color: switch2.colorHandle
            }
        }
    }
}
