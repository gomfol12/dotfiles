-- ==================== Menu ==================== --
-- TODO: add icons, make it useful

-- Default libs
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local beautiful = require("beautiful")

-- Variable definitions
local terminal = RC.vars.terminal
local editor = RC.vars.editor
local editor_cmd = terminal .. " -e " .. editor

-- Sub Menu
sm = {
    {
        "hotkeys",
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "Terminal", terminal },
    { "Shutdown/Logout", "oblogout" },
    { "restart", awesome.restart },
    {
        "quit",
        function()
            awesome.quit()
        end,
    },
}

-- Main Menu
local m = {
    { "awesome", sm },
    { "open terminal", terminal },
}

return m
