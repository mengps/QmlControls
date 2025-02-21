import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelRadio")

    Column {
        anchors.centerIn: parent
        spacing: 40

        Row {
            spacing: 10

            DelRadio {
                text: qsTr("Radio")
            }

            DelRadio {
                text: qsTr("Disabled")
                enabled: false
            }
        }

        Row {
            spacing: 10

            ButtonGroup { id: radioGroup }

            DelRadio {
                text: qsTr("Emoji1")
                ButtonGroup.group: radioGroup

                Text {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "😀"
                    font.pixelSize: 20
                }
            }

            DelRadio {
                text: qsTr("Emoji2")
                ButtonGroup.group: radioGroup

                Text {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "😁"
                    font.pixelSize: 20
                }
            }

            DelRadio {
                text: qsTr("Emoji3")
                ButtonGroup.group: radioGroup

                Text {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "😂"
                    font.pixelSize: 20
                }
            }

            DelRadio {
                text: qsTr("Emoji4")
                ButtonGroup.group: radioGroup

                Text {
                    anchors.bottom: parent.top
                    anchors.bottomMargin: 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "🤣"
                    font.pixelSize: 20
                }
            }
        }

        Column {
            spacing: 10

            ButtonGroup { id: radioGroup2 }

            DelRadio {
                text: qsTr("Option A")
                ButtonGroup.group: radioGroup2
            }

            DelRadio {
                text: qsTr("Option B")
                ButtonGroup.group: radioGroup2
            }

            DelRadio {
                text: qsTr("Option C")
                ButtonGroup.group: radioGroup2
            }

            DelRadio {
                text: qsTr("More...")
                ButtonGroup.group: radioGroup2

                TextField {
                    width: 110
                    height: 30
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.right
                    anchors.leftMargin: 10
                    visible: parent.checked
                    placeholderText: qsTr("Please input")
                }
            }
        }
    }
}
