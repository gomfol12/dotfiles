pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services

Rectangle {
    id: root

    default property alias content: contentContainer.data

    property color fillColor: Colors.color0
    property color outlineColor: Colors.color1
    property int outlineWidth: Config.bar.borderWidth

    Layout.preferredHeight: Config.bar.boxHeight
    Layout.topMargin: Config.bar.boxMargin
    Layout.bottomMargin: Config.bar.boxMargin
    color: root.fillColor

    Item {
        id: contentContainer
        anchors.fill: parent
    }

    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.width: root.outlineWidth
        border.color: root.outlineColor
        z: 1
    }
}
