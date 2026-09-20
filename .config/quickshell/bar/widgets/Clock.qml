pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.bar.widgets
import qs.services

BarBox {
    id: root

    required property var panelWindow

    property bool popupOpen: false

    readonly property int popupWidth: 240
    readonly property int popupHeight: 110

    function openPopup(): void {
        popupOpen = true;
    }

    function closePopup(): void {
        popupOpen = false;
    }

    function togglePopup(): void {
        popupOpen ? closePopup() : openPopup();
    }

    fillColor: Colors.color0
    implicitWidth: clockLabel.implicitWidth + 20
    implicitHeight: clockLabel.implicitHeight

    Text {
        id: clockLabel
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10

        font.pixelSize: Config.font.size
        font.family: Config.font.family
        color: Colors.foreground
        verticalAlignment: Text.AlignVCenter

        text: Time.time
    }

    MouseArea {
        id: clickArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.togglePopup()
    }

    HyprlandFocusGrab {
        id: popupFocusGrab
        windows: [clockPopup]
        active: root.popupOpen
        onCleared: root.closePopup()
    }

    PopupWindow {
        id: clockPopup
        anchor.window: root.panelWindow
        anchor.rect.x: root.panelWindow.width - width
        anchor.rect.y: root.panelWindow.height
        implicitWidth: root.popupWidth
        implicitHeight: root.popupHeight
        visible: root.popupOpen
        onClosed: root.closePopup()

        Rectangle {
            anchors.fill: parent
            border.width: 2
            border.color: Colors.color1
            color: Colors.background

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                    color: Colors.foreground
                    text: "yo"
                }
            }
        }
    }
}
