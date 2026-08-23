pragma ComponentBehavior: Bound

import QtQuick
import qs.services
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    required property var panelWindow

    readonly property var icons: ({
            FLOAT: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/plane.svg`),
            FULL: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/fullscreen.svg`),
            PINNED: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/pin.svg`)
        })

    function focusedClientPerMonitor() {
        const monitor = Hypr.monitorFor(root.panelWindow.screen);

        for (const ws of Hypr.workspaces.values) {
            if (ws.id !== monitor.activeWorkspace.id)
                continue;

            const last = ws.lastIpcObject.lastwindow.replace(/^0x/, "");

            for (const tl of ws.toplevels.values) {
                if (tl.address.replace(/^0x/, "") === last)
                    return tl.lastIpcObject;
            }
        }

        return null;
    }

    readonly property var client: focusedClientPerMonitor()

    readonly property var statelabels: {
        if (!client)
            return [];

        const labels = [];

        if (client.floating) {
            labels.push("FLOAT");
        }
        if (client.fullscreen) {
            labels.push("FULL");
        }
        if (client.pinned) {
            labels.push("PINNED");
        }

        return labels;
    }

    implicitWidth: stateRow.implicitWidth
    implicitHeight: stateRow.implicitHeight

    Row {
        id: stateRow

        Repeater {
            model: root.statelabels

            Rectangle {
                id: stateRect

                required property var modelData

                color: Colors.background
                implicitHeight: 24
                implicitWidth: 24

                IconImage {
                    anchors.centerIn: parent
                    width: 14
                    height: 14

                    source: root.icons[stateRect.modelData] || ""
                }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter

            font.pixelSize: Config.font.size
            font.family: Config.font.family
            color: Colors.foreground
            text: root.client ? root.client.title : ""

            elide: Text.ElideRight
            maximumLineCount: 1
            wrapMode: Text.NoWrap
            verticalAlignment: Text.AlignVCenter
        }
    }
}
