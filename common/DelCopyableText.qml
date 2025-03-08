import QtQuick 2.15

TextEdit {
    id: control

    readOnly: true
    color: "#000"
    selectByMouse: true
    selectByKeyboard: true
    selectedTextColor: "#000"
    selectionColor: Qt.rgba(22/255,119/255,1,0.6)
    font {
        family: "微软雅黑"
        pixelSize: 14
    }
}
