-- ==================== Titlebar ==================== --

-- Default libs
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local modkey = RC.vars.modkey

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    local titlebar = awful.titlebar(c, { size = 25 })

    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    titlebar:setup({
        {
            {
                awful.titlebar.widget.titlewidget(c),
                left = 5,
                right = 5,
                widget = wibox.container.margin,
            },
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            buttons = buttons,
            layout = wibox.layout.flex.horizontal,
        },
        {
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.minimizebutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal(),
        },
        layout = wibox.layout.align.horizontal,
    })
end)
