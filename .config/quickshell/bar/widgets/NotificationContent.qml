pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.services

ColumnLayout {
    id: root

    property string appName: ""
    property string titleSuffix: ""
    property string summary: ""
    property string body: ""
    property string image: ""
    property var notification: null

    property bool expanded: false
    property int collapsedSummaryLines: 2
    property int collapsedBodyLines: 3
    property int expandedLines: 1000

    property color actionColor: Colors.color0
    property int actionHeight: 24

    property bool imageLoadable: true

    readonly property bool hasImage: imageFile.path !== "" ? imageFile.loaded : imageView.status === Image.Ready
    // readonly property bool imageReady: imageLoadable && hasImage && imageView.status === Image.Ready
    readonly property bool expandable: bodyText.truncated || summaryText.truncated || expanded
    readonly property int actionCount: notification?.actions.length || 0

    property int iconWidth: 96
    property int iconHeight: 64

    signal actionInvoked

    onImageChanged: imageLoadable = true

    spacing: 8

    FileView {
        id: imageFile

        path: Notifications.localImagePath(root.image)
        printErrors: false
        preload: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Item {
            visible: root.imageLoadable && root.image !== ""
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: root.iconWidth
            Layout.preferredHeight: root.iconHeight

            // Rectangle {
            //     anchors.fill: parent
            //     visible: !root.imageReady
            //     color: Colors.color1

            //     Text {
            //         anchors.centerIn: parent
            //         color: Colors.background
            //         font.pixelSize: Config.font.size + 4
            //         font.family: Config.font.family
            //         font.bold: true
            //         text: root.appName !== "" ? root.appName.charAt(0).toUpperCase() : "?"
            //     }
            // }

            Image {
                id: imageView

                anchors.fill: parent

                visible: root.imageLoadable && root.hasImage
                source: root.imageLoadable && (imageFile.path === "" || imageFile.loaded) ? root.image : ""
                sourceSize: Qt.size(root.iconWidth * 2, root.iconHeight * 2)
                mipmap: true
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                onStatusChanged: if (status === Image.Error)
                    root.imageLoadable = false
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            spacing: 2

            RowLayout {
                Layout.fillWidth: true

                Text {
                    Layout.fillWidth: true
                    color: Colors.color1
                    font.pixelSize: Config.font.size
                    font.family: Config.font.family
                    font.bold: true
                    text: root.appName + root.titleSuffix
                    elide: Text.ElideRight
                }

                Image {
                    visible: root.expandable
                    Layout.preferredWidth: Config.font.size
                    Layout.preferredHeight: Config.font.size
                    Layout.alignment: Qt.AlignVCenter

                    source: Qt.resolvedUrl(`${Quickshell.shellDir}/icons/arrow-down.svg`)
                    sourceSize: Qt.size(width * 2, height * 2)
                    fillMode: Image.PreserveAspectFit
                    rotation: root.expanded ? 180 : 0

                    Behavior on rotation {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.OutQuad
                        }
                    }

                    MouseArea {
                        anchors.centerIn: parent
                        width: parent.width + 16
                        height: parent.height + 12
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.expanded = !root.expanded
                    }
                }
            }

            Text {
                id: summaryText

                Layout.fillWidth: true
                visible: root.summary !== ""
                color: Colors.foreground
                font.pixelSize: Config.font.size
                font.family: Config.font.family
                font.bold: true
                text: root.summary
                textFormat: Text.PlainText
                wrapMode: Text.Wrap
                maximumLineCount: root.expanded ? root.expandedLines : root.collapsedSummaryLines
                elide: Text.ElideRight
            }

            Text {
                id: bodyText

                Layout.fillWidth: true
                visible: root.body !== ""
                color: Colors.foreground
                font.pixelSize: Config.font.size
                font.family: Config.font.family
                text: root.body
                textFormat: Text.StyledText
                linkColor: Colors.color1
                wrapMode: Text.Wrap
                maximumLineCount: root.expanded ? root.expandedLines : root.collapsedBodyLines
                elide: Text.ElideRight
                onLinkActivated: function (link) {
                    Qt.openUrlExternally(link);
                }
            }
        }
    }

    Row {
        Layout.fillWidth: true
        visible: root.actionCount > 0
        spacing: 6

        Repeater {
            model: root.notification ? root.notification.actions : []

            delegate: Rectangle {
                id: actionButton

                required property var modelData

                implicitWidth: actionLabel.implicitWidth + (actionIcon.visible ? 28 : 16)
                height: root.actionHeight
                color: root.actionColor

                IconImage {
                    id: actionIcon

                    anchors.left: parent.left
                    anchors.leftMargin: 6
                    anchors.verticalCenter: parent.verticalCenter
                    width: 16
                    height: 16
                    source: root.notification.hasActionIcons && Quickshell.hasThemeIcon(actionButton.modelData.identifier) ? Quickshell.iconPath(actionButton.modelData.identifier, true) : ""
                    visible: source !== ""
                }

                Text {
                    id: actionLabel

                    anchors.left: actionIcon.visible ? actionIcon.right : parent.left
                    anchors.leftMargin: actionIcon.visible ? 6 : 8
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: Colors.foreground
                    font.pixelSize: Config.font.size
                    font.family: Config.font.family
                    text: actionButton.modelData.text
                    elide: Text.ElideRight
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        actionButton.modelData.invoke();
                        root.actionInvoked();
                    }
                }
            }
        }
    }
}
