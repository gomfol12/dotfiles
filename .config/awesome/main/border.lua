-- ==================== Border Management ==================== --

local beautiful = require("beautiful")
local n = require("naughty")
local h = require("lib.helper")

local function correct_border(tag)
    if tag.layout["name"] == "floating" then
        for _, c in ipairs(tag:clients()) do
            c.border_width = beautiful.border_width
        end
        return
    end

    local client_not_floating = {}
    for _, c in ipairs(tag:clients()) do
        if c.floating == false then
            table.insert(client_not_floating, c)
        elseif c.floating == true then
            c.border_width = beautiful.border_width
        end
    end

    if #client_not_floating == 1 then
        client_not_floating[1].border_width = 0
    elseif #client_not_floating > 1 then
        for _, c in ipairs(client_not_floating) do
            c.border_width = beautiful.border_width
        end
    end
end

tag.connect_signal("tagged", function(t)
    correct_border(t)
end)
tag.connect_signal("untagged", function(t)
    correct_border(t)
end)
tag.connect_signal("property::layout", function(t)
    correct_border(t)
end)
client.connect_signal("property::floating", function(c)
    local tag = c.first_tag
    if tag ~= nil then
        correct_border(tag)
    end
end)
client.connect_signal("property::maximized", function(c)
    local tag = c.first_tag
    if tag ~= nil then
        correct_border(tag)
    end
end)
awesome.connect_signal("startup", function(c)
    for _, t in pairs(root.tags()) do
        correct_border(t)
    end
end)
