-- ==================== Hotkeys popup widget ==================== --

local hotkeys_popup = require("awful.hotkeys_popup.widget")

local tmux_rule_any = { name = { "tmux", "TMUX" } }
local tmux_keys = {
    ["tmux: mapleader"] = {
        {
            modifiers = { "Control" },
            keys = {
                a = "mapleader",
            },
        },
    },
    ["tmux: general"] = {
        {
            modifiers = {},
            keys = {
                ["C-c"] = "source config",
                c = "source config",
                ["C-b"] = "refresh client",
                b = "refresh client",
                enter = "next layout",
                ["C-["] = "enter copy mode",
                ["C-]"] = "paste",
            },
        },
    },
    ["tmux: copy mode"] = {
        {
            modifiers = {},
            keys = {
                y = "copy selection",
                ["C-c"] = "copy selection",
                v = "begin selection",
                space = "begin selection",
                o = "xdg-open selection",
                ["C-o"] = "open editor",
                S = "search selection in browser",
            },
        },
    },
    ["tmux: window"] = {
        {
            modifiers = {},
            keys = {
                ["C-w"] = "create new window",
                w = "create new window",
                W = "create new window with current pwd",
                space = "select next window",
                backspace = "select prev window",
                X = "kill window",
                r = "rotate window clockwise",
                R = "rotate window counter clockwise",
            },
        },
    },
    ["tmux: pane"] = {
        {
            modifiers = {},
            keys = {
                ["C-v"] = "new pane split vertical with current pwd",
                ["C-s"] = "new pane split horizontal with current pwd",
                v = "new pane split vertical with current pwd",
                s = "new pane split horizontal with current pwd",
                V = "new pane split vertical",
                S = "new pane split horizontal",
                ["C-j"] = "select pane bottom",
                ["C-k"] = "select pane top",
                ["C-h"] = "select pane left",
                ["C-l"] = "select pane right",
                j = "select pane bottom",
                k = "select pane top",
                h = "select pane left",
                l = "select pane right",
                up = "resize pane up",
                down = "resize pane down",
                left = "resize pane left",
                right = "resize pane right",
                ["C-x"] = "kill pane",
                x = "kill pane",
                J = "swap pane down",
                K = "swap pane up",
                ["C-z"] = "zoom/maximize pane",
                z = "zoom/maximize pane",
            },
        },
    },
    ["tmux: tree mode"] = {
        {
            modifiers = {},
            keys = {
                ["C-t"] = "open tree mode",
                t = "open tree mode",
                T = "open tree mode expanded list",
            },
        },
    },
    ["tmux: copy cat"] = {
        {
            modifiers = {},
            keys = {
                ["/"] = "regex search",
                n = "next search",
                N = "prev search",
                ["C-f"] = "file search",
                ["C-g"] = "git status file search",
                ["C-e"] = "SHA-1/SHA-256 hashes search",
                ["C-u"] = "url search",
                ["C-d"] = "number search",
                ["C-i"] = "ip search",
                enter = "copy selection",
                y = "copy selection",
            },
        },
    },
    ["tmux: tpm"] = {
        {
            modifiers = {},
            keys = {
                I = "install plugins",
                U = "update plugins",
                N = "uninstall plugins",
            },
        },
    },
}
hotkeys_popup.add_hotkeys(tmux_keys)

local nvim_rule_any = { name = { "nvim", "NVIM" } }
local nvim_keys = {
    ["nvim: vim-table-mode"] = {
        {
            modifiers = { "Leader" },
            keys = {
                tm = "Toggle Table Mode",
                tt = "Tableize",
                tdd = "delete row",
                tdc = "delete column",
                tic = "insert column",
                tfa = "add formula",
                tfe = "eval formula",
                ["t?"] = "get current cell name",
            },
        },
    },
}
hotkeys_popup.add_hotkeys(nvim_keys)

for group_name, _ in pairs(tmux_keys) do
    hotkeys_popup.add_group_rules(group_name, { rule_any = tmux_rule_any })
end
for group_name, _ in pairs(nvim_keys) do
    hotkeys_popup.add_group_rules(group_name, { rule_any = nvim_rule_any })
end
