pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.services

Item {
    id: root

    required property var panelWindow

    readonly property var currentMonitor: Hypr.monitorFor(root.panelWindow.screen)

    implicitWidth: workspacesRow.implicitWidth
    implicitHeight: workspacesRow.implicitHeight

    Row {
        id: workspacesRow

        Repeater {
            id: workspaces
            model: Hypr.workspaces

            Workspace {
                required property var modelData

                workspace: modelData
                monitor: root.currentMonitor
            }
        }
    }
}
