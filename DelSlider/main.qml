import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelSlider")

    Column {
        anchors.centerIn: parent
        spacing: 10

        Column {

            DelSlider {
                width: 300
                height: 30
                value: 50

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    text: parent.currentValue.toFixed(0)
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }

            DelSlider {
                width: 300
                height: 30
                range: true
                value: [20, 50]

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    text: {
                        const v = parent.currentValue;
                        return v[0].toFixed(0) + ", "+ v[1].toFixed(0);
                    }
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }

            DelSlider {
                width: 300
                height: 30
                value: 50
                enabled: false

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    text: qsTr("禁用")
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }
        }

        Row {
            height: 250
            spacing: 30

            DelSlider {
                width: 30
                height: 240
                value: 50
                orientation: Qt.Vertical

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: parent.currentValue.toFixed(0)
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }

            DelSlider {
                width: 30
                height: 240
                range: true
                value: [20, 50]
                orientation: Qt.Vertical

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: {
                        const v = parent.currentValue;
                        return v[0].toFixed(0) + ", "+ v[1].toFixed(0);
                    }
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }
        }
    }
}
