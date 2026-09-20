pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray as Tray
import Quickshell.Widgets
import qs.services

BarBox {
    id: root

    required property var panelWindow
    property var activeItem: null
    property var activeMenu: null

    implicitWidth: trayRow.implicitWidth + Config.bar.boxMargin * 2

    function openMenu(item, anchorItem) {
        closeMenu();
        activeItem = item;

        const iconPos = anchorItem.mapToItem(null, 0, 0);
        const growRight = iconPos.x < (panelWindow.width / 2);

        activeMenu = menuComponent.createObject(root, {
            menuHandle: item.menu,
            anchorItem: anchorItem,
            placement: "below",
            side: growRight ? "right" : "left"
        });
    }

    function closeMenu() {
        if (activeMenu) {
            activeMenu.destroy();
            activeMenu = null;
        }
        activeItem = null;
    }

    Component {
        id: menuComponent
        TraySubmenu {
            rootClose: root.closeMenu
        }
    }

    Row {
        id: trayRow
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: Tray.SystemTray.items

            Item {
                id: trayItem
                required property var modelData

                width: 24
                height: Config.bar.boxHeight

                IconImage {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    mipmap: true
                    source: {
                        const icon = trayItem.modelData.icon;
                        if (typeof icon !== "string" || icon === "")
                            return "";
                        return icon.startsWith("/") || icon.startsWith("file:") || icon.startsWith("image:") || icon.startsWith("qrc:") ? icon : Quickshell.iconPath(icon, true);
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            trayItem.modelData.activate();
                        } else if (mouse.button === Qt.MiddleButton) {
                            trayItem.modelData.secondaryActivate();
                        } else if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                            root.openMenu(trayItem.modelData, trayItem);
                        }
                    }
                }
            }
        }
    }
}
