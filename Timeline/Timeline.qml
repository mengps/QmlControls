import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    clip: true

    property var initModel: []
    property bool reverse: true

    /*! 默认节点样式 */
    property real defaultNodeBackgroundRadius: 16
    property string defaultNodeBackgroundColor: "#e4e7ed"
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
            width: nodeOptions.backgroundRadius
            height: width

            Rectangle {
                visible: nodeOptions.icon === ""
                width: parent.width
                height: parent.height
                radius: width >> 1
                color: nodeOptions.backgroundColor
                border.color: nodeOptions.borderColor
                border.width: nodeOptions.borderWidth
            }

            Text {
                visible: nodeOptions.icon !== ""
                font.pixelSize: parent.width
                font.family: fontAwesome.name
                text: nodeOptions.icon
            }
        }
    }
    property Component lineDelegate: Component {
        Item {
            Rectangle {
                width: lineOptions.width
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                color: lineOptions.color
            }
        }
    }
    property Component contentDelegate: Component {
        Column {
            width: parent.width
            spacing: 5

            Text {
                id: __timeText
                text: timestamp.toLocaleString(Qt.locale(), timeOptions.format)
                font: Qt.font(timeOptions.font)
                color: timeOptions.fontColor
            }

            Rectangle {
                width: parent.width
                height: __contentText.height + 10
                color: contentOptions.backgroundColor
                border.color: contentOptions.borderColor
                border.width: contentOptions.borderWidth
                radius: contentOptions.backgroundRadius

                Text {
                    id: __contentText
                    width: parent.width - 12
                    anchors.centerIn: parent
                    text: content
                    font: Qt.font(contentOptions.font)
                    color: contentOptions.fontColor
                    textFormat: contentOptions.format
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


    function __initOption(object) {
        object.__nodeOptions = {
            icon: object.nodeOptions && object.nodeOptions.icon || "",
            backgroundColor: object.nodeOptions && object.nodeOptions.backgroundColor || root.defaultNodeBackgroundColor,
            backgroundRadius: object.nodeOptions && object.nodeOptions.backgroundRadius || root.defaultNodeBackgroundRadius,
            borderColor: object.nodeOptions && object.nodeOptions.borderColor || root.defaultNodeBorderColor,
            borderWidth: object.nodeOptions && object.nodeOptions.borderWidth || root.defaultNodeBorderWidth
        }

        object.__lineOptions = {
            color: object.lineOptions && object.lineOptions.color || root.defaultLineColor,
            width: object.lineOptions && object.lineOptions.width || root.defaultLineWidth,
        }

        object.__timestamp = object.timestamp;
        object.__timeOptions = {
            format: object.timeOptions && object.timeOptions.format || root.defaultTimeFormat,
            font: object.timeOptions && object.timeOptions.font || root.defaultTimeFont,
            fontColor: object.timeOptions && object.timeOptions.fontColor || root.defaultTimeFontColor,
        }

        object.__content = object.content || "";
        object.__contentOptions = {
            format: object.contentOptions && object.contentOptions.format || root.defaultContentFormat,
            font: object.contentOptions && object.contentOptions.font || root.defaultContentFont,
            fontColor: object.contentOptions && object.contentOptions.fontColor || root.defaultContentFontColor,
            backgroundColor: object.contentOptions && object.contentOptions.backgroundColor || root.defaultContentBackgroundColor,
            backgroundRadius: object.contentOptions && object.contentOptions.backgroundRadius || root.defaultContentBackgroundRadius,
            borderColor: object.contentOptions && object.contentOptions.borderColor || root.defaultContentBorderColor,
            borderWidth: object.contentOptions && object.contentOptions.borderWidth || root.defaultContentBorderWdith,
        };
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
        __initOption(object);
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
                width: nodeLoader.width
                height: parent.height - nodeLoader.height
                anchors.top: nodeLoader.bottom
                sourceComponent: lineDelegate
                property var lineOptions: __lineOptions
            }

            Loader {
                id: nodeLoader
                sourceComponent: nodeDelegate
                property var nodeOptions: __nodeOptions
            }

            Loader {
                id: contentLoader
                anchors.left: nodeLoader.right
                anchors.leftMargin: 10
                anchors.right: parent.right
                sourceComponent: contentDelegate
                property var content: __content
                property var contentOptions: __contentOptions
                property var timestamp: __timestamp
                property var timeOptions: __timeOptions
            }
        }
    }
}
