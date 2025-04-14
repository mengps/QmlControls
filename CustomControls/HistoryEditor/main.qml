import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("History Editor")

    TextField {
        id: inputField
        width: 300
        height: 40
        selectByMouse: true
        font.pointSize: 12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100
        background: Rectangle {
           radius: 4
           border.color: "green"
        }

        property bool editing: false

        onTextEdited: editing = true;
        onEditingFinished: editing = false;
        onTextChanged: {
            myModel.sortByKey(inputField.text);
        }
    }

    Button {
        text: qsTr("搜索")
        width: 70
        height: 40
        anchors.top: inputField.top
        anchors.left: inputField.right
        anchors.leftMargin: 12
    }

    Rectangle {
        id: historyList
        radius: 4
        width: 300
        height: 200
        visible: inputField.editing || inputField.activeFocus
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: inputField.bottom
        anchors.topMargin: 2
        border.color: "red"
        color: "#eee"

        ListView {
            id: listView
            anchors.fill: parent
            anchors.margins: 5
            clip: true
            spacing: 5
            delegate: Component {
                Rectangle {
                    radius: 4
                    width: listView.width - 20
                    height: 40
                    color: hovered ? "#f4f4f4" : "#ddd"
                    border.color: "gray"

                    property bool hovered: false

                    Text {
                        id: displayText
                        text: display
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 20
                        font.pixelSize: 18
                        font.wordSpacing: 3

                        TextMetrics {
                            id: startWidth
                            font: displayText.font
                            text: {
                                let index = display.indexOf(inputField.text);
                                if (index !== -1)
                                    return displayText.text.substring(0, index);
                                else
                                    return "";
                            }
                        }

                        TextMetrics {
                            id: keyWidth
                            font: displayText.font
                            text: inputField.text
                        }

                        Rectangle {
                            color: "red"
                            opacity: 0.4
                            x: startWidth.advanceWidth
                            width: keyWidth.advanceWidth
                            height: parent.height
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true;
                        onExited: parent.hovered = false;
                    }
                }
            }
            model: myModel
            ScrollBar.vertical: ScrollBar {
                width: 12
                policy: ScrollBar.AlwaysOn
            }
        }
    }
}
