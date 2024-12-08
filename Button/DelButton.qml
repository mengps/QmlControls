import QtQuick 2.15
import QtQuick.Controls 2.15
import DelegateUI.Controls 1.0

Button {
    id: control

    property bool animationEnabled: true
    property int type: DelButtonType.Type_Default
    property int shape: DelButtonType.Shape_Default
    property int radiusBg: 6
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#000000"
            case DelButtonType.Type_Primary: return "white";
            default: return "#000000";
            }
        } else {
            return Qt.rgba(0,0,0,0.2);
        }
    }
    property color colorBg: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default: return "white";
            case DelButtonType.Type_Primary:
                return control.down ? "#0958d9": control.hovered ? "#4096ff" : "#1677ff";
            default: return "white";
            }
        } else {
            return Qt.rgba(0,0,0,0.2);
        }
    }
    property color colorBorder: enabled ? (control.down ? "#4096ff" : control.hovered ? "#69b1ff" : "#a0808080") : "#a0808080"
    property string contentDescription: text

    width: implicitContentWidth + leftPadding + rightPadding
    height: implicitContentHeight + topPadding + bottomPadding
    padding: 10
    topPadding: 8
    bottomPadding: 8
    font {
        family: "微软雅黑"
        pixelSize: 16
    }
    contentItem: Text {
        text: control.text
        font: control.font
        color: control.colorText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 300 } }
    }
    background: Item {
        Rectangle {
            id: __effect
            width: __bg.width
            height: __bg.height
            radius: __bg.radius
            anchors.centerIn: parent
            color: "transparent"
            border.width: control.down || control.hovered ? 12 : 0
            border.color: control.enabled ? "#69b1ff" : "transparent"
            opacity: 0.6

            ParallelAnimation {
                id: __animation
                NumberAnimation {
                    target: __effect; property: "width"; from: __bg.width; to: __bg.width + 12;
                    duration: 200
                }
                NumberAnimation {
                    target: __effect; property: "height"; from: __bg.height; to: __bg.height + 12;
                    duration: 200
                }
                NumberAnimation {
                    target: __effect; property: "opacity"; from: 0.6; to: 0;
                    duration: 200
                }
            }

            Connections {
                target: control
                function onReleased() {
                    if (control.animationEnabled)
                        __animation.restart();
                }
            }
        }
        Rectangle {
            id: __bg
            width: control.pressed ? realWidth - 1 : realWidth
            height: control.pressed ? realHeight - 1 : realHeight
            anchors.centerIn: parent
            radius: control.shape == DelButtonType.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.color: control.colorBorder

            property real realWidth: control.shape == DelButtonType.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == DelButtonType.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
}
