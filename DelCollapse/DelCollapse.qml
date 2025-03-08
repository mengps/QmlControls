import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import DelegateUI.Controls 1.0

import "qrc:/../common"

Item {
    id: control

    height: __listView.contentHeight

    titleFont {
        family: "微软雅黑"
        pixelSize: 14
    }
    contentFont {
        family: "微软雅黑"
        pixelSize: 14
    }

    signal actived(key: string);

    property bool animationEnabled: true
    property var initModel: []
    property alias count: __listModel.count
    property alias spacing: __listView.spacing
    property bool accordion: false
    property var activeKey: accordion ? "" : []
    property var defaultActiveKey: []
    property int expandIcon: DelIcon.RightOutlined
    property font titleFont
    property color colorBg: "#fff"
    property color colorIcon: Qt.rgba(0,0,0,0.88)
    property color colorTitle: Qt.rgba(0,0,0,0.88)
    property color colorTitleBg: Qt.rgba(0,0,0,0.04)
    property font contentFont
    property color colorContent: Qt.rgba(0,0,0,0.88)
    property color colorContentBg: "#fff"
    property color colorBorder: Qt.darker("#fff", 1.18)
    property int radiusBg: 6
    property Component titleDelegate: Row {
        leftPadding: 16
        rightPadding: 16
        height: Math.max(40, __icon.height, __title.height)
        spacing: 8

        DelIconText {
            id: __icon
            anchors.verticalCenter: parent.verticalCenter
            iconSource: control.expandIcon
            colorIcon: control.colorIcon
            rotation: isActive ? 90 : 0

            Behavior on rotation { enabled: control.animationEnabled; RotationAnimation { duration: 100 } }
        }

        Text {
            id: __title
            anchors.verticalCenter: parent.verticalCenter
            text: model.title
            elide: Text.ElideRight
            font: control.titleFont
            color: control.colorTitle
        }
    }
    property Component contentDelegate: DelCopyableText {
        padding: 16
        topPadding: 8
        bottomPadding: 8
        text: model.content
        font: control.contentFont
        wrapMode: Text.WordWrap
        color: control.colorContent
    }

    onInitModelChanged: {
        clear();
        for (const object of initModel) {
            append(object);
        }
    }

    function get(index) {
        return __listModel.get(index);
    }

    function set(index, object) {
        __listModel.set(index, object);
    }

    function setProperty(index, propertyName, value) {
        __listModel.setProperty(index, propertyName, value);
    }

    function move(from, to, count = 1) {
        __listModel.move(from, to, count);
    }

    function insert(index, object) {
        __listModel.insert(index, object);
    }

    function append(object) {
        __listModel.append(object);
    }

    function removeAt(index, count = 1) {
        __listModel.remove(index, count);
    }

    function clear() {
        __listModel.clear();
    }

    Behavior on colorBg { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorTitle { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorTitleBg { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorContent { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
    Behavior on colorContentBg { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

    QtObject {
        id: __private
        function calcActiveKey() {
            if (control.accordion) {
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        control.activeKey = item.model.key;
                        break;
                    }
                }
            } else {
                let keys = [];
                for (let i = 0; i < __listView.count; i++) {
                    const item = __listView.itemAtIndex(i);
                    if (item && item.active) {
                        keys.push(item.model.key);
                    }
                }
                control.activeKey = keys;
            }
        }
    }

    ListView {
        id: __listView
        anchors.fill: parent
        interactive: false
        spacing: -1
        model: ListModel { id: __listModel }
        onContentHeightChanged: if (contentHeight > 0) cacheBuffer = contentHeight;
        delegate: DelRectangle {
            id: __rootItem
            width: __listView.width
            height: __column.height + ((detached && active) ? 1 : 0)
            topLeftRadius: (isStart || detached) ? control.radiusBg : 0
            topRightRadius: (isStart || detached) ? control.radiusBg : 0
            bottomLeftRadius: (isEnd || detached) ? control.radiusBg : 0
            bottomRightRadius: (isEnd || detached) ? control.radiusBg : 0
            color: control.colorBg
            border.color: control.colorBorder
            border.width: detached
            clip: true

            required property var model
            required property int index
            property bool isStart: index == 0
            property bool isEnd: (index + 1) === control.count
            property bool active: false
            property bool detached: __listView.spacing !== -1

            Component.onCompleted: {
                if (control.defaultActiveKey.indexOf(model.key) != -1)
                    active = true;
            }

            Column {
                id: __column
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter

                DelRectangle {
                    width: parent.width
                    height: __titleLoader.height
                    topLeftRadius: (isStart || detached) ? control.radiusBg : 0
                    topRightRadius: (isStart || detached) ? control.radiusBg : 0
                    bottomLeftRadius: (isEnd && !active) || (detached && !active) ? control.radiusBg : 0
                    bottomRightRadius: (isEnd && !active) || (detached && !active) ? control.radiusBg : 0
                    color: control.colorTitleBg
                    border.color: control.colorBorder

                    Loader {
                        id: __titleLoader
                        width: parent.width
                        sourceComponent: titleDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active

                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }

                        TapHandler {
                            onTapped: {
                                if (control.accordion) {
                                    for (let i = 0; i < __listView.count; i++) {
                                        const item = __listView.itemAtIndex(i);
                                        if (item && item !== __rootItem) {
                                            item.active = false;
                                        }
                                    }
                                    __rootItem.active = !__rootItem.active;
                                } else {
                                    __rootItem.active = !__rootItem.active;
                                }
                                if (__rootItem.active)
                                    control.actived(__rootItem.model.key);
                                __private.calcActiveKey();
                            }
                        }
                    }
                }

                DelRectangle {
                    width: parent.width
                    height: active ? __contentLoader.height : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    bottomLeftRadius: control.radiusBg
                    bottomRightRadius: control.radiusBg
                    color: control.colorContentBg
                    clip: true

                    Behavior on height { enabled: control.animationEnabled; NumberAnimation { duration: 100 } }

                    Loader {
                        id: __contentLoader
                        width: parent.width
                        anchors.centerIn: parent
                        sourceComponent: contentDelegate
                        property alias model: __rootItem.model
                        property alias index: __rootItem.index
                        property alias isActive: __rootItem.active
                    }
                }
            }
        }
    }

    Loader {
        anchors.fill: __listView
        active: spacing === -1
        sourceComponent: Rectangle {
            color: "transparent"
            border.color: control.colorBorder
            radius: control.radiusBg
        }
    }
}
