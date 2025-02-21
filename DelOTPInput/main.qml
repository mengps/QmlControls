import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 680
    height: 500
    visible: true
    title: qsTr("DelegateUI-DelOTPInput")

    Column {
        anchors.centerIn: parent
        spacing: 10

        Text {
            text: qsTr("[默认仅允许输入数字] 当前输入: ") + number.currentInput
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }

        DelOTPInput {
            id: number
            length: 6
        }

        DelOTPInput {
            length: 6
            enabled: false
        }

        Text {
            text: qsTr("[仅允许输入字母] 当前输入: ") + letter.currentInput
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }

        DelOTPInput {
            id: letter
            length: 6
            itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
        }

        Text {
            text: qsTr("[自动大小输入字母] 当前输入: ") + upper.currentInput
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }

        DelOTPInput {
            id: upper
            length: 6
            itemValidator: RegularExpressionValidator { regularExpression: /[a-zA-Z]?/ }
            formatter: (text) => text.toUpperCase();
        }

        Text {
            text: qsTr("[密码(0-9 a-z A-Z)] 当前输入: ") + password.currentInput
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }

        DelOTPInput {
            id: password
            length: 6
            itemPassword: true
            itemPasswordCharacter: "●"
            itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]?/ }
        }

        Text {
            text: qsTr("[16位序列号] 当前输入: ") + activationCodeInput.currentInput
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
        }

        DelOTPInput {
            id: activationCodeInput
            length: 4
            characterLength: 4
            itemWidth: 80
            itemSpacing: 5
            itemValidator: RegularExpressionValidator { regularExpression: /[0-9a-zA-Z]{1,4}/ }
            formatter: (text) => text.toUpperCase();
            dividerDelegate: Item {
                width: 12
                height: activationCodeInput.itemHeight

                Rectangle {
                    width: 12
                    height: 1
                    color: "#000"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
