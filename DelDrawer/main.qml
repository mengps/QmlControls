import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelRadio"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelDrawer")

    Column {
        anchors.centerIn: parent
        spacing: 10

        Row {
            spacing: 10

            ButtonGroup { id: radioGroup }

            DelRadio {
                text: qsTr("上")
                checked: true
                ButtonGroup.group: radioGroup
                property int value: Qt.TopEdge
            }

            DelRadio {
                text: qsTr("下")
                ButtonGroup.group: radioGroup
                property int value: Qt.BottomEdge
            }

            DelRadio {
                text: qsTr("左")
                ButtonGroup.group: radioGroup
                property int value: Qt.LeftEdge
            }

            DelRadio {
                text: qsTr("右")
                ButtonGroup.group: radioGroup
                property int value: Qt.RightEdge
            }
        }

        DelButton {
            anchors.horizontalCenter: parent.horizontalCenter
            type: DelButton.Type_Primary
            text: qsTr("打开")
            onClicked: drawer.open();

            DelDrawer {
                id: drawer
                drawerSize: 260
                edge: radioGroup.checkedButton.value
                title: qsTr("Basic Drawer")
                contentDelegate: DelCopyableText {
                    leftPadding: 15
                    text: "Some contents...\nSome contents...\nSome contents..."
                }
            }
        }
    }
}
