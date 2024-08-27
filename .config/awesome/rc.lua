-- ==================== awesome rc ==================== --
-- TODO: desktop widget: system stats
-- TODO: redo scripts: awesome wm compatibility
-- TODO: calender, mem, network click widget
-- TODO: gui network/bluetooth controls
-- TODO: widget icons

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Global Namespace
RC = {}
RC.vars = require("main.user-variables")

-- Default libs
local awful = require("awful")
local beautiful = require("beautiful")
local menubar = require("menubar")
local naughty = require("naughty")
require("awful.autofocus")

local helper = require("lib.helper")

-- Check if PRIMARY monitor environment variables is set
if os.getenv("PRIMARY") == nil then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Error",
        text = "PRIMARY monitor environment variable not configured properly.",
        timeout = 0,
    })
end

-- Error handling
require("main.error-handling")

-- Layouts
RC.layouts = require("main.layouts")

-- Tags
RC.tags = require("main.tags")

-- Theme
beautiful.init(awful.util.getdir("config") .. "theme/theme.lua")
beautiful.wallpaper = RC.vars.wallpaper

-- Menu / Menubar
RC.menu = require("main.menu")
menubar.geometry = { height = 25 }
menubar.right_label = ""
menubar.left_label = ""
menubar.show_categories = false
menubar.utils.terminal = RC.vars.terminal

-- Mouse and Key bindings
local binding = {
    globalbuttons = require("binding.globalbuttons"),
    clientbuttons = require("binding.clientbuttons"),
    globalkeys = require("binding.globalkeys"),
    clientkeys = require("binding.clientkeys"),
    bindtotags = require("binding.bindtotags"),
}
RC.globalkeys = binding.globalkeys
RC.globalkeys = binding.bindtotags(RC.globalkeys)

root.buttons(binding.globalbuttons)
root.keys(RC.globalkeys)

-- Rules
local rules = require("main.rules")
awful.rules.rules = rules(binding.clientkeys, binding.clientbuttons)

-- Signals
require("main.signals")

-- Titlebar
require("appearance.titlebar")

-- Statusbar
require("appearance.statusbar")

-- Border Management
require("main.border")

-- Hotkeys popup
require("main.hotkeys_popup")

-- Set focus to Primary Monitor only on initial startup
if not helper.is_restart() then
    for s in screen do
        for out, _ in pairs(s.outputs) do
            if out == os.getenv("PRIMARY") then
                awful.screen.focus(s)
            end
        end
    end
end

-- perverse tags on restarts
awesome.connect_signal("exit", function(reason_restart)
    if not reason_restart then
        return
    end

    local file = io.open("/tmp/awesomewm-last-selected-tags", "w+")
    if not file then
        return
    end

    for s in screen do
        for out, _ in pairs(s.outputs) do
            file:write(out .. " " .. s.selected_tag.index, "\n")
        end
    end

    file:close()
end)

awesome.connect_signal("startup", function()
    local file = io.open("/tmp/awesomewm-last-selected-tags", "r")
    if not file then
        return
    end

    local selected_tags = {}

    for line in file:lines() do
        local output, tag_index = line:match("(.*) (.*)")
        selected_tags[output] = tonumber(tag_index)
    end

    for s in screen do
        for out, _ in pairs(s.outputs) do
            local i = selected_tags[out]
            s.tags[i]:view_only()
        end
    end

    file:close()
end)

-- xdg autostart
-- awful.spawn.with_shell(
--     'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;'
--         .. 'xrdb -merge <<< "awesome.started:true";'
--         -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
--         .. 'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
-- )
