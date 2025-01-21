import QtQuick 2.15

Text {
    id: control

    property int iconSource: 0
    property alias iconSize: control.font.pixelSize
    property alias colorIcon: control.color
    property string contentDescription: text

    text: String.fromCharCode(iconSource)
    font.family: __loader.name
    font.pixelSize: 14

    FontLoader {
        id: __loader
        source: "qrc:/../common/FontAwesome.otf"
    }

    Accessible.role: Accessible.StaticText
    Accessible.name: control.text
    Accessible.description: control.contentDescription

}
