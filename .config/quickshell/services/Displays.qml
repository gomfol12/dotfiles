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

    readonly property string workingMonitor: {
        const focused = Hypr.focusedMonitor;
        if (focused && focused.name !== root.pendingName)
            return focused.name;

        for (const m of Hypr.monitors.values) {
            if (m.name !== root.pendingName)
                return m.name;
        }

        return "";
    }

    readonly property bool canMirror: hasPending && workingMonitor !== ""

    property var activeMirror: null

    function dismiss(): void {
        pendingName = "";
        pendingDescription = "";
    }

    // laptop -> beamer
    function mirrorWorkingToNew(): void {
        if (!canMirror)
            return;

        startMirror([monitorRule(pendingName, "highres", "auto", 1, workingMonitor)], {
            output: pendingName,
            target: workingMonitor,
            restore: {
                mode: "highres",
                scale: 1,
                position: "auto"
            }
        });
    }

    // beamer -> laptop
    function mirrorNewToWorking(): void {
        if (!canMirror)
            return;

        const working = workingMonitor;

        const saved = snapshot(working, "0x0");

        startMirror([monitorRule(pendingName, "highres", "0x0", 1, ""), monitorRule(working, saved.mode, "auto", saved.scale, pendingName)], {
            output: working,
            target: pendingName,
            resotre: saved
        });
    }

    function startMirror(rules: var, mirror: var): void {
        // undo a previous mirror
        const all = activeMirror ? [restoreRule(activeMirror)] : [];

        applyRules(all.concat(rules));
        activeMirror = mirror;
        dismiss();
    }

    // stop mirroring
    function clearMirror(): void {
        if (!activeMirror)
            return;

        applyRules([restoreRule(activeMirror)]);
        activeMirror = null;
    }

    function restoreRule(mirror: var): string {
        return monitorRule(mirror.output, mirror.restore.mode, mirror.restore.position, mirror.restore.scale, "");
    }

    function liveMonitor(name: string): var {
        for (const m of Hypr.monitors.values) {
            if (m.name === name)
                return m;
        }

        return null;
    }

    function snapshot(name: string, fallbackPosition: string): var {
        const ipc = liveMonitor(name)?.lastIpcObject;
        if (!ipc?.width)
            return {
                mode: "highres",
                scale: 1,
                position: fallbackPosition
            };

        return {
            mode: `${ipc.width}x${ipc.height}@${Number(ipc.refreshRate).toFixed(3)}`,
            scale: Math.round(ipc.scale * 1000) / 1000,
            position: `${ipc.x}x${ipc.y}`
        };
    }

    function monitorRule(output: string, mode: string, position: string, scale: real, mirrorOf: string): string {
        return `hl.monitor({ output = '${luaString(output)}', mode = '${luaString(mode)}', position = '${luaString(position)}', scale = ${scale}, mirror = '${luaString(mirrorOf)}' })`;
    }

    function applyRules(rules: var): void {
        applier.command = ["hyprctl", "eval", rules.join("; ")];
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
                const name = event.parse(3)[1];

                if (name === root.pendingName)
                    root.dismiss();

                // monitor of active mirror is gone, so drop the rule.
                if (root.activeMirror && (name === root.activeMirror.output || name === root.activeMirror.target))
                    root.clearMirror();
            }
        }
    }
}
