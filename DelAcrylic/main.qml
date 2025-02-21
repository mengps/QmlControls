import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../DelSlider"

Window {
    width: 750
    height: 500
    visible: true
    title: qsTr("DelegateUI-DelAcrylic")

    Image {
        id: bg
        anchors.fill: parent
        source: "qrc:/img.jpg"
    }

    DelAcrylic {
        id: acrylic
        x: (bg.width - width) * 0.5
        y: (bg.height - height) * 0.5
        width: 300
        height: 300
        sourceItem: bg
        opacityNoise: slider1.currentValue
        opacityTint: slider2.currentValue
        radiusBlur: slider3.currentValue

        MouseArea {
            anchors.fill: parent
            drag.target: parent
        }
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -50

        DelSlider {
            id: slider1
            width: 200
            height: 30
            min: 0
            max: 1
            stepSize: 0.01
            value: 0.02

            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("OpacityNoise: ") + parent.currentValue.toFixed(2)
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }
        }

        DelSlider {
            id: slider2
            width: 200
            height: 30
            min: 0
            max: 1
            stepSize: 0.01
            value: 0

            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("OpacityTint: ") + parent.currentValue.toFixed(2)
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }
        }

        DelSlider {
            id: slider3
            width: 200
            height: 30
            min: 0
            max: 100
            value: 48
            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("RadiusBlur: ") + parent.currentValue.toFixed(0)
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }
        }
    }
}
