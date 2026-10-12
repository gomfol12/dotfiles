pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    readonly property var notifications: server.trackedNotifications.values
    readonly property int notificationCount: notifications.length

    property int unreadCount: 0
    property var lastNotification: null

    signal notificationReceived(var notification)

    readonly property var urlSchemes: ["file:", "data:", "http://", "https://", "image://"]

    NotificationServer {
        id: server

        actionsSupported: true
        actionIconsSupported: true
        bodySupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        keepOnReload: true
        persistenceSupported: true

        onNotification: function (notification) {
            notification.tracked = true;
            root.lastNotification = notification;
            root.unreadCount++;
            root.notificationReceived(notification);
        }
    }

    function markRead(): void {
        unreadCount = 0;
    }

    function dismiss(notification): void {
        notification.dismiss();
    }

    function clear(): void {
        for (const notification of notifications.slice())
            dismiss(notification);
        markRead();
    }

    function imageSource(value): string {
        if (!value)
            return "";
        if (value.startsWith("/"))
            return "file://" + value;
        return urlSchemes.some(scheme => value.startsWith(scheme)) ? value : "";
    }

    function localImagePath(value): string {
        if (!value)
            return "";
        if (value.startsWith("file://"))
            return value.slice(7);
        return value.startsWith("/") ? value : "";
    }

    function notificationImage(notification): string {
        return imageSource(notification.hints?.["image-path"]) || imageSource(notification.image) || imageSource(notification.appIcon);
    }
}
