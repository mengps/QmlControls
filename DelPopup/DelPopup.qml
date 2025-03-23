import QtQuick 2.15
import QtGraphicalEffects 1.15
import QtQuick.Templates 2.15 as T

import "qrc:/../DelResizeMouseArea"

T.Popup {
    id: control

    property bool animationEnabled: true
    property bool movable: false
    property bool resizable: false
    property real minimumX: Number.NaN
    property real maximumX: Number.NaN
    property real minimumY: Number.NaN
    property real maximumY: Number.NaN
    property real minimumWidth: 0
    property real maximumWidth: Number.NaN
    property real minimumHeight: 0
    property real maximumHeight: Number.NaN
    property color colorShadow: "#80000000"
    property color colorBg: "#fff"
    property int radiusBg: 6

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    enter: Transition {
        NumberAnimation {
            property: "opacity";
            from: 0.0
            to: 1.0
            duration: control.animationEnabled ? 200 : 0
        }
    }
    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0
            duration: control.animationEnabled ? 200 : 0
        }
    }
    background: Item {
        DropShadow {
            anchors.fill: __popupRect
            radius: 8.0
            samples: 17
            color: control.colorShadow
            source: __popupRect
        }
        Rectangle {
            id: __popupRect
            anchors.fill: parent
            color: control.colorBg
            radius: control.radiusBg
        }
        Loader {
            active: control.movable || control.resizable
            sourceComponent: DelResizeMouseArea {
                anchors.fill: parent
                target: control
                movable: control.movable
                resizable: control.resizable
                minimumX: control.minimumX
                maximumX: control.maximumX
                minimumY: control.minimumY
                maximumY: control.maximumY
                minimumWidth: control.minimumWidth
                maximumWidth: control.maximumWidth
                minimumHeight: control.minimumHeight
                maximumHeight: control.maximumHeight
            }
        }
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: 200 } }
}
