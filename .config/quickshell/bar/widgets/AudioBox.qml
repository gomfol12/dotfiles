pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire
import qs.services

BarBox {
    id: root

    required property var panelWindow

    implicitWidth: row.implicitWidth + 16
    implicitHeight: row.implicitHeight

    color: Colors.background

    RowLayout {
        id: row
        anchors.centerIn: parent

        Item {
            implicitWidth: volumeRow.implicitWidth
            implicitHeight: volumeRow.implicitHeight

            RowLayout {
                id: volumeRow

                anchors.fill: parent

                IconImage {
                    implicitSize: 16
                    source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/${Audio.volumeIconName()}`)
                }

                Text {
                    text: Math.round(Audio.volume * 100) + "%"
                    color: Colors.foreground
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        const pos = mapToItem(null, mouse.x, mouse.y);
                        sinkPicker.toggleAt(pos.x, pos.y + 15);
                    } else if (mouse.button === Qt.RightButton) {
                        Audio.toggleMute();
                    }
                }
                onWheel: wheel => {
                    const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                    Audio.setVolume(Audio.volume + delta);
                }
            }
        }

        IconImage {
            implicitSize: 14
            source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/${Audio.micIconName()}`)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        const pos = mapToItem(null, mouse.x, mouse.y);
                        sourcePicker.toggleAt(pos.x, pos.y + 15);
                    } else if (mouse.button === Qt.RightButton) {
                        Audio.toggleMicMute();
                    }
                }
            }
        }
    }

    DevicePicker {
        id: sinkPicker

        anchorWindow: root.panelWindow
        deviceType: "sink"

        implicitWidth: 220
    }

    DevicePicker {
        id: sourcePicker

        anchorWindow: root.panelWindow
        deviceType: "source"

        implicitWidth: 220
    }
}
