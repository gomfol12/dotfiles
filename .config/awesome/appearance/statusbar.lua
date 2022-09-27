-- ==================== Statusbar ==================== --
-- TODO: layoutbox icons, better separator

-- Default libs
local awful = require("awful")
local wibox = require("wibox")

local taglist = require("appearance.taglist")
local tasklist = require("appearance.tasklist")
local wallpaper = require("appearance.wallpaper")

for s in screen do
    wallpaper.set_wallpaper(s)

    -- Statusbar widgets
    s.promptbox = awful.widget.prompt({ prompt = " Run: ", with_shell = true })
    s.layoutbox = awful.widget.layoutbox(s)
    s.taglist = taglist(s)
    s.tasklist = tasklist(s)

    local space = wibox.widget.textbox(" ")
    local spacer = wibox.widget.textbox("|")

    local clock = wibox.widget({
        format = "%a %d %B, %R",
        refresh = 60,
        widget = wibox.widget.textclock,
    })

    local c_widgets = require("appearance.widgets")

    -- Default right_widgets widget for Statusbar
    local right_widgets = {
        clock,
        spacing = 5,
        layout = wibox.layout.fixed.horizontal,
    }

    -- Set different right_widgets widget for PRIMARY Monitor
    for out, _ in pairs(s.outputs) do
        if out == os.getenv("PRIMARY") then
            right_widgets = {
                spacer,
                -- c_widgets.updates,
                c_widgets.net,
                spacer,
                wibox.widget.textbox(" "),
                c_widgets.cpu,
                c_widgets.cpu_temp,
                spacer,
                wibox.widget.textbox(" "),
                c_widgets.gpu,
                spacer,
                wibox.widget.textbox(" "),
                c_widgets.mem,
                spacer,
                c_widgets.audio,
                spacer,
                wibox.widget.textbox(" "),
                clock,
                spacer,
                wibox.widget.systray(),
                spacing = 5,
                layout = wibox.layout.fixed.horizontal,
            }
        end
    end

    -- Create Statusbar
    local barheight = 25

    if RC.vars.hostname == os.getenv("HOSTNAME_DESKTOP") then
        barheight = 25
    end
    if RC.vars.hostname == os.getenv("HOSTNAME_LAPTOP") then
        barheight = 50
    end

    s.wibox = awful.wibar({ position = "top", height = barheight, screen = s })
    s.wibox:setup({
        {
            s.taglist,
            s.layoutbox,
            s.promptbox,
            layout = wibox.layout.fixed.horizontal,
        },
        s.tasklist,
        right_widgets,
        layout = wibox.layout.align.horizontal,
    })
end
