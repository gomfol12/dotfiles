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

function _M.concat(...)
    local t = {}
    for i = 1, select("#", ...) do
        local arg = select(i, ...)
        if arg ~= nil then
            for k, v in pairs(arg) do
                if type(k) == "string" then
                    t[k] = v
                else
                    t[#t + 1] = v
                end
            end
        end
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

function _M.check_executable(progs, msg)
    local str = ""
    for _, p in ipairs(progs) do
        if vim.fn.executable(p) ~= 1 then
            str = str .. p .. " "
        end
    end

    if str ~= "" and msg ~= nil then
        print(msg .. " " .. str)
        return false
    end

    return true
end

function _M.check_formatters(T)
    _M.check_executable(T, "Formatters not installed:")
end

function _M.check_linters(T)
    _M.check_executable(T, "Linters not installed:")
end

return _M
