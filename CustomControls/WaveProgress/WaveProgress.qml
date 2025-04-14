import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Item {
    id: root
    width: radius * 2
    height: container.height + slider.height

    property real radius: 0
    property real radiusMargin: 5
    property alias value: slider.value
    property real waveSpeed: 3
    property color waveColor: "#a8a8e6"
    property real progressTextPrecision: 0
    property alias progressTextVisible: progress.visible
    property alias progressTextFont: progress.font
    property alias progressTextColor: progress.color

    property alias sliderVisible: slider.visible
    property alias sliderHeight: slider.height
    property color sliderBackgroundColor: "#a8a8e6"
    property color sliderHandleColor: "#a8a8e6"
    property color sliderHandleBorderColor: "white"
    property real sliderHandleRadius: 11

    Rectangle {
        id: container
        width: root.radius * 2
        height: root.radius * 2
        radius: root.radius

        Item {
            width: root.radius * 2 - root.radiusMargin * 2
            height: root.radius * 2 - root.radiusMargin * 2
            anchors.centerIn: parent

            Item {
                id: wave
                clip: true
                anchors.fill: parent
                visible: false

                Rectangle {
                    y: mask.height * 1.1 * (1 - root.value)
                    width: root.radius * 4
                    height: root.radius * 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    radius: root.radius * 1.5
                    color: root.waveColor
                    rotation: 45

                    NumberAnimation on rotation {
                        from: 0
                        to: 360
                        running: root.value < 1.0
                        duration: root.waveSpeed * 1000
                        loops: NumberAnimation.Infinite
                    }
                }
            }

            Rectangle {
                id: mask
                width: parent.width
                height: parent.height
                radius: root.radius
                visible: false
            }

            OpacityMask {
                width: parent.width
                height: parent.height
                source: wave
                maskSource: mask
            }

            Text {
                id: progress
                text: (root.value * 100).toFixed(root.progressTextPrecision)
                font.bold: true
                font.pointSize: 32
                anchors.centerIn: parent
            }
        }
    }

    Slider {
        id: slider
        width: parent.width
        anchors.top: container.bottom
        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            width: slider.availableWidth
            height: 8
            radius: 4

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: root.sliderBackgroundColor
                radius: 2
            }
        }
        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: radius * 2
            implicitHeight: radius * 2
            radius: root.sliderHandleRadius
            color: slider.pressed ? Qt.darker(root.sliderHandleColor, 1.2) : root.sliderHandleColor
            border.color: root.sliderHandleBorderColor
            border.width: 2
        }
    }
}
