import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelScrollBar"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelCollapse")

    Flickable {
        anchors.fill: parent
        anchors.margins: 10
        contentHeight: column.height
        ScrollBar.vertical: DelScrollBar { }

        Column {
            id: column
            width: parent.width
            spacing: 10 

            Text {
                text: qsTr("基本用法")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelCollapse {
                width: parent.width
                defaultActiveKey: ['1']
                initModel: [
                    {
                        key: '1',
                        title: 'This is panel header 1',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '2',
                        title: 'This is panel header 2',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '3',
                        title: 'This is panel header 3',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    }
                ]
            }

            Text {
                text: qsTr("手风琴模式")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelCollapse {
                width: parent.width
                accordion: true
                initModel: [
                    {
                        key: '1',
                        title: 'This is panel header 1',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '2',
                        title: 'This is panel header 2',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '3',
                        title: 'This is panel header 3',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    }
                ]
            }

            Text {
                text: qsTr("自定义展开图标")
                font {
                    family: "微软雅黑"
                    pixelSize: 14
                }
            }

            DelCollapse {
                width: parent.width
                spacing: 10
                expandIcon: DelIcon.CaretRightOutlined
                initModel: [
                    {
                        key: '1',
                        title: 'This is panel header 1',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '2',
                        title: 'This is panel header 2',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    },
                    {
                        key: '3',
                        title: 'This is panel header 3',
                        content: 'A dog is a type of domesticated animal. Known for its loyalty and faithfulness, it can be found as a welcome guest in many households across the world.'
                    }
                ]
            }
        }
    }
}
