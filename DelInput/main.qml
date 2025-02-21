import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelInput")

    Row {
        anchors.centerIn: parent
        spacing: 10

        DelInput {
            width: 120
            placeholderText: qsTr("Basic usage")
        }

        DelInput {
            width: 120
            iconPosition: DelInput.Position_Left
            iconSource: DelIcon.UserOutlined
            placeholderText: qsTr("Username")
        }

        DelInput {
            width: 120
            iconPosition: DelInput.Position_Right
            iconSource: DelIcon.UserOutlined
            placeholderText: qsTr("Username")
        }
    }
}
