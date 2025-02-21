import QtQuick 2.15
import QtQuick.Window 2.15

import "qrc:/../common"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelRate")

    Column {
        anchors.centerIn: parent
        spacing: 20

        DelRate {
            initValue: 3
            iconColor: "red"
        }

        DelRate {
            allowHalf: true
            initValue: 3.5
            count: 10
        }

        DelRate {
            allowHalf: true
            initValue: 3.5
            count: 10
            iconColor: "#00a8f3"
            fillIcon: DelIcon.HeartFilled
            emptyIcon: DelIcon.HeartOutlined
            halfIcon: DelIcon.HeartFilled
        }

        DelRate {
            initValue: 3
            toolTipVisible: true
            toolTipTexts: ['terrible', 'bad', 'normal', 'good', 'wonderful']
        }

        DelRate {
            id: customRate
            allowHalf: true
            initValue: 3.5
            count: 10
            iconColor: "#0ed145"
            fillDelegate: Rectangle {
                width: customRate.iconSize
                height: customRate.iconSize
                color: customRate.iconColor
            }
            emptyDelegate: Rectangle {
                width: customRate.iconSize
                height: customRate.iconSize
                color: "transparent"
                border.width: 2
                border.color: customRate.iconColor
            }
            halfDelegate: Row {
                Rectangle {
                    width: customRate.iconSize * 0.5
                    height: customRate.iconSize
                    color: customRate.iconColor
                    border.width: 2
                    border.color: customRate.iconColor
                }
                Rectangle {
                    width: customRate.iconSize * 0.5
                    height: customRate.iconSize
                    color: "transparent"
                    border.width: 2
                    border.color:  customRate.iconColor
                }
            }
        }
    }
}
