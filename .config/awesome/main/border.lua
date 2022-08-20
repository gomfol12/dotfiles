-- ==================== Border Management ==================== --

local beautiful = require("beautiful")

tag.connect_signal("tagged", function(t)
    if t.layout["name"] == "floating" then
        return
    end

    if #t:clients() == 1 then
        t:clients()[1].border_width = 0
    elseif #t:clients() >= 1 then
        for _, c in ipairs(t:clients()) do
            if c.border_width == 0 then
                c.border_width = beautiful.border_width
            end
        end
    end
end)

tag.connect_signal("untagged", function(t)
    if t.layout["name"] == "floating" then
        return
    end

    if #t:clients() == 1 then
        t:clients()[1].border_width = 0
    end
end)

tag.connect_signal("property::layout", function(t)
    if t.layout["name"] == "floating" then
        for _, c in ipairs(t:clients()) do
            if c.border_width == 0 then
                c.border_width = beautiful.border_width
            end
        end
    else
        if #t:clients() == 1 then
            t:clients()[1].border_width = 0
        end
    end
end)

client.connect_signal("property::floating", function(c)
    if c.border_width == 0 then
        c.border_width = beautiful.border_width
    else
        if c.first_tag ~= nil and #c.first_tag:clients() == 1 then
            c.border_width = 0
        end
    end
end)

awesome.connect_signal("startup", function(c)
    for _, t in pairs(root.tags()) do
        if #t:clients() == 1 then
            t:clients()[1].border_width = 0
        end
    end
end)
