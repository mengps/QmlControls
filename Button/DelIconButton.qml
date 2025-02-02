import QtQuick 2.15
import QtQuick.Controls 2.15
import DelegateUI.Controls 1.0

DelButton {
    id: control

    property int iconSource: 0
    property int iconSize: 14
    property int iconSpacing: 5
    property int iconPosition: DelButtonType.Position_Start
    property color colorIcon: {
        if (enabled) {
            switch(control.type)
            {
            case DelButtonType.Type_Default:
                return control.down ? "#0958d9" : control.hovered ? "#4096ff" : "black";
            case DelButtonType.Type_Outlined:
                return control.down ? "#0958d9" : control.hovered ? "#4096ff" : "#1677ff";
            case DelButtonType.Type_Primary: return "white";
            case DelButtonType.Type_Filled: return "#1677ff";
            default: return "#1677ff";
            }
        } else {
            return Qt.rgba(0,0,0,0.45);
        }
    }
    contentItem: Item {
        implicitHeight: Math.max(__icon.implicitHeight, __text.implicitHeight)
        implicitWidth: __row.implicitWidth

        Row {
            id: __row
            anchors.verticalCenter: parent.verticalCenter
            spacing: control.iconSpacing
            layoutDirection: control.iconPosition === DelButtonType.Position_Start ? Qt.LeftToRight : Qt.RightToLeft

            Text {
                id: __icon
                anchors.verticalCenter: parent.verticalCenter
                color: control.colorIcon
                font.family: delegateuiFont.name
                text: String.fromCharCode(control.iconSource)

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

    FontLoader {
        id: delegateuiFont
        source: "qrc:/../common/DelegateUI-Icons.ttf"
    }
}
