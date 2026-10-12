pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.services

BarBox {
    id: root

    required property var panelWindow

    readonly property int toastWidth: 360
    readonly property int toastPadding: 12
    readonly property int toastLineHeight: Config.font.size + 4
    readonly property int toastSpacing: 8
    readonly property int collapsedSummaryLines: 2
    readonly property int collapsedBodyLines: 3

    readonly property int availableHeight: root.panelWindow.screen.height - root.panelWindow.height - 24

    readonly property int expandedLines: Math.max(6, Math.floor((root.availableHeight - root.toastPadding * 2 - root.toastLineHeight * 4 - root.toastSpacing * 4) / root.toastLineHeight))

    property int layoutRevision: 0

    ListModel {
        id: toastModel
    }

    function sameNotification(first, second): bool {
        return first.appName === (second.appName || "Notification") && first.summary === (second.summary || "") && first.body === (second.body || "") && first.image === Notifications.notificationImage(second) && first.actionSignature === root.actionSignature(second) && first.urgency === String(second.urgency);
    }

    function actionSignature(notification): string {
        return JSON.stringify((notification.actions || []).map(action => [action.identifier, action.text]));
    }

    function notificationFor(id): var {
        for (const notification of Notifications.notifications) {
            if (notification.id === id)
                return notification;
        }
        return null;
    }

    function reportHeight(index, height): void {
        if (index < 0 || index >= toastModel.count)
            return;
        if (toastModel.get(index).measuredHeight === height)
            return;
        toastModel.setProperty(index, "measuredHeight", height);
        root.layoutRevision++;
        Qt.callLater(root.fitToasts);
    }

    function toastY(index): int {
        root.layoutRevision; // dep: re-evaluate when any height changes
        let y = root.panelWindow.height + 8;
        for (let current = 0; current < index && current < toastModel.count; current++)
            y += toastModel.get(current).measuredHeight + root.toastSpacing;
        return y;
    }

    function fitToasts(): void {
        let total = 0;
        for (let index = 0; index < toastModel.count; index++)
            total += toastModel.get(index).measuredHeight + root.toastSpacing;
        total -= root.toastSpacing;

        while (toastModel.count > 1 && total > root.availableHeight) {
            total -= toastModel.get(0).measuredHeight + root.toastSpacing;
            toastModel.remove(0);
        }
    }

    function showToast(notification): void {
        for (let index = 0; index < toastModel.count; index++) {
            const entry = toastModel.get(index);
            if (!sameNotification(entry, notification))
                continue;

            toastModel.setProperty(index, "appName", notification.appName || "Notification");
            toastModel.setProperty(index, "summary", notification.summary || "");
            toastModel.setProperty(index, "body", notification.body || "");
            toastModel.setProperty(index, "image", Notifications.notificationImage(notification));
            toastModel.setProperty(index, "actionSignature", root.actionSignature(notification));
            toastModel.setProperty(index, "urgency", String(notification.urgency));
            toastModel.setProperty(index, "notificationId", notification.id);
            toastModel.setProperty(index, "count", entry.count + 1);
            return;
        }

        toastModel.append({
            appName: notification.appName || "Notification",
            summary: notification.summary || "",
            body: notification.body || "",
            image: Notifications.notificationImage(notification),
            actionSignature: root.actionSignature(notification),
            urgency: String(notification.urgency),
            notificationId: notification.id,
            count: 1,
            measuredHeight: 0
        });
        Qt.callLater(root.fitToasts);
    }

    Connections {
        target: Notifications

        function onNotificationReceived(notification) {
            root.showToast(notification);
        }
    }

    Repeater {
        model: toastModel

        delegate: Item {
            id: toastItem

            required property string appName
            required property string summary
            required property string body
            required property string image
            required property int notificationId
            required property int count
            required property int index

            property alias expanded: card.expanded
            readonly property var notification: root.notificationFor(notificationId)
            readonly property int cardHeight: card.implicitHeight + root.toastPadding * 2

            onCardHeightChanged: root.reportHeight(index, cardHeight)
            onCountChanged: updateTimer()
            onExpandedChanged: updateTimer()
            Component.onCompleted: root.reportHeight(index, cardHeight)

            function updateTimer(): void {
                if (expanded || toastMouse.containsMouse)
                    toastTimer.stop();
                else
                    toastTimer.restart();
            }

            PopupWindow {
                visible: true
                grabFocus: false

                anchor.window: root.panelWindow
                anchor.rect.x: root.panelWindow.width - width - 12
                anchor.rect.y: root.toastY(toastItem.index)
                implicitWidth: root.toastWidth
                implicitHeight: toastItem.cardHeight

                Rectangle {
                    anchors.fill: parent
                    border.width: Config.bar.borderWidth
                    border.color: Colors.color1
                    color: Colors.background

                    MouseArea {
                        id: toastMouse

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onContainsMouseChanged: toastItem.updateTimer()
                        onClicked: toastModel.remove(toastItem.index)
                    }

                    NotificationContent {
                        id: card

                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.margins: root.toastPadding

                        appName: toastItem.appName
                        titleSuffix: toastItem.count > 1 ? " (" + toastItem.count + ")" : ""
                        summary: toastItem.summary
                        body: toastItem.body
                        image: toastItem.image
                        notification: toastItem.notification

                        collapsedSummaryLines: root.collapsedSummaryLines
                        collapsedBodyLines: root.collapsedBodyLines
                        expandedLines: root.expandedLines
                        actionColor: Colors.color0
                        actionHeight: root.toastLineHeight

                        onActionInvoked: toastModel.remove(toastItem.index)
                    }
                }
            }

            Timer {
                id: toastTimer

                interval: toastItem.notification && toastItem.notification.expireTimeout > 0 ? toastItem.notification.expireTimeout : 5000
                running: true
                onTriggered: {
                    if (toastItem.index >= 0 && toastItem.index < toastModel.count)
                        toastModel.remove(toastItem.index);
                }
            }
        }
    }
}
