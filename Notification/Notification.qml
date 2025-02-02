import QtQuick 2.15

import "qrc:/../common"

Item {
    id: root

    property real backgroundWidth: width - 20
    property color backgroundColor: "#a0c4d6ff"
    property real backgroundRadius: 5
    property real topMargin: 10
    property real bottomMargin: 10
    property color iconColor: "black"
    property real titleSpacing: 10
    property color titleColor: "black"
    property font titleFont
    property color messageColor: "black"
    property font messageFont
    property alias notificationDelegate: repeater.delegate

    function notify(title, message, type = Notification.None, timeout = 3000) {
        listModel.append({
                             title: title,
                             message: message,
                             type: type,
                             timeout: timeout
                         });
    }

    function notify2(object) {
        listModel.append(object);
    }

    enum DefaultType {
        None = 0,
        Success = 1,
        Warning = 2,
        Message = 3,
        Error = 4
    }

    FontLoader {
        id: delegateuiFont
        source: "qrc:/../common/DelegateUI-Icons.ttf"
    }

    Column {
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10

        Repeater {
            id: repeater
            model: ListModel {
                id: listModel
            }
            delegate: Rectangle {
                width: root.backgroundWidth
                height: __column.height + root.topMargin + root.bottomMargin
                radius: root.backgroundRadius
                color: root.backgroundColor
                clip: true

                Component.onCompleted: {
                    __timer.interval = timeout;
                    __timer.start();
                }

                NumberAnimation on height {
                    id: __removeAniamtion
                    to: 0
                    running: false
                    duration: 500
                    alwaysRunToEnd: true
                    onFinished: {
                        listModel.remove(index);
                    }
                }

                Timer {
                    id: __timer
                    onTriggered: {
                        __removeAniamtion.start();
                    }
                }

                Column {
                    id: __column
                    width: parent.width
                    anchors.centerIn: parent
                    spacing: root.titleSpacing

                    Row {
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 5

                        Text {
                            id: __icon
                            anchors.verticalCenter: __title.verticalCenter
                            font.family: delegateuiFont.name
                            font.pointSize: root.titleFont.pointSize + 1
                            color: {
                                switch (type) {
                                case Notification.Success: return "green";
                                case Notification.Warning: return "orange";
                                case Notification.Message: return "gray";
                                case Notification.Error: return "red";
                                default: return "";
                                }
                            }
                            text: {
                                switch (type) {
                                case Notification.Success: return String.fromCharCode(DelIcon.CheckCircleFilled);
                                case Notification.Warning: return String.fromCharCode(DelIcon.ExclamationCircleFilled);
                                case Notification.Message: return String.fromCharCode(DelIcon.ExclamationCircleFilled);
                                case Notification.Error: return String.fromCharCode(DelIcon.CloseCircleFilled);
                                default: return "";
                                }
                            }
                        }

                        Text {
                            id: __title
                            font: root.titleFont
                            color: root.titleColor
                            text: title
                            wrapMode: Text.WrapAnywhere
                        }
                    }

                    Text {
                        id: __message
                        width: parent.width - 16
                        anchors.horizontalCenter: parent.horizontalCenter
                        font: root.messageFont
                        color: root.messageColor
                        text: message
                        horizontalAlignment: Text.AlignHCenter
                        wrapMode: Text.WrapAnywhere
                    }
                }

                Text {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 6
                    text: "×"
                    font.bold: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            __timer.stop();
                            __removeAniamtion.restart();
                        }
                    }
                }
            }
        }
    }
}
