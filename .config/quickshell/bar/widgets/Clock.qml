pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.services

Item {
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

    implicitWidth: clockLabel.implicitWidth
    implicitHeight: clockLabel.implicitHeight

    Text {
        id: clockLabel
        anchors.centerIn: parent

        font.pixelSize: Config.font.size
        font.family: Config.font.family
        color: Colors.foreground

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
