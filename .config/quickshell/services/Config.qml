pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property var font: QtObject {
        property string family: "Inconsolata Nerd Font"
        property int size: 16
    }
}
