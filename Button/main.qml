import QtQuick 2.15
import QtQuick.Window 2.15
import "qrc:/../common"

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
                type: DelButton.Type_Outlined
                text: qsTr("线框按钮")
            }

            DelButton {
                enabled: false
                type: DelButton.Type_Outlined
                text: qsTr("线框按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                type: DelButton.Type_Primary
                text: qsTr("主要按钮")
            }

            DelButton {
                enabled: false
                type: DelButton.Type_Primary
                text: qsTr("主要按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                type: DelButton.Type_Filled
                text: qsTr("填充按钮")
            }

            DelButton {
                enabled: false
                type: DelButton.Type_Filled
                text: qsTr("填充按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                type: DelButton.Type_Text
                text: qsTr("文本按钮")
            }

            DelButton {
                enabled: false
                type: DelButton.Type_Text
                text: qsTr("文本按钮禁用")
            }
        }

        Row {
            spacing: 15

            DelButton {
                shape: DelButton.Shape_Circle
                text: qsTr("❤️")
            }

            DelButton {
                type: DelButton.Type_Primary
                shape: DelButton.Shape_Circle
                text: qsTr("❤️")
                colorText: "red"
            }

            DelButton {
                enabled: false
                shape: DelButton.Shape_Circle
                text: qsTr("❤")
            }
        }

        Row {
            spacing: 15

            DelIconButton {
                iconSource: DelIcon.GiftOutlined
            }

            DelIconButton {
                type: DelButton.Type_Outlined
                iconSource: DelIcon.GiftOutlined
            }

            DelIconButton {
                type: DelButton.Type_Primary
                iconSource: DelIcon.GiftOutlined
                text: qsTr("礼物")
            }

            DelIconButton {
                type: DelButton.Type_Filled
                iconSource: DelIcon.GiftOutlined
                text: qsTr("礼物")
            }

            DelIconButton {
                type: DelButton.Type_Text
                iconPosition: DelButton.Position_End
                iconSource: DelIcon.GiftOutlined
                text: qsTr("礼物")
            }

            DelIconButton {
                type: DelButton.Type_Primary
                shape: DelButton.Shape_Circle
                iconSource: DelIcon.GiftOutlined
            }

            DelIconButton {
                enabled: false
                shape: DelButton.Shape_Circle
                iconSource: DelIcon.GiftOutlined
            }
        }
    }
}
