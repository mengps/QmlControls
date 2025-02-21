import QtQuick 2.15
import QtQuick.Controls 2.15 as T

import "qrc:/../common"

T.TextField {
    id: control

    enum IconPosition {
        Position_Left = 0,
        Position_Right = 1
    }

    property bool animationEnabled: true
    readonly property bool active: hovered || activeFocus
    property int iconSource: 0
    property int iconSize: 16
    property int iconPosition: DelInput.Position_Left
    property color colorIcon: colorText
    property color colorText: enabled ? "#000" : Qt.rgba(0,0,0,0.45)
    property color colorBorder: enabled ? active ? "#1677ff" : Qt.rgba(0,0,0,0.25) : "transparent"
    property color colorBg: enabled ? "#fff" : Qt.rgba(0,0,0,0.1)
    property int radiusBg: 6
    property string contentDescription: ""

    property Component iconDelegate: DelIconText {
        iconSource: control.iconSource
        iconSize: control.iconSize
        colorIcon: control.colorIcon
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

    objectName: "__DelInput__"
    focus: true
    padding: 5
    leftPadding: 10 + ((iconSource != 0 && iconPosition == DelInput.Position_Left) ? iconSize : 0)
    rightPadding: 10 + ((iconSource != 0 && iconPosition == DelInput.Position_Right) ? iconSize : 0)
    implicitWidth: contentWidth + leftPadding + rightPadding
    implicitHeight: contentHeight + topPadding + bottomPadding
    color: colorText
    selectByMouse: true
    placeholderTextColor: enabled ? Qt.rgba(0,0,0,0.25) : Qt.rgba(0,0,0,0.45)
    selectedTextColor: "#000"
    selectionColor: Qt.rgba(22/255, 119/255, 1, 0.6)
    font {
        family: "微软雅黑"
        pixelSize: 14
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        radius: control.radiusBg

        Loader {
            anchors.left: iconPosition == DelInput.Position_Left ? parent.left : undefined
            anchors.right: iconPosition == DelInput.Position_Right ? parent.right : undefined
            anchors.margins: 5
            anchors.verticalCenter: parent.verticalCenter
            active: control.iconSize != 0
            sourceComponent: iconDelegate
        }
    }

    Accessible.role: Accessible.EditableText
    Accessible.editable: true
    Accessible.description: control.contentDescription
}
