import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Tour Test")

    SwipeView {
        id: view
        anchors.fill: parent

        Item {
            id: firstPage

            Column {
                anchors.centerIn: parent
                spacing: 10

                Button {
                    text: qsTr("漫游焦点")
                    onClicked: {
                        tourFocus.open();
                    }

                    TourFocus {
                        id: tourFocus
                        currentTarget: tourFocus1
                    }
                }

                Row {
                    spacing: 10

                    Button {
                        id: tourFocus1
                        text: qsTr("漫游焦点1")
                    }
                }
            }
        }

        Item {
            id: secondPage

            Column {
                anchors.centerIn: parent
                spacing: 10

                Button {
                    text: qsTr("漫游步骤")
                    onClicked: {
                        tourStep.resetStep();
                        tourStep.open();
                    }

                    TourStep {
                        id: tourStep
                        stepCardWidth: 200
                        stepTitleFont.family: "微软雅黑"
                        stepTitleFont.pointSize: 12
                        stepTitleFont.bold: true
                        indicatorFont.bold: true
                        stepModel: [
                            {
                                target: tourStep1,
                                title: qsTr("步骤1"),
                                titleColor: "#3fcc9b",
                                description: qsTr("这是步骤1\n========"),
                            },
                            {
                                target: tourStep2,
                                cardColor: "#f4ffa2",
                                title: qsTr("步骤2"),
                                description: qsTr("这是步骤2\n!!!!!!!!!!"),
                                descriptionColor: "#3116ff"
                            },
                            {
                                target: tourStep3,
                                cardColor: "#ffa2eb",
                                title: qsTr("步骤3"),
                                titleColor: "red",
                                description: qsTr("这是步骤3\n##############")
                            }
                        ]
                    }
                }

                Row {
                    spacing: 10

                    Button {
                        id: tourStep1
                        text: qsTr("漫游步骤1")
                    }

                    Button {
                        id: tourStep2
                        text: qsTr("漫游步骤2")
                    }

                    Button {
                        id: tourStep3
                        text: qsTr("漫游步骤3   ####")
                    }
                }
            }
        }
    }

    PageIndicator {
        id: indicator
        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        count: view.count
        currentIndex: view.currentIndex
    }
}
