pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import qs.services

BarBox {
    id: root

    required property var panelWindow

    readonly property int historyWidth: 360
    readonly property int historyMargin: 12
    readonly property int historyMinHeight: 120
    readonly property int collapsedBodyLines: 3

    readonly property int historyMaxHeight: Math.max(historyMinHeight, (root.panelWindow.screen?.height ?? 1080) - root.panelWindow.height - 8 - historyMargin)

    readonly property int historyHeight: Math.min(historyMaxHeight, Math.max(historyMinHeight, historyHeader.implicitHeight + historyList.contentHeight + 8 + 2 * historyMargin + 2 * Config.bar.borderWidth))

    NotificationPopup {
        panelWindow: root.panelWindow
    }

    implicitWidth: bell.implicitWidth + 16
    fillColor: Notifications.unreadCount > 0 ? Colors.color7 : Colors.color0

    Item {
        id: bell
        anchors.centerIn: parent

        implicitWidth: bellImage.implicitWidth
        implicitHeight: bellImage.implicitHeight

        IconImage {
            id: bellImage
            implicitSize: 16
            source: Notifications.unreadCount > 0 ? Qt.resolvedUrl(`${Quickshell.shellDir}/icons/bell-dark`) : Qt.resolvedUrl(`${Quickshell.shellDir}/icons/bell-light`)
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: historyPopup.toggle()
    }

    Popup {
        id: historyPopup
        anchorWindow: root.panelWindow
        onPopupOpenChanged: if (popupOpen)
            Notifications.markRead()

        anchor.rect.x: root.panelWindow.width - width - 12
        anchor.rect.y: root.panelWindow.height + 8
        implicitWidth: root.historyWidth
        implicitHeight: root.historyHeight

        Rectangle {
            anchors.fill: parent
            border.width: Config.bar.borderWidth
            border.color: Colors.color1
            color: Colors.background

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: root.historyMargin
                spacing: 8

                RowLayout {
                    id: historyHeader

                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        color: Colors.foreground
                        font.pixelSize: Config.font.size
                        font.family: Config.font.family
                        font.bold: true
                        text: "Notifications"
                    }

                    Text {
                        color: Colors.color1
                        font.pixelSize: Config.font.size
                        font.family: Config.font.family
                        text: "Clear"

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Notifications.clear()
                        }
                    }
                }

                ListView {
                    id: historyList

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 6
                    model: Notifications.notifications

                    // no bounce.
                    boundsBehavior: Flickable.StopAtBounds
                    boundsMovement: Flickable.StopAtBounds

                    // more responsive scrolling
                    flickDeceleration: 10000
                    maximumFlickVelocity: 3000

                    WheelHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        onWheel: function (event) {
                            const step = 100;
                            const maxY = Math.max(0, historyList.contentHeight - historyList.height);
                            historyList.contentY = Math.max(0, Math.min(maxY, historyList.contentY - event.angleDelta.y / 120 * step));
                        }
                    }

                    Timer {
                        id: scrollBarHideTimer

                        interval: 800
                        onTriggered: historyScrollBar.recentlyScrolled = false
                    }

                    onContentYChanged: {
                        historyScrollBar.recentlyScrolled = true;
                        scrollBarHideTimer.restart();
                    }

                    QQC.ScrollBar.vertical: QQC.ScrollBar {
                        id: historyScrollBar

                        property bool recentlyScrolled: false

                        policy: QQC.ScrollBar.AlwaysOn
                        interactive: true
                        implicitWidth: 6
                        padding: 1

                        background: null

                        contentItem: Rectangle {
                            implicitWidth: 4
                            implicitHeight: 24
                            color: historyScrollBar.pressed ? Colors.foreground : Colors.color1
                            opacity: historyScrollBar.size < 1 && (historyScrollBar.recentlyScrolled || historyScrollBar.hovered || historyScrollBar.pressed) ? 1 : 0

                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 150
                                }
                            }
                        }
                    }

                    delegate: Rectangle {
                        id: historyEntry

                        required property var modelData

                        width: ListView.view.width
                        height: content.implicitHeight + 20
                        color: Colors.color0

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: Notifications.dismiss(historyEntry.modelData)
                        }

                        NotificationContent {
                            id: content

                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.margins: 10

                            appName: historyEntry.modelData.appName
                            summary: historyEntry.modelData.summary
                            body: historyEntry.modelData.body
                            image: Notifications.notificationImage(historyEntry.modelData)
                            notification: historyEntry.modelData

                            collapsedBodyLines: root.collapsedBodyLines
                            actionColor: Colors.background
                            actionHeight: 24
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        visible: Notifications.notificationCount === 0
                        color: Colors.foreground
                        font.pixelSize: Config.font.size
                        font.family: Config.font.family
                        text: "No notifications"
                    }
                }
            }
        }
    }
}
