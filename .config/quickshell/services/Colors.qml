pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string cachePath: Quickshell.env("XDG_CACHE_HOME") || Quickshell.env("HOME") + "/.cache"
    readonly property string themingDir: cachePath + "/theming"
    readonly property string colorsFile: themingDir + "/colors.json"

    FileView {
        id: fileView

        path: root.colorsFile

        watchChanges: true
        onFileChanged: reload()

        JsonAdapter {
            id: adapter

            property string wallpaper: ""
            property int alpha: 0

            property JsonObject special: JsonObject {
                property string background: "#000000"
                property string foreground: "#000000"
                property string cursor: "#000000"
            }

            property JsonObject colors: JsonObject {
                property string color0: "#000000"
                property string color1: "#000000"
                property string color2: "#000000"
                property string color3: "#000000"
                property string color4: "#000000"
                property string color5: "#000000"
                property string color6: "#000000"
                property string color7: "#000000"
                property string color8: "#000000"
                property string color9: "#000000"
                property string color10: "#000000"
                property string color11: "#000000"
                property string color12: "#000000"
                property string color13: "#000000"
                property string color14: "#000000"
                property string color15: "#000000"
            }
        }
    }

    readonly property string wallpaper: fileView.adapter.wallpaper
    readonly property int alpha: fileView.adapter.alpha

    readonly property var special: fileView.adapter.special
    readonly property var colors: fileView.adapter.colors

    readonly property string background: special.background
    readonly property string foreground: special.foreground
    readonly property string cursor: special.cursor
    readonly property string color0: colors.color0
    readonly property string color1: colors.color1
    readonly property string color2: colors.color2
    readonly property string color3: colors.color3
    readonly property string color4: colors.color4
    readonly property string color5: colors.color5
    readonly property string color6: colors.color6
    readonly property string color7: colors.color7
    readonly property string color8: colors.color8
    readonly property string color9: colors.color9
    readonly property string color10: colors.color10
    readonly property string color11: colors.color11
    readonly property string color12: colors.color12
    readonly property string color13: colors.color13
    readonly property string color14: colors.color14
    readonly property string color15: colors.color15
}
