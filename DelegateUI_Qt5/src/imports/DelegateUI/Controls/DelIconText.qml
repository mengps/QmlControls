import QtQuick 2.15
import DelegateUI 1.0

DelText {
    id: control

    property int iconSource: 0
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    text: String.fromCharCode(iconSource)
    font.family: 'DelegateUI-Icons'
    font.pixelSize: DelTheme.DelIconText.fontSize
    color: DelTheme.DelIconText.colorText

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.contentDescription
}
