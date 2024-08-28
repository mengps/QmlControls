import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("WaveProgress Test")
    color: "black"

    Column {
        anchors.centerIn: parent

        WaveProgress {
            id: waveProgress
            radius: 50
            radiusMargin: 4
            anchors.horizontalCenter: parent.horizontalCenter
            waveColor: "#00a8f3"
            progressTextVisible: false
            sliderVisible: false

            Timer {
                interval: 20
                repeat: true
                running: true
                onTriggered: {
                    if (direction)
                        waveProgress.value += 0.01;
                    else
                        waveProgress.value -= 0.01;

                    if (waveProgress.value >= 1.0 || waveProgress.value <= 0.0)
                        direction = !direction;
                }
                property bool direction: true
            }
        }

        WaveProgress {
            radius: 100
            value: 0.5
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
