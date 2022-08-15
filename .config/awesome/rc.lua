-- ==================== awesome rc ==================== --

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

-- Vicious
local vicious = require("vicious")

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
RC.menu = awful.menu({ items = require("main.menu") })
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
