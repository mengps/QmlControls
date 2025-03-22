import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelDivider"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelCard")

    Column {
        anchors.centerIn: parent
        spacing: 20

        DelCard {
            anchors.horizontalCenter: parent.horizontalCenter
            title: qsTr("Card title")
            extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
            bodyDescription: qsTr("Card content\nCard content\nCard content")
        }

        DelDivider {
            width: parent.width
            height: 1
            title: qsTr("整体结构")
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 40

            DelCard {
                id: card
                title: qsTr("Card title")
                extraDelegate: DelButton { type: DelButton.Type_Link; text: qsTr("More") }
                coverSource: "https://gw.alipayobjects.com/zos/rmsportal/JiqGstEfoWAOHiTxclqi.png"
                bodyAvatarIcon: DelIcon.AccountBookOutlined
                bodyTitle: qsTr("Card Meta title")
                bodyDescription: qsTr("This is the description")
                actionDelegate: Item {
                    height: 45

                    DelDivider {
                        width: parent.width
                        height: 1
                    }

                    RowLayout {
                        width: parent.width
                        height: parent.height

                        Item {
                            Layout.preferredWidth: parent.width / 3
                            Layout.fillHeight: true

                            DelIconText {
                                anchors.centerIn: parent
                                iconSource: DelIcon.SettingOutlined
                                iconSize: 16
                            }
                        }

                        Item {
                            Layout.preferredWidth: parent.width / 3
                            Layout.fillHeight: true

                            DelDivider {
                                width: 1
                                height: parent.height * 0.5
                                anchors.verticalCenter: parent.verticalCenter
                                orientation: Qt.Vertical
                            }

                            DelIconText {
                                anchors.centerIn: parent
                                iconSource: DelIcon.EditOutlined
                                iconSize: 16
                            }
                        }

                        Item {
                            Layout.preferredWidth: parent.width / 3
                            Layout.fillHeight: true

                            DelDivider {
                                width: 1
                                height: parent.height * 0.5
                                anchors.verticalCenter: parent.verticalCenter
                                orientation: Qt.Vertical
                            }

                            DelIconText {
                                anchors.centerIn: parent
                                iconSource: DelIcon.EllipsisOutlined
                                iconSize: 16
                            }
                        }
                    }
                }

                Rectangle {
                    id: focusRect
                    width: 0
                    height: 0
                    color: "transparent"
                    border.width: 2
                    border.color: "red"

                    Behavior on x { NumberAnimation { duration: 200 } }
                    Behavior on y { NumberAnimation { duration: 200 } }
                    Behavior on width { NumberAnimation { duration: 200 } }
                    Behavior on height { NumberAnimation { duration: 200 } }
                }
            }

            component Area: Rectangle {
                width: 300
                height: 60
                color: hovered ? Qt.rgba(0,0,0,0.1) : "#fff"
                border.color: Qt.rgba(0,0,0,0.1)

                property alias text: areaText.text
                property alias hovered: hoverHandler.hovered

                function setArea(x, y, w, h) {
                    if (hovered) {
                        focusRect.x = x;
                        focusRect.y = y;
                        focusRect.width = w;
                        focusRect.height = h;
                    }
                }

                Text {
                    id: areaText
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 30
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }

                HoverHandler { id: hoverHandler }
            }

            Column {
                spacing: -1
                Area {
                    text: qsTr("titleDelegate\n设置卡片标题区域代理")
                    onHoveredChanged: {
                        setArea(0, 0, 210, 60);
                    }
                }
                Area {
                    text: qsTr("extraDelegate\n设置卡片右上角操作区域代理")
                    onHoveredChanged: {
                        setArea(210, 0, 90, 60);
                    }
                }
                Area {
                    text: qsTr("coverDelegate\n设置卡片封面区域代理")
                    onHoveredChanged: {
                        setArea(0, 60, card.width, 180);
                    }
                }
                Area {
                    text: qsTr("bodyDelegate\n设置卡片主体区域代理")
                    onHoveredChanged: {
                        setArea(0, 240, card.width, 100);
                    }
                }
                Area {
                    text: qsTr("actionDelegate\n设置卡片动作区域代理")
                    onHoveredChanged: {
                        setArea(0, 340, card.width, 45);
                    }
                }
            }
        }
    }
}
