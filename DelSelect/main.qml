import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelSelect")

    Row {
        anchors.centerIn: parent
        spacing: 10

        DelSelect {
            width: 120
            height: 30
            tooltipVisible: true
            model: [
                { value: 'jack', label: 'Jack' },
                { value: 'lucy', label: 'Lucy' },
                { value: 'yiminghe', label: 'Yimingheabcdef' },
                { value: 'disabled', label: 'Disabled', enabled: false },
            ]
        }

        DelSelect {
            width: 120
            height: 30
            enabled: false
            model: [
                { value: 'jack', label: 'Jack' },
                { value: 'lucy', label: 'Lucy' },
                { value: 'yiminghe', label: 'Yiminghe' },
                { value: 'disabled', label: 'Disabled', enabled: false },
            ]
        }

        DelSelect {
            width: 120
            height: 30
            loading: true
            model: [
                { value: 'jack', label: 'Jack' },
                { value: 'lucy', label: 'Lucy' },
                { value: 'yiminghe', label: 'Yiminghe' },
                { value: 'disabled', label: 'Disabled', enabled: false },
            ]
        }
    }
}
