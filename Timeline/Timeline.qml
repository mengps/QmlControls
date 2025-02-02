import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root

    clip: true

    property var initModel: []
    property bool reverse: true
    property alias count: listModel.count

    /*! 默认节点样式 */
    property string defaultNodeIconColor: "black"
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
                font.family: delegateuiFont.name
                text: String.fromCharCode(nodeOptions.icon)
                color: nodeOptions.iconColor
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
                    font: Qt.font(contentOptions.font)
                    color: contentOptions.fontColor
                    textFormat: contentOptions.format
                    text: content
                    wrapMode: Text.WrapAnywhere
                }
            }
        }
    }

    onReverseChanged: sort();
    Component.onCompleted: {
        for (const item of initModel) {
            append(item);
        }
    }

    function __initOptions(object, clone = undefined) {
        /*! clone 不为 undefined 且 object 不存在选项时拷贝到 object 中 */
        object.__nodeOptions = object.nodeOptions || {};
        object.__nodeOptions.icon = object.nodeOptions && object.nodeOptions.icon ||
                clone && clone.__nodeOptions && clone.__nodeOptions.icon || "";
        object.__nodeOptions.iconColor = object.nodeOptions && object.nodeOptions.iconColor ||
                clone && clone.__nodeOptions && clone.__nodeOptions.iconColor || root.defaultNodeIconColor;
        object.__nodeOptions.backgroundColor = object.nodeOptions && object.nodeOptions.backgroundColor ||
                clone && clone.__nodeOptions && clone.__nodeOptions.backgroundColor || root.defaultNodeBackgroundColor;
        object.__nodeOptions.backgroundRadius = object.nodeOptions && object.nodeOptions.backgroundRadius ||
                clone && clone.__nodeOptions && clone.__nodeOptions.backgroundRadius || root.defaultNodeBackgroundRadius;
        object.__nodeOptions.borderColor = object.nodeOptions && object.nodeOptions.borderColor ||
                clone && clone.__nodeOptions && clone.__nodeOptions.borderColor || root.defaultNodeBorderColor;
        object.__nodeOptions.borderWidth = object.nodeOptions && object.nodeOptions.borderWidth ||
                clone && clone.__nodeOptions && clone.__nodeOptions.borderWidth || root.defaultNodeBorderWidth;
        delete object.nodeOptions;

        object.__lineOptions = object.lineOptions || {};
        object.__lineOptions.color = object.lineOptions && object.lineOptions.color ||
                clone && clone.__lineOptions && clone.__lineOptions.color || root.defaultLineColor;
        object.__lineOptions.width = object.lineOptions && object.lineOptions.width ||
                clone && clone.__lineOptions && clone.__lineOptions.width || root.defaultLineWidth;
        delete object.lineOptions;

        object.__timeOptions = object.timeOptions || {};
        object.__timeOptions.format = object.timeOptions && object.timeOptions.format ||
                clone && clone.__timeOptions && clone.__timeOptions.format || root.defaultTimeFormat;
        object.__timeOptions.font = object.timeOptions && object.timeOptions.font ||
                clone && clone.__timeOptions && clone.__timeOptions.font || root.defaultTimeFont;
        object.__timeOptions.fontColor = object.timeOptions && object.timeOptions.fontColor ||
                clone && clone.__timeOptions && clone.__timeOptions.fontColor || root.defaultTimeFontColor;
        delete object.timeOptions;

        /*! 先变更 format 再改变 timestamp, 可以触发动态更新 */
        object.__timestamp = object.timestamp|| clone && clone.__timestamp;
        delete object.timestamp;

        object.__contentOptions = object.contentOptions || {};
        object.__contentOptions.format = object.contentOptions && object.contentOptions.format ||
                clone && clone.__contentOptions && clone.__contentOptions.format || root.defaultContentFormat;
        object.__contentOptions.font = object.contentOptions && object.contentOptions.font ||
                clone && clone.__contentOptions && clone.__contentOptions.font || root.defaultContentFont;
        object.__contentOptions.fontColor = object.contentOptions && object.contentOptions.fontColor ||
                clone && clone.__contentOptions && clone.__contentOptions.fontColor || root.defaultContentFontColor;
        object.__contentOptions.backgroundColor = object.contentOptions && object.contentOptions.backgroundColor ||
                clone && clone.__contentOptions && clone.__contentOptions.backgroundColor || root.defaultContentBackgroundColor;
        object.__contentOptions.backgroundRadius = object.contentOptions && object.contentOptions.backgroundRadius ||
                clone && clone.__contentOptions && clone.__contentOptions.backgroundRadius || root.defaultContentBackgroundRadius;
        object.__contentOptions.borderColor = object.contentOptions && object.contentOptions.borderColor ||
                clone && clone.__contentOptions && clone.__contentOptions.borderColor ||root.defaultContentBorderColor;
        object.__contentOptions.borderWidth = object.contentOptions && object.contentOptions.borderWidth ||
                clone && clone.__contentOptions && clone.__contentOptions.borderWidth || root.defaultContentBorderWdith
        delete object.contentOptions;

        /*! 先变更 format 再改变 content, 可以触发动态更新 */
        object.__content = object.content || clone && clone.__content || "";
        delete object.content;
    }

    function append(object) {
        __initOptions(object);

        let index = 0;
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            if (root.reverse) {
                if (listModel.get(i).__timestamp < object.__timestamp) {
                    index = i + 1;
                } else break;
            } else {
                if (listModel.get(i).__timestamp > object.__timestamp) {
                    index = i + 1;
                } else break;
            }
        }
        listModel.insert(index, object);
    }

    function sort(){
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            for (let j = 0; i + j < rowCount - 1; j++) {
                if (root.reverse) {
                    if (listModel.get(j).__timestamp > listModel.get(j + 1).__timestamp) {
                        listModel.move(j, j + 1, 1);
                    }
                } else {
                    if (listModel.get(j).__timestamp < listModel.get(j + 1).__timestamp) {
                        listModel.move(j, j + 1, 1);
                    }
                }
            }
        }
    }

    function getAtIndex(index) {
        let result = {};
        let object = listModel.get(index);
        for (let key in object) {
            result[key.slice(2)] = object[key];
        }
        return result;
    }

    function setAtIndex(index, object) {
        __initOptions(object, listModel.get(index));
        listModel.set(index, object);
        sort();
    }

    function removeAtIndex(index) {
        listModel.remove(index);
    }

    function removeAtTimestamp(timestamp) {
        let rowCount = listModel.count;
        for (let i = 0; i < rowCount; i++) {
            if (timestamp.getTime() === listModel.get(i).__timestamp.getTime()) {
                listModel.remove(i);
                break;
            }
        }
    }

    FontLoader {
        id: delegateuiFont
        source: "qrc:/../common/DelegateUI-Icons.ttf"
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
