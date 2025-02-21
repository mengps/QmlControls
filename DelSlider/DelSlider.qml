import QtQuick 2.15
import QtQuick.Templates 2.15 as T

Item {
    id: control

    enum SnapMode
    {
        NoSnap = 0,
        SnapAlways = 1,
        SnapOnRelease = 2
    }

    signal firstMoved();
    signal firstReleased();
    signal secondMoved();
    signal secondReleased();

    property bool animationEnabled: true
    property real min: 0
    property real max: 100
    property real stepSize: 0.0
    property var value: range ? [0, 0] : 0
    readonly property var currentValue: {
        if (__sliderLoader.item) {
            return range ? [__sliderLoader.item.first.value, __sliderLoader.item.second.value] : __sliderLoader.item.value;
        } else {
            return value;
        }
    }
    property bool range: false
    property bool hovered: __sliderLoader.item ? __sliderLoader.item.hovered : false
    property int snapMode: DelSlider.NoSnap
    property int orientation: Qt.Horizontal
    property int radiusBg: 6
    property color colorBg: (enabled && hovered) ? Qt.rgba(0,0,0,0.25) : Qt.rgba(0,0,0,0.15)
    property color colorHandle: "#fff"
    property color colorTrack: {
        if (enabled)
            return hovered ? "#69b1ff" : "#91caff";
        else
            return Qt.rgba(145/255,202/255,1,0);
    }
    property Component handleToolTipDelegate: Item { }
    property Component handleDelegate: Rectangle {
        id: __handleItem
        x: {
            if (control.orientation == Qt.Horizontal) {
                return slider.leftPadding + visualPosition * (slider.availableWidth - width);
            } else {
                return slider.topPadding + (slider.availableWidth - width) * 0.5;
            }
        }
        y: {
            if (control.orientation == Qt.Horizontal) {
                return slider.topPadding + (slider.availableHeight - height) * 0.5;
            } else {
                return slider.leftPadding + visualPosition * (slider.availableHeight - height);
            }
        }
        implicitWidth: active ? 18 : 14
        implicitHeight: active ? 18 : 14
        radius: height * 0.5
        color: control.colorHandle
        border.color: {
            if (control.enabled) {
                return active ? "#69b1ff" : "#91caff";
            } else {
                return Qt.rgba(0,0,0,0.25);
            }
        }
        border.width: active ? 4 : 2

        property bool down: pressed
        property bool active: __hoverHandler.hovered || down

        Behavior on implicitWidth { enabled: control.animationEnabled; NumberAnimation { duration: 100 } }
        Behavior on implicitHeight { enabled: control.animationEnabled; NumberAnimation { duration: 100 } }
        Behavior on border.width { enabled: control.animationEnabled; NumberAnimation { duration: 100 } }
        Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
        Behavior on border.color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

        Loader {
            sourceComponent: handleToolTipDelegate
            onLoaded: item.parent = __handleItem;
            property alias handleHovered: __hoverHandler.hovered
            property alias handlePressed: __handleItem.down
        }

        HoverHandler {
            id: __hoverHandler
            acceptedDevices: PointerDevice.AllDevices
        }
    }
    property Component bgDelegate: Item {
        Rectangle {
            width: control.orientation == Qt.Horizontal ? parent.width : 4
            height: control.orientation == Qt.Horizontal ? 4 : parent.height
            anchors.horizontalCenter: control.orientation == Qt.Horizontal ? undefined : parent.horizontalCenter
            anchors.verticalCenter: control.orientation == Qt.Horizontal ? parent.verticalCenter : undefined
            radius: control.radiusBg
            color: control.colorBg

            Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }

            Rectangle {
                x: {
                    if (control.orientation == Qt.Horizontal)
                        return range ? (slider.first.visualPosition * parent.width) : 0;
                    else
                        return 0;
                }
                y: {
                    if (control.orientation == Qt.Horizontal)
                        return 0;
                    else
                        return range ? (slider.second.visualPosition * parent.height) : slider.visualPosition * parent.height;
                }
                width: {
                    if (control.orientation == Qt.Horizontal)
                        return range ? (slider.second.visualPosition * parent.width - x) : slider.visualPosition * parent.width;
                    else
                        return parent.width;
                }
                height: {
                    if (control.orientation == Qt.Horizontal)
                        return parent.height;
                    else
                        return range ? (slider.first.visualPosition * parent.height - y) : ((1.0 - slider.visualPosition) * parent.height);
                }
                color: colorTrack
                radius: parent.radius

                Behavior on color { enabled: control.animationEnabled; ColorAnimation { duration: 100 } }
            }
        }
    }
    property string contentDescription: ""

    onValueChanged: __fromValueUpdate();

    function decrease(first = true) {
        if (__sliderLoader.item) {
            if (range) {
                if (first)
                    __sliderLoader.item.first.decrease();
                else
                    __sliderLoader.item.second.decrease();
            } else {
                __sliderLoader.item.decrease();
            }
        }
    }
    function increase(first = true) {
        if (range) {
            if (first)
                __sliderLoader.item.first.increase();
            else
                __sliderLoader.item.second.increase();
        } else {
            __sliderLoader.item.decrease();
        }
    }
    function __fromValueUpdate() {
        if (__sliderLoader.item) {
            if (range) {
                __sliderLoader.item.setValues(...value);
            } else {
                __sliderLoader.item.value = value;
            }
        }
    }

    Component {
        id: __sliderComponent

        T.Slider {
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            orientation: control.orientation
            snapMode: {
                switch (control.snapMode) {
                case DelSlider.SnapAlways: return T.Slider.SnapAlways;
                case DelSlider.SnapOnRelease: return T.Slider.SnapOnRelease;
                default: return T.Slider.NoSnap;
                }
            }
            handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
                property alias pressed: __control.pressed
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
                property alias visualPosition: __control.visualPosition
            }
            onMoved: control.firstMoved();
            onPressedChanged: {
                if (!pressed)
                    control.firstReleased();
            }
        }
    }

    Component {
        id: __rangeSliderComponent

        T.RangeSlider {
            id: __control
            from: min
            to: max
            stepSize: control.stepSize
            snapMode: {
                switch (control.snapMode) {
                case DelSlider.SnapAlways: return T.RangeSlider.SnapAlways;
                case DelSlider.SnapOnRelease: return T.RangeSlider.SnapOnRelease;
                default: return T.RangeSlider.NoSnap;
                }
            }
            orientation: control.orientation
            first.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.first.visualPosition
                property alias pressed: __control.first.pressed
            }
            first.onMoved: control.firstMoved();
            first.onPressedChanged: {
                if (!first.pressed)
                    control.firstReleased();
            }
            second.handle: Loader {
                sourceComponent: handleDelegate
                property alias slider: __control
                property alias visualPosition: __control.second.visualPosition
                property alias pressed: __control.second.pressed
            }
            second.onMoved: control.secondMoved();
            second.onPressedChanged: {
                if (!second.pressed)
                    control.secondReleased();
            }
            background: Loader {
                sourceComponent: bgDelegate
                property alias slider: __control
            }
        }
    }

    Loader {
        id: __sliderLoader
        anchors.fill: parent
        sourceComponent: control.range ? __rangeSliderComponent : __sliderComponent
        onLoaded: __fromValueUpdate();
    }

    Accessible.role: Accessible.Slider
    Accessible.name: control.contentDescription
    Accessible.description: control.contentDescription
    Accessible.onIncreaseAction: increase();
    Accessible.onDecreaseAction: decrease();
}
