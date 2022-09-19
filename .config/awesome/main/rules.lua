-- ==================== Rules ==================== --
-- TODO: add rules when necessary

-- Default libs
local awful = require("awful")
local beautiful = require("beautiful")
local ruled = require("ruled")

local _M = {}

-- placement, that should be applied after setting x/y/width/height/geometry
function ruled.client.delayed_properties.delayed_placement(c, value, props)
    if props.delayed_placement then
        ruled.client.extra_properties.placement(c, props.delayed_placement, props)
    end
end

function _M.get(clientkeys, clientbuttons)
    local rules = {

        -- All clients will match this rule.
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                raise = true,
                keys = clientkeys,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            },
        },

        -- Floating clients.
        {
            rule_any = {
                instance = {
                    "DTA", -- Firefox addon DownThemAll.
                    "copyq", -- Includes session name in class.
                    "pinentry",
                },
                class = {
                    "Arandr",
                    "Blueman-manager",
                    "Blueman-services",
                    "Blueman-adapters",
                    "Blueman-applet",
                    "Nm-connection-editor",
                    "Nm-applet",
                    "Gpick",
                    "Kruler",
                    "MessageWin", -- kalarm.
                    "Sxiv",
                    "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
                    "Wpa_gui",
                    "veromix",
                    "xtightvncviewer",
                },

                -- Note that the name property shown in xprop might be set slightly after creation of the client
                -- and the name shown there might not match defined rules here.
                name = {
                    "Event Tester", -- xev.
                },
                role = {
                    "AlarmWindow", -- Thunderbird's calendar.
                    "ConfigManager", -- Thunderbird's about:config.
                    "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
                },
            },
            properties = {
                floating = true,
                placement = awful.placement.centered,
            },
        },

        {
            rule_any = {
                class = {
                    "Dragon-drop",
                },
            },
            properties = {
                placement = awful.placement.centered,
            },
        },

        {
            rule_any = {
                class = {
                    "mpv",
                    "Nsxiv",
                    "Pavucontrol",
                    "System-config-printer.py",
                },
            },
            properties = {
                floating = true,
                delayed_placement = awful.placement.centered,
                width = awful.screen.focused().workarea.width * 0.7,
                height = awful.screen.focused().workarea.height * 0.7,
            },
        },

        -- Add titlebars to normal clients and dialogs
        -- {
        --     rule_any = {
        --         type = { "normal", "dialog" },
        --     },
        --     properties = {
        --         titlebars_enabled = true,
        --     },
        -- },

        -- Set Firefox to always map on the tag named "2" on screen 1.
        -- { rule = { class = "Firefox" },
        --   properties = { screen = 1, tag = "2" } },
    }

    return rules
end

return setmetatable({}, {
    __call = function(_, ...)
        return _M.get(...)
    end,
})
