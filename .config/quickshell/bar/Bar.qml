pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.bar.widgets
import qs.services

Rectangle {
    anchors.fill: parent
    color: Colors.background

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 5
        anchors.leftMargin: 5

        Item {
            Layout.fillWidth: true
        }

        ClockWidget {}
    }
}
