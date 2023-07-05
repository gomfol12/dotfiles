-- local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

-- function utils.opt(scope, key, value)
--     scopes[scope][key] = value
--     if scope ~= "o" then
--         scopes["o"][key] = value
--     end
-- end

-- function utils.map(mode, lhs, rhs, opts)
--     local options = { noremap = true }
--     if opts then
--         options = vim.tbl_extend("force", options, opts)
--     end
--     vim.api.nvim_set_keymap(mode, lhs, rhs, options)
-- end

local _M = {}

function _M.getHost()
    local hostname = ""
    local file_hostname = io.popen("/bin/hostname")
    if file_hostname then
        hostname = file_hostname:read("*a") or ""

        hostname = string.gsub(hostname, "\n$", "")
        file_hostname:close()
    end
    return hostname
end

function _M.concat(t1, t2)
    local t = {}
    for k, v in pairs(t1) do
        t[k] = v
    end
    for k, v in pairs(t2) do
        t[k] = v
    end
    return t
end

function _G.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. _G.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function _G.put(...)
    return vim.print(...)
end

function _G.file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

return _M
