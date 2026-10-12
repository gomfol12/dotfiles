pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.bar
import qs.services
import qs.bar.widgets

Scope {
    id: root

    property bool topVisible: true
    property bool bottomVisible: Config.isLaptop()

    IpcHandler {
        target: "bars"

        function toggleTop(): void {
            root.topVisible = !root.topVisible;
        }
        function toggleBottom(): void {
            root.bottomVisible = !root.bottomVisible;
        }
    }

    Variants {
        id: panels

        model: Quickshell.screens

        Scope {
            id: perScreen
            required property var modelData
            readonly property bool isPrimary: modelData.name === Config.system.primaryMonitor

            PanelWindow {
                id: topWindow

                screen: perScreen.modelData
                visible: root.topVisible

                anchors {
                    top: true
                    left: true
                    right: true
                }

                implicitHeight: Config.bar.height

                Bar {
                    panelWindow: topWindow
                    primary: perScreen.isPrimary
                }
            }

            LazyLoader {
                active: perScreen.isPrimary

                PanelWindow {
                    id: bottomWindow

                    screen: perScreen.modelData
                    visible: root.bottomVisible

                    anchors {
                        bottom: true
                        left: true
                        right: true
                    }

                    implicitHeight: Config.bar.height

                    BottomBar {}
                }
            }
        }
    }
}
