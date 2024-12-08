import QtQuick 2.15
import QtQuick.Controls 2.15

DelButton {
    id: control
    font.family: fontAwesome.name
    text: String.fromCharCode(iconSource)

    property int iconSource: 0

    FontLoader {
        id: fontAwesome
        source: "qrc:/../common/FontAwesome.otf"
    }
}
