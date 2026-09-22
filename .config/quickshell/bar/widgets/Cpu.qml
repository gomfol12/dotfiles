pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services

BarBox {
    id: root

    property bool showDetails: false
    property string cpuUsage: "..."
    property string cpuTemp: "..."

    property real prevUser: 0
    property real prevNice: 0
    property real prevSystem: 0
    property real prevIdle: 0
    property real prevIowait: 0
    property real prevIrq: 0
    property real prevSoftirq: 0
    property real prevSteal: 0
    property bool hasPreviousSample: false

    implicitWidth: cpuBox.implicitWidth + 16
    implicitHeight: cpuBox.implicitHeight

    Item {
        id: cpuBox
        anchors.centerIn: parent

        implicitWidth: cpuText.implicitWidth
        implicitHeight: cpuText.implicitHeight

        RowLayout {
            id: cpuText

            IconImage {
                implicitSize: 16
                source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/cpu`)
            }

            Text {
                text: root.cpuUsage
                color: Colors.foreground
            }

            Text {
                text: root.cpuTemp
                color: Colors.foreground
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: root.showDetails = !root.showDetails
        }
    }

    Process {
        id: cpuT

        command: ["sh", "-c", "sensors | awk '/^Tdie:/ {printf \"%d\", $2}'"]

        stdout: StdioCollector {
            onStreamFinished: {
                const temp = text.trim();
                if (temp.length > 0) {
                    root.cpuTemp = temp + "°C";
                }
            }
        }
    }

    Process {
        id: cpuU

        command: ["sh", "-c", "grep '^cpu ' /proc/stat"]

        stdout: StdioCollector {
            onStreamFinished: {
                // field names for first line of /proc/stat (https://www.kernel.org/doc/Documentation/filesystems/proc.txt)
                //      user    nice   system  idle      iowait irq   softirq  steal  guest  guest_nice
                // cpu  74608   2520   24433   1117073   6176   4054  0        0      0      0

                const p = text.trim().split(/\s+/);

                if (p.length < 9)
                    return;

                const user = Number(p[1]);
                const nice = Number(p[2]);
                const system = Number(p[3]);
                const idle = Number(p[4]);
                const iowait = Number(p[5]);
                const irq = Number(p[6]);
                const softirq = Number(p[7]);
                const steal = Number(p[8]);

                // Algorithm to calculate CPU usage percentage
                // PrevIdle = prevIdle + prevIowait
                // Idle = idle + iowait

                // PrevNonIdle = prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal
                // NonIdle = user + nice + system + irq + softirq + steal

                // PrevTotal = PrevIdle + PrevNonIdle
                // Total = Idle + NonIdle

                // differentiate: actual value minus the previous one
                // totald = Total - PrevTotal
                // idled = Idle - PrevIdle

                // CPU_Percentage = ((totald - idled) / totald) * 100

                if (root.hasPreviousSample) {
                    const idled = (idle - root.prevIdle) + (iowait - root.prevIowait);

                    const totald = (user - root.prevUser) + (nice - root.prevNice) + (system - root.prevSystem) + idled + (irq - root.prevIrq) + (softirq - root.prevSoftirq) + (steal - root.prevSteal);

                    const usage = ((totald - idled) / totald) * 100;

                    root.cpuUsage = Math.round(usage) + "%";
                }

                root.prevUser = user;
                root.prevNice = nice;
                root.prevSystem = system;
                root.prevIdle = idle;
                root.prevIowait = iowait;
                root.prevIrq = irq;
                root.prevSoftirq = softirq;
                root.prevSteal = steal;
                root.hasPreviousSample = true;
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            cpuU.running = true;
            cpuT.running = true;
        }
    }
}
