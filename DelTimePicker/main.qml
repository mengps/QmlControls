import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    width: 640
    height: 600
    visible: true
    title: qsTr("DelegateUI-DelTimePicker")

    Column {
        anchors.centerIn: parent
        spacing: 20

        Row {
            spacing: 10

            DelTimePicker {
                iconPosition: DelTimePicker.Position_Right
            }

            DelTimePicker {
                iconPosition: DelTimePicker.Position_Left
            }

            DelTimePicker {
                enabled: false
            }
        }

        Row {
            spacing: 10

            DelTimePicker {
                placeholderText: qsTr("HH:MM:SS")
                format: DelTimePicker.Format_HHMMSS
            }

            DelTimePicker {
                placeholderText: qsTr("HH:MM")
                format: DelTimePicker.Format_HHMM
            }

            DelTimePicker {
                placeholderText: qsTr("MM:SS")
                format: DelTimePicker.Format_MMSS
            }
        }
    }
}
