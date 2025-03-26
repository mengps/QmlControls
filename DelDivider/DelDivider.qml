import QtQuick 2.15
import QtQuick.Shapes 1.15

Item {
    id: control

    enum Align
    {
        Align_Left = 0,
        Align_Center = 1,
        Align_Right = 2
    }

    enum Style
    {
        SolidLine = 0,
        DashLine = 1
    }

    font {
        family: "微软雅黑"
        pixelSize: 14
    }

    property bool animationEnabled: true
    property font font
    property string title: ""
    property int titleAlign: DelDivider.Align_Left
    property int titlePadding: 20
    property color colorText: "#000000"
    property color colorSplit: Qt.rgba(0,0,0,0.2)
    property int style: DelDivider.SolidLine
    property int orientation: Qt.Horizontal

    property Component titleDelegate: Text {
        font: control.font
        text: control.title
        color: control.colorText
    }
    property Component splitDelegate: Shape {
        id: __shape

        property real lineX: __titleLoader.x + __titleLoader.implicitWidth * 0.5
        property real lineY: __titleLoader.y + __titleLoader.implicitHeight * 0.5

        ShapePath {
            strokeStyle: control.style == DelDivider.SolidLine ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: 1
            fillColor: "transparent"
            startX: control.orientation == Qt.Horizontal ? 0 : __shape.lineX
            startY: control.orientation == Qt.Horizontal ? __shape.lineY : 0
            PathLine {
                x: {
                    if (control.orientation == Qt.Horizontal) {
                        return control.title == "" ? 0 : __titleLoader.x - 10;
                    } else {
                        return __shape.lineX;
                    }
                }
                y: control.orientation == Qt.Horizontal ? __shape.lineY : __titleLoader.y - 10
            }
        }

        ShapePath {
            strokeStyle: control.style == DelDivider.SolidLine ? ShapePath.SolidLine : ShapePath.DashLine
            strokeColor: control.colorSplit
            strokeWidth: 1
            fillColor: "transparent"
            startX: {
                if (control.orientation == Qt.Horizontal) {
                    return control.title == "" ? 0 : (__titleLoader.x + __titleLoader.implicitWidth + 10);
                } else {
                    return __shape.lineX;
                }
            }
            startY: {
                if (control.orientation == Qt.Horizontal) {
                    return __shape.lineY;
                } else {
                    return control.title == "" ? 0 : (__titleLoader.y + __titleLoader.implicitHeight + 10);
                }
            }

            PathLine {
                x: control.orientation == Qt.Horizontal ?  control.width : __shape.lineX
                y: control.orientation == Qt.Horizontal ? __shape.lineY : control.height
            }
        }
    }

    Behavior on colorSplit { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorText { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

    Loader {
        id: __splitLoader
        sourceComponent: splitDelegate
    }

    Loader {
        id: __titleLoader
        z: 1
        anchors.top: (control.orientation != Qt.Horizontal && control.titleAlign == DelDivider.Align_Left) ? parent.top : undefined
        anchors.topMargin: (control.orientation != Qt.Horizontal && control.titleAlign == DelDivider.Align_Left) ? control.titlePadding : 0
        anchors.bottom: (control.orientation != Qt.Horizontal && control.titleAlign == DelDivider.Align_Right) ? parent.right : undefined
        anchors.bottomMargin: (control.orientation != Qt.Horizontal && control.titleAlign == DelDivider.Align_Right) ? control.titlePadding : 0
        anchors.left: (control.orientation == Qt.Horizontal && control.titleAlign == DelDivider.Align_Left) ? parent.left : undefined
        anchors.leftMargin: (control.orientation == Qt.Horizontal && control.titleAlign == DelDivider.Align_Left) ? control.titlePadding : 0
        anchors.right: (control.orientation == Qt.Horizontal && control.titleAlign == DelDivider.Align_Right) ? parent.right : undefined
        anchors.rightMargin: (control.orientation == Qt.Horizontal && control.titleAlign == DelDivider.Align_Right) ? control.titlePadding : 0
        anchors.horizontalCenter: (control.orientation != Qt.Horizontal || control.titleAlign == DelDivider.Align_Center) ? parent.horizontalCenter : undefined
        anchors.verticalCenter: (control.orientation == Qt.Horizontal || control.titleAlign == DelDivider.Align_Center) ? parent.verticalCenter : undefined
        sourceComponent: titleDelegate
    }
}
