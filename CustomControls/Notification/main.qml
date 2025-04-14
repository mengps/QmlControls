import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Notification Test")

    Notification {
        id: topNotification
        z: 100
        backgroundWidth: 240
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        titleFont.pointSize: 11
        messageFont.pointSize: 11
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        Row {
            spacing: 10

            Button {
                text: qsTr("成功")
                onClicked: {
                    topNotification.notify(qsTr("成功"), qsTr("这是一条成功的提示消息"), Notification.Success);
                }
            }

            Button {
                text: qsTr("警告")
                onClicked: {
                    topNotification.notify(qsTr("警告"), qsTr("这是一条警告的提示消息"), Notification.Warning);
                }
            }

            Button {
                text: qsTr("消息")
                onClicked: {
                    topNotification.notify(qsTr("消息"), qsTr("这是一条消息的提示消息"), Notification.Message);
                }
            }

            Button {
                text: qsTr("错误")
                onClicked: {
                    topNotification.notify(qsTr("错误"), qsTr("这是一条错误的提示消息"), Notification.Error);
                }
            }
        }
    }
}
