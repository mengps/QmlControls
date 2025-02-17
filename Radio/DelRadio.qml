import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.RadioButton {
    id: control

    property bool animationEnabled: true
    property bool effectEnabled: true
    property int radiusIndicator: 8
    property color colorText: enabled ? "#000" : Qt.rgba(0,0,0,0.45)
    property color colorIndicator: enabled ? checked ? "#4096ff" : "#fff" : Qt.rgba(0,0,0,0.1)
    property color colorIndicatorBorder: checked ? "#4096ff" : Qt.rgba(0,0,0,0.25)
    property string contentDescription: ""

    font {
        family: "微软雅黑"
        pixelSize: 14
    }

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitContentHeight, implicitIndicatorHeight) + topPadding + bottomPadding
    spacing: 8
    indicator: Item {
        x: control.leftPadding
        implicitWidth: __bg.width
        implicitHeight: __bg.height
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: width * 0.5
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
                    target: __effect; property: "width"; from: __bg.width + 3; to: __bg.width + 8;
                    duration: 100
                    easing.type: Easing.OutQuart
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.height + 3; to: __bg.height + 8;
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
                        __effect.border.width = 8;
                        __animation.restart();
                    }
                }
            }
        }

        Rectangle {
            id: __bg
            width: control.radiusIndicator * 2
            height: width
            anchors.centerIn: parent
            radius: height * 0.5
            color: control.colorIndicator
            border.color: control.colorIndicatorBorder
            border.width: control.checked ? 0 : 1

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

            Rectangle {
                width: control.checked ? control.radiusIndicator - 2 : 0
                height: width
                anchors.centerIn: parent
                radius: width * 0.5

                Behavior on width { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }
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

    Accessible.role: Accessible.RadioButton
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onPressAction: control.clicked();
}
