pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.services

Popup {
    id: root

    required property string deviceType

    readonly property bool isSink: deviceType === "sink"

    implicitWidth: 220
    implicitHeight: list.implicitHeight + 8

    function selectDevice(node): void {
        if (root.isSink)
            Audio.setDefaultSink(node);
        else
            Audio.setDefaultSource(node);

        root.close();
    }

    Rectangle {
        anchors.fill: parent

        color: Colors.background
        border.color: Colors.color1
        border.width: 2

        Column {
            id: list

            anchors.fill: parent
            anchors.margins: 4
            spacing: 2

            Repeater {
                model: Pipewire.nodes.values.filter(n => {
                    const isDevice = root.isSink ? n.isSink : !n.isSink;

                    return isDevice && n.audio !== null && !n.isStream;
                })

                Item {
                    id: entry

                    required property var modelData

                    readonly property bool selected: root.isSink ? modelData === Audio.sink : modelData === Audio.source

                    width: list.width
                    height: 26

                    Rectangle {
                        anchors.fill: parent

                        color: mouse.containsMouse ? Colors.color1 : "transparent"
                    }

                    Rectangle {
                        width: 3
                        height: 16

                        anchors.left: parent.left
                        anchors.leftMargin: 2
                        anchors.verticalCenter: parent.verticalCenter

                        color: entry.selected ? Colors.color2 : "transparent"
                    }

                    Text {
                        anchors.left: parent.left
                        anchors.leftMargin: 6
                        anchors.right: parent.right
                        anchors.rightMargin: 6
                        anchors.verticalCenter: parent.verticalCenter

                        color: mouse.containsMouse ? Colors.background : Colors.foreground

                        text: entry.modelData.description || entry.modelData.name

                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: mouse

                        anchors.fill: parent

                        hoverEnabled: true

                        onClicked: {
                            root.selectDevice(entry.modelData);
                        }
                    }
                }
            }
        }
    }
}
