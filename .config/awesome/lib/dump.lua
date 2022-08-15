local _M = {}

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
