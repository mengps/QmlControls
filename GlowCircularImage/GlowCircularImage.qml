import QtQuick 2.15

Item {
    id: root

    property alias spread: back.spread;          //光圈强度
    property alias radius: back.radius;          //图像圆半径
    property alias glowRadius: back.glowRadius;  //光圈半径
    property alias glowColor: back.color;        //光圈颜色

    property alias source: image.source;
    property alias fillMode: image.fillMode;

    GlowRectangle {
        id: back
        anchors.fill: parent
        color: "black"          //默认为黑色
        glowColor: color

        CircularImage {
            id: image
            anchors.fill: parent
            radius: parent.radius
            mipmap: true
            antialiasing: true
        }
    }
}

