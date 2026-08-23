pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import qs.bar

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

            implicitHeight: 30

            Bar {
                panelWindow: panelWindow
            }
        }
    }
}
