pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.services

Popup {
    id: root

    readonly property color bgColor: Colors.color0
    readonly property color fgColor: Colors.color7
    readonly property color accentColor: Colors.color2
    readonly property color mutedColor: Qt.alpha(fgColor, 0.6)
    readonly property int pad: 14
    readonly property int gap: 8

    readonly property string screenName: root.anchorWindow?.screen?.name ?? ""
    readonly property bool wanted: Displays.hasPending && screenName !== "" && screenName === Displays.workingMonitor

    implicitWidth: 360
    implicitHeight: layout.implicitHeight + pad * 2
    color: "transparent"

    function show(): void {
        if (!anchorWindow)
            return;

        // centered under the bar.
        openAt((anchorWindow.width - implicitWidth) / 2, anchorWindow.height + 8);
    }

    onWantedChanged: {
        if (wanted)
            show();
        else
            close();
    }

    Component.onCompleted: {
        if (wanted)
            show();
    }

    // closed some other way
    onPopupOpenChanged: {
        if (!popupOpen && wanted)
            Displays.dismiss();
    }

    component ActionButton: Rectangle {
        id: btn

        required property string title
        required property string hint

        signal clicked

        Layout.fillWidth: true
        Layout.preferredHeight: 52
        opacity: enabled ? 1 : 0.4
        color: mouse.containsMouse ? Qt.alpha(root.accentColor, 0.25) : "transparent"
        border.width: 2
        border.color: root.accentColor

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            spacing: 0

            Item {
                Layout.fillHeight: true
            }

            Text {
                Layout.fillWidth: true
                text: btn.title
                color: root.fgColor
                font.bold: true
                font.pixelSize: 14
                elide: Text.ElideRight
            }

            Text {
                Layout.fillWidth: true
                text: btn.hint
                color: root.mutedColor
                font.pixelSize: 11
                elide: Text.ElideRight
            }

            Item {
                Layout.fillHeight: true
            }
        }

        MouseArea {
            id: mouse

            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.bgColor
        border.width: 2
        border.color: root.accentColor

        ColumnLayout {
            id: layout

            anchors.fill: parent
            anchors.margins: root.pad
            spacing: root.gap

            Text {
                text: "New display connected"
                color: root.fgColor
                font.bold: true
                font.pixelSize: 16
            }

            Text {
                Layout.fillWidth: true
                text: Displays.pendingDescription !== "" ? `${Displays.pendingName} · ${Displays.pendingDescription}` : Displays.pendingName
                color: root.mutedColor
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            ActionButton {
                title: `${Displays.workingMonitor} → ${Displays.pendingName}`
                hint: "Show this screen on the new display"
                enabled: Displays.canMirror
                onClicked: Displays.mirrorWorkingToNew()
            }

            ActionButton {
                title: `${Displays.pendingName} → ${Displays.workingMonitor}`
                hint: "New display at full resolution, mirrored here"
                enabled: Displays.canMirror
                onClicked: Displays.mirrorNewToWorking()
            }

            Text {
                Layout.alignment: Qt.AlignRight
                text: "Keep extended"
                color: root.mutedColor
                font.pixelSize: 12

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Displays.dismiss()
                }
            }
        }
    }
}
