import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import DelegateUI.Utils 1.0

Window {
    id: window
    width: 900
    height: 700
    visible: true
    title: qsTr("DelegateUI-DelAsyncHasher")

    component HashItem: Rectangle {
        width: parent.width
        height: column.height + 10
        color: "transparent"
        border.color: "gray"
        property alias source: hasher.source
        property alias sourceObject: hasher.sourceObject

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter

            Text {
                font.pointSize: 14
                text: "[Source] " + (hasher.source != "" ? hasher.source : "Object")
            }

            DelAsyncHasher {
                id: hasher
                algorithm: DelAsyncHasher.Md5
                onHashProgress: function(processed, total) {
                    progressBar.value = processed / total;
                }
                onStarted: {
                    startTime = Date.now();
                }
                onFinished: {
                    progressBar.visible = false;
                    totalTime = Date.now() - startTime;
                }
                property real startTime: 0
                property real totalTime: 0
            }

            Text {
                id: result
                font.pointSize: 14
                text: "[Result] " + hasher.hashValue

                ProgressBar {
                    id: progressBar
                    width: 400
                    height: parent.height
                    anchors.left: parent.left
                    anchors.leftMargin: 110
                }
            }

            Text {
                font.pointSize: 14
                text: "[Time  ] " + hasher.totalTime + " ms"
            }
        }
    }

    Column {
        width: parent.width

        HashItem { source: "file:///E:/EpicGames/RedDeadRedemption2/levels_1.rpf" } //8GB文件
        HashItem { source: "https://img.loliapi.cn/i/pc/img381.webp" }
        HashItem { source: "https://img.loliapi.cn/i/pc/img226.webp" }
        HashItem { source: "https://img.loliapi.cn/i/pc/img300.webp" }
        HashItem { source: "https://img.loliapi.cn/i/pc/img301.webp" }
        HashItem { sourceObject: window }
        Item {
            width: parent.width
            height: 80

            Column {
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    font.pointSize: 14
                    text: "[Source] "

                    TextField {
                        width: 200
                        height: parent.height
                        anchors.left: parent.left
                        anchors.leftMargin: 110
                        font.pointSize: 11
                        clip: true
                        topInset: 0
                        bottomInset: 0
                        topPadding: 0
                        bottomPadding: 0
                        onTextChanged: textHasher.sourceText = text;
                    }
                }

                DelAsyncHasher {
                    id: textHasher
                    algorithm: DelAsyncHasher.Md5
                    onStarted: {
                        startTime = Date.now();
                    }
                    onFinished: {
                        totalTime = Date.now() - startTime;
                    }
                    property real startTime: 0
                    property real totalTime: 0
                }

                Text {
                    font.pointSize: 14
                    text: "[Result] " + textHasher.hashValue
                }

                Text {
                    font.pointSize: 14
                    text: "[Time  ] " + textHasher.totalTime + " ms"
                }
            }
        }
        Item {
            width: parent.width
            height: 80

            Text {
                anchors.centerIn: parent
                color: "#ee00ff"
                font.pointSize: 26
                font.family: "华文彩云"

                Timer {
                    running: true
                    triggeredOnStart: true
                    repeat: true
                    interval: 10
                    onTriggered: {
                        parent.text = new Date().toLocaleString(Qt.locale(), "yyyy-MM-dd hh:mm:ss:zzz");
                    }
                }
            }
        }
    }
}
