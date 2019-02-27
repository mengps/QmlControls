import QtQuick 2.12
import QtQuick.Window 2.2

Window
{
    visible: true
    width: 640
    height: 480
    title: qsTr("Glow Circular Image")

    GlowRectangle
    {
        id: glowRect
        width: 100
        height: 50
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        color: "#09A3DC"
        glowColor: "#09A3DC"
        radius: 5
        glowRadius: 5
    }

    CircularImage
    {
        id: image
        anchors.left: glowRect.right
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        width: 200
        height: 200
        fillMode: Image.PreserveAspectFit
        source: "qrc:/test.png"
    }

    GlowCircularImage
    {
        id: blend
        anchors.left: image.right
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        width: 200
        height: width
        radius: width / 2
        spread: 0.8
        glowRadius: 30
        glowColor: "#663366"
        fillMode: Image.PreserveAspectFit
        source: "qrc:/test.png"

        ColorAnimation
        {
            target: blend
            property: "glowColor"
            from: "#FF88FF"
            to: "#663366"
            duration: 800
            running: true
            easing.type: Easing.Linear
            property bool reverse: false
            onStopped:
            {
                if (!reverse)
                {

                    from = "#663366";
                    to = "#FF88FF";
                }
                else
                {
                    from = "#FF88FF";
                    to = "#663366";
                }
                reverse = !reverse
                running = true;
            }
        }
    }
}
