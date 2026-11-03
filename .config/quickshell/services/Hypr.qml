pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property bool ignoreHeadless: false

    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors

    readonly property HyprlandToplevel activeToplevel: Hyprland.activeToplevel
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor

    property string pendingMonitor: ""
    property string pendingDescription: ""
    readonly property bool hasPendingMonitor: pendingMonitor !== ""
    readonly property string workingMonitor: {
        const focused = root.focusedMonitor;
        if (focused && focused.name !== root.pendingMonitor)
            return focused.name;

        for (const monitor of root.monitors.values) {
            if (monitor.name !== root.pendingMonitor)
                return monitor.name;
        }

        return "";
    }
    readonly property bool canMirror: hasPendingMonitor && workingMonitor !== ""
    property var activeMirror: null

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    function dismissMonitorPrompt(): void {
        pendingMonitor = "";
        pendingDescription = "";
    }

    function mirrorWorkingToNew(): void {
        if (!canMirror)
            return;

        startMirror(
            [monitorRule(pendingMonitor, "preferred", "auto", 1, workingMonitor)],
            {
                output: pendingMonitor,
                target: workingMonitor,
                restore: {
                    mode: "preferred",
                    scale: 1,
                    position: "auto"
                }
            }
        );
    }

    function mirrorNewToWorking(): void {
        if (!canMirror)
            return;

        const working = workingMonitor;
        const saved = snapshot(working, "0x0");

        startMirror(
            [
                monitorRule(pendingMonitor, "preferred", "0x0", 1, ""),
                monitorRule(working, saved.mode, "auto", saved.scale, pendingMonitor)
            ],
            {
                output: working,
                target: pendingMonitor,
                restore: saved
            }
        );
    }

    function clearMirror(): void {
        if (!activeMirror)
            return;

        applyMonitorRules([restoreRule(activeMirror)]);
        activeMirror = null;
    }

    function startMirror(rules: var, mirror: var): void {
        if (activeMirror)
            rules.unshift(restoreRule(activeMirror));

        applyMonitorRules(rules);
        activeMirror = mirror;
        dismissMonitorPrompt();
    }

    function applyMonitorRules(rules: var): void {
        monitorApplier.command = [
            "hyprctl",
            "eval",
            rules.join("; ")
        ];
        monitorApplier.running = true;
    }

    function restoreRule(mirror: var): string {
        return monitorRule(
            mirror.output,
            mirror.restore.mode,
            mirror.restore.position,
            mirror.restore.scale,
            ""
        );
    }

    function monitorRule(output: string, mode: string, position: string, scale: real, mirrorOf: string): string {
        return `hl.monitor({ output = '${luaString(output)}', mode = '${luaString(mode)}', position = '${luaString(position)}', scale = ${scale}, mirror = '${luaString(mirrorOf)}' })`;
    }

    function luaString(value: string): string {
        return value.replace(/\\/g, "\\\\").replace(/'/g, "\\'");
    }

    function snapshot(name: string, fallbackPosition: string): var {
        const monitor = liveMonitor(name);
        const ipc = monitor?.lastIpcObject;
        if (!ipc?.width || !ipc?.height)
            return {
                mode: "preferred",
                scale: 1,
                position: fallbackPosition
            };

        return {
            mode: `${ipc.width}x${ipc.height}@${Number(ipc.refreshRate).toFixed(3)}`,
            scale: Number(ipc.scale),
            position: `${ipc.x}x${ipc.y}`
        };
    }

    function liveMonitor(name: string): var {
        for (const monitor of root.monitors.values) {
            if (monitor.name === name)
                return monitor;
        }
        return null;
    }

    function isIgnoredMonitor(name: string): bool {
        return (ignoreHeadless && name.startsWith("HEADLESS"))
            || name.startsWith("Unknown")
            || name === "FALLBACK";
    }

    function monitorFor(screen: ShellScreen): HyprlandMonitor {
        return Hyprland.monitorFor(screen);
    }

    function focusedClientPerMonitor(screen: ShellScreen): var {
        const monitor = Hypr.monitorFor(screen);
        if (!monitor || !monitor.activeWorkspace)
            return null;

        for (const ws of Hypr.workspaces.values) {
            if (ws.id !== monitor.activeWorkspace.id)
                continue;

            const lastWindow = ws.lastIpcObject?.lastwindow;
            if (typeof lastWindow !== "string")
                return null;

            const last = lastWindow.replace(/^0x/, "");

            for (const tl of ws.toplevels.values) {
                if (typeof tl.address === "string" && tl.address.replace(/^0x/, "") === last)
                    return tl.lastIpcObject;
            }
        }

        return null;
    }

    Process {
        id: monitorApplier

        stdout: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "")
                    console.log(`hyprctl monitor: ${text.trim()}`);
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.trim() !== "")
                    console.error(`hyprctl monitor: ${text.trim()}`);
            }
        }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;

            if (n === "monitoraddedv2") {
                const parts = event.parse(3);
                const name = parts[1];
                if (!name || root.isIgnoredMonitor(name))
                    return;

                root.pendingMonitor = name;
                root.pendingDescription = parts[2] ?? "";
                Hyprland.refreshMonitors();
                return;
            }

            if (n === "monitorremovedv2") {
                const name = event.parse(3)[1];
                if (name === root.pendingMonitor)
                    root.dismissMonitorPrompt();
                if (root.activeMirror && (name === root.activeMirror.output || name === root.activeMirror.target))
                    root.clearMirror();
                Hyprland.refreshMonitors();
                return;
            }

            if (n.endsWith("v2"))
                return;

            if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } else if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } else if (n.includes("mon")) {
                Hyprland.refreshMonitors();
            } else if (n.includes("workspace")) {
                Hyprland.refreshWorkspaces();
            } else if (n.includes("window") || n.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(n)) {
                Hyprland.refreshToplevels();
            }
        }
    }
}
