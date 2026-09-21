pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

PopupWindow {
    id: root

    required property var anchorWindow

    property bool popupOpen: false

    default property alias content: contentItem.data

    function open(): void {
        popupOpen = true;
    }

    function openAt(x: real, y: real): void {
        anchor.rect.x = x;
        anchor.rect.y = y;
        popupOpen = true;
    }

    function close(): void {
        popupOpen = false;
    }

    function toggle(): void {
        popupOpen ? close() : open();
    }

    function toggleAt(x: real, y: real): void {
        if (popupOpen) {
            close();
        } else {
            openAt(x, y);
        }
    }

    anchor.window: root.anchorWindow
    visible: root.popupOpen

    onClosed: close()

    HyprlandFocusGrab {
        id: focusGrab

        windows: [root]
        active: root.popupOpen

        onCleared: root.close()
    }

    Item {
        id: contentItem

        anchors.fill: parent
    }
}
