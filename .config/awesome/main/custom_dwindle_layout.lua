local naughty = require("naughty")

local capi = {
    mouse = mouse,
    screen = screen,
    mousegrabber = mousegrabber,
}

local function arrange(p)
    local wa = p.workarea
    local cls = p.clients
    local n = #cls
    local old_width, old_height = wa.width, 2 * wa.height

    local t = p.tag or capi.screen[p.screen].selected_tag
    local mwfactor = t.master_width_factor

    for k, c in ipairs(cls) do
        if k % 2 == 0 then
            wa.width, old_width = math.ceil(old_width * (1 - mwfactor)), wa.width
            if k ~= n then
                wa.height, old_height = math.floor(wa.height / 2), wa.height
            end
        else
            wa.height, old_height = math.ceil(old_height / 2), wa.height
            if k ~= n then
                wa.width, old_width = math.floor(wa.width * mwfactor), wa.width
            end
        end

        if k % 2 == 0 then
            wa.x = wa.x + old_width
        end

        if k % 2 == 1 and k ~= 1 then
            wa.y = wa.y + old_height
        end

        local g = {
            x = wa.x,
            y = wa.y,
            width = wa.width,
            height = wa.height,
        }
        p.geometries[c] = g
    end
end

local dwindle = {}
dwindle.name = "c_dwindle"
dwindle.arrange = arrange

return dwindle
