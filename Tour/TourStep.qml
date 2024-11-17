import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15

Popup {
    id: root

    x: __private.focusX - (stepCardWidth - focusWidth) * 0.5
    y: __private.focusY + focusHeight + 5

    property var stepModel: []
    property Item currentTarget: null
    property int currentStep: 0
    property color overlayColor: "#80000000"
    property bool showArrow: true
    property real arrowWidth: 20
    property real arrowHeight: 10
    property real focusMargin: 5
    property real focusWidth: currentTarget ? (currentTarget.width + focusMargin * 2) : 0
    property real focusHeight: currentTarget ? (currentTarget.height + focusMargin * 2) : 0
    property real stepCardWidth: 100
    property real stepCardRadius: 5
    property color stepCardColor: "white"
    property font stepTitleFont
    property color stepTitleColor: "black"
    property font stepDescriptionFont
    property color stepDescriptionColor: "black"
    property font indicatorFont
    property color indicatorColor: "black"
    property font buttonFont: Qt.font({ family: "微软雅黑" })
    property Component arrowDelegate:  Canvas {
        id: __arrowDelegate
        width: arrowWidth
        height: arrowHeight
        contextType: "2d"
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onPaint: {
            const ctx = getContext("2d");
            ctx.fillStyle = fillStyle;
            ctx.beginPath();
            ctx.moveTo(0, height);
            ctx.lineTo(width * 0.5, 0);
            ctx.lineTo(width, height);
            ctx.closePath();
            ctx.fill()
        }
        property color fillStyle: root.stepCardColor

        Connections {
            target: root
            function onCurrentTargetChanged() {
                if (root.stepModel.length > root.currentStep) {
                    const stepData = root.stepModel[root.currentStep];
                    __arrowDelegate.fillStyle = stepData.cardColor ? stepData.cardColor : root.stepCardColor;
                }
                __arrowDelegate.requestPaint();
            }
        }
    }
    property Component stepCardDelegate: Rectangle {
        id: __stepCardDelegate
        height: __stepCardColumn.height + 20
        color: stepData.cardColor ? stepData.cardColor : root.stepCardColor
        radius: stepData.cardRadius ? stepData.cardRadius : root.stepCardRadius

        property var stepData: new Object

        Connections {
            target: root
            function onCurrentTargetChanged() {
                if (root.stepModel.length > root.currentStep)
                    stepData = root.stepModel[root.currentStep];
            }
        }

        Column {
            id: __stepCardColumn
            width: parent.width
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.title ? stepData.title : ""
                color: stepData.titleColor ? stepData.titleColor : root.stepTitleColor
                font: root.stepTitleFont
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.description || ""
                color: stepData.descriptionColor ? stepData.descriptionColor : root.stepDescriptionColor
                font: root.stepDescriptionFont
            }

            Item {
                width: parent.width
                height: 30

                Loader {
                    id: indicatorLoader
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: root.indicatorDelegate
                }

                /*! DelegateUI 将会使用新的 DButton */
                Button {
                    id: control
                    text: (root.currentStep + 1 == root.stepModel.length) ? qsTr("结束导览") : qsTr("下一步")
                    width: textMetrics.width + 20
                    height: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    font: root.buttonFont
                    contentItem: Text {
                        text: control.text
                        font: control.font
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    background: Rectangle {
                        radius: 4
                        color: control.down ? Qt.darker("#1677ff", 1.1) : (control.hovered ? Qt.lighter("#1677ff", 1.1) : "#1677ff")
                    }
                    onClicked: {
                        if ((root.currentStep + 1 == root.stepModel.length))
                            root.close();
                        else if (root.currentStep + 1 < root.stepModel.length) {
                            root.currentStep += 1;
                            __stepCardDelegate.stepData = root.stepModel[root.currentStep];
                            root.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }

                    TextMetrics {
                        id: textMetrics
                        font: root.buttonFont
                        text: control.text
                    }
                }
            }
        }
    }
    property Component indicatorDelegate: Text {
        text: (root.currentStep + 1) + " / " + root.stepModel.length
        font: root.indicatorFont
        color: root.indicatorColor
    }

    function resetStep() {
        root.currentStep = 0;
        if (root.stepModel.length > root.currentStep) {
            const stepData = root.stepModel[root.currentStep];
            currentTarget = stepData.target;
        }
    }

    function appendStep(object) {
        stepModel.push(object);
    }

    onCurrentTargetChanged: __private.recalcPosition();
    onAboutToShow: __private.recalcPosition();

    Behavior on x { NumberAnimation { duration: 200 } }
    Behavior on y { NumberAnimation { duration: 200 } }

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

                Behavior on xMin { NumberAnimation { duration: 200 } }
                Behavior on yMin { NumberAnimation { duration: 200 } }

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
    background: Column {
        width: Math.max(root.arrowWidth, root.stepCardWidth)

        Loader {
            id: arrowLoader
            width: root.arrowWidth
            height: root.arrowHeight
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: root.arrowDelegate
        }

        Loader {
            id: stepLoader
            width: root.stepCardWidth
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: root.stepCardDelegate
        }
    }
}
