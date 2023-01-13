-- ==================== Tasklist ==================== --

-- Default libs
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local modkey = RC.vars.modkey

return setmetatable({}, {
    __call = function(_, s)
        return awful.widget.tasklist({
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            style = {
                shape = gears.shape.rectangle,
            },
            layout = {
                spacing = 0,
                layout = wibox.layout.flex.horizontal,
            },
            widget_template = {
                {
                    {
                        -- {
                        --     id = "icon_role",
                        --     widget = wibox.widget.imagebox,
                        -- },
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    left = 5,
                    right = 5,
                    widget = wibox.container.margin,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            buttons = gears.table.join(
                awful.button({}, 1, function(c)
                    c:emit_signal("request::activate", "tasklist", { raise = true })
                end),
                awful.button({}, 3, function(c)
                    c.minimized = not c.minimized
                end)
                -- awful.button({}, 3, function()
                --     awful.menu.client_list({ theme = { width = 250 } })
                -- end),
                -- awful.button({}, 4, function()
                --     awful.client.focus.byidx(1)
                -- end),
                -- awful.button({}, 5, function()
                --     awful.client.focus.byidx(-1)
                -- end)
            ),
        })
    end,
})
