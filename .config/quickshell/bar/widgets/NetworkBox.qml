pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services

BarBox {
    id: root

    property string hostname: ""
    property string interfaceName: ""

    property real downloadSpeed: 0
    property real uploadSpeed: 0

    property real prevRx: 0
    property real prevTx: 0
    property bool initialized: false

    implicitWidth: networkBox.implicitWidth + 16
    implicitHeight: networkBox.implicitHeight

    RowLayout {
        id: networkBox
        anchors.centerIn: parent

        IconImage {
            implicitSize: 14
            source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/arrow-down-to-line`)
        }

        Text {
            text: `${root.downloadSpeed.toFixed(2)} MiB/s`
            color: Colors.foreground
        }

        IconImage {
            implicitSize: 14
            source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/arrow-up-from-line`)
        }

        Text {
            text: `${root.uploadSpeed.toFixed(2)} MiB/s`
            color: Colors.foreground
        }
    }

    Process {
        id: networkProcess

        command: ["awk", "$1 ~ /^" + root.interfaceName + ":/ {print $2, $10}", "/proc/net/dev",]

        stdout: StdioCollector {
            onStreamFinished: {
                const values = text.trim().split(/\s+/);

                if (values.length < 2)
                    return;

                const rx = Number(values[0]);
                const tx = Number(values[1]);

                if (root.initialized) {
                    root.downloadSpeed = Math.max(0, (rx - root.prevRx) / 1024 / 1024);
                    root.uploadSpeed = Math.max(0, (tx - root.prevTx) / 1024 / 1024);
                }

                root.prevRx = rx;
                root.prevTx = tx;
                root.initialized = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networkProcess.running = true
    }

    Process {
        id: hostnameProcess

        command: ["hostname"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.hostname = text.trim();

                if (root.hostname === Quickshell.env("HOSTNAME_DESKTOP")) {
                    root.interfaceName = "enp37s0";
                } else if (root.hostname === Quickshell.env("HOSTNAME_LAPTOP")) {
                    root.interfaceName = "wlp170s0";
                }
            }
        }
    }

    Component.onCompleted: {
        hostnameProcess.running = true;
    }
}
