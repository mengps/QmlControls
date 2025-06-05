import QtQuick 2.15
import QtQuick.Layouts 1.15
import DelegateUI 1.0

RowLayout {
    id: __mySlider
    height: 30
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 30
    spacing: 20

    property alias label: __label
    property alias slider: __slider
    property bool scaleVisible: false

    Text {
        id: __label
        Layout.preferredWidth: DelTheme.Primary.fontPrimarySize * 8
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter
        font {
            family: DelTheme.Primary.fontPrimaryFamily
            pixelSize: DelTheme.Primary.fontPrimarySize
        }
        color: DelTheme.Primary.colorTextBase
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Row {
            anchors.top: parent.top
            anchors.topMargin: 6
            anchors.horizontalCenter: parent.horizontalCenter
            visible: scaleVisible
            spacing: (parent.width - 14 - ((__repeater.count - 1) * 4)) / (__repeater.count - 1)

            Repeater {
                id: __repeater
                model: Math.round((__slider.max - __slider.min) / __slider.stepSize) + 1
                delegate: Rectangle {
                    width: 4
                    height: 6
                    radius: 2
                    color: __slider.colorBg

                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 8
                        text: (__slider.stepSize) * index + __slider.min
                        font {
                            family: DelTheme.Primary.fontPrimaryFamily
                            pixelSize: DelTheme.Primary.fontPrimarySize
                        }
                        color: DelTheme.Primary.colorTextBase
                    }
                }
            }
        }

        DelSlider {
            id: __slider
            anchors.fill: parent
            min: 0.0
            max: 1.0
            stepSize: 0.1
            handleToolTipDelegate: DelToolTip {
                arrowVisible: true
                delay: 100
                text: __slider.currentValue.toFixed(1)
                visible: handlePressed || handleHovered
            }
        }
    }
}
