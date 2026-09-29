pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.bar.widgets
import qs.services

Rectangle {
    anchors.fill: parent
    color: Colors.background

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Config.bar.spacing
        anchors.rightMargin: Config.bar.spacing
        spacing: Config.bar.spacing

        Item {
            Layout.fillWidth: true
        }

        NetworkBox {}

        Cpu {}

        Memory {}
    }
}
