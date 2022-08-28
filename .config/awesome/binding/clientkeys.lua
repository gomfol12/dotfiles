-- ==================== Client Keys ==================== --

-- Default libs
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

-- vars
local modkey = RC.vars.modkey

return gears.table.join(

    awful.key({ modkey }, "f", function(c)
        if c.floating == true then
            c.floating = false
        end
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, "Shift" }, "c", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    awful.key({ modkey, "Shift" }, "f", function(c)
        if c.fullscreen == true then
            c.fullscreen = false
        end
        c.floating = not c.floating
    end, { description = "toggle floating", group = "client" }),
    awful.key({ modkey }, "n", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" }),
    awful.key({ modkey, "Shift" }, "w", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey, "Shift" }, "e", function(c)
        c:move_to_screen()
    end, { description = "move to screen", group = "client" }),
    awful.key({ modkey }, "z", function(c)
        c.ontop = not c.ontop
    end, { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey }, "m", function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, { description = "minimize", group = "client" }),
    awful.key({ modkey }, "t", function(c)
        c.ontop = false
        c.fullscreen = false
        c.maximized = false
        c.maximized_vertical = false
        c.maximized_horizontal = false
        c.sticky = false
        c.floating = false
    end, { description = "tile client", group = "client" }),
    awful.key({ modkey }, "a", function(c)
        c.sticky = not c.sticky
        c:raise()
    end),

    -- Maximized
    awful.key({ modkey }, "s", function(c)
        if c.maximized == false and c.border_width == 0 then
            c.border_befor_maximized_zero = true
        end
        c.maximized = not c.maximized
        if c.maximized == true then
            c.border_width = 0
        elseif c.maximized == false then
            if c.border_befor_maximized_zero ~= nil and c.border_befor_maximized_zero == true then
                c.border_befor_maximized_zero = false
                return
            end
            c.border_width = beautiful.border_width
        end
        c:raise()
    end, { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "v", function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Control" }, "s", function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = "(un)maximize horizontally", group = "client" })
)
