-- ==================== Tags ==================== --
-- TODO: logic for added/removing monitors

-- Default libs
local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

local tags = {}

local tagpairs = {
    primary = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    primary_layout = RC.layouts[1],

    secondary = { "1", "2", "3", "4", "5" },
    secondary_layout = RC.layouts[1],

    default = { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    default_layout = RC.layouts[1],
}

for s in screen do
    for out, _ in pairs(s.outputs) do
        if out == os.getenv("PRIMARY") then
            tags[s] = awful.tag(tagpairs.primary, s, tagpairs.primary_layout)
        elseif out == os.getenv("SECONDARY") then
            tags[s] = awful.tag(tagpairs.secondary, s, tagpairs.secondary_layout)
        else
            tags[s] = awful.tag(tagpairs.default, s, tagpairs.default_layout)
        end
    end
end

-- insanly stupid hacky way to fix unity redraw problem (see https://forum.unity.com/threads/editor-panels-only-redraw-on-update-mouse-over.731285/)
tag.connect_signal("property::selected", function(t)
    local clients = awful.client.visible(s)
    for _, client in pairs(clients) do
        if awful.rules.match(client, { class = "Unity" }) then
            client.border_width = client.border_width + 1
            gears.timer.start_new(1 / 60, function()
                client.border_width = client.border_width - 1
            end)
        end
    end
end)

return tags
