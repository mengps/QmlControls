import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import Qt.labs.platform 1.0
import an.controls 1.0

Window
{
    id: root
    width: 400
    height: 500
    color: "transparent"
    visible: true

    Component.onCompleted: flags |= Qt.Tool | Qt.FramelessWindowHint;

    MoveMouseArea
    {
        anchors.fill: parent
        target: root
    }

    GlowRectangle
    {
        id: background
        width: parent.width - 20
        height: parent.height - 20
        anchors.centerIn: parent
        radius: 6
        glowRadius: 6
        opacity: 0.95
        color: "#C4D6FA"
        glowColor: color

        Text
        {
            id: title
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: "图文编辑器（测试）"
            font.family: "Consolas"
            font.pointSize: 24
            style: Text.Sunken
            styleColor: "red"
            transform: rotation
            antialiasing: true
        }

        Text
        {
            id: label
            text: "请输入文本或插入表情："
            font.pointSize: 12
            anchors.top: title.bottom
            anchors.topMargin: 20
            anchors.left: root.left
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle
        {
            id: rect
            width: parent.width - 20
            anchors.top: label.bottom
            anchors.topMargin: 5
            anchors.bottom: row.top
            anchors.bottomMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: "gray"

            Flickable
            {
                id: flick
                flickableDirection: Flickable.VerticalFlick
                anchors.fill: parent

                TextArea.flickable: MyTextArea
                {
                    id: mytext
                    focus: true
                    font.pointSize: 12
                    color: "red"
                    leftPadding: 16
                    rightPadding: 16
                    topPadding: 16
                    bottomPadding: 16

                    DropArea
                    {
                        anchors.fill: parent;
                        onDropped:
                        {
                            if(drop.hasUrls)
                            {
                                for(var i = 0; i < drop.urls.length; i++)
                                {
                                    console.log(drop.urls[i]);
                                    mytext.insertImage(drop.urls[i]);
                                }
                            }
                        }
                    }
                }

                ScrollBar.vertical: ScrollBar
                {
                    width: 14
                    policy: ScrollBar.AsNeeded
                }
            }
        }

        Row
        {
            id: row
            spacing: 5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            Button
            {
                id: insertFaces
                text: "插入表情"
                onClicked: facesManager.visible = !facesManager.visible;
            }

            Button
            {
                id: openFile
                text: "插入本地图片"
                onClicked: fileDialog.open();
            }
        }

        Rectangle
        {
            id: previewRect
            z: 10
            radius: 10
            color: "#FFFFFF"
            border.color: "gray"
            visible: false
            width: 80
            height: 80

            AnimatedImage
            {
                id: gifPreview
                anchors.centerIn: parent
                width: 30
                height: 30
                mipmap: true
                onSourceChanged: playing = true;
                onPlayingChanged: playing = true;
            }

            Image
            {
                id: imagePreview
                anchors.centerIn: parent
                width: 30
                height: 30
                mipmap: true
            }
        }

        FacesManager
        {
            id: facesManager
            visible: false
            width: parent.width - 160
            height: 300
            anchors.bottom: row.top
            anchors.bottomMargin: 4
            anchors.horizontalCenter: row.horizontalCenter
        }

        FileDialog
        {
            id: fileDialog
            folder: StandardPaths.writableLocation(StandardPaths.PicturesLocation)
            title: "请打开一张图片"
            nameFilters: ['图片文件 (*.jpg *.bmp *.jpeg *.png *gif)']
            onAccepted:  mytext.insertImage(file)
        }
    }
}
