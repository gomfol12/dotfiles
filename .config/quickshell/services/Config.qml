pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    readonly property var font: QtObject {
        property string family: "Inconsolata Nerd Font"
        property int size: 16
    }

    readonly property var workspace: QtObject {
        property int cellSize: root.font.size + 14
    }
}
