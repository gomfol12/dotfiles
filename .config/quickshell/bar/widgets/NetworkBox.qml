pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services

BarBox {
    id: root

    property real downloadSpeed: 0
    property real uploadSpeed: 0

    property real prevRx: 0
    property real prevTx: 0
    property double prevTime: 0
    property bool initialized: false

    property bool showDetails: false

    implicitWidth: networkBox.implicitWidth + 16
    implicitHeight: networkBox.implicitHeight

    Item {
        id: networkBox
        anchors.centerIn: parent

        implicitWidth: networkText.implicitWidth
        implicitHeight: networkText.implicitHeight

        RowLayout {
            id: networkText

            IconImage {
                implicitSize: 14
                source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/arrow-down-to-line`)
                opacity: root.downloadSpeed > 0 ? 1 : 0.5
            }

            Text {
                text: `${root.downloadSpeed.toFixed(2)} MiB/s`
                color: Colors.foreground
                visible: root.showDetails
            }

            IconImage {
                implicitSize: 14
                source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/arrow-up-from-line`)
                opacity: root.uploadSpeed > 0 ? 1 : 0.5
            }

            Text {
                text: `${root.uploadSpeed.toFixed(2)} MiB/s`
                color: Colors.foreground
                visible: root.showDetails
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.showDetails = !root.showDetails;
            }
        }
    }

    Process {
        id: networkProcess

        command: ["cat", `/sys/class/net/${Config.system.networkInterface}/statistics/rx_bytes`, `/sys/class/net/${Config.system.networkInterface}/statistics/tx_bytes`]

        stdout: StdioCollector {
            onStreamFinished: {
                const values = text.trim().split(/\s+/);

                if (values.length < 2)
                    return;

                const rx = Number(values[0]);
                const tx = Number(values[1]);

                if (!Number.isFinite(rx) || !Number.isFinite(tx))
                    return;

                const now = Date.now();

                if (root.initialized) {
                    const elapsed = (now - root.prevTime) / 1000;

                    if (elapsed > 0) {
                        const rxDelta = Math.max(0, rx - root.prevRx);
                        const txDelta = Math.max(0, tx - root.prevTx);

                        root.downloadSpeed = rxDelta / 1024 / 1024 / elapsed;

                        root.uploadSpeed = txDelta / 1024 / 1024 / elapsed;
                    }
                }

                root.prevRx = rx;
                root.prevTx = tx;
                root.prevTime = now;
                root.initialized = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: Config.system.networkInterface !== ""
        repeat: true
        triggeredOnStart: true

        onTriggered: networkProcess.running = true
    }
}
