import QtQuick 2.15
import QtQuick.Templates 2.15 as T

import "qrc:/../common"
import "qrc:/../DelPopup"
import "qrc:/../DelScrollBar"
import "qrc:/../DelToolTip"

T.ComboBox {
    id: control

    property bool animationEnabled: true
    property int hoverCursorShape: Qt.PointingHandCursor
    property bool tooltipVisible: false
    property bool loading: false
    property int defaulPopupMaxHeight: 240
    property color colorText: enabled ? "#000" : Qt.rgba(0,0,0,0.45)
    property color colorBorder: enabled ? hovered ? "#1677ff" : Qt.rgba(0,0,0,0.25) : "transparent"
    property color colorBg: enabled ? "#fff" : Qt.rgba(0,0,0,0.1)

    property int radiusBg: 6
    property int radiusPopupBg: 6
    property string contentDescription: ""

    property Component indicatorDelegate: DelIconText {
        iconSize: 12
        iconSource: control.loading ? DelIcon.LoadingOutlined : DelIcon.DownOutlined

        NumberAnimation on rotation {
            running: control.loading
            from: 0
            to: 360
            loops: Animation.Infinite
            duration: 1000
        }
    }

    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorBorder { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

    rightPadding: 8
    topPadding: 5
    bottomPadding: 5
    implicitWidth: implicitContentWidth + implicitIndicatorWidth + leftPadding + rightPadding
    implicitHeight: implicitContentHeight + topPadding + bottomPadding
    textRole: "label"
    valueRole: "value"
    objectName: "__DelSelect__"
    font {
        family: "微软雅黑"
        pixelSize: 14
    }
    delegate: T.ItemDelegate { }
    indicator: Loader {
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        sourceComponent: indicatorDelegate
    }
    contentItem: Text {
        leftPadding: 8
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText
        font: control.font
        color: control.colorText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Rectangle {
        color: control.colorBg
        border.color: control.colorBorder
        border.width: control.visualFocus ? 2 : 1
        radius: control.radiusBg
    }
    popup: DelPopup {
        y: control.height + 2
        implicitWidth: control.width
        implicitHeight: implicitContentHeight + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: control.animationEnabled ? 200 : 0 } }
        exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: control.animationEnabled ? 200 : 0 } }
        contentItem: ListView {
            id: __popupListView
            clip: true
            implicitHeight: Math.min(control.defaulPopupMaxHeight, contentHeight)
            model: control.popup.visible ? control.model : null
            currentIndex: control.highlightedIndex
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var modelData
                required property int index
                property alias model: __popupDelegate.modelData

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 4
                bottomPadding: 4
                enabled: model.enabled ?? true
                contentItem: Text {
                    text: __popupDelegate.model[control.textRole]
                    color: __popupDelegate.enabled ? "#000" : Qt.rgba(0,0,0,0.45)
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 2
                    color: {
                        if (__popupDelegate.enabled)
                            return highlighted ? "#e6f4ff" : hovered ? Qt.rgba(0,0,0,0.1) : "transparent";
                        else
                            return "transparent";
                    }

                    Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
                }
                highlighted: control.highlightedIndex === index
                onClicked: {
                    control.currentIndex = index;
                    control.activated(index);
                    control.popup.close();
                }

                HoverHandler {
                    cursorShape: control.hoverCursorShape
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: DelToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        text: __popupDelegate.model[control.textRole]
                        position: DelToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: DelScrollBar { }

            Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: 100 } }
        }
    }

    HoverHandler {
        cursorShape: control.hoverCursorShape
    }

    Accessible.role: Accessible.ComboBox
    Accessible.name: control.displayText
    Accessible.description: control.contentDescription
}
