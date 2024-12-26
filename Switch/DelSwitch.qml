import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.Switch {
    id: control

    property bool animationEnabled: true
    property bool effectEnabled: true
    property string checkedText: ""
    property string uncheckedText: ""
    property int checkedIconSource: 0
    property int uncheckedIconSource: 0
    property string contentDescription: ""
    property int radiusBg: __bg.height * 0.5
    property color colorHandle: "#ffffff"
    property color colorBg: {
        if (!enabled)
            return checked ? "#68A7FF" : "#D9D9D9";

        if (checked)
            return control.down ? "#1677FF" : control.hovered ? "#3F95FF" : "#1677FF";
        else
            return control.down ? "#C0C0C0" : control.hovered ? "#8D8D8D" : "#C0C0C0";
    }
    property Component handleDelegate: Rectangle {
        radius: height * 0.5
        color: control.colorHandle
    }

    width: implicitIndicatorWidth + leftPadding + rightPadding
    height: implicitIndicatorHeight + topPadding + bottomPadding
    font {
        family: "微软雅黑"
        pixelSize: 16
    }
    indicator: Item {
        implicitWidth: __bg.width
        implicitHeight: __bg.height

        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            visible: control.effectEnabled
            color: "transparent"
            border.width: 0
            border.color: control.enabled ? "#8D8D8D" : "transparent"
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
            width: Math.max(Math.max(checkedWidth, uncheckedWidth) + __handle.width, height * 2)
            height: hasText ? Math.max(checkedHeight, uncheckedHeight, 22) : 22
            anchors.centerIn: parent
            radius: control.radiusBg
            color: control.colorBg
            clip: true

            property bool hasText: control.checkedText.length !== 0 || control.uncheckedText.length !== 0
            property real checkedWidth: __checkedText.width + 6
            property real uncheckedWidth: __uncheckedText.width + 6
            property real checkedHeight: __checkedText.height + 4
            property real uncheckedHeight: __uncheckedText.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }

            Text {
                id: __checkedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __uncheckedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: __handle.left
                font: control.font
                text: control.checkedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                id: __uncheckedText
                width: text.length === 0 ? 0 : Math.max(implicitWidth + 8, __checkedText.implicitWidth + 8)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: __handle.right
                font: control.font
                text: control.uncheckedText
                color: control.colorHandle
                horizontalAlignment: Text.AlignHCenter
            }

            Loader {
                id: __handle
                x: control.checked ? (parent.width - width - 2) : 2
                width: height
                height: parent.height - 4
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: handleDelegate

                Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }
            }
        }
    }

    Accessible.role: Accessible.CheckBox
    Accessible.name: control.checked ? control.checkedText : control.uncheckedText
    Accessible.description: control.contentDescription
    Accessible.onToggleAction: control.toggle();
}
