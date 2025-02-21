import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../DelInput"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelCheckBox")

    Column {
        anchors.centerIn: parent
        spacing: 30

        Row {
            spacing: 10

            DelCheckBox {
                text: qsTr("Checkbox")
            }

            DelCheckBox {
                text: qsTr("Disabled")
                enabled: false
            }

            DelCheckBox {
                text: qsTr("Disabled")
                checkState: Qt.PartiallyChecked
                enabled: false
            }

            DelCheckBox {
                text: qsTr("Disabled")
                checkState: Qt.Checked
                enabled: false
            }
        }

        Column {
            spacing: 10

            ButtonGroup {
                id: childGroup
                exclusive: false
                checkState: parentBox.checkState
            }

            DelCheckBox {
                id: parentBox
                text: qsTr("Parent")
                checkState: childGroup.checkState
            }

            DelCheckBox {
                checked: true
                text: qsTr("Child 1")
                leftPadding: indicator.width
                ButtonGroup.group: childGroup
            }

            DelCheckBox {
                text: qsTr("Child 2")
                leftPadding: indicator.width
                ButtonGroup.group: childGroup
            }

            DelCheckBox {
                text: qsTr("Child 3")
                leftPadding: indicator.width
                ButtonGroup.group: childGroup
            }

            DelCheckBox {
                text: qsTr("More...")
                leftPadding: indicator.width
                ButtonGroup.group: childGroup

                DelInput {
                    width: 110
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
