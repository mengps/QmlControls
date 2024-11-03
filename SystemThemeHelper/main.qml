import QtQuick 2.15
import QtQuick.Window 2.15

import DelegateUI.Utils 1.0

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("SystemThemeHelper Test - ") + (themeHelper.colorScheme == SystemThemeHelper.Dark ? "Dark" : "Light")
    color: themeHelper.colorScheme == SystemThemeHelper.Dark ? "black" : "white"

    Behavior on color { ColorAnimation { } }

    SystemThemeHelper {
        id: themeHelper
        onThemeColorChanged: {
            console.log("onThemeColorChanged:", themeColor);
        }
        onColorSchemeChanged: {
            setWindowTitleBarMode(window, themeHelper.colorScheme == SystemThemeHelper.Dark)
            console.log("onColorSchemeChanged:", colorScheme);
        }
        Component.onCompleted: {
            console.log("onColorSchemeChanged:", colorScheme);
            setWindowTitleBarMode(window, themeHelper.colorScheme == SystemThemeHelper.Dark)
        }
    }

    Text {
        anchors.centerIn: parent
        text: qsTr("主题颜色")
        font.family: "微软雅黑"
        font.pointSize: 32
        color: themeHelper.themeColor
    }
}
