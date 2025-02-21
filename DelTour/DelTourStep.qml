import QtQuick 2.15
import QtQuick.Controls 2.15

import "qrc:/../DelButton"

Popup {
    id: control

    x: __private.focusX - (stepCardWidth - focusWidth) * 0.5
    y: __private.focusY + focusHeight + 5

    property bool animationEnabled: true
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
            ctx.fill();
        }
        property color fillStyle: control.stepCardColor

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep) {
                    const stepData = control.stepModel[control.currentStep];
                    __arrowDelegate.fillStyle = stepData.cardColor ? stepData.cardColor : control.stepCardColor;
                }
                __arrowDelegate.requestPaint();
            }
        }
    }
    property Component stepCardDelegate: Rectangle {
        id: __stepCardDelegate
        height: __stepCardColumn.height + 20
        color: stepData.cardColor ? stepData.cardColor : control.stepCardColor
        radius: stepData.cardRadius ? stepData.cardRadius : control.stepCardRadius

        property var stepData: new Object

        Connections {
            target: control
            function onCurrentTargetChanged() {
                if (control.stepModel.length > control.currentStep)
                    stepData = control.stepModel[control.currentStep];
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
                color: stepData.titleColor ? stepData.titleColor : control.stepTitleColor
                font: control.stepTitleFont
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: stepData.description || ""
                color: stepData.descriptionColor ? stepData.descriptionColor : control.stepDescriptionColor
                font: control.stepDescriptionFont
            }

            Item {
                width: parent.width
                height: 30

                Loader {
                    id: indicatorLoader
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                    sourceComponent: control.indicatorDelegate
                }

                DelButton {
                    id: __prevButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: __nextButton.left
                    anchors.rightMargin: 15
                    anchors.bottom: __nextButton.bottom
                    visible: control.currentStep != 0
                    text: qsTr("上一步")
                    font: control.buttonFont
                    type: DelButton.Type_Outlined
                    onClicked: {
                        if (control.currentStep > 0) {
                            control.currentStep -= 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }

                DelButton {
                    id: __nextButton
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.bottom: parent.bottom
                    text: (control.currentStep + 1 == control.stepModel.length) ? qsTr("结束导览") : qsTr("下一步")
                    font: control.buttonFont
                    type: DelButton.Type_Primary
                    onClicked: {
                        if ((control.currentStep + 1 == control.stepModel.length)) {
                            control.resetStep();
                            control.close();
                        } else if (control.currentStep + 1 < control.stepModel.length) {
                            control.currentStep += 1;
                            __stepCardDelegate.stepData = control.stepModel[control.currentStep];
                            control.currentTarget = __stepCardDelegate.stepData.target;
                        }
                    }
                }
            }
        }
    }
    property Component indicatorDelegate: Text {
        text: (control.currentStep + 1) + " / " + control.stepModel.length
        font: control.indicatorFont
        color: control.indicatorColor
    }

    function resetStep() {
        control.currentStep = 0;
        if (control.stepModel.length > control.currentStep) {
            const stepData = control.stepModel[control.currentStep];
            currentTarget = stepData.target;
        }
    }

    function appendStep(object) {
        stepModel.push(object);
    }

    onCurrentTargetChanged: __private.recalcPosition();
    onAboutToShow: __private.recalcPosition();

    Behavior on x { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }
    Behavior on y { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }

    QtObject {
        id: __private
        property real focusX: 0
        property real focusY: 0
        function recalcPosition() {
            if (!control.currentTarget) return;
            const pos = control.currentTarget.mapToItem(null, 0, 0);
            focusX = pos.x - control.focusMargin;
            focusY = pos.y - control.focusMargin;
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

                Behavior on xMin { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }
                Behavior on yMin { enabled: control.animationEnabled; NumberAnimation { duration: 200 } }

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
        width: Math.max(control.arrowWidth, control.stepCardWidth)

        Loader {
            id: arrowLoader
            width: control.arrowWidth
            height: control.arrowHeight
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.arrowDelegate
        }

        Loader {
            id: stepLoader
            width: control.stepCardWidth
            anchors.horizontalCenter: parent.horizontalCenter
            sourceComponent: control.stepCardDelegate
        }
    }
}
