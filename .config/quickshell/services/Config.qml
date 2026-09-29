pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property var font: QtObject {
        property string family: "Inconsolata Nerd Font"
        property int size: 16
    }

    readonly property var bar: QtObject {
        property int boxHeight: 26
        property int boxMargin: 4
        property int spacing: 8
        property int borderWidth: 2
        readonly property int height: boxHeight + boxMargin * 2
    }

    property var system: QtObject {
        property string primaryMonitor: Quickshell.env("PRIMARY")
        property string hostname: ""
        property string networkInterface: ""
    }

    function isDesktop(): bool {
        return root.system.hostname === Quickshell.env("HOSTNAME_DESKTOP");
    }

    function isLaptop(): bool {
        return root.system.hostname === Quickshell.env("HOSTNAME_LAPTOP");
    }

    Process {
        id: hostnameProcess

        command: ["hostname"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.system.hostname = text.trim();

                if (root.isDesktop()) {
                    root.system.networkInterface = "enp37s0";
                } else if (root.isLaptop()) {
                    root.system.networkInterface = "wlp170s0";
                }
            }
        }
    }

    Component.onCompleted: {
        hostnameProcess.running = true;
    }
}
