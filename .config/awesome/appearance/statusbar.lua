-- ==================== Statusbar ==================== --
-- TODO: vicious pkg module, layoutbox icons

-- Default libs
local awful = require("awful")
local wibox = require("wibox")

-- Vicious
local vicious = require("vicious")
local c_widgets = require("appearance.statusbar_widgets")

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

    -- Vicious widgets
    local clock = wibox.widget.textbox()
    vicious.register(clock, vicious.widgets.date, "%a %d %B, %R", 60)

    local mem = wibox.widget.textbox()
    vicious.cache(vicious.widgets.mem)
    vicious.register(mem, vicious.widgets.mem, "$1% ($2MiB)", 5)

    local cpu = wibox.widget.textbox()
    vicious.cache(vicious.widgets.cpu)
    vicious.register(cpu, vicious.widgets.cpu, "$1%", 5)

    local cpu_temp = wibox.widget.textbox()
    vicious.cache(c_widgets.cpu_temp)
    vicious.register(cpu_temp, c_widgets.cpu_temp, "$1°C", 5)

    local gpu = wibox.widget.textbox()
    vicious.cache(c_widgets.nvidia_gpu)
    vicious.register(gpu, c_widgets.nvidia_gpu, "$1% $2°C", 5)

    local net = wibox.widget.textbox()
    local netdev = RC.vars.netdev
    vicious.register(net, vicious.widgets.net, function(widget, args)
        if args["{" .. netdev .. " carrier}"] == 1 then
            return " "
                .. args["{" .. netdev .. " down_mb}"]
                .. "MiB 祝 "
                .. args["{" .. netdev .. " up_mb}"]
                .. "MiB"
        else
            return "not connected"
        end
    end, 5)

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
                space,
                net,
                spacer,
                wibox.widget.textbox(" "),
                cpu,
                cpu_temp,
                spacer,
                wibox.widget.textbox(" "),
                gpu,
                spacer,
                wibox.widget.textbox(" "),
                mem,
                spacer,
                wibox.widget.textbox(" "),
                clock,
                wibox.widget.systray(),
                spacing = 5,
                layout = wibox.layout.fixed.horizontal,
            }
        end
    end

    -- Create Statusbar
    s.wibox = awful.wibar({ position = "top", height = 25, screen = s })
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
