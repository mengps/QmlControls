import QtQuick 2.15
import DelegateUI 1.0

Text {
    id: control

    renderType: DelTheme.textRenderType
    color: DelTheme.Primary.colorTextBase
    font {
        family: DelTheme.Primary.fontPrimaryFamily
        pixelSize: DelTheme.Primary.fontPrimarySize
    }
}
