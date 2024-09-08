import QtQuick 2.15

Item {
    id: root

    implicitWidth: mouseArea.width
    implicitHeight: mouseArea.height

    property int count: 5
    property real value: 0
    property real spacing: row.spacing
    property real iconSize: 24
    property real iconFontSize: 24
    property color iconColor: "#fadb14"
    /* 允许半星 */
    property bool allowHalf: false
    property bool isDone: false
    property string fillIcon: "\uf005"
    property string emptyIcon: "\uf006"
    property string halfIcon: "\uf123"
    property Component fillDelegate: Component {
        Text {
            text: fillIcon
            color: root.iconColor
            font.family: fontAwesome.name
            font.pixelSize: iconFontSize
        }
    }
    property Component emptyDelegate: Component {
        Text {
            text: emptyIcon
            color: root.iconColor
            font.family: fontAwesome.name
            font.pixelSize: iconFontSize
        }
    }
    property Component halfDelegate: Component {
        Text {
            text: halfIcon
            color: root.iconColor
            font.family: fontAwesome.name
            font.pixelSize: iconFontSize
        }
    }

    /* 结束 */
    signal done(real value);

    QtObject {
        id: __private
        property real doneValue: 0
    }

    FontLoader {
        id: fontAwesome
        source: "file:./../common/FontAwesome.otf"
    }

    MouseArea {
        id: mouseArea
        width: row.width
        height: root.iconSize
        hoverEnabled: true
        onExited: {
            if (root.isDone) {
                root.value = __private.doneValue;
            }
        }

        Row {
            id: row
            spacing: 4

            Repeater {
                id: repeater
                model: root.count
                delegate: MouseArea {
                    width: root.iconSize
                    height: root.iconSize
                    hoverEnabled: true
                    onClicked: {
                        root.isDone = !root.isDone;
                        if (root.isDone) {
                            __private.doneValue = root.value;
                            root.done(__private.doneValue);
                        }
                    }
                    onPositionChanged: function(mouse) {
                        if (root.allowHalf) {
                            if (mouse.x > (width * 0.5)) {
                                root.value = index + 1;
                            } else {
                                root.value = index + 0.5;
                            }

                        } else {
                            root.value = index + 1;
                        }
                    }

                    Loader {
                        active: index < repeater.fillCount
                        sourceComponent: fillDelegate
                    }

                    Loader {
                        active: repeater.hasHalf && index === (repeater.emptyStartIndex - 1)
                        sourceComponent: halfDelegate
                    }

                    Loader {
                        active: index >= repeater.emptyStartIndex
                        sourceComponent: emptyDelegate
                    }
                }

                property int fillCount: Math.floor(root.value)
                property int emptyStartIndex: Math.round(root.value)
                property bool hasHalf: root.value - fillCount > 0
            }
        }
    }
}
