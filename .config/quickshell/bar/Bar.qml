pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.bar.widgets
import qs.services

Rectangle {
    id: root

    property var panelWindow

    anchors.fill: parent
    color: Colors.background

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Config.bar.spacing
        anchors.rightMargin: Config.bar.spacing
        spacing: Config.bar.spacing

        BarBox {
            id: workspaceGroup

            Layout.preferredWidth: workspaces.implicitWidth

            Workspaces {
                id: workspaces
                anchors.centerIn: parent
                panelWindow: root.panelWindow
            }
        }

        BarBox {
            id: stateGroup

            visible: stateIcons.implicitWidth > 0
            Layout.preferredWidth: stateIcons.implicitWidth + Config.bar.boxMargin * 2

            StateIcons {
                id: stateIcons
                anchors.centerIn: parent
                panelWindow: root.panelWindow
            }
        }

        WindowTitle {
            panelWindow: root.panelWindow
        }

        NetworkBox {}

        Cpu {}

        Memory {}

        PowerBox {}

        AudioBox {
            panelWindow: root.panelWindow
        }

        Tray {
            panelWindow: root.panelWindow
        }

        Clock {
            panelWindow: root.panelWindow
        }
    }
}
