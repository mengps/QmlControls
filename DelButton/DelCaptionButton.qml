import QtQuick 2.15

DelIconButton {
    id: control

    property bool isError: false

    leftPadding: 12
    rightPadding: 12
    radiusBg: 0
    hoverCursorShape: Qt.ArrowCursor
    type: DelButton.Type_Text
    iconSize: 14
    font.pixelSize: iconSize
    effectEnabled: false
    colorIcon: {
        if (enabled) {
            return checked ? "#4096ff" : "#000";
        } else {
            return Qt.rgba(0,0,0,0.45);
        }
    }
    colorBg: {
        if (enabled) {
            if (isError) {
                return control.down ? "#f5222d": control.hovered ? "#ff7875" : Qt.rgba(245/255,34/255,45/255,0);
            } else {
                return control.down ? Qt.rgba(0,0,0,0.15) : control.hovered ? Qt.rgba(0,0,0,0.06) : Qt.rgba(0,0,0,0);
            }
        } else {
            return Qt.rgba(0,0,0,0.2);
        }
    }
}
