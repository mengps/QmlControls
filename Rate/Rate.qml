import QtQuick 2.15

import "qrc:/../common"

Item {
    id: control

    implicitWidth: mouseArea.width
    implicitHeight: mouseArea.height

    property int count: 5
    property real value: 0
    property alias spacing: row.spacing
    property real iconSize: 24
    property color iconColor: "#fadb14"
    /* 允许半星 */
    property bool allowHalf: false
    property bool isDone: false
    property int fillIcon: DelIcon.StarFilled
    property int emptyIcon: DelIcon.StarOutlined
    property int halfIcon: DelIcon.StarFilled
    property Component fillDelegate: Component {
        Text {
            text: String.fromCharCode(control.fillIcon)
            color: control.iconColor
            font.family: delegateuiFont.name
            font.pixelSize: control.iconSize
        }
    }
    property Component emptyDelegate: Component {
        Text {
            text: String.fromCharCode(control.emptyIcon)
            color: control.iconColor
            font.family: delegateuiFont.name
            font.pixelSize: control.iconSize
        }
    }
    property Component halfDelegate: Component {
        Text {
            text: String.fromCharCode(control.emptyIcon)
            color: control.iconColor
            font.family: delegateuiFont.name
            font.pixelSize: control.iconSize

            Text {
                text: String.fromCharCode(control.halfIcon)
                color: control.iconColor
                font.family: delegateuiFont.name
                font.pixelSize: control.iconSize
                layer.enabled: true
                layer.effect: ShaderEffect {
                    fragmentShader: "
                        uniform sampler2D source;
                        uniform float qt_Opacity;
                        in vec2 qt_TexCoord0;
                        void main() {
                            vec4 tex = texture2D(source, qt_TexCoord0);
                            if (qt_TexCoord0.x > 0.5)
                                gl_FragColor = vec4(0);
                            else
                                gl_FragColor = tex * qt_Opacity;
                        }"
                }
            }
        }
    }

    /* 结束 */
    signal done(real value);

    QtObject {
        id: __private
        property real doneValue: 0
    }

    FontLoader {
        id: delegateuiFont
        source: "qrc:/../common/DelegateUI-Icons.ttf"
    }

    MouseArea {
        id: mouseArea
        width: row.width
        height: control.iconSize
        hoverEnabled: true
        onExited: {
            if (control.isDone) {
                control.value = __private.doneValue;
            }
        }

        Row {
            id: row
            spacing: 4

            Repeater {
                id: repeater
                model: control.count
                delegate: MouseArea {
                    id: controlItem
                    width: control.iconSize
                    height: control.iconSize
                    hoverEnabled: true
                    onEntered: hovered = true;
                    onExited: hovered = false;
                    onClicked: {
                        control.isDone = !control.isDone;
                        if (control.isDone) {
                            __private.doneValue = control.value;
                            control.done(__private.doneValue);
                        }
                    }
                    onPositionChanged: function(mouse) {
                        if (control.allowHalf) {
                            if (mouse.x > (width * 0.5)) {
                                control.value = index + 1;
                            } else {
                                control.value = index + 0.5;
                            }

                        } else {
                            control.value = index + 1;
                        }
                    }
                    property bool hovered: false

                    Loader {
                        active: index < repeater.fillCount
                        sourceComponent: fillDelegate
                        property bool hovered: controlItem.hovered
                    }

                    Loader {
                        active: repeater.hasHalf && index === (repeater.emptyStartIndex - 1)
                        sourceComponent: halfDelegate
                        property bool hovered: controlItem.hovered
                    }

                    Loader {
                        active: index >= repeater.emptyStartIndex
                        sourceComponent: emptyDelegate
                        property bool hovered: controlItem.hovered
                    }
                }

                property int fillCount: Math.floor(control.value)
                property int emptyStartIndex: Math.round(control.value)
                property bool hasHalf: control.value - fillCount > 0
            }
        }
    }
}
