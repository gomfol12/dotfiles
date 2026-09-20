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

    readonly property var bar: QtObject {
        property int boxHeight: 26
        property int boxMargin: 4
        property int spacing: 8
        property int borderWidth: 2
        readonly property int height: boxHeight + boxMargin * 2
    }
}
