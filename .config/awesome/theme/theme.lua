-- ==================== theme ==================== --
-- INFO:
-- color0,8 black
-- color1,9 red
-- color2,10 green
-- color3,11 yellow
-- color4,12 blue
-- color5,13 magenta
-- color6,14 cyan
-- color7,15 white

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local naughty = require("naughty")
local awful = require("awful")

-- inherit default theme
local theme = dofile(themes_path .. "default/theme.lua")

theme.font = "Inconsolata Nerd Font 13"

-- general
theme.bg_normal = xrdb.background
theme.bg_focus = xrdb.color1
theme.bg_urgent = xrdb.color7
theme.bg_minimize = theme.color8
theme.bg_systray = theme.bg_normal

theme.fg_normal = xrdb.foreground
theme.fg_focus = xrdb.color0
theme.fg_urgent = xrdb.color0
theme.fg_minimize = xrdb.foreground

-- systray
theme.systray_icon_spacing = 5

--border
theme.border_width = dpi(2)
theme.border_normal = xrdb.color8
theme.border_focus = theme.bg_focus
theme.border_marked = xrdb.color2

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- tooltip
theme.tooltip_bg = theme.bg_normal
theme.tooltip_fg = theme.fg_normal

theme.tooltip_border_width = dpi(1)
theme.tooltip_border_color = xrdb.color7

-- menu
theme.menu_submenu_icon = nil
theme.menu_submenu = " "
theme.menu_height = dpi(25)
theme.menu_width = dpi(170)
theme.menu_font = theme.font

theme.menu_bg_normal = theme.bg_normal
theme.menubar_fg_normal = theme.fg_normal
theme.menu_bg_focus = theme.bg_focus
theme.menu_fg_focus = theme.fg_focus

theme.menu_border_width = theme.border_width
theme.menu_border_color = theme.border_focus

-- menubar
theme.menubar_bg_normal = theme.bg_normal
theme.menubar_fg_normal = theme.fg_normal
theme.menubar_bg_focus = theme.bg_focus
theme.menubar_fg_focus = theme.fg_focus

theme.menubar_border_width = theme.border_width
theme.menubar_border_color = theme.border_focus

-- prompt
theme.prompt_bg = theme.bg_normal
theme.prompt_fg = theme.fg_normal
theme.prompt_bg_cursor = xrdb.foreground
theme.prompt_fg_cursor = xrdb.foreground

-- notifications
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(128)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.border_width = theme.border_width
naughty.config.defaults.border_color = theme.border_focus
naughty.config.defaults.max_width = dpi(400)
naughty.config.defaults.margin = dpi(8)
naughty.config.defaults.shape = function(cr, w, h)
    gears.shape.rectangle(cr, w, h)
end

naughty.config.padding = dpi(8)
naughty.config.spacing = dpi(8)

local ruled = require("ruled")
ruled.notification.connect_signal("request::rules", function()
    ruled.notification.append_rule({
        rule = { urgency = "critical" },
        properties = {
            font = theme.font,
            bg = "#ff0000",
            fg = "#ffffff",
            timeout = 0,
        },
    })
    ruled.notification.append_rule({
        rule = { urgency = "normal" },
        properties = {
            font = theme.font,
            bg = theme.bg_normal,
            fg = theme.fg_normal,
            opacity = 0.9,
        },
    })
    ruled.notification.append_rule({
        rule = { urgency = "low" },
        properties = {
            font = theme.font,
            bg = theme.bg_normal,
            fg = theme.fg_normal,
            opacity = 0.9,
        },
    })
end)

-- taglist
theme.taglist_bg_focus = theme.bg_focus
theme.taglist_fg_focus = theme.fg_focus
theme.taglist_bg_urgent = xrdb.color7
theme.taglist_fg_urgent = xrdb.color0
theme.taglist_bg_occupied = theme.bg_normal
theme.taglist_fg_occupied = theme.fg_normal
theme.taglist_bg_empty = theme.bg_normal
theme.taglist_fg_empty = theme.fg_normal
theme.taglist_bg_volatile = theme.bg_normal
theme.taglist_fg_volatile = theme.fg_normal

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

--tasklist
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_bg_urgent = xrdb.color7
theme.tasklist_fg_urgent = xrdb.color0
theme.tasklist_bg_minimize = "#888888"
theme.tasklist_fg_minimize = xrdb.color0
theme.tasklist_sticky = " "
theme.tasklist_ontop = " "
theme.tasklist_floating = " "
theme.tasklist_maximized = " "
theme.tasklist_maximized_horizontal = " "
theme.tasklist_maximized_vertical = " "
theme.tasklist_above = " "
theme.tasklist_below = " "

-- titlebar
theme.titlebar_bg_normal = theme.bg_normal
theme.titlebar_fg_normal = theme.fg_normal
theme.titlebar_bg_focus = theme.bg_focus
theme.titlebar_fg_focus = theme.fg_focus
theme.titlebar_bg_urgent = xrdb.color7
theme.titlebar_fg_urgent = xrdb.color0

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- awesome icon
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- maximized
-- theme.maximized_hide_border = true

-- progressbar

-- snap
theme.snap_bg = xrdb.color7
theme.snap_shape = gears.shape.rectangle

-- hotkeys popup
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_font = theme.font
theme.hotkeys_description_font = theme.font
theme.hotkeys_modifiers_fg = xrdb.color2
-- theme.hotkeys_label_bg = xrdb.color2
-- theme.hotkeys_label_fg = xrdb.color0
theme.hotkeys_group_margin = 10

theme.hotkeys_border_width = theme.border_width
theme.hotkeys_border_color = theme.border_focus

return theme
