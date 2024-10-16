import QtQuick 2.15

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
        id: fontAwesome
        source: "qrc:/../common/FontAwesome.otf"
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
                            font.family: fontAwesome.name
                            font.pointSize: root.titleFont.pointSize
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
                                case Notification.Success: return "\uf058";
                                case Notification.Warning: return "\uf071";
                                case Notification.Message: return "\uf05a";
                                case Notification.Error: return "\uf057";
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
