import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services

BarBox {
    id: root

    property bool showDetails: false
    property string memoryUsage: "..."

    implicitWidth: memoryBox.implicitWidth + 16
    implicitHeight: memoryBox.implicitHeight

    Item {
        id: memoryBox
        anchors.centerIn: parent

        implicitWidth: memoryText.implicitWidth
        implicitHeight: memoryText.implicitHeight

        RowLayout {
            id: memoryText

            IconImage {
                implicitSize: 16
                source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/memory`)
            }

            Text {
                text: root.memoryUsage
                color: Colors.foreground
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.showDetails = !root.showDetails;
                memory.running = true;
            }
        }
    }

    Process {
        id: memory

        command: root.showDetails ? ["sh", "-c", "free | awk '/^Mem:/ {v=$3 / 1024 / 1024; r=int(v*10+0.5)/10; printf (r == int(r) ? \"%d GiB\" : \"%.1f GiB\"), r}'"] : ["sh", "-c", "free | awk '/^Mem:/ {printf \"%d%%\", (($3 / $2) * 100) + 0.5}'"]

        stdout: StdioCollector {
            onStreamFinished: root.memoryUsage = text.trim()
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: memory.running = true
    }
}
