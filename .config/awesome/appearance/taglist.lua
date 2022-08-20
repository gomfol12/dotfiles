-- ==================== Taglist ==================== --

-- Default libs
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local modkey = RC.vars.modkey

return setmetatable({}, {
    __call = function(_, s)
        return awful.widget.taglist({
            screen = s,
            filter = awful.widget.taglist.filter.all,
            style = { shape = gears.shape.rectangle },
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
                    left = 8,
                    right = 8,
                    widget = wibox.container.margin,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            -- buttons = gears.table.join(
            -- awful.button({}, 1, function(t)
            --     t:view_only()
            -- end),
            -- awful.button({ modkey }, 1, function(t)
            --     if client.focus then
            --         client.focus:move_to_tag(t)
            --     end
            -- end),
            -- awful.button({}, 3, awful.tag.viewtoggle),
            -- awful.button({ modkey }, 3, function(t)
            --     if client.focus then
            --         client.focus:toggle_tag(t)
            --     end
            -- end)
            -- ),
        })
    end,
})
