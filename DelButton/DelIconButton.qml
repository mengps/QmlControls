import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/../common"

DelButton {
    id: control

    property int iconSource: 0
    property int iconSize: 16
    property int iconSpacing: 5
    property int iconPosition: DelButton.Position_Start
    property color colorIcon: colorText
    contentItem: Item {
        implicitWidth: __row.implicitWidth
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)

        Row {
            id: __row
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === DelButton.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            DelIconText {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                iconSize: control.iconSize
                iconSource: control.iconSource
                verticalAlignment: Text.AlignVCenter

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
            }

            Text {
                id: __text
                anchors.verticalCenter: parent.verticalCenter
                text: control.text
                font: control.font
                color: control.colorText
                elide: Text.ElideRight

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
            }
        }
    }
}
