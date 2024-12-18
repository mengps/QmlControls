import QtQuick 2.15
import QtQuick.Controls 2.15
import DelegateUI.Controls 1.0

Button {
    id: control

    property bool animationEnabled: true
        property bool effectEnabled: true
    property int type: DelButtonType.Type_Default
    property int shape: DelButtonType.Shape_Default
    property int radiusBg: 6
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#000000"
            case DelButtonType.Type_Outlined:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#1677ff";
            case DelButtonType.Type_Primary: return "white";
            case DelButtonType.Type_Filled: return "#1677ff";
            case DelButtonType.Type_Text: return "#4096ff";
            default: return "#4096ff";
            }
        } else {
            return Qt.rgba(0,0,0,0.45);
        }
    }
    property color colorBg: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
            case DelButtonType.Type_Outlined:
                return control.down ? "#ffffff" : control.hovered ? "#ffffff" : "#00ffffff";
            case DelButtonType.Type_Primary:
                return control.down ? "#0958d9": control.hovered ? "#4096ff" : "#1677ff";
            case DelButtonType.Type_Filled:
                return control.down ? "#91caff": control.hovered ? "#bae0ff" : "#e6f4ff";
            case DelButtonType.Type_Text:
                return control.down ? "#91caff": control.hovered ? "#bae0ff" : "#00bae0ff";
            default: return "white";
            }
        } else {
            return Qt.rgba(0,0,0,0.45);
        }
    }
    property color colorBorder: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? "#1677ff" : control.hovered ? "#69b1ff" : "#80808080";
            default:
                return control.down ? "#1677ff" : control.hovered ? "#69b1ff" : "#4096ff";
            }
        } else {
            return "#4096ff";
        }
    }
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
            border.width: 0
            border.color: control.enabled ? "#69b1ff" : "transparent"
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
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius: control.shape == DelButtonType.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.width: (control.type == DelButtonType.Type_Filled || control.type == DelButtonType.Type_Text) ? 0 : 1
            border.color: control.enabled ? control.colorBorder : "transparent"

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
