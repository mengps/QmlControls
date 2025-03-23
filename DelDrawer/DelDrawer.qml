import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import QtQuick.Templates 2.15 as T

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelDivider"

T.Drawer {
    id: control

    titleFont {
        family: "微软雅黑"
        pixelSize: 18
    }

    property bool animationEnabled: true
    property int drawerSize: 378
    property string title: ""
    property font titleFont
    property color colorTitle: "#000"
    property color colorBg: "#fff"
    property color colorOverlay: Qt.rgba(0,0,0,0.45)
    property Component titleDelegate: Item {
        height: 56

        Row {
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 15
            spacing: 5

            DelIconButton {
                id: __close
                type: DelButton.Type_Text
                effectEnabled: false
                topPadding: 2
                bottomPadding: 2
                leftPadding: 4
                rightPadding: 4
                radiusBg: 4
                anchors.verticalCenter: parent.verticalCenter
                iconSource: DelIcon.CloseOutlined
                hoverCursorShape: Qt.PointingHandCursor
                colorIcon: hovered ? Qt.rgba(0,0,0,1) : Qt.rgba(0,0,0,0.4)
                colorBg: __close.down ? Qt.rgba(0,0,0,0.15) :
                                        __close.hovered ? Qt.rgba(0,0,0,0.06) : Qt.rgba(0,0,0,0)
                onClicked: {
                    control.close();
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: control.title
                font: control.titleFont
                color: control.colorTitle
            }
        }

        DelDivider {
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }
    property Component contentDelegate: Item { }

    enter: Transition { NumberAnimation { duration: control.animationEnabled ? 200 : 0 } }
    exit: Transition { NumberAnimation { duration: control.animationEnabled ? 200 : 0 } }

    width: edge == Qt.LeftEdge || edge == Qt.RightEdge ? drawerSize : parent.width
    height: edge == Qt.LeftEdge || edge == Qt.RightEdge ? parent.height : drawerSize
    edge: Qt.RightEdge
    parent: T.Overlay.overlay
    modal: true
    background: Item {
        DropShadow {
            anchors.fill: __rect
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: __rect
        }
        Rectangle {
            id: __rect
            anchors.fill: parent
            color: control.colorBg
        }
    }
    contentItem: ColumnLayout {
        Loader {
            Layout.fillWidth: true
            sourceComponent: titleDelegate
        }
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: contentDelegate
        }
    }

    T.Overlay.modal: Rectangle {
        color: control.colorOverlay
    }
}
