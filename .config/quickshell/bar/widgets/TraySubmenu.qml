pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.services

PopupWindow {
    id: level

    required property var menuHandle
    required property Item anchorItem
    required property var rootClose
    property string placement: "right"   // "right" | "left" | "below"
    property string side: "right"        // decided once at the top, passed down unchanged

    anchor.item: anchorItem
    anchor.edges: placement === "below" ? (Edges.Bottom | Edges.Left) : placement === "right" ? (Edges.Top | Edges.Left) : (Edges.Top | Edges.Right)
    anchor.gravity: placement === "left" ? (Edges.Bottom | Edges.Left) : (Edges.Bottom | Edges.Right)
    anchor.adjustment: PopupAdjustment.Flip | PopupAdjustment.Slide

    property var childEntry: null
    property var childLevel: null

    readonly property int levelWidth: 220

    implicitWidth: levelWidth
    implicitHeight: column.implicitHeight + 8
    visible: true
    grabFocus: true
    color: "transparent"

    onClosed: {
        closeChild();
        level.rootClose();
    }

    function resolveIcon(icon) {
        if (typeof icon !== "string" || icon === "")
            return "";
        if (icon.startsWith("/") || icon.startsWith("file:") || icon.startsWith("image:") || icon.startsWith("qrc:"))
            return icon;
        return Quickshell.iconPath(icon, true);
    }

    function closeChild() {
        if (level.childLevel) {
            level.childLevel.destroy();
            level.childLevel = null;
            level.childEntry = null;
        }
    }

    function openChild(entry, entryItem) {
        if (level.childEntry === entry)
            return;
        level.closeChild();
        level.childEntry = entry;

        const marker = level.side === "right" ? entryItem.rightAnchor : entryItem.leftAnchor;

        const comp = Qt.createComponent(Qt.resolvedUrl("TraySubmenu.qml"));
        if (comp.status === Component.Ready) {
            level.childLevel = comp.createObject(level, {
                menuHandle: entry,
                anchorItem: marker,
                rootClose: level.rootClose,
                side: level.side,
                placement: level.side
            });
        } else {
            console.warn("TraySubmenu: failed to load submenu component:", comp.errorString());
        }
    }

    QsMenuOpener {
        id: opener
        menu: level.menuHandle
    }

    Rectangle {
        anchors.fill: parent
        color: Colors.background
        border.width: Config.bar.borderWidth
        border.color: Colors.color1

        Column {
            id: column
            anchors.fill: parent
            anchors.margins: 4
            spacing: 2

            Repeater {
                model: opener.children

                Item {
                    id: entryItem
                    required property var modelData
                    readonly property string iconSource: level.resolveIcon(modelData.icon)
                    readonly property bool isSeparator: modelData.isSeparator
                    readonly property alias rightAnchor: rightAnchor
                    readonly property alias leftAnchor: leftAnchor

                    width: column.width
                    height: isSeparator ? 1 : 28

                    Item {
                        id: rightAnchor
                        width: 1
                        height: 1
                        anchors.left: parent.right
                        anchors.leftMargin: 2
                        anchors.top: parent.top
                    }

                    Item {
                        id: leftAnchor
                        width: 1
                        height: 1
                        anchors.right: parent.left
                        anchors.rightMargin: 2
                        anchors.top: parent.top
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: entryItem.isSeparator || entryMouse.containsMouse
                        color: Colors.color1
                    }

                    IconImage {
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                        width: 18
                        height: 18
                        visible: !entryItem.isSeparator && entryItem.iconSource !== ""
                        source: entryItem.iconSource
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: entryItem.iconSource !== "" ? 30 : 8
                        anchors.right: submenuArrow.left
                        anchors.rightMargin: 4
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !entryItem.isSeparator
                        color: entryItem.modelData.enabled ? Colors.foreground : Colors.color8
                        text: entryItem.modelData.text
                        elide: Text.ElideRight
                    }

                    Text {
                        id: submenuArrow
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !entryItem.isSeparator && entryItem.modelData.hasChildren
                        text: ">"
                        color: Colors.foreground
                    }

                    MouseArea {
                        id: entryMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: !entryItem.isSeparator && entryItem.modelData.enabled
                        onEntered: {
                            if (entryItem.modelData.hasChildren)
                                level.openChild(entryItem.modelData, entryItem);
                            else
                                level.closeChild();
                        }
                        onClicked: {
                            if (!entryItem.modelData.hasChildren) {
                                entryItem.modelData.triggered();
                                level.rootClose();
                            }
                        }
                    }
                }
            }
        }
    }
}
