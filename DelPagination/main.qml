import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import "qrc:/../common"
import "qrc:/../DelButton"
import "qrc:/../DelDivider"

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelPagination")

    Column {
        anchors.centerIn: parent
        spacing: 20

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("基本用法")
        }

        DelPagination {
            currentPageIndex: 0
            total: 50
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("更多数量")
        }

        Column {
            spacing: 10

            DelPagination {
                currentPageIndex: 6
                total: 500
                pageSizeModel: [
                    { label: qsTr("10条每页"), value: 10 },
                    { label: qsTr("20条每页"), value: 20 },
                    { label: qsTr("30条每页"), value: 30 },
                    { label: qsTr("40条每页"), value: 40 }
                ]
            }

            DelPagination {
                enabled: false
                currentPageIndex: 6
                total: 500
                pageSizeModel: [
                    { label: qsTr("10条每页"), value: 10 },
                    { label: qsTr("20条每页"), value: 20 },
                    { label: qsTr("30条每页"), value: 30 },
                    { label: qsTr("40条每页"), value: 40 }
                ]
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("跳转功能")
        }

        Column {
            spacing: 10

            DelPagination {
                currentPageIndex: 6
                total: 500
                showQuickJumper: true
                pageSizeModel: [
                    { label: qsTr("10条每页"), value: 10 },
                    { label: qsTr("20条每页"), value: 20 },
                    { label: qsTr("30条每页"), value: 30 },
                    { label: qsTr("40条每页"), value: 40 }
                ]
            }

            DelPagination {
                enabled: false
                currentPageIndex: 6
                total: 500
                showQuickJumper: true
                pageSizeModel: [
                    { label: qsTr("10条每页"), value: 10 },
                    { label: qsTr("20条每页"), value: 20 },
                    { label: qsTr("30条每页"), value: 30 },
                    { label: qsTr("40条每页"), value: 40 }
                ]
            }
        }

        DelDivider {
            width: parent.width
            height: 20
            title: qsTr("自定义上一步和下一步")
        }

        DelPagination {
            id: pagination
            currentPageIndex: 2
            total: 500
            pageSizeModel: [
                { label: qsTr("10条每页"), value: 10 },
                { label: qsTr("20条每页"), value: 20 },
                { label: qsTr("30条每页"), value: 30 },
                { label: qsTr("40条每页"), value: 40 }
            ]
            prevButtonDelegate: DelButton {
                text: "Previous"
                type: DelButton.Type_Link
                onClicked: pagination.gotoPrevPage();
            }
            nextButtonDelegate: DelButton {
                text: "Next"
                type: DelButton.Type_Link
                onClicked: pagination.gotoNextPage();
            }
        }
    }
}
