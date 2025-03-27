import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelDivider"
import "qrc:/../DelInput"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelTag")

    Column {
        anchors.centerIn: parent
        width: parent.width - 40
        height: parent.height - 40
        spacing: 20

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("基本用法")
        }

        Column {
            width: parent.width
            spacing: 10

            Row {
                spacing: 10

                DelTag {
                    text: "Tag 1"
                }

                DelTag {
                    text: "Link"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Qt.openUrlExternally("https://github.com/mengps/DelegateUI");
                        }
                    }
                }

                DelTag {
                    text: "Prevent Default"
                    closeIconSource: DelIcon.CloseOutlined
                }

                DelTag {
                    text: "Tag 2"
                    closeIconSource: DelIcon.CloseCircleOutlined
                }
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("多彩标签")
        }

        Column {
            width: parent.width
            spacing: 10

            Row {
                spacing: 10

                Repeater {
                    model: [ "red", "volcano", "orange", "gold", "yellow", "lime", "green", "cyan", "blue", "geekblue", "purple", "magenta" ]
                    delegate: DelTag {
                        text: modelData
                        presetColor: modelData
                    }
                }
            }

            Row {
                spacing: 10

                Repeater {
                    model: [ "#f50", "#2db7f5", "#87d068", "#108ee9" ]
                    delegate: DelTag {
                        text: modelData
                        presetColor: modelData
                    }
                }
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("动态添加和删除")
        }

        Flow {
            width: parent.width
            spacing: 10

            Repeater {
                id: editRepeater
                model: ListModel {
                    id: editTagsModel
                    ListElement { tag: "Unremovable"; removable: false }
                    ListElement { tag: "Tag 1"; removable: true }
                    ListElement { tag: "Tag 2"; removable: true }
                }
                delegate: DelTag {
                    text: tag
                    closeIconSource: removable ? DelIcon.CloseOutlined : 0
                    onClose: {
                        editTagsModel.remove(index, 1);
                    }
                }
            }

            DelInput {
                width: 100
                font.pixelSize: 12
                iconSource: DelIcon.PlusOutlined
                placeholderText: "New Tag"
                colorBg: "transparent"
                onAccepted: {
                    focus = false;
                    editTagsModel.append({ tag: text, removable: true })
                    clear();
                }
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("带图标的标签")
        }

        Row {
            spacing: 10

            DelTag {
                text: "Twitter"
                iconSource: DelIcon.TwitterOutlined
                presetColor: "#55acee"
            }

            DelTag {
                text: "Youtube"
                iconSource: DelIcon.YoutubeOutlined
                presetColor: "#cd201f"
            }

            DelTag {
                text: "Facebook "
                iconSource: DelIcon.FacebookOutlined
                presetColor: "#3b5999"
            }

            DelTag {
                text: "LinkedIn"
                iconSource: DelIcon.LinkedinOutlined
                presetColor: "#55acee"
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("预设状态的标签")
        }

        Column {
            width: parent.width
            spacing: 10

            Row {
                spacing: 10

                DelTag {
                    text: "success"
                    tagState: DelTag.State_Success
                }

                DelTag {
                    text: "processing"
                    tagState: DelTag.State_Processing
                }

                DelTag {
                    text: "error"
                    tagState: DelTag.State_Error
                }

                DelTag {
                    text: "warning"
                    tagState: DelTag.State_Warning
                }

                DelTag {
                    text: "default"
                    tagState: DelTag.State_Default
                }
            }

            Row {
                spacing: 10

                DelTag {
                    text: "success"
                    tagState: DelTag.State_Success
                    iconSource: DelIcon.CheckCircleOutlined
                }

                DelTag {
                    text: "processing"
                    rotating: true
                    tagState: DelTag.State_Processing
                    iconSource: DelIcon.SyncOutlined
                }

                DelTag {
                    text: "error"
                    tagState: DelTag.State_Error
                    iconSource: DelIcon.CloseCircleOutlined
                }

                DelTag {
                    text: "warning"
                    tagState: DelTag.State_Warning
                    iconSource: DelIcon.ExclamationCircleOutlined
                }

                DelTag {
                    text: "waiting"
                    tagState: DelTag.State_Default
                    iconSource: DelIcon.ClockCircleOutlined
                }

                DelTag {
                    text: "stop"
                    tagState: DelTag.State_Default
                    iconSource: DelIcon.MinusCircleOutlined
                }
            }
        }
    }
}
