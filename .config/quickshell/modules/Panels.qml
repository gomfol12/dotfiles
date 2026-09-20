pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.bar
import qs.services

Scope {
    id: root

    Variants {
        id: panels

        model: Quickshell.screens

        PanelWindow {
            id: panelWindow
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Config.bar.height

            Bar {
                panelWindow: panelWindow
            }
        }
    }
}
