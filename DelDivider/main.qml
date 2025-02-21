import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelDivider")

    Rectangle {
        width: 400
        height: 400
        border.color: "gray"
        anchors.centerIn: parent

        Column {
            width: parent.width
            spacing: 10

            DelDivider {
                width: parent.width
                height: 30
                title: qsTr("水平分割线-居左")
                titleAlign: DelDivider.Align_Left
            }

            Text {
                width: parent.width - 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nonne merninisti licere mihi ista probare, quae sunt a te dicta? Refert tamen, quo modo.")
                wrapMode: Text.WordWrap
            }

            DelDivider {
                width: parent.width
                height: 30
                title: qsTr("水平分割线-居中")
                titleAlign: DelDivider.Align_Center
            }

            DelDivider {
                width: parent.width
                height: 30
                title: qsTr("水平分割线-居右")
                titleAlign: DelDivider.Align_Right
            }

            DelDivider {
                width: 30
                height: 200
                anchors.horizontalCenter: parent.horizontalCenter
                title: qsTr("垂\n直\n分\n割\n线\n居\n中")
                titleAlign: DelDivider.Align_Center
                orientation: Qt.Vertical
            }
        }
    }
}
