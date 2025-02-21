import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("DelegateUI-DelRadioBlock")

    Column {
        anchors.centerIn: parent
        spacing: 40

        Column {
            spacing: 10

            DelRadioBlock {
                initCheckedIndex: 0
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear' },
                    { label: 'Orange', value: 'Orange' },
                ]
            }

            DelRadioBlock {
                initCheckedIndex: 1
                type: DelRadioBlock.Type_Outlined
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear' },
                    { label: 'Orange', value: 'Orange' },
                ]
            }

            DelRadioBlock {
                initCheckedIndex: 2
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear', enabled: false },
                    { label: 'Orange', value: 'Orange' },
                ]
            }

            DelRadioBlock {
                enabled: false
                initCheckedIndex: 2
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear' },
                    { label: 'Orange', value: 'Orange' },
                ]
            }
        }

        Column {
            spacing: 10

            DelRadioBlock {
                initCheckedIndex: 0
                size: DelRadioBlock.Size_Fixed
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear' },
                    { label: 'Orange', value: 'Orange' },
                ]
            }

            DelRadioBlock {
                initCheckedIndex: 0
                size: DelRadioBlock.Size_Fixed
                type: DelRadioBlock.Type_Outlined
                model: [
                    { label: 'Apple', value: 'Apple' },
                    { label: 'Pear', value: 'Pear' },
                    { label: 'Orange', value: 'Orange' },
                ]
            }
        }
    }
}
