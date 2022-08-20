-- ==================== Helper Functions ==================== --

local awful = require("awful")

local _M = {}

-- Detect restart
function _M.is_restart()
    -- If we already did restart detection: Just return the result
    if _M.restart_detected ~= nil then
        return _M.restart_detected
    end

    -- Register a new boolean
    awesome.register_xproperty("awesome_restart_check", "boolean")
    -- Check if this boolean is already set
    _M.restart_detected = awesome.get_xproperty("awesome_restart_check") ~= nil
    -- Set it to true
    awesome.set_xproperty("awesome_restart_check", true)
    -- Return the result
    return _M.restart_detected
end

-- dmenu_prompt
function _M.dmenu_prompt(question, func)
    awful.spawn.easy_async({ "dmenu_prompt.sh", question }, function(stdout, stderr, reason, exit_code)
        if exit_code == 0 then
            func()
        end
    end)
end

function _M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. _M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

return _M
