import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("ColorPicker Control")

    /*! 可以直接使用 */
    ColorPicker {
        id: colorPicker
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5
        z: 10
    }

    ColorPickerPopup {
        id: colorPickerPopup
    }

    Row {
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        spacing: 10

        Button {
            id: button1
            text: qsTr("打开")
            onClicked: {
                colorPicker.open();
            }
        }

        Rectangle {
            height: button1.height
            width: button1.width
            color: colorPicker.currentColor
            border.color: "black"
        }

        Button {
            id: button2
            text: qsTr("打开弹窗")
            onClicked: {
                colorPickerPopup.open();
            }
        }

        Rectangle {
            height: button2.height
            width: button2.width
            color: colorPickerPopup.currentColor
            border.color: "black"
        }
    }
}
