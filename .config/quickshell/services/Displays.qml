pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property bool ignoreHeadless: false

    property string pendingName: ""
    property string pendingDescription: ""
    readonly property bool hasPending: pendingName !== ""

    readonly property string mirrorSource: {
        const focused = Hypr.focusedMonitor;
        if (focused && focused.name !== root.pendingName)
            return focused.name;

        for (const m of Hypr.monitors.values) {
            if (m.name !== root.pendingName)
                return m.name;
        }

        return "";
    }

    function dismiss(): void {
        pendingName = "";
        pendingDescription = "";
    }

    function extend(): void {
        if (!hasPending)
            return;

        applyMonitor(pendingName, "");
        dismiss();
    }

    function mirror(): void {
        if (!hasPending || mirrorSource === "")
            return;

        applyMonitor(pendingName, mirrorSource);
        dismiss();
    }

    function applyMonitor(output: string, mirrorOf: string): void {
        const code = `hl.monitor({ output = '${luaString(output)}', mode = 'preferred', position = 'auto', scale = 1, mirror = '${luaString(mirrorOf)}' })`;
        applier.command = ["hyprctl", "eval", code];
        applier.running = true;
    }

    function luaString(s: string): string {
        return s.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }

    function isIgnored(name: string): bool {
        if (ignoreHeadless && name.startsWith("HEADLESS"))
            return true;

        return name.startsWith("Unknown") || name === "FALLBACK";
    }

    Process {
        id: applier
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            // monitoraddedv2>>ID,NAME,DESCRIPTION (the description may contain commas)
            if (event.name === "monitoraddedv2") {
                const parts = event.parse(3);
                const name = parts[1];
                if (!name || root.isIgnored(name))
                    return;

                root.pendingName = name;
                root.pendingDescription = parts[2] ?? "";
            } else if (event.name === "monitorremovedv2") {
                if (event.parse(3)[1] === root.pendingName)
                    root.dismiss();
            }
        }
    }
}
