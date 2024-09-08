import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Rate Test")

    Column {
        anchors.centerIn: parent
        spacing: 20

        Rate {
            value: 3
            iconColor: "red"
        }

        Rate {
            allowHalf: true
            value: 3.5
            count: 10
        }

        Rate {
            allowHalf: true
            value: 3.5
            count: 10
            iconFontSize: 20
            iconColor: "#00a8f3"
            fillIcon: "\uf240"
            emptyIcon: "\uf244"
            halfIcon: "\uf242"
        }

        Rate {
            id: customRate
            allowHalf: true
            value: 3.5
            count: 10
            iconColor: "#0ed145"
            fillDelegate: Rectangle {
                width: customRate.iconSize
                height: customRate.iconSize
                color: hovered ? Qt.lighter(customRate.iconColor) : customRate.iconColor
            }
            emptyDelegate: Rectangle {
                width: customRate.iconSize
                height: customRate.iconSize
                color: "transparent"
                border.width: 2
                border.color: hovered ? Qt.lighter(customRate.iconColor) : customRate.iconColor
            }
            halfDelegate: Row {
                Rectangle {
                    width: customRate.iconSize * 0.5
                    height: customRate.iconSize
                    color: hovered ? Qt.lighter(customRate.iconColor) : customRate.iconColor
                    border.width: 2
                    border.color: hovered ? Qt.lighter(customRate.iconColor) : customRate.iconColor
                }
                Rectangle {
                    width: customRate.iconSize * 0.5
                    height: customRate.iconSize
                    color: "transparent"
                    border.width: 2
                    border.color: hovered ? Qt.lighter(customRate.iconColor) : customRate.iconColor
                }
            }
        }
    }
}
