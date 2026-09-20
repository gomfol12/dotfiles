pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services
import Quickshell
import Quickshell.Widgets

Item {
    id: root

    required property var panelWindow

    readonly property int stateSize: Config.bar.boxHeight
    readonly property var icons: ({
            FLOAT: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/plane.svg`),
            FULL: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/fullscreen.svg`),
            PINNED: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/pin.svg`)
        })
    readonly property var client: Hypr.focusedClientPerMonitor(panelWindow.screen)
    readonly property var stateLabels: {
        if (!client)
            return [];

        const labels = [];
        if (client.floating)
            labels.push("FLOAT");
        if (client.fullscreen)
            labels.push("FULL");
        if (client.pinned)
            labels.push("PINNED");

        return labels;
    }

    implicitWidth: stateLabels.length * stateSize
    implicitHeight: stateSize
    Layout.minimumWidth: implicitWidth
    Layout.preferredWidth: implicitWidth

    Row {
        anchors.fill: parent

        Repeater {
            model: root.stateLabels

            Item {
                id: stateIcon
                required property var modelData
                readonly property var iconSource: root.icons[modelData] || ""

                width: root.stateSize
                height: root.stateSize

                IconImage {
                    anchors.centerIn: parent
                    width: 14
                    height: 14
                    source: stateIcon.iconSource
                    visible: stateIcon.iconSource !== ""
                }
            }
        }
    }
}
