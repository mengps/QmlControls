import QtQuick 2.15
import QtQuick.Window 2.15
import DelegateUI.Controls 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Button Test")

    Column {
        anchors.centerIn: parent
        spacing: 15

        Row {
            spacing: 15

            DelButton {
                text: qsTr("默认按钮")
            }

            DelButton {
                enabled: false
                text: qsTr("默认按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                type: DelButtonType.Type_Primary
                text: qsTr("主按钮")
            }

            DelButton {
                enabled: false
                type: DelButtonType.Type_Primary
                text: qsTr("主按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                shape: DelButtonType.Shape_Circle
                text: qsTr("❤️")
            }

            DelButton {
                type: DelButtonType.Type_Primary
                shape: DelButtonType.Shape_Circle
                text: qsTr("❤️")
                colorText: "red"
            }

            DelButton {
                enabled: false
                shape: DelButtonType.Shape_Circle
                text: qsTr("❤")
            }
        }

        Row {
            spacing: 15

            DelIconButton {
                iconSource: 0xf2b5
            }

            DelIconButton {
                type: DelButtonType.Type_Primary
                iconSource: 0xf2b5
            }

            DelIconButton {
                shape: DelButtonType.Shape_Circle
                iconSource: 0xf2b5
            }

            DelIconButton {
                type: DelButtonType.Type_Primary
                shape: DelButtonType.Shape_Circle
                iconSource: 0xf2b5
            }

            DelIconButton {
                enabled: false
                shape: DelButtonType.Shape_Circle
                iconSource: 0xf2b5
            }
        }
    }
}
