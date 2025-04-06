import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelCheckBox"
import "qrc:/../DelDivider"
import "qrc:/../DelPagination"
import "qrc:/../DelScrollBar"

Window {
    width: 1000
    height: 700
    visible: true
    title: qsTr("DelegateUI-DelTableView")

    Component {
        id: textDelegate

        Text {
            id: displayText
            leftPadding: 8
            rightPadding: 8
            font {
                family: "微软雅黑"
                pixelSize: 14
            }
            text: cellData
            color: "#000"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            TextMetrics {
                id: displayWidth
                font: displayText.font
                text: displayText.text
            }

            TextMetrics {
                id: startWidth
                font: displayText.font
                text: {
                    let index = displayText.text.indexOf(filterInput);
                    if (index !== -1)
                        return displayText.text.substring(0, index);
                    else
                        return '';
                }
            }

            TextMetrics {
                id: filterWidth
                font: displayText.font
                text: filterInput
            }

            Rectangle {
                color: "red"
                opacity: 0.1
                x: startWidth.advanceWidth + (displayText.width - displayWidth.advanceWidth) * 0.5
                width: filterWidth.advanceWidth
                height: parent.height
            }
        }
    }

    Component {
        id: tagsDelegate

        Item {
            Row {
                id: row
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Repeater {
                    model: cellData
                    delegate: Item {
                        width: tagText.width + 12
                        height: tagText.height + 6

                        required property int index
                        required property string modelData

                        Rectangle {
                            anchors.fill: parent
                            color: [ "red", "green", "orange", "magenta", "cyan"][index]
                            radius: 2
                            opacity: 0.2
                        }

                        Text {
                            id: tagText
                            anchors.centerIn: parent
                            text: modelData
                            font {
                                family: "微软雅黑"
                                pixelSize: 14
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: actionDelegate

        Item {
            Row {
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                DelButton {
                    type: DelButton.Type_Link
                    text: qsTr(`Invite`)
                }

                DelButton {
                    type: DelButton.Type_Link
                    text: qsTr(`Delete`)
                }
            }
        }
    }

    Flickable {
        clip: true
        width: parent.width - 20
        height: parent.height - 40
        anchors.centerIn: parent
        contentHeight: contentColunm.implicitHeight
        ScrollBar.vertical: DelScrollBar { }

        Column {
            id: contentColunm
            width: parent.width - 20
            spacing: 20

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("基本用法")
            }

            DelTableView {
                width: parent.width
                height: 200
                columns: [
                    {
                        title: 'Name',
                        dataIndex: 'name',
                        key: 'name',
                        delegate: textDelegate,
                        width: 200
                    },
                    {
                        title: 'Age',
                        dataIndex: 'age',
                        key: 'age',
                        delegate: textDelegate,
                        width: 100
                    },
                    {
                        title: 'Address',
                        dataIndex: 'address',
                        key: 'address',
                        delegate: textDelegate,
                        width: 300
                    },
                    {
                        title: 'Tags',
                        key: 'tags',
                        dataIndex: 'tags',
                        delegate: tagsDelegate,
                        width: 200
                    },
                    {
                        title: 'Action',
                        key: 'action',
                        dataIndex: 'action',
                        delegate: actionDelegate,
                        width: 300
                    }
                ]
                initModel: [
                    {
                        key: '1',
                        name: 'John Brown',
                        age: 32,
                        address: 'New York No. 1 Lake Park',
                        tags: ['nice', 'developer'],
                    },
                    {
                        key: '2',
                        name: 'Jim Green',
                        age: 42,
                        address: 'London No. 1 Lake Park',
                        tags: ['loser'],
                    },
                    {
                        key: '3',
                        name: 'Joe Black',
                        age: 32,
                        address: 'Sydney No. 1 Lake Park',
                        tags: ['cool', 'teacher'],
                    }
                ]
            }

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("自定义选择项")
            }

            Column {
                width: parent.width
                spacing: 10

                Row {
                    spacing: 10

                    DelIconButton {
                        text: qsTr("Reload")
                        type: DelButton.Type_Primary
                        enabled: tableView.checkedKeys.length > 0
                        onClicked: {
                            loading = true;
                            reloadTimer.restart();
                        }

                        Timer {
                            id: reloadTimer
                            interval: 2000
                            onTriggered: {
                                parent.loading = false;
                                tableView.clearAllCheckedKeys();
                            }
                        }
                    }

                    DelCheckBox {
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("Switch alternatingRow")
                        onClicked: tableView.alternatingRow = checked;
                    }
                }

                DelTableView {
                    id: tableView
                    width: parent.width
                    height: 400
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            delegate: textDelegate,
                            width: 200,
                            minimumWidth: 100,
                            maximumWidth: 400,
                            align: 'center',
                            selectionType: 'checkbox',
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            delegate: textDelegate,
                            width: 100,
                            editable: true,
                        },
                        {
                            title: 'Address',
                            dataIndex: 'address',
                            delegate: textDelegate,
                            width: 300
                        },
                        {
                            title: 'Tags',
                            dataIndex: 'tags',
                            delegate: tagsDelegate,
                            width: 350,
                        },
                        {
                            title: 'Action',
                            dataIndex: 'action',
                            delegate: actionDelegate,
                            width: 200
                        }
                    ]
                }

                DelPagination {
                    anchors.horizontalCenter: parent.horizontalCenter
                    total: 1000
                    pageSize: 100
                    showQuickJumper: true
                    onCurrentPageIndexChanged: {
                        /*! 生成一些数据 */
                        tableView.initModel = Array.from({ length: pageSize }).map(
                                    (_, i) => {
                                        return {
                                            key: String(i + currentPageIndex * pageSize),
                                            name: `Edward King ${i + currentPageIndex * pageSize}`,
                                            age: i % 30 + 30,
                                            address: `London, Park Lane no. ${i + currentPageIndex * pageSize}`,
                                            tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                        }
                                    });
                    }
                }
            }

            DelDivider {
                width: parent.width
                height: 20
                title: qsTr("排序和过滤")
            }

            Column {
                width: parent.width
                spacing: 10

                DelTableView {
                    id: sortAndFilterTable
                    width: parent.width
                    height: 400
                    columns: [
                        {
                            title: 'Name',
                            dataIndex: 'name',
                            delegate: textDelegate,
                            width: 200,
                            minimumWidth: 100,
                            maximumWidth: 400,
                            align: 'center',
                            selectionType: 'checkbox',
                        },
                        {
                            title: 'Age',
                            dataIndex: 'age',
                            delegate: textDelegate,
                            width: 150,
                            sorter: (a, b) => a.age - b.age,
                            sortDirections: ['descend', 'false'],
                            onFilter: (value, record) => String(record.age).includes(value)
                        },
                        {
                            title: 'Address',
                            dataIndex: 'address',
                            delegate: textDelegate,
                            width: 300,
                            sorter: (a, b) => a.address.length - b.address.length,
                            sortDirections: ['ascend', 'descend', 'false'],
                            onFilter: (value, record) => record.address.includes(value)
                        },
                        {
                            title: 'Tags',
                            dataIndex: 'tags',
                            delegate: tagsDelegate,
                            width: 350,
                        },
                    ]
                }

                DelPagination {
                    anchors.horizontalCenter: parent.horizontalCenter
                    total: 1000
                    pageSize: 100
                    showQuickJumper: true
                    onCurrentPageIndexChanged: {
                        /*! 生成一些数据 */
                        sortAndFilterTable.initModel = Array.from({ length: pageSize }).map(
                                    (_, i) => {
                                        return {
                                            key: String(i + currentPageIndex * pageSize),
                                            name: `Edward King ${i + currentPageIndex * pageSize}`,
                                            age: i % 30 + 30,
                                            address: `London, Park Lane no. ${i + currentPageIndex * pageSize}`,
                                            tags: ['nice', 'cool', 'loser', 'teacher', 'developer'].splice(0, i % 5 + 1),
                                        }
                                    });
                    }
                }
            }
        }
    }
}
