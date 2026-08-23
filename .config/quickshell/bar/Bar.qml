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

        Workspaces {
            panelWindow: root.panelWindow
        }

        WindowTitle {
            panelWindow: root.panelWindow
        }

        Item {
            Layout.fillWidth: true
        }

        Clock {
            panelWindow: root.panelWindow
        }
    }
}
