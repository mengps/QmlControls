import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: root

    property Item currentTarget: null
    property color overlayColor: "#80000000"
    property real focusMargin: 5
    property real focusWidth: currentTarget ? (currentTarget.width + focusMargin * 2) : 0
    property real focusHeight: currentTarget ? (currentTarget.height + focusMargin * 2) : 0

    onAboutToShow: __private.recalcPosition();

    QtObject {
        id: __private
        property real focusX: 0
        property real focusY: 0
        function recalcPosition() {
            if (!root.currentTarget) return;
            const pos = root.currentTarget.mapToItem(null, 0, 0);
            focusX = pos.x - root.focusMargin;
            focusY = pos.y - root.focusMargin;
        }
    }

    Overlay.modal: Item {
        onWidthChanged: __private.recalcPosition();
        onHeightChanged: __private.recalcPosition();

        Rectangle {
            id: source
            color: overlayColor
            anchors.fill: parent
            layer.enabled: true
            layer.effect: ShaderEffect {
                property real xMin: __private.focusX / source.width
                property real xMax: (__private.focusX + focusWidth) / source.width
                property real yMin: __private.focusY / source.height
                property real yMax: (__private.focusY + focusHeight) / source.height
                fragmentShader: "
                        uniform sampler2D source;
                        uniform float qt_Opacity;
                        uniform float xMin;
                        uniform float xMax;
                        uniform float yMin;
                        uniform float yMax;
                        in vec2 qt_TexCoord0;
                        void main() {
                            vec4 tex = texture2D(source, qt_TexCoord0);
                            if (qt_TexCoord0.x > xMin && qt_TexCoord0.x < xMax
                                && qt_TexCoord0.y > yMin && qt_TexCoord0.y < yMax)
                                gl_FragColor = vec4(0);
                            else
                                gl_FragColor = tex * qt_Opacity;
                        }"
            }
        }
    }
    parent: Overlay.overlay
    modal: true
    background: Item { }
}
