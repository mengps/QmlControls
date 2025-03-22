import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: control

    enum Type {
        Type_Default = 0,
        Type_Outlined = 1,
        Type_Primary = 2,
        Type_Filled = 3,
        Type_Text = 4,
        Type_Link = 5
    }

    enum Shape {
        Shape_Default = 0,
        Shape_Circle = 1
    }

    enum IconPosition {
        Position_Start = 0,
        Position_End = 1
    }

    property bool animationEnabled: true
    property bool effectEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property int type: DelButton.Type_Default
    property int shape: DelButton.Shape_Default
    property int radiusBg: 6
    property color colorText: {
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#000000"
            case DelButton.Type_Outlined:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#1677ff";
            case DelButton.Type_Primary: return "white";
            case DelButton.Type_Filled: return "#1677ff";
            case DelButton.Type_Text:
            case DelButton.Type_Link:
                return control.down ? "#1677ff" : control.hovered ? "#4096ff" : "#1677ff";
            default: return "#4096ff";
            }
        } else {
            return Qt.rgba(0,0,0,0.25);
        }
    }
    property color colorBg: {
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
            case DelButton.Type_Outlined:
                return control.down ? "#ffffff" : control.hovered ? "#ffffff" : "#00ffffff";
            case DelButton.Type_Primary:
                return control.down ? "#0958d9": control.hovered ? "#4096ff" : "#1677ff";
            case DelButton.Type_Filled:
                return control.down ? "#91caff": control.hovered ? "#bae0ff" : "#e6f4ff";
            case DelButton.Type_Text:
                return control.down ? "#91caff": control.hovered ? "#bae0ff" : "#00bae0ff";
            default: return "white";
            }
        } else {
            return Qt.rgba(0,0,0,0.25);
        }
    }
    property color colorBorder: {
        if (type == DelButton.Type_Link) return "transparent";
        if (enabled) {
            switch(control.type)
            {
            case DelButton.Type_Default:
                return control.down ? "#1677ff" : control.hovered ? "#69b1ff" : "#80808080";
            default:
                return control.down ? "#1677ff" : control.hovered ? "#69b1ff" : "#4096ff";
            }
        } else {
            return "#4096ff";
        }
    }
    property string contentDescription: text

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    padding: 10
    topPadding: 5
    bottomPadding: 5
    font {
        family: "微软雅黑"
        pixelSize: 14
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
            visible: control.effectEnabled && control.type != DelButton.Type_Link
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
            radius: control.shape == DelButton.Shape_Default ? control.radiusBg : height * 0.5
            color: control.colorBg
            border.width: (control.type == DelButton.Type_Filled || control.type == DelButton.Type_Text) ? 0 : 1
            border.color: control.enabled ? control.colorBorder : "transparent"

            property real realWidth: control.shape == DelButton.Shape_Default ? parent.width : parent.height
            property real realHeight: control.shape == DelButton.Shape_Default ? parent.height : parent.height

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }
            Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
}
