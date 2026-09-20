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

    fillColor: root.monitorFocused ? Colors.color1 : Colors.color0
    implicitWidth: title.implicitWidth
    implicitHeight: title.implicitHeight
    Layout.fillWidth: true

    Text {
        id: title

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter

        font.pixelSize: Config.font.size
        font.family: Config.font.family
        color: root.monitorFocused ? Colors.background : Colors.foreground
        text: root.client && typeof root.client.title === "string" ? root.client.title : ""

        elide: Text.ElideRight
        maximumLineCount: 1
        wrapMode: Text.NoWrap
        verticalAlignment: Text.AlignVCenter
    }
}
