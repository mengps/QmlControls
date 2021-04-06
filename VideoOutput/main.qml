import QtQuick 2.12
import QtQuick.Window 2.12
import QtMultimedia 5.8
import an.video 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("VideoOutput")

    VideoFrameProvider {
        id: provider
        videoUrl: "rtsp://xxx.xxx.xxx/channel=1"
    }

    VideoOutput {
        anchors.fill: parent
        source: provider
    }
}
