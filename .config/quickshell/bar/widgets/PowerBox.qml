import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services

BarBox {
    id: root

    property bool showDetails: false

    readonly property color stateColor: Power.critical ? "red" : Colors.foreground

    readonly property string detailsText: {
        const battery = Power.battery;
        if (!battery)
            return "";

        const percent = `${Math.round(Power.percentage)}%`;
        const seconds = battery.timeToFull > 0 ? battery.timeToFull : battery.timeToEmpty;

        return seconds > 0 ? `${percent} - ${formatDuration(seconds)}` : percent;
    }

    function formatDuration(seconds: real): string {
        const totalMinutes = Math.round(seconds / 60);
        const hours = Math.floor(totalMinutes / 60);
        const minutes = totalMinutes % 60;

        return hours > 0 ? `${hours}h ${minutes}m` : `${minutes}m`;
    }

    visible: Power.hasBattery

    implicitWidth: content.implicitWidth + 16
    implicitHeight: 16

    color: Colors.background

    RowLayout {
        id: content

        anchors.centerIn: parent
        spacing: 6

        Item {
            Layout.preferredWidth: 20
            Layout.preferredHeight: 12

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                width: 18
                height: 10

                radius: 2
                color: "transparent"
                border.color: root.stateColor
                border.width: 1

                Rectangle {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter

                    width: Math.max(0, parent.width * Math.min(Power.percentage, 100) / 100)
                    height: parent.height - 2

                    radius: 1
                    color: root.stateColor
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.leftMargin: 18
                anchors.verticalCenter: parent.verticalCenter

                width: 2
                height: 5

                radius: 1
                color: root.stateColor
            }
        }

        Text {
            visible: root.showDetails
            text: root.detailsText
            color: root.stateColor
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showDetails = !root.showDetails
    }
}
