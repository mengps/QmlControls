import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"

Window {
    width: 640
    height: 700
    visible: true
    title: qsTr("Timeline Test")

    Row {
        id: row
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5

        RadioButton {
            checked: true
            text: qsTr("倒序")
            onClicked: timeline.reverse = true;
        }

        RadioButton {
            text: qsTr("正序")
            onClicked: timeline.reverse = false;
        }

        Button {
            text: qsTr("添加 HTML")
            onClicked: {
                timeline.append({
                                    timestamp: new Date(),
                                    content: "<h2 style=\"color:red;\">可以使用HTML</h2><p>_(:3 」∠)_ -･･*'``*:.｡. .｡.:*･゜ﾟ･*☆</p>",
                                    contentOptions: { format: Text.RichText },
                                    nodeOptions: { icon: DelIcon.MessageOutlined }
                                });
            }
        }
        Button {
            text: qsTr("添加 Markdown")
            onClicked: {
                timeline.append({
                                    timestamp: new Date(),
                                    content: "## 可以使用Markdown\n - `(ˉ﹃ˉ)`\n - (* >ω<)\n - ლ(´ڡ`ლ)",
                                    contentOptions: { format: Text.MarkdownText },
                                    nodeOptions: { icon: DelIcon.VideoCameraOutlined }
                                });
            }
        }

        Button {
            text: qsTr("删除")
            onClicked: {
                timeline.removeAtTimestamp(new Date(2024, 7, 1, 1));
            }
        }

        Button {
            text: qsTr("更新")
            onClicked: {
                timeline.setAtIndex(0, {
                                        nodeOptions: { iconColor: "orange" },
                                        timestamp: timeline.getAtIndex(0).timestamp,
                                        timeOptions: {
                                            font: { family: "微软雅黑", pointSize: 12 },
                                            fontColor: "darkBlue",
                                            format: "yyyy-MM-dd hh:mm:ss:zzz"
                                        },
                                        content: " ## " + timeline.getAtIndex(0).content,
                                        contentOptions: { format: Text.MarkdownText }
                                    });
            }
        }
    }

    Timeline {
        id: timeline
        width: 400
        anchors.top: row.bottom
        anchors.topMargin: 10
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        defaultNodeBackgroundColor: "transparent"
        defaultNodeBorderWidth: 1
        defaultTimeFormat: "yyyy-MM-dd hh:mm:ss"
        initModel: [
            {
                timestamp: new Date(2024, 7, 1, 1),
                content: "更新 Github 模板 1",
                nodeOptions: { icon: DelIcon.MessageOutlined }
            },
            {
                timestamp: new Date(2024, 7, 7, 11),
                content: "更新 Github 模板 2",
                nodeOptions: { backgroundColor: "blue" },
                lineOptions: { color: "red" }
            },
            {
                timestamp: new Date(2024, 7, 7, 16),
                content: "更新 Github 模板 2",
                lineOptions: { width: 5 }
            },
            {
                timestamp: new Date(2024, 7, 9, 5, 30),
                content: "更新 Github 模板 3"
            },
            {
                timestamp: new Date(2024, 7, 12, 9),
                timeOptions: {
                    font: { family: "华文彩云", pointSize: 12 },
                    fontColor: "green",
                    format: "yyyy-MM-dd hh:mm:ss:zzz"
                },
                content: "更新 Github 模板 4",
            },
            {
                timestamp: new Date(2024, 7, 12, 18, 30),
                content: "更新 Github 模板 5",
                contentOptions: {
                    font: { family: "微软雅黑", pointSize: 14 },
                    fontColor: "red",
                    backgroundColor: "#ddd"
                }
            },
            {
                timestamp: new Date(2024, 7, 17, 5, 35),
                content: "更新 Github 模板 6 ===================================",
                contentOptions: {
                    borderColor: "#ddd"
                }
            }
        ]
    }
}
