import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import "qrc:/../common"
import "qrc:/../Button"
import "qrc:/../Switch"
import "qrc:/../RadioBlock"

Window {
    width: 1000
    height: 750
    visible: true
    color: "#f0f0f0"
    title: qsTr("TabView Test")

    Column {
        width: parent.width
        spacing: 10

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            DelRadioBlock {
                id: positionRadio1
                initCheckedIndex: 0
                model: [
                    { label: qsTr("上"), value: DelTabView.Position_Top },
                    { label: qsTr("下"), value: DelTabView.Position_Bottom },
                    { label: qsTr("左"), value: DelTabView.Position_Left },
                    { label: qsTr("右"), value: DelTabView.Position_Right }
                ]
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: qsTr("是否居中")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelSwitch {
                id: isCenterSwitch
                checkedText: qsTr("是")
                uncheckedText: qsTr("否")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: qsTr("标签大小")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelSwitch {
                id: sizeSwitch
                checkedText: qsTr("固定")
                uncheckedText: qsTr("自动")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        DelTabView {
            id: defaultTabView
            width: parent.width
            height: 200
            defaultTabWidth: 50
            tabPosition: positionRadio1.currentCheckedValue
            tabSize: sizeSwitch.checked ? DelTabView.Size_Fixed : DelTabView.Size_Auto
            tabCentered: isCenterSwitch.checked
            addTabCallback:
                () => {
                    append({
                               title: "New Tab " + (count + 1),
                               content: "Content of Tab Content ",
                               contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                           });
                    currentIndex = count - 1;
                    positionViewAtEnd();
                }
            contentDelegate: Rectangle {
                color: model.contentColor

                Text {
                    anchors.centerIn: parent
                    text: model.content + (index + 1)
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }
            initModel: [
                {
                    key: "1",
                    icon: DelIcon.MessageOutlined,
                    title: "Tab 1",
                    content: "Content of Tab Content ",
                    contentColor: "#60ff0000"
                },
                {
                    key: "2",
                    icon: DelIcon.MessageOutlined,
                    title: "Tab 2",
                    content: "Content of Tab Content ",
                    contentColor: "#6000ff00"
                },
                {
                    key: "3",
                    title: "Tab 3",
                    content: "Content of Tab Content ",
                    contentColor: "#600000ff"
                }
            ]
        }

        Rectangle {
            width: parent.width
            height: 1
            color: "black"
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 2

            DelRadioBlock {
                id: positionRadio2
                initCheckedIndex: 0
                model: [
                    { label: qsTr("上"), value: DelTabView.Position_Top },
                    { label: qsTr("下"), value: DelTabView.Position_Bottom },
                    { label: qsTr("左"), value: DelTabView.Position_Left },
                    { label: qsTr("右"), value: DelTabView.Position_Right }
                ]
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: qsTr("是否居中")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelSwitch {
                id: isCenterSwitch2
                checkedText: qsTr("是")
                uncheckedText: qsTr("否")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: qsTr("标签大小")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelSwitch {
                id: sizeSwitch2
                checkedText: qsTr("固定")
                uncheckedText: qsTr("自动")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: qsTr("是否可编辑")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelSwitch {
                id: typeSwitch
                checkedText: qsTr("是")
                uncheckedText: qsTr("否")
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        DelTabView {
            id: cardTabView
            width: parent.width
            height: 200
            defaultTabWidth: 50
            tabPosition: positionRadio2.currentCheckedValue
            tabSize: sizeSwitch2.checked ? DelTabView.Size_Fixed : DelTabView.Size_Auto
            tabType: typeSwitch.checked ? DelTabView.Type_CardEditable :  DelTabView.Type_Card
            tabCentered: isCenterSwitch2.checked
            addTabCallback:
                () => {
                    append({
                               title: "New Tab " + (count + 1),
                               content: "Content of Tab Content ",
                               contentColor: Qt.rgba(Math.random(), Math.random(), Math.random(), 0.24).toString()
                           });
                    currentIndex = count - 1;
                    positionViewAtEnd();
                }
            contentDelegate: Rectangle {
                color: model.contentColor

                Text {
                    anchors.centerIn: parent
                    text: model.content + (index + 1)
                    font {
                        family: "微软雅黑"
                        pixelSize: 14
                    }
                }
            }
            initModel: [
                {
                    key: "1",
                    icon: DelIcon.MessageOutlined,
                    title: "Tab 1",
                    content: "Content of Card Tab Content ",
                    contentColor: "#60ff0000"
                },
                {
                    key: "2",
                    editable: false,
                    icon: DelIcon.MessageOutlined,
                    title: "Tab 2",
                    content: "Content of Card Tab Content ",
                    contentColor: "#6000ff00"
                },
                {
                    key: "3",
                    title: "Tab 3",
                    content: "Content of Card Tab Content ",
                    contentColor: "#600000ff"
                }
            ]
        }
    }
}
