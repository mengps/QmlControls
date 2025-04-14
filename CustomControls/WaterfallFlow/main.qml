import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 600
    height: 900
    title: qsTr("Waterfall Flow")
    color: "#bbb"

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: width

        property var jsonData: []
        property int spacing: 5
        property int column: 2
        property int currentColumn: 0
        property int currentX: 0
        property var currentY: new Array(column).fill(0)
        property var prevHeight: new Array(column).fill(0) //上一列的高度数组

        onColumnChanged: forceLayout();
        onContentYChanged: {
            //需要时加载更多
            if ((contentY + height) > contentHeight) {
                loadMore();
            }
        }
        onWidthChanged: {
            if ((width - spacing) % 2 !== 0) {
                spacing += 1;
            }
            forceLayout();
        }
        onHeightChanged: forceLayout();

        function loadMore() {
            //这部分来自后台请求, 必须知道封面宽高
            let titleList = [
                    "单行标题: 测试测试测试测试",
                    "双行标题: 测试测试测试测试测试测测试测试测试测试测试测试",
                    "三行标题: 测试测试测试测试测试测测试测试测试测试测试测试测试测试测试测试测试测试测试"
                ];
            for (let i = 0; i < 10; i++) {
                let userId = Math.round(Math.random() * 100000);
                let type = Math.round(Math.random());  //0 image / 1 video
                let cover = "file:/C:/Users/mps95/Desktop/素材/动漫图片/img2" + i + ".jpg"; //封面, 无论视频还是图片都需要有
                let url = cover;
                if (type == 1) {
                    //url = "file:/test.mp4";
                }

                let object = {
                    type: type,
                    cover: cover,
                    user: userId,
                    url: url,
                    title: titleList[Math.round(Math.random() * 2)],
                    coverWidth: 300,
                    coverHeight: (type + 2) * 100 + Math.round(Math.random() * 3) * 80
                };

                jsonData.push(object);
                listModel.append(object);
            }
        }

        function forceLayout() {
            currentColumn = 0;
            currentX = 0;
            currentY = new Array(column).fill(0);
            prevHeight = new Array(column).fill(0);

            listModel.clear();
            for (let i = 0; i < jsonData.length; i++) {
                listModel.append(jsonData[i]);
            }
        }

        Repeater {
            id: repeater
            model: ListModel {
                id: listModel
                Component.onCompleted: {
                    flickable.loadMore();
                }
            }
            delegate: Rectangle {
                id: rootItem
                width: (flickable.width - flickable.spacing) / flickable.column
                height: coverRealHeight + titleHeight + infoHeight
                radius: 4
                clip: true

                property real aspectRatio: coverWidth / coverHeight
                property real coverRealWidth: width
                property real coverRealHeight: width / aspectRatio
                property real titleWidth: width
                property real titleHeight: titleText.height
                property real infoWidth: width
                property real infoHeight: 50

                Component.onCompleted: {
                    if (flickable.currentColumn == flickable.column) {
                        flickable.currentColumn = 0;
                        flickable.currentX = 0;
                        for (let i = 0; i < flickable.column; i++) {
                            flickable.currentY[i] += flickable.prevHeight[i];
                        }
                    }

                    x = flickable.currentX;
                    y = flickable.currentY[flickable.currentColumn];

                    flickable.prevHeight[flickable.currentColumn] = Math.round(height + flickable.spacing);

                    print(flickable.currentColumn, flickable.currentX, flickable.prevHeight, flickable.currentY);

                    flickable.currentX += coverRealWidth + flickable.spacing;

                    flickable.currentColumn++;

                    let max = 0;
                    for (let j = 0; j < flickable.column; j++) {
                        max = Math.max(flickable.prevHeight[j] + flickable.currentY[j]);
                    }

                    flickable.contentHeight = max;
                }

                Column {
                    Item {
                        id: coverPort
                        width: coverRealWidth
                        height: coverRealHeight

                        Image {
                            anchors.fill: parent
                            anchors.topMargin: rootItem.radius
                            source: cover
                        }
                    }

                    Item {
                        id: titlePort
                        width: titleWidth
                        height: titleText.height

                        Text {
                            id: titleText
                            width: parent.width
                            wrapMode: Text.WrapAnywhere
                            text: title
                            font.family: "微软雅黑"
                            font.pointSize: 14
                        }
                    }

                    Item {
                        id: infoPort
                        width: infoWidth
                        height: infoHeight

                        RowLayout {
                            anchors.fill: parent

                            CircularImage {
                                id: head
                                Layout.preferredWidth: parent.height - 5
                                Layout.preferredHeight: parent.height - 5
                                Layout.leftMargin: 5
                                Layout.alignment: Qt.AlignVCenter
                                source: "file:/C:/Users/mps95/Desktop/head.jpg"
                            }

                            Text {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                text: "用户" + user
                                font.pointSize: 14
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.preferredWidth: 100
                                Layout.preferredHeight: parent.height
                                Layout.rightMargin: 5
                                text: (like ? "🩷" : "🤍") + " " + Math.round(Math.random() * 1000)
                                font.pointSize: 14
                                horizontalAlignment: Text.AlignRight
                                verticalAlignment: Text.AlignVCenter
                                property int like: Math.round(Math.random())
                            }
                        }
                    }
                }
            }
        }
    }
}
