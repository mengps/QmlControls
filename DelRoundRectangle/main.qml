import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import DelegateUI.Controls 1.0

import "qrc:/../DelSlider"

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelRoundRectangle")

    component MySlider: Row {
        height: 30
        spacing: 10
        property alias value: __slider.currentValue
        property alias text: __text.text

        DelSlider {
            id: __slider
            width: 200
            height: 30
            min: 0
            max: 100
            stepSize: 1
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: 10

        MySlider {
            id: topLeftSlider
            text: qsTr("左上圆角半径: ") + value
        }

        MySlider {
            id: topRightSlider
            text: qsTr("右上圆角半径: ") + value
        }

        MySlider {
            id: bottomLeftSlider
            text: qsTr("左下圆角半径: ") + value
        }

        MySlider {
            id: bottomRightSlider
            text: qsTr("右下圆角半径: ") + value
        }

        DelRectangle {
            width: 200
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#60ff0000"
            border.width: 1
            border.color: "black"
            topLeftRadius: topLeftSlider.value
            topRightRadius: topRightSlider.value
            bottomLeftRadius: bottomLeftSlider.value
            bottomRightRadius: bottomRightSlider.value
        }
    }
}
