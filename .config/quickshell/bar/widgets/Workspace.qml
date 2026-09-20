pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.services

Rectangle {
    id: root

    required property var workspace
    required property var monitor

    readonly property bool sameMonitor: workspace && workspace.monitor === monitor
    readonly property bool isActive: workspace && workspace.active
    readonly property bool isOccupied: workspace && workspace.toplevels.values.length > 0
    readonly property bool isUrgent: workspace && workspace.urgent
    readonly property string workspaceLabel: workspace ? workspace.id : ""

    visible: sameMonitor
    width: Config.bar.boxHeight
    height: Config.bar.boxHeight
    color: isUrgent ? Colors.foreground : (isActive ? Colors.color1 : Colors.background)
    border.width: 0

    Text {
        anchors.centerIn: parent
        font.pixelSize: Config.font.size
        font.family: Config.font.family
        color: root.isUrgent ? Colors.background : Colors.foreground
        text: root.workspaceLabel
    }

    Rectangle {
        visible: root.isOccupied
        width: 4
        height: 4
        radius: 0
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: Config.bar.boxMargin
        anchors.rightMargin: Config.bar.boxMargin
        color: root.isUrgent ? Colors.background : Colors.foreground
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.workspace) {
                root.workspace.activate();
            }
        }
    }
}
