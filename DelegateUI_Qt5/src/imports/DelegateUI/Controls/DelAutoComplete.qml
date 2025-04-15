import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Window 2.15
import DelegateUI 1.0

DelInput {
    id: control

    signal search(input: string)
    signal select(option: var)

    property var options: []
    property var filterOption: (input, option) => true
    property string textRole: 'label'
    property string valueRole: 'value'
    property bool tooltipVisible: false
    property int defaulPopupMaxHeight: 240

    onOptionsChanged: __private.model = options;
    onTextEdited: {
        control.search(text);
        __private.filter();
        if (__private.model.length > 0)
            __private.openPopup();
        else
            __popup.close();
    }

    Item {
        id: __private
        property var window: Window.window
        property var model: []
        function openPopup() {
            if (!__popup.opened)
                __popup.open();
        }
        function filter() {
            __private.model = options.filter(option => filterOption(text, option) === true);
        }
    }

    TapHandler {
        onTapped: {
            if (__private.model.length > 0)
                __private.openPopup();
        }
    }

    DelPopup {
        id: __popup
        implicitWidth: control.width
        implicitHeight: Math.min(control.defaulPopupMaxHeight, __popupListView.contentHeight) + topPadding + bottomPadding
        leftPadding: 4
        rightPadding: 4
        topPadding: 6
        bottomPadding: 6
        closePolicy: T.Popup.NoAutoClose | T.Popup.CloseOnEscape | T.Popup.CloseOnPressOutsideParent
        onAboutToShow: {
            const pos = control.mapToItem(null, 0, 0);
            x = (control.width - width) * 0.5;
            if (__private.window.height > (pos.y + control.height + implicitHeight + 6)){
                y = control.height + 6;
            } else if (pos.y > implicitHeight) {
                y = -implicitHeight - 6;
            } else {
                y = __private.window.height - (pos.y + implicitHeight + 6);
            }
        }
        enter: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 0.0
                to: 1.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
            }
        }
        exit: Transition {
            NumberAnimation {
                property: 'opacity'
                from: 1.0
                to: 0.0
                easing.type: Easing.InOutQuad
                duration: control.animationEnabled ? DelTheme.Primary.durationMid : 0
            }
        }
        contentItem: ListView {
            id: __popupListView
            clip: true
            model: __private.model
            boundsBehavior: Flickable.StopAtBounds
            delegate: T.ItemDelegate {
                id: __popupDelegate

                required property var modelData
                required property int index

                property var textData: modelData[control.textRole]
                property var valueData: modelData[control.valueRole]

                width: __popupListView.width
                height: implicitContentHeight + topPadding + bottomPadding
                leftPadding: 8
                rightPadding: 8
                topPadding: 4
                bottomPadding: 4
                contentItem: Text {
                    text: __popupDelegate.textData
                    color: DelTheme.DelSelect.colorItemText
                    font {
                        family: DelTheme.DelSelect.fontFamily
                        pixelSize: DelTheme.DelSelect.fontSize
                        weight: highlighted ? Font.DemiBold : Font.Normal
                    }
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    radius: 2
                    color: highlighted ? DelTheme.DelSelect.colorItemBgActive :
                                        hovered ? DelTheme.DelSelect.colorItemBgHover :
                                                  DelTheme.DelSelect.colorItemBg;
                }
                highlighted: __popupListView.currentIndex === index
                onClicked: {
                    control.select(__popupDelegate.modelData);
                    control.text = __popupDelegate.textData;
                    __popupListView.currentIndex = index;
                    __popup.close();
                    __private.filter();
                }

                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }

                Loader {
                    y: __popupDelegate.height
                    anchors.horizontalCenter: parent.horizontalCenter
                    active: control.tooltipVisible
                    sourceComponent: DelToolTip {
                        arrowVisible: false
                        visible: __popupDelegate.hovered
                        text: __popupDelegate.textData
                        position: DelToolTip.Position_Bottom
                    }
                }
            }
            T.ScrollBar.vertical: DelScrollBar { }
        }
    }
}
