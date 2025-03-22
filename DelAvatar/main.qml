import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelAvatar")

    Column {
        anchors.centerIn: parent
        spacing: 30

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Row {
                spacing: 10

                DelAvatar {
                    size: 100
                    iconSource: DelIcon.UserOutlined
                }

                DelAvatar {
                    size: 80
                    iconSource: DelIcon.UserOutlined
                }

                DelAvatar {
                    size: 60
                    iconSource: DelIcon.UserOutlined
                }

                DelAvatar {
                    size: 40
                    iconSource: DelIcon.UserOutlined
                }

                DelAvatar {
                    size: 20
                    iconSource: DelIcon.UserOutlined
                }
            }

            Row {
                spacing: 10

                DelAvatar {
                    size: 100
                    iconSource: DelIcon.UserOutlined
                    radiusBg: 6
                }

                DelAvatar {
                    size: 80
                    iconSource: DelIcon.UserOutlined
                    radiusBg: 6
                }

                DelAvatar {
                    size: 60
                    iconSource: DelIcon.UserOutlined
                    radiusBg: 6
                }

                DelAvatar {
                    size: 40
                    iconSource: DelIcon.UserOutlined
                    radiusBg: 6
                }

                DelAvatar {
                    size: 20
                    iconSource: DelIcon.UserOutlined
                    radiusBg: 6
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                iconSource: DelIcon.UserOutlined
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                textSource: "U"
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                textSource: "USER"
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                imageSource: "https://avatars.githubusercontent.com/u/33405710?v=4"
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                textSource: "U"
                colorText: "#F56A00"
                colorBg: "#FDE3CF"
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                iconSource: DelIcon.UserOutlined
                colorBg: "#87D068"
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                size: 40
                textSource: changeButton.userList[changeButton.index]
                colorBg: changeButton.colorList[changeButton.index]
                textSize: DelAvatar.Size_Fixed
            }

            DelAvatar {
                anchors.verticalCenter: parent.verticalCenter
                size: 40
                textSource: changeButton.userList[changeButton.index]
                colorBg: changeButton.colorList[changeButton.index]
                textSize: DelAvatar.Size_Auto
            }

            DelButton {
                id: changeButton
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("ChangeUser")
                onClicked: {
                    index = (index + 1) % 4;
                }
                property int index: 0
                property var userList: ['U', 'Lucy', 'Tom', 'Edward']
                property var colorList: ['#f56a00', '#7265e6', '#ffbf00', '#00a2ae']
            }
        }
    }
}
