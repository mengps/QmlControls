import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Dialogs 1.3

Window {
    id: root
    width: 550
    height: 650
    color: "transparent"
    visible: true

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#C4D6FA"

        Text {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("编辑器图像助手")
            font.family: "微软雅黑"
            font.pointSize: 24
            antialiasing: true
        }

        Text {
            id: label
            text: qsTr("请输入文本或插入图像：")
            font.pointSize: 12
            font.family: "微软雅黑"
            anchors.top: title.bottom
            anchors.topMargin: 20
            anchors.left: root.left
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            id: rect
            width: parent.width - 20
            anchors.top: label.bottom
            anchors.topMargin: 5
            anchors.bottom: row.top
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: "gray"

            Flickable {
                id: flick
                flickableDirection: Flickable.VerticalFlick
                anchors.fill: parent
                TextArea.flickable: RichTextArea {
                    id: mytext
                    focus: true
                    font.family: "微软雅黑"
                    font.pointSize: 12
                    color: "red"
                    leftPadding: 16
                    rightPadding: 16
                    topPadding: 16
                    bottomPadding: 16

                    DropArea {
                        anchors.fill: parent;
                        onDropped: {
                            if (drop.hasUrls) {
                                for (var i = 0; i < drop.urls.length; i++) {
                                    console.log(drop.urls[i]);
                                    mytext.insertImage(drop.urls[i]);
                                }
                            }
                        }
                    }
                }
                ScrollBar.vertical: ScrollBar {
                    width: 14
                    policy: ScrollBar.AsNeeded
                }
            }
        }

        Row {
            id: row
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            Button {
                id: openFile
                text: qsTr("插入本地图片")
                font.family: "微软雅黑"
                onClicked: fileDialog.open();
            }
        }

        FileDialog {
            id: fileDialog
            folder: shortcuts.desktop
            title: qsTr("请打开一张图片")
            nameFilters: [qsTr('图片文件 (*.jpg *.bmp *.jpeg *.png *gif)')]
            onAccepted:  mytext.insertImage(fileUrl);
        }
    }
}
