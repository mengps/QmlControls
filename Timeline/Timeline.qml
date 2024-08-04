import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    clip: true

    property var initModel: []
    property bool reverse: true

    /*! 默认节点样式 */
    property real defaultNodeRadius: 16
    property string defaultNodeColor: "#e4e7ed"
    property string defaultNodeBorderColor: "#3bc3ff"
    property int defaultNodeBorderWidth: 0

    /*! 默认线样式 */
    property string defaultLineColor: "#e4e7ed"
    property int defaultLineWidth: 2

    /*! 默认时间样式 */
    property font defaultTimeFont
    property string defaultTimeFontColor: "black"
    property string defaultTimeFormat: "yyyy-MM-dd"

    /*! 默认内容样式 */
    property int defaultContentFormat: Text.AutoText
    property font defaultContentFont
    property string defaultContentFontColor: "black"
    property real defaultContentBackgroundRadius: 5
    property string defaultContentBackgroundColor: "transparent"
    property string defaultContentBorderColor: "transparent"
    property real defaultContentBorderWdith: 1

    property Component nodeDelegate: Component {
        Item {
            width: __nodeRadius
            height: width

            Rectangle {
                visible: __nodeIcon === ""
                width: parent.width
                height: parent.height
                radius: width >> 1
                color: __nodeColor
                border.color: __nodeBorderColor
                border.width: __nodeBorderWidth
            }

            Text {
                visible: __nodeIcon !== ""
                font.pixelSize: parent.width
                font.family: fontAwesome.name
                text: __nodeIcon
            }
        }
    }
    property Component lineDelegate: Component {
        Rectangle {
            color: __lineColor
        }
    }
    property Component contentDelegate: Component {
        Column {
            width: parent.width
            spacing: 5

            Text {
                id: __timeText
                text: __timestamp.toLocaleString(Qt.locale(), __timeFormat)
                font: __timeFont
                color: __timeFontColor
            }

            Rectangle {
                width: parent.width
                height: __contentText.height + 10
                color: __contentBackgroundColor
                border.color: __contentBorderColor
                border.width: __contentBorderWidth
                radius: __contentBackgroundRadius

                Text {
                    id: __contentText
                    width: parent.width - 12
                    anchors.centerIn: parent
                    text: __content
                    font: __contentFont
                    color: __contentFontColor
                    textFormat: __contentFormat
                    wrapMode: Text.WrapAnywhere
                }
            }
        }
    }

    onReverseChanged: sort();
    Component.onCompleted: {
        for (let item of initModel) {
            append(item);
        }
    }

    function initOption(object) {
        object.nodeIcon = object.nodeIcon || "";
        object.nodeRadius = object.nodeRadius || root.defaultNodeRadius;
        object.nodeColor = object.nodeColor || root.defaultNodeColor;
        object.nodeBorderColor = object.nodeBorderColor || root.defaultNodeBorderColor;
        object.nodeBorderWidth = object.nodeBorderWidth || root.defaultNodeBorderWidth;
        object.lineColor = object.lineColor || root.defaultLineColor;
        object.lineWidth = object.lineWidth || root.defaultLineWidth;
        object.timeFont = object.timeFont || root.defaultTimeFont;
        object.timeFontColor = object.timeFontColor || root.defaultTimeFontColor;
        object.timeFormat = object.timeFormat || root.defaultTimeFormat;
        object.contentFormat = object.contentFormat || root.defaultContentFormat;
        object.contentFont = object.contentFont || root.defaultContentFont;
        object.contentFontColor = object.contentFontColor || root.defaultContentFontColor;
        object.contentBackgroundRadius = object.contentBackgroundRadius || root.defaultContentBackgroundRadius;
        object.contentBackgroundColor = object.contentBackgroundColor || root.defaultContentBackgroundColor;
        object.contentBorderColor = object.contentBorderColor || root.defaultContentBorderColor;
        object.contentBorderWdith = object.contentBorderWdith || root.defaultContentBorderWdith;
    }

    function append(object) {
        let index = 0;
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            if (root.reverse) {
                if (listModel.get(i).timestamp < object.timestamp) {
                    index = i + 1;
                } else break;
            } else {
                if (listModel.get(i).timestamp > object.timestamp) {
                    index = i + 1;
                } else break;
            }
        }
        initOption(object);
        listModel.insert(index, object);
    }

    function sort(){
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            for (let j = 0; i + j < rowCount - 1; j++) {
                if (root.reverse) {
                    if (listModel.get(j).timestamp > listModel.get(j + 1).timestamp) {
                        listModel.move(j, j + 1, 1);
                    }
                } else {
                    if (listModel.get(j).timestamp < listModel.get(j + 1).timestamp) {
                        listModel.move(j, j + 1, 1);
                    }
                }
            }
        }
    }

    function removeAtIndex(index) {
        listModel.remove(index);
    }

    function removeAtTimestamp(timestamp) {
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            if (timestamp.getTime() === listModel.get(i).timestamp.getTime()) {
                listModel.remove(i);
                break;
            }
        }
    }

    FontLoader {
        id: fontAwesome
        source: "file:./../common/FontAwesome.otf"
    }

    ListView {
        id: listView
        anchors.fill: parent
        model: ListModel { id: listModel }
        ScrollBar.vertical: ScrollBar { width: 14 }
        delegate: Item {
            width: listView.width
            height: contentLoader.height + 5
            opacity: 0

            NumberAnimation on opacity {
                from: 0
                to: 1
                duration: 300
                running: true
            }

            Loader {
                id: lineLoader
                active: index !== (listModel.count - 1)
                width: lineWidth
                height: parent.height - nodeLoader.height
                anchors.top: nodeLoader.bottom
                anchors.horizontalCenter: nodeLoader.horizontalCenter
                sourceComponent: lineDelegate
                property string __lineColor: lineColor
            }

            Loader {
                id: nodeLoader
                sourceComponent: nodeDelegate
                property string __nodeIcon: nodeIcon
                property real __nodeRadius: nodeRadius
                property string __nodeColor: nodeColor
                property string __nodeBorderColor: nodeBorderColor
                property real __nodeBorderWidth: nodeBorderWidth
            }

            Loader {
                id: contentLoader
                anchors.left: nodeLoader.right
                anchors.leftMargin: 10
                anchors.right: parent.right
                sourceComponent: contentDelegate
                property var __timestamp: timestamp
                property font __timeFont: Qt.font(timeFont)
                property string __timeFontColor: timeFontColor
                property string __timeFormat: timeFormat

                property string __content: content
                property int __contentFormat: contentFormat
                property font __contentFont: Qt.font(contentFont)
                property string __contentFontColor: contentFontColor
                property string __contentBackgroundColor: contentBackgroundColor
                property real __contentBackgroundRadius: contentBackgroundRadius
                property string __contentBorderColor: contentBorderColor
                property real __contentBorderWidth: contentBorderWdith
            }
        }
    }
}
