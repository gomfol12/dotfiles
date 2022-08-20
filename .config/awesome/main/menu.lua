-- ==================== Menu ==================== --
-- TODO: add icons

-- Default libs
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful = require("beautiful")

local helper = require("lib.helper")

-- Variable definitions
local terminal = RC.vars.terminal

-- Sub Menu
local sm = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "Terminal", terminal },
    { "restart", awesome.restart },
    {
        "quit",
        function()
            helper.dmenu_prompt("Quit awesome?", function()
                awesome.quit()
            end)
        end,
    },
}

local sys = {
    {
        "Reboot",
        function()
            helper.dmenu_prompt("Reboot?", function()
                awful.spawn("reboot")
            end)
        end,
    },
    {
        "Shutdown",
        function()
            helper.dmenu_prompt("Shutdown?", function()
                awful.spawn("shutdown -h now")
            end)
        end,
    },
}

-- Main Menu
local m = awful.menu({
    items = {
        { "awesome", sm },
        { "System", sys },
        { "open terminal", terminal },
    },
})

return m
