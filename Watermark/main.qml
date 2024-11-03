import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

import DelegateUI.Controls 1.0

Window {
    id: window
    width: 1080
    height: 600
    visible: true
    title: qsTr("DelegateUI Watermark")

    RowLayout {
        anchors.fill: parent

        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.5
            Layout.preferredHeight: parent.height * 0.5

            Item {
                id: content1
                Layout.fillWidth: true
                Layout.fillHeight: true

                Watermark {
                    id: watermark1
                    anchors.fill: parent
                    offset.x: -50
                    offset.y: -50
                    rotate: slider1.value
                    fontColor: "#30ff0000"
                }

                Text {
                    anchors.centerIn: parent
                    text: qsTr("文字水印测试")
                    font.pointSize: 36
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.maximumHeight: 40

                Slider {
                    id: slider1
                    Layout.preferredWidth: 150
                    Layout.fillHeight: true
                    value: -22
                    from: -360
                    to: 360
                    stepSize: 1
                }

                TextField {
                    id: markText
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "DelegateUI Watermark"
                    placeholderText: qsTr("输入水印文本")
                    font.family: "微软雅黑"
                    selectByMouse: true
                }

                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: qsTr("确定")
                    onClicked: watermark1.text = markText.text;
                }

                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: qsTr("导出")
                    onClicked: {
                        content1.grabToImage((result)=>{
                                                 result.saveToFile("./content1.png");
                                                 Qt.openUrlExternally("file:./");
                                             });
                    }
                }
            }
        }

        ColumnLayout {
            Layout.preferredWidth: parent.width * 0.5
            Layout.preferredHeight: parent.height * 0.5

            Item {
                id: content2
                Layout.fillWidth: true
                Layout.fillHeight: true

                Watermark {
                    id: watermark2
                    anchors.fill: parent
                    offset.x: -50
                    offset.y: -50
                    markSize.width: 200
                    markSize.height: 150
                    rotate: slider2.value
                    opacity: 0.2
                }

                Text {
                    anchors.centerIn: parent
                    text: qsTr("图像水印测试")
                    font.pointSize: 36
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.maximumHeight: 40

                Slider {
                    id: slider2
                    Layout.preferredWidth: 150
                    Layout.fillHeight: true
                    value: -22
                    from: -360
                    to: 360
                    stepSize: 1
                }

                TextField {
                    id: markImage
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: "https://avatars.githubusercontent.com/u/33405710?v=4"
                    placeholderText: qsTr("输入水印图片链接")
                    font.family: "微软雅黑"
                    selectByMouse: true
                }

                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: qsTr("确定")
                    onClicked: watermark2.image = markImage.text;
                }

                Button {
                    Layout.preferredWidth: 80
                    Layout.fillHeight: true
                    text: qsTr("导出")
                    onClicked: {
                        content2.grabToImage((result)=>{
                                                 result.saveToFile("./content2.png");
                                                 Qt.openUrlExternally("file:./");
                                             });
                    }
                }
            }
        }
    }
}
