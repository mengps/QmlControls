import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qrc:/../DelButton"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelToolTip")

    GridLayout {
        anchors.centerIn: parent
        width: 400
        rows: 3
        columns: 3

        DelButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 3
            text: qsTr("上方")

            DelToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr("上方文字提示")
            }
        }

        DelButton {
            Layout.alignment: Qt.AlignLeft
            text: qsTr("左方")

            DelToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr("左方文字提示")
                position: DelToolTip.Position_Left
            }
        }

        DelButton {
            Layout.alignment: Qt.AlignCenter
            text: qsTr("箭头中心")

            DelToolTip {
                x: 0
                visible: parent.hovered
                arrowVisible: true
                text: qsTr("箭头中心会自动指向 parent 的中心")
                position: DelToolTip.Position_Top
            }
        }

        DelButton {
            Layout.alignment: Qt.AlignRight
            text: qsTr("右方")

            DelToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr("右方文字提示")
                position: DelToolTip.Position_Right
            }
        }

        DelButton {
            Layout.alignment: Qt.AlignHCenter
            Layout.columnSpan: 3
            text: qsTr("下方")

            DelToolTip {
                visible: parent.hovered
                arrowVisible: true
                text: qsTr("下方文字提示")
                position: DelToolTip.Position_Bottom
            }
        }
    }
}
