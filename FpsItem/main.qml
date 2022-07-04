import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Shapes 1.15

import an.item 1.0

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("FpsItem Test")

    FpsItem {
        id: fpsItem
    }

    Item {
        id: back
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        layer.samples: 8

        property bool running: false

        MouseArea {
            anchors.fill: parent
            onClicked: parent.running = !parent.running;
        }

        PathAnimation {
            target: ball
            running: back.running
            duration: 4000
            loops: -1
            path: Path {
                startX: -ball.width * 0.5
                startY: back.height - ball.height * 0.5
                PathCurve { x: back.width * 0.8 - ball.width * 0.5; y: back.height * 0.8 - ball.height * 0.5 }
                PathCurve { x: back.width * 0.2 - ball.width * 0.5; y: back.height * 0.2 - ball.height * 0.5 }
                PathCurve { x: back.width - ball.width * 0.5; y: - ball.height * 0.5 }
            }
        }

        Shape {
            ShapePath {
                strokeColor: "#ff1493"
                fillColor: "transparent"
                startX: 0
                startY: back.height
                PathCurve { x: back.width * 0.8; y: back.height * 0.8 }
                PathCurve { x: back.width * 0.2; y: back.height * 0.2 }
                PathCurve { x: back.width; y: 0 }
            }
        }

        Rectangle {
            id: ball
            x: -width * 0.5
            y: back.height - height * 0.5
            width: 50
            height: width
            radius: width * 0.5
            gradient: Gradient {
                GradientStop { position: 0.20; color: "#af2020" }
                GradientStop { position: 1.00; color: "#c27131" }
            }
            transformOrigin: Item.Center
            transform: Rotation {
                axis { x: 1; y: 1; z: 0 }

                NumberAnimation on angle {
                    running: back.running
                    duration: 1000
                    loops: -1
                    from: 0
                    to: 360
                }
            }
        }

        Text {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 10
            font.pointSize: 12
            text: "FPS: " + fpsItem.fps
            color: "red"
        }
    }
}
