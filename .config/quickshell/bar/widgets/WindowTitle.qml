pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.bar.widgets
import qs.services

BarBox {
    id: root

    required property var panelWindow
    readonly property var client: Hypr.focusedClientPerMonitor(panelWindow.screen)
    readonly property var monitor: Hypr.monitorFor(panelWindow.screen)
    readonly property bool monitorFocused: !!(monitor && monitor.focused)

    readonly property int contentMargin: 2
    readonly property int tabSpacing: 3
    readonly property int minTabWidth: 90

    TextMetrics {
        id: badgeMetrics

        font.pixelSize: Config.font.size
        font.family: Config.font.family

        text: "+" + root.windows.length
    }

    readonly property int badgeWidth: Math.ceil(badgeMetrics.width)

    property var order: []

    function trackOrder() {
        const current = Hypr.toplevels.values.map(t => t.address);
        const present = new Set(current);
        const known = new Set(order);
        const kept = order.filter(a => present.has(a));      // forget closed windows
        const fresh = current.filter(a => !known.has(a));    // new windows go to the end
        if (fresh.length > 0 || kept.length !== order.length)
            order = kept.concat(fresh);
    }

    Component.onCompleted: trackOrder()

    Connections {
        target: Hypr.toplevels
        function onValuesChanged() {
            root.trackOrder();
        }
    }

    readonly property var windows: {
        const id = root.monitor?.activeWorkspace?.id;
        const byAddress = new Map(Hypr.toplevels.values.map(t => [t.address, t]));
        return root.order.map(a => byAddress.get(a)).filter(t => t && t.workspace?.id === id);
    }

    function isFocused(t): bool {
        return t.address === root.client?.address || (root.monitorFocused && t.activated);
    }

    // how many tabs fit and reserve space for the "+N" badge
    readonly property int fitAll: Math.floor((width - contentMargin * 2 + tabSpacing) / (minTabWidth + tabSpacing))
    readonly property int maxTabs: windows.length <= fitAll ? windows.length : Math.max(1, Math.floor((width - contentMargin * 2 - badgeWidth + tabSpacing) / (minTabWidth + tabSpacing)))

    readonly property var shownWindows: {
        const focusedIdx = Math.max(0, windows.findIndex(t => isFocused(t)));
        // start at 0; only scroll when the focused window is beyond the last visible slot
        const start = Math.max(0, focusedIdx - maxTabs + 1);
        return windows.slice(start, start + maxTabs);
    }

    readonly property int hiddenCount: windows.length - shownWindows.length

    fillColor: "transparent"
    implicitHeight: Config.bar.height
    Layout.fillWidth: true

    RowLayout {
        id: row

        anchors.fill: parent
        anchors.leftMargin: root.contentMargin
        anchors.rightMargin: root.contentMargin

        spacing: root.tabSpacing

        Repeater {
            model: root.shownWindows

            Rectangle {
                id: tab

                required property var modelData
                readonly property bool focused: root.isFocused(modelData)

                Layout.fillWidth: true
                Layout.fillHeight: true

                color: focused ? (root.monitorFocused ? Colors.color1 : Colors.color0) : "transparent"
                border.width: focused ? 0 : 1
                border.color: Colors.color0

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: root.contentMargin
                    anchors.rightMargin: root.contentMargin
                    verticalAlignment: Text.AlignVCenter

                    font.pixelSize: Config.font.size
                    font.family: Config.font.family
                    color: tab.focused && root.monitorFocused ? Colors.background : Colors.foreground
                    text: typeof tab.modelData.title === "string" ? tab.modelData.title : ""

                    elide: Text.ElideRight
                    maximumLineCount: 1
                    wrapMode: Text.NoWrap
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hypr.dispatch('hl.dsp.focus({window="address:0x' + tab.modelData.address + '"})');
                    }
                }
            }
        }

        Text {
            id: badge

            visible: root.hiddenCount > 0

            verticalAlignment: Text.AlignVCenter

            font.pixelSize: Config.font.size
            font.family: Config.font.family
            color: Colors.foreground

            text: "+" + root.hiddenCount
        }
    }
}
