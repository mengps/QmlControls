import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelPopup")

    DelButton {
        anchors.centerIn: parent
        text: (popup.opened ? qsTr("隐藏") : qsTr("显示"))
        type: DelButton.Type_Primary
        onClicked: {
            if (popup.opened)
                popup.close();
            else
                popup.open();
        }
    }

    DelPopup {
        id: popup
        x: (parent.width - width) * 0.5
        y: (parent.height - height) * 0.5
        width: 400
        height: 300
        parent: Overlay.overlay
        closePolicy: DelPopup.NoAutoClose
        movable: true
        resizable: true
        minimumX: 0
        maximumX: parent.width - width
        minimumY: 0
        maximumY: parent.height - height
        minimumWidth: 400
        minimumHeight: 300
        contentItem: Item {
            DelCaptionButton {
                anchors.right: parent.right
                isError: true
                radiusBg: popup.radiusBg * 0.5
                colorText: colorIcon
                iconSource: DelIcon.CloseOutlined
                onClicked: popup.close();
            }
        }
    }
}
