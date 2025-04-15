import QtQuick 2.15
import DelegateUI 1.0

Text {
    id: control

    property int iconSource: 0
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    text: String.fromCharCode(iconSource)
    font.family: __loader.name
    font.pixelSize: DelTheme.DelIconText.fontSize
    color: DelTheme.DelIconText.colorText

    FontLoader {
        id: __loader
        source: "qrc:/../resources/font/DelegateUI-Icons.ttf"
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}
