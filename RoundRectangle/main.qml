import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import DelegateUI.Controls 1.0

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("RoundRectangle Test")

    component MySlider: Row {
        height: 30
        property alias value: __slider.value
        property alias text: __text.text

        Slider {
            id: __slider
            from: 0
            to: 100
            stepSize: 1
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: __text
            anchors.verticalCenter: parent.verticalCenter
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
