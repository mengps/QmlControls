import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: colorPopup

    property alias title: colorPicker.title
    property alias initColor: colorPicker.initColor
    property alias currentColor: colorPicker.currentColor

    signal accepted();
    signal rejected();

    width: colorPicker.width + leftInset + leftMargin + rightInset + rightMargin
    height: colorPicker.height + topInset + topMargin + bottomInset + bottomMargin
    parent: Overlay.overlay
    anchors.centerIn: Overlay.overlay
    enter: Transition {
        NumberAnimation {
            duration: 300
            property: "opacity"
            easing.type: Easing.OutQuad
            to: 1.0
        }
    }
    exit: Transition {
        NumberAnimation {
            duration: 300
            property: "opacity"
            easing.type: Easing.InBack
            easing.overshoot: 1.0
            to: 0.0
        }
    }
    onAboutToShow: colorPicker.open();
    onAboutToHide: colorPicker.hide();
    background: ColorPicker {
        id: colorPicker
        width: 480
        onAccepted: {
            colorPopup.accepted();
            colorPopup.close();
        }
        onRejected: {
            colorPopup.rejected();
            colorPopup.close();
        }
    }
}
