import QtQuick
import Quickshell
import qs.services

BarBox {
    id: root

    visible: Power.hasBattery

    implicitWidth: 30
    implicitHeight: 16

    color: Colors.background

    Item {
        anchors.centerIn: parent
        width: 20
        height: 12

        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            width: 18
            height: 10

            radius: 2
            color: "transparent"
            border.color: Power.critical ? "red" : Colors.foreground
            border.width: 1

            Rectangle {
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                width: Math.max(0, parent.width * Power.percentage / 100)
                height: parent.height - 2

                radius: 1
                color: Power.critical ? "red" : Colors.foreground
            }
        }

        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter

            width: 2
            height: 5

            radius: 1
            color: Power.critical ? "red" : Colors.foreground
        }
    }
}
