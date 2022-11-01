import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Item {
    id: root
    width: 460
    height: 500
    scale: 0
    opacity: 0
    enabled: false

    property bool movable: true
    property alias title: contentText.text
    property color initColor: "white"
    readonly property color currentColor: pickerRect.currentColor

    onInitColorChanged: pickerRect.setColor(initColor);

    signal accepted();
    signal rejected();

    function open() {
        focus = true;
        enabled = true;
    }

    function hide() {
        focus = false;
        enabled = false;
    }

    Keys.onEscapePressed: cancelButton.clicked();

    NumberAnimation on scale {
        running: root.enabled
        duration: 350
        easing.type: Easing.OutBack
        easing.overshoot: 1.0
        to: 1.0
    }

    NumberAnimation on opacity {
        running: root.enabled
        duration: 300
        easing.type: Easing.OutQuad
        to: 1.0
    }

    NumberAnimation on scale {
        running: !root.enabled
        duration: 300
        easing.type: Easing.InBack
        easing.overshoot: 1.0
        to: 0.0
    }

    NumberAnimation on opacity {
        running: !root.enabled
        duration: 250
        easing.type: Easing.OutQuad
        to: 0.0
    }

    RectangularGlow {
        width: parent.width + 4
        height: parent.height + 4
        anchors.centerIn: parent
        glowRadius: 4
        spread: 0.2
        color: "#206856E6"
        cornerRadius: 4
    }

    Rectangle {
        anchors.fill: parent
        color: "#f6f6f6"
        border.color: "#aea4ee"
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.movable

        property point startPos: Qt.point(0, 0)
        property point offsetPos: Qt.point(0, 0)

        onClicked: (mouse) => mouse.accepted = false;
        onPressed: (mouse) => {
            startPos = Qt.point(mouse.x, mouse.y);
            cursorShape = Qt.SizeAllCursor;
        }
        onReleased: (mouse) => {
            startPos = Qt.point(mouse.x, mouse.y);
            cursorShape = Qt.ArrowCursor;
        }
        onPositionChanged: (mouse) => {
            if (pressed) {
                offsetPos = Qt.point(mouse.x - startPos.x, mouse.y - startPos.y);
                root.x = root.x + offsetPos.x;
                root.y = root.y + offsetPos.y;
            }
        }

        Text {
            id: contentText
            height: 20
            anchors.top: parent.top
            anchors.topMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 25
            anchors.right: parent.right
            font.family: "微软雅黑"
            color: "#222255"
            text: qsTr("选择新颜色")
            antialiasing: true
            verticalAlignment: Text.AlignVCenter
        }

        Item {
            id: pickerRect
            width: 330
            height: 290
            anchors.top: contentText.bottom
            anchors.left: contentText.left
            anchors.leftMargin: -cursorWidth * 0.5

            property real cursorWidth: 30
            property color hueColor: {
                let v = 1.0 - hueSlider.value;

                if (0.0 <= v && v < 0.16) {
                    return Qt.rgba(1.0, 0.0, v / 0.16, 1.0);
                } else if (0.16 <= v && v < 0.33) {
                    return Qt.rgba(1.0 - (v - 0.16) / 0.17, 0.0, 1.0, 1.0);
                } else if (0.33 <= v && v < 0.5) {
                    return Qt.rgba(0.0, ((v - 0.33) / 0.17), 1.0, 1.0);
                } else if (0.5 <= v && v < 0.76) {
                    return Qt.rgba(0.0, 1.0, 1.0 - (v - 0.5) / 0.26, 1.0);
                } else if (0.76 <= v && v < 0.85) {
                    return Qt.rgba((v - 0.76) / 0.09, 1.0, 0.0, 1.0);
                } else if (0.85 <= v && v <= 1.0) {
                    return Qt.rgba(1.0, 1.0 - (v - 0.85) / 0.15, 0.0, 1.0);
                } else {
                    return "red";
                }
            }
            property real saturation: colorPickerCursor.x / (width - cursorWidth)
            property real brightness: 1 - colorPickerCursor.y / (height - cursorWidth)
            property color currentColor: Qt.hsva(hueSlider.value, saturation, brightness, alphaSlider.value)
            property color __color: Qt.rgba(0, 0, 0, 0)

            function setColor(color) {
                alphaSlider.x = alphaPicker.width == 0 ? 0 : (alphaPicker.width - alphaSlider.width) * color.a;
                hueSlider.x = (huePicker.width - hueSlider.width) * (Math.max(color.hsvHue, 0));
                colorPickerCursor.x = color.hsvSaturation * (width - cursorWidth);
                colorPickerCursor.y = (1.0 - color.hsvValue) * (height - cursorWidth);
            }

            function fromColor() {
                pickerRect.setColor(Qt.rgba(parseInt(redEditor.text) / 255.
                                            , parseInt(greenEditor.text) / 255.
                                            , parseInt(blueEditor.text) / 255.
                                            , parseInt(alphaEditor.text) / 255.));
            }

            function fromArgbColor() {
                __color = '#' + argbEditor.text;
                pickerRect.setColor(__color);
            }

            onCurrentColorChanged: {
                redEditor.text = (currentColor.r * 255).toFixed(0);
                greenEditor.text = (currentColor.g * 255).toFixed(0);
                blueEditor.text = (currentColor.b * 255).toFixed(0);
                alphaEditor.text = (currentColor.a * 255).toFixed(0);
                argbEditor.text = currentColor.toString().replace("#", "");
            }

            Rectangle {
                x: pickerRect.cursorWidth * 0.5
                y: pickerRect.height - pickerRect.cursorWidth * 0.5
                width: pickerRect.height - pickerRect.cursorWidth
                height: pickerRect.width - pickerRect.cursorWidth
                rotation: -90
                transformOrigin: Item.TopLeft
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "white" }
                    GradientStop { position: 1.0; color: pickerRect.hueColor }
                }
            }

            Rectangle {
                x: pickerRect.cursorWidth * 0.5
                y: pickerRect.cursorWidth * 0.5
                width: pickerRect.width - pickerRect.cursorWidth
                height: pickerRect.height - pickerRect.cursorWidth
                gradient: Gradient {
                    GradientStop { position: 1.0; color: "#ff000000" }
                    GradientStop { position: 0.0; color: "#00000000" }
                }
            }

            Rectangle {
                id: colorPickerCursor
                width: pickerRect.cursorWidth
                height: pickerRect.cursorWidth
                border.color: "#e6e6e6"
                border.width: 1
                color: pickerRect.currentColor

                Behavior on scale { NumberAnimation { easing.type: Easing.OutBack; duration: 300 } }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.color: "white"
                    border.width: 1
                }
            }

            MouseArea {
                x: pickerRect.cursorWidth
                y: pickerRect.cursorWidth
                anchors.fill: parent

                function handleCursorPos(x, y) {
                    let halfWidth = pickerRect.cursorWidth * 0.5;
                    colorPickerCursor.x = Math.max(0, Math.min(width , x + halfWidth) - pickerRect.cursorWidth);
                    colorPickerCursor.y = Math.max(0, Math.min(height, y + halfWidth) - pickerRect.cursorWidth);
                }

                onPositionChanged: (mouse) => handleCursorPos(mouse.x, mouse.y);
                onPressed: (mouse) => {
                    colorPickerCursor.scale = 0.7;
                    handleCursorPos(mouse.x, mouse.y);
                }
                onReleased: colorPickerCursor.scale = 1.0;
            }
        }

        Item {
            id: previewItem
            width: 90
            height: 90
            anchors.left: pickerRect.right
            anchors.leftMargin: 10
            anchors.top: contentText.bottom
            anchors.topMargin: 15

            Grid {
                id: previwBackground
                anchors.fill: parent
                rows: 11
                columns: 11
                clip: true

                property real cellWidth: width / columns
                property real cellHeight: height / rows

                Repeater {
                    model: parent.columns * parent.rows

                    Rectangle {
                        width: previwBackground.cellWidth
                        height: width
                        color: (index % 2 == 0) ? "gray" : "transparent"
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                color: pickerRect.currentColor
                border.color: "#e6e6e6"
                border.width: 2
            }
        }

        component ColorEditor: ColumnLayout {
            id: __layout
            width: previewItem.width
            height: 50

            property alias label: label.text
            property alias text: input.text
            property alias validator: input.validator

            signal textEdited();
            signal accepted();

            Text {
                id: label
                font.family: "微软雅黑"
                color: "#222255"
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
            }

            Rectangle {
                clip: true
                color: "transparent"
                border.color: "#e6e6e6"
                border.width: 2
                Layout.fillHeight: true
                Layout.fillWidth: true

                TextInput {
                    id: input
                    leftPadding: 10
                    rightPadding: 10
                    selectionColor: "#398ed4"
                    selectByMouse: true
                    anchors.fill: parent
                    horizontalAlignment: TextInput.AlignRight
                    verticalAlignment: TextInput.AlignVCenter
                    onTextEdited: __layout.textEdited();
                    onAccepted: __layout.accepted();
                }
            }
        }

        Column {
            anchors.top: previewItem.bottom
            anchors.topMargin: 10
            anchors.left: previewItem.left
            spacing: 6

            ColorEditor {
                id: redEditor
                label: "红色"
                validator: IntValidator { top: 255; bottom: 0 }
                onAccepted: pickerRect.fromColor();
            }

            ColorEditor {
                id: greenEditor
                label: "绿色"
                validator: IntValidator { top: 255; bottom: 0 }
                onAccepted: pickerRect.fromColor();
            }

            ColorEditor {
                id: blueEditor
                label: "蓝色"
                validator: IntValidator { top: 255; bottom: 0 }
                onAccepted: pickerRect.fromColor();
            }

            ColorEditor {
                id: alphaEditor
                label: "透明度"
                validator: IntValidator { top: 255; bottom: 0 }
                onAccepted: pickerRect.fromColor();
            }

            ColorEditor {
                id: argbEditor
                label: "十六进制 (ARGB)"
                validator: RegularExpressionValidator { regularExpression: /[0-9a-fA-F]{0,8}/ }
                onAccepted: pickerRect.fromArgbColor();
            }
        }

        Rectangle {
            id: huePicker
            width: pickerRect.width - pickerRect.cursorWidth
            height: 32
            anchors.top: pickerRect.bottom
            anchors.topMargin: 10
            anchors.left: contentText.left
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0;  color: "#ff0000" }
                GradientStop { position: 0.16; color: "#ffff00" }
                GradientStop { position: 0.33; color: "#00ff00" }
                GradientStop { position: 0.5;  color: "#00ffff" }
                GradientStop { position: 0.76; color: "#0000ff" }
                GradientStop { position: 0.85; color: "#ff00ff" }
                GradientStop { position: 1.0;  color: "#ff0000" }
            }

            Rectangle {
                id: hueSlider
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9
                color: pickerRect.hueColor

                property real value: x / (parent.width - width)

                Behavior on scale { NumberAnimation { easing.type: Easing.OutBack; duration: 300 } }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.color: "white"
                    border.width: 2
                }
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = hueSlider.width * 0.5;
                    hueSlider.x = Math.max(0, Math.min(width, x + halfWidth) - hueSlider.width);
                }

                onPressed: (mouse) => {
                    hueSlider.scale = 0.6;
                    handleCursorPos(mouse.x);
                }
                onReleased: hueSlider.scale = 0.9;
                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }

        Item {
            id: alphaPickerItem
            width: huePicker.width
            height: huePicker.height
            anchors.top: huePicker.bottom
            anchors.topMargin: 25
            anchors.left: huePicker.left

            Grid {
                id: alphaPicker
                anchors.fill: parent
                rows: 4
                columns: 29
                clip: true

                property real cellWidth: width / columns
                property real cellHeight: height / rows

                Repeater {
                    model: parent.columns * parent.rows

                    Rectangle {
                        width: alphaPicker.cellWidth
                        height: width
                        color: (index % 2 == 0) ? "gray" : "transparent"
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 1.0; color: "#ff000000" }
                    GradientStop { position: 0.0; color: "#00ffffff" }
                }
            }

            Rectangle {
                id: alphaSlider
                x: parent.width - width
                width: height
                height: parent.height
                anchors.verticalCenter: parent.verticalCenter
                color: Qt.rgba(0.1, 0.1, 0.1, (value + 1.0) / 2.0)
                border.color: "#e6e6e6"
                border.width: 2
                scale: 0.9

                property real value: x / (parent.width - width)

                Behavior on scale { NumberAnimation { easing.type: Easing.OutBack; duration: 300 } }

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 1
                    color: "transparent"
                    border.color: "white"
                    border.width: 1
                }
            }

            MouseArea {
                anchors.fill: parent

                function handleCursorPos(x) {
                    let halfWidth = alphaSlider.width * 0.5;
                    alphaSlider.x = Math.max(0, Math.min(width, x + halfWidth) - alphaSlider.width);
                }

                onPressed: (mouse) => {
                    alphaSlider.scale = 0.6;
                    handleCursorPos(mouse.x);
                }
                onReleased: alphaSlider.scale = 0.9;
                onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            }
        }

        Button {
            id: confirmButton
            width: 200
            height: alphaPickerItem.height
            anchors.top: alphaPickerItem.bottom
            anchors.topMargin: 25
            anchors.left: alphaPickerItem.left
            text: qsTr("确定")
            hoverEnabled: true
            topInset: down ? 1 : 0
            bottomInset: topInset
            leftInset: topInset
            rightInset: topInset
            font.family: "微软雅黑"
            onClicked: {
                root.initColor = root.currentColor;
                root.hide();
                root.accepted();
            }
        }

        Button {
            id: cancelButton
            width: 200
            height: alphaPickerItem.height
            anchors.top: alphaPickerItem.bottom
            anchors.topMargin: 25
            anchors.right: parent.right
            anchors.rightMargin: 25
            text: qsTr("取消")
            hoverEnabled: true
            topInset: down ? 1 : 0
            bottomInset: topInset
            leftInset: topInset
            rightInset: topInset
            font.family: "微软雅黑"
            onClicked: {
                pickerRect.setColor(root.initColor);
                root.hide();
                root.rejected();
            }
        }
    }
}
