import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelDivider"
import "qrc:/../DelRadio"
import "qrc:/../DelScrollBar"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelTimeline")

    Flickable {
        clip: true
        width: parent.width
        height: parent.height - 40
        anchors.centerIn: parent
        contentHeight: column.implicitHeight
        ScrollBar.vertical: DelScrollBar { }

        Column {
            id: column
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height
            width: parent.width - 40
            spacing: 20

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("基本用法")
            }

            DelTimeline {
                width: parent.width
                height: 180
                initModel: [
                    {
                        content: 'Create a services site',
                    },
                    {
                        content: 'Solve initial network problems',
                    },
                    {
                        content: 'Technical testing',
                    },
                    {
                        content: 'Network problems being solved',
                    }
                ]
            }

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("自定义节点颜色和图标")
            }

            DelTimeline {
                width: parent.width
                height: 300
                initModel: [
                    {
                        colorNode: "#52c41a",
                        content: 'Create a services site',
                    },
                    {
                        colorNode: "#f5222d",
                        content: 'Solve initial network problems 1\nSolve initial network problems 2\nSolve initial network problems 3',
                    },
                    {
                        colorNode: "#fa8c16",
                        content: 'Technical testing 1\nTechnical testing 2\nTechnical testing 3',
                    },
                    {
                        content: 'Network problems being solved',
                    },
                    {
                        colorNode: "#00CCFF",
                        icon: DelIcon.SmileOutlined,
                        iconSize: 20,
                        content: 'Custom icon testing',
                    }
                ]
            }

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("节点加载中")
            }

            Column {
                width: parent.width
                spacing: 20

                Row {
                    spacing: 10

                    DelButton {
                        text: "Start loading"
                        type: DelButton.Type_Primary
                        onClicked: {
                            loadingTimeline.set(3, {
                                                    time: new Date(),
                                                    timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                                                    loading: true,
                                                    content: 'New Content',
                                                });
                        }
                    }

                    DelButton {
                        text: "Stop loading"
                        type: DelButton.Type_Primary
                        onClicked: {
                            loadingTimeline.set(3, {
                                                    time: new Date(),
                                                    timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                                                    loading: false,
                                                    content: 'New Content',
                                                });
                        }
                    }
                }

                DelTimeline {
                    id: loadingTimeline
                    width: parent.width
                    height: 180
                    initModel: [
                        {
                            content: 'Create a services site',
                        },
                        {
                            content: 'Solve initial network problems',
                        },
                        {
                            content: 'Technical testing',
                        },
                        {
                            loading: true,
                            content: 'Recording...',
                        }
                    ]
                }

                DelDivider {
                    width: parent.width
                    height: 20
                    title: qsTr("排序和模式")
                }

                Column {
                    width: parent.width
                    spacing: 20

                    DelButton {
                        text: "Toggle Reverse"
                        type: DelButton.Type_Primary
                        onClicked: {
                            reverseTimeline.reverse = !reverseTimeline.reverse;
                        }
                    }

                    ButtonGroup { id: radioGroup }

                    Row {
                        spacing: 10

                        DelRadio {
                            text: qsTr("Left")
                            checked: true
                            ButtonGroup.group: radioGroup
                            property int value: DelTimeline.Mode_Left
                        }

                        DelRadio {
                            text: qsTr("Right")
                            ButtonGroup.group: radioGroup
                            property int value: DelTimeline.Mode_Right
                        }

                        DelRadio {
                            text: qsTr("Alternate")
                            ButtonGroup.group: radioGroup
                            property int value: DelTimeline.Mode_Alternate
                        }
                    }

                    DelTimeline {
                        id: reverseTimeline
                        width: parent.width
                        height: 200
                        mode: radioGroup.checkedButton.value
                        initModel: [
                            {
                                time: new Date(2020, 2, 19),
                                content: 'Create a services site',
                            },
                            {
                                time: new Date(2022, 2, 19),
                                content: 'Solve initial network problems',
                            },
                            {
                                content: 'Technical testing',
                            },
                            {
                                time: new Date(2024, 2, 19),
                                timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                                loading: true,
                                content: 'Recording...',
                            }
                        ]
                    }
                }
            }

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("内容文本格式")
            }

            DelTimeline {
                width: parent.width
                height: 320
                initModel: [
                    {
                        time: new Date(2020, 2, 19),
                        content: '<p style="color:red">HTML Text</p><br><img src="https://avatars.githubusercontent.com/u/33405710?v=4" width="50" height="50">',
                        contentFormat: Text.RichText
                    },
                    {
                        time: new Date(2022, 2, 19),
                        content: 'Solve initial network problems',
                    },
                    {
                        content: 'Technical testing',
                    },
                    {
                        time: new Date(2024, 2, 19),
                        timeFormat: 'yyyy-MM-dd-hh:mm:ss',
                        loading: true,
                        content: '### Markdown Text\n - Line 1\n - Line 2',
                        contentFormat: Text.MarkdownText
                    }
                ]
            }
        }
    }
}
