import QtQuick 2.15
import QtQuick.Layouts 1.15

import "qrc:/../DelAvatar"
import "qrc:/../DelDivider"

Rectangle {
    id: control

    width: 300
    height: __column.height
    color: "#fff"
    border.color: Qt.rgba(0,0,0,0.2)
    radius: 6
    clip: true

    titleFont {
        family: "微软雅黑"
        pixelSize: 14
        weight: Font.DemiBold
    }

    bodyTitleFont {
        family: "微软雅黑"
        pixelSize: 14
        weight: Font.DemiBold
    }

    bodyDescriptionFont {
        family: "微软雅黑"
        pixelSize: 14
    }

    property string title: ""
    property font titleFont

    property url coverSource: ""
    property int coverFillMode: Image.Stretch

    property int bodyAvatarSize: 40
    property int bodyAvatarIcon: 0
    property string bodyAvatarSource: ""
    property string bodyAvatarText: ""
    property string bodyTitle: ""
    property font bodyTitleFont
    property string bodyDescription: ""
    property font bodyDescriptionFont

    property color colorTitle: "#000"
    property color colorBodyAvatar: "#000"
    property color colorBodyAvatarBg: "transparent"
    property color colorBodyTitle: "#000"
    property color colorBodyDescription: Qt.rgba(0,0,0,0.45)

    property Component titleDelegate: Item {
        height: 60

        RowLayout {
            anchors.fill: parent
            anchors.topMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 15
            anchors.rightMargin: 15

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: control.title
                font: control.titleFont
                color: control.colorTitle
                wrapMode: Text.WrapAnywhere
                verticalAlignment: Text.AlignVCenter
            }

            Loader {
                Layout.alignment: Qt.AlignVCenter
                sourceComponent: extraDelegate
            }
        }

        DelDivider {
            width: parent.width;
            height: 1
            anchors.bottom: parent.bottom
            visible: control.coverSource == ""
        }
    }
    property Component extraDelegate: Item { }
    property Component coverDelegate: Image {
        height: control.coverSource == "" ? 0 : 180
        source: control.coverSource
        fillMode: control.coverFillMode
    }
    property Component bodyDelegate: Item {
        height: 100

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.preferredWidth: __avatar.visible ? 70 : 0
                Layout.fillHeight: true

                DelAvatar {
                    id: __avatar
                    size: control.bodyAvatarSize
                    anchors.centerIn: parent
                    colorBg: control.colorBodyAvatarBg
                    iconSource: control.bodyAvatarIcon
                    imageSource: control.bodyAvatarSource
                    textSource: control.bodyAvatarText
                    colorIcon: control.colorBodyAvatar
                    colorText: control.colorBodyAvatar
                    visible: !(iconSource == 0 && imageSource == "" && textSource == "")
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Text {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyTitle
                    font: control.bodyTitleFont
                    color: control.colorBodyTitle
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyTitle != ""
                }

                Text {
                    Layout.fillWidth: true
                    leftPadding: __avatar.visible ? 0 : 15
                    rightPadding: 15
                    text: control.bodyDescription
                    font: control.bodyDescriptionFont
                    color: control.colorBodyDescription
                    wrapMode: Text.WrapAnywhere
                    visible: control.bodyDescription != ""
                }
            }
        }
    }
    property Component actionDelegate: Item { }

    Column {
        id: __column
        width: parent.width

        Loader {
            width: parent.width
            sourceComponent: titleDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: coverDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: bodyDelegate
        }
        Loader {
            width: parent.width
            sourceComponent: actionDelegate
        }
    }
}
