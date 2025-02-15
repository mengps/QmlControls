import QtQuick 2.15
import QtGraphicalEffects 1.15

import "qrc:/../common"

Item {
    id: control

    implicitWidth: mouseArea.width
    implicitHeight: mouseArea.height

    toolTipFont {
        family: "微软雅黑"
        pixelSize: 14
    }

    property bool animationEnabled: true
    property int count: 5
    property real initValue: -1
    property real value: 0
    property alias spacing: row.spacing
    property real iconSize: 24
    property color iconColor: "#fadb14"
    /* 文字提示 */
    property font toolTipFont
    property bool toolTipVisible: false
    property var toolTipTexts: []
    property color colorFill: "#fadb14"
    property color colorEmpty: "#fadb14"
    property color colorHalf: "#fadb14"
    property color colorToolTipText: "#141414"
    property color colorToolTipBg: "#fff"
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
                layer.effect: halfRateHelper
            }
        }
    }
    property Component toolTipDelegate: Item {
        width: 12
        height: 6
        opacity: hovered ? 1 : 0

        Behavior on opacity { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }

        DropShadow {
            anchors.fill: __item
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: __item
        }

        Item {
            id: __item
            width: __toolTipBg.width
            height: __arrow.height + __toolTipBg.height - 1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom

            Rectangle {
                id: __toolTipBg
                width: __toolTipText.implicitWidth + 14
                height: __toolTipText.implicitHeight + 12
                anchors.bottom: __arrow.top
                anchors.bottomMargin: -1
                anchors.horizontalCenter: parent.horizontalCenter
                color: control.colorToolTipBg
                radius: 4

                Text {
                    id: __toolTipText
                    color: control.colorToolTipText
                    text: control.toolTipTexts[index]
                    font: control.toolTipFont
                    anchors.centerIn: parent
                }
            }

            Canvas {
                id: __arrow
                width: 12
                height: 6
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onColorBgChanged: requestPaint();
                onPaint: {
                    const ctx = getContext("2d");
                    ctx.beginPath();
                    ctx.moveTo(0, 0);
                    ctx.lineTo(width, 0);
                    ctx.lineTo(width * 0.5, height);
                    ctx.closePath();
                    ctx.fillStyle = colorBg;
                    ctx.fill();
                }
                property color colorBg: control.colorToolTipBg
            }
        }
    }

    property Component halfRateHelper: ShaderEffect {
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

    onInitValueChanged: {
        __private.doneValue = value = initValue;
        isDone = true;
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
                id: __repeater

                property int fillCount: Math.floor(control.value)
                property int emptyStartIndex: Math.round(control.value)
                property bool hasHalf: control.value - fillCount > 0

                model: control.count
                delegate: MouseArea {
                    id: __rootItem
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
                    required property int index
                    property bool hovered: false

                    Loader {
                        active: index < __repeater.fillCount
                        sourceComponent: fillDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: __repeater.hasHalf && index === (__repeater.emptyStartIndex - 1)
                        sourceComponent: halfDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        active: index >= __repeater.emptyStartIndex
                        sourceComponent: emptyDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }

                    Loader {
                        x: (parent.width - width) * 0.5
                        y: -height - 4
                        z: 10
                        active: control.toolTipVisible
                        sourceComponent: control.toolTipDelegate
                        property int index: __rootItem.index
                        property bool hovered: __rootItem.hovered
                    }
                }
            }
        }
    }
}
