import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 750
    height: 500
    visible: true
    title: qsTr("Acrylic Test")

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
        opacityNoise: slider1.value
        opacityTint: slider2.value
        radiusBlur: slider3.value

        MouseArea {
            anchors.fill: parent
            drag.target: parent
        }
    }

    Column {

        Slider {
            id: slider1
            anchors.horizontalCenter: parent.horizontalCenter
            from: 0
            to: 1
            stepSize: 0.01
            value: 0.02
            ToolTip.visible: hovered
            ToolTip.text: value.toFixed(2)

            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("opacityNoise")
            }
        }

        Slider {
            id: slider2
            anchors.horizontalCenter: parent.horizontalCenter
            from: 0
            to: 1
            stepSize: 0.01
            value: 0
            ToolTip.visible: hovered
            ToolTip.text: value.toFixed(2)

            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("opacityTint")
            }
        }

        Slider {
            id: slider3
            from: 0
            to: 100
            value: 48
            ToolTip.visible: hovered
            ToolTip.text: value.toFixed(0)

            Text {
                anchors.left: parent.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("radiusBlur")
            }
        }
    }
}
