import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../DelButton"

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelTour")

    SwipeView {
        id: view
        anchors.fill: parent

        Item {
            id: firstPage

            Column {
                anchors.centerIn: parent
                spacing: 10

                DelButton {
                    text: qsTr("漫游焦点")
                    type: DelButton.Type_Primary
                    onClicked: {
                        tourFocus.open();
                    }

                    DelTourFocus {
                        id: tourFocus
                        currentTarget: tourFocus1
                    }
                }

                Row {
                    spacing: 10

                    DelButton {
                        id: tourFocus1
                        text: qsTr("漫游焦点1")
                        type: DelButton.Type_Outlined
                    }
                }
            }
        }

        Item {
            id: secondPage

            Column {
                anchors.centerIn: parent
                spacing: 10

                DelButton {
                    text: qsTr("漫游步骤")
                    type: DelButton.Type_Primary
                    onClicked: {
                        tourStep.resetStep();
                        tourStep.open();
                    }

                    DelTourStep {
                        id: tourStep
                        stepCardWidth: 300
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

                    DelButton {
                        id: tourStep1
                        text: qsTr("漫游步骤1")
                        type: DelButton.Type_Outlined
                    }

                    DelButton {
                        id: tourStep2
                        text: qsTr("漫游步骤2")
                        type: DelButton.Type_Outlined
                    }

                    DelButton {
                        id: tourStep3
                        text: qsTr("漫游步骤3   ####")
                        type: DelButton.Type_Outlined
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
