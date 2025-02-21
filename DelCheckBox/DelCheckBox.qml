import QtQuick 2.15
import QtQuick.Templates 2.15 as T

import "qrc:/../common"

T.CheckBox {
    id: control

    property bool animationEnabled: true
    property bool effectEnabled: true
    property int indicatorSize: 20
    property color colorText: enabled ? "#000" : Qt.rgba(0,0,0,0.45)
    property color colorIndicator: enabled ? (checkState != Qt.Unchecked) ? "#1677ff" : "#fff" : Qt.rgba(0,0,0,0.1)
    property color colorIndicatorBorder: enabled ? (hovered || checked) ? "#1677ff" : Qt.rgba(0,0,0,0.25) : Qt.rgba(0,0,0,0.1)
    property string contentDescription: ""

    font {
        family: "微软雅黑"
        pixelSize: 14
    }

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    spacing: 6
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.implicitWidth
        implicitHeight: __bg.implicitHeight
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.implicitWidth
            height: __bg.implicitHeight
            radius: 4
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? Qt.rgba(0,0,0,0.45) : "transparent"
            opacity: 0.2

            ParallelAnimation {
                id: __animation
                onFinished: __effect.border.width = 0;
                NumberAnimation {
                    target: __effect; property: "width"; from: __bg.implicitWidth + 2; to: __bg.implicitWidth + 6;
                    duration: 100
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.implicitHeight + 2; to: __bg.implicitHeight + 6;
                    duration: 100
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "opacity"; from: 0.2; to: 0;
                    duration: 300
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled && control.effectEnabled) {
                        __effect.border.width = 6;
                        __animation.restart();
                    }
                }
            }
        }

        DelIconText {
            id: __bg
            iconSize: control.indicatorSize
            iconSource: DelIcon.BorderOutlined
            anchors.centerIn: parent
            colorIcon: control.colorIndicatorBorder

            Behavior on colorIcon { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

            /*! √ 的背景色 */
            DelIconText {
                anchors.centerIn: parent
                iconSource: DelIcon.XFilledPath1
                iconSize: parent.iconSize * 0.5
                colorIcon: "#fff"
                visible: control.checkState == Qt.Checked
            }

            DelIconText {
                iconSource: DelIcon.CheckSquareFilled
                iconSize: parent.iconSize
                colorIcon: control.colorIndicator
                visible: control.checkState == Qt.Checked
            }

            DelIconText {
                anchors.centerIn: parent
                iconSource: DelIcon.XFilledPath1
                iconSize: parent.iconSize * 0.5
                colorIcon: control.colorIndicator
                visible: control.checkState == Qt.PartiallyChecked
            }
        }
    }
    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
    background: Item { }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.text
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}
