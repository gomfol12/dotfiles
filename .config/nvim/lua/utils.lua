local utils = {}

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

function utils.getHost()
    local hostname = ""
    local file_hostname = io.popen("/bin/hostname")
    if file_hostname then
        hostname = file_hostname:read("*a") or ""

        hostname = string.gsub(hostname, "\n$", "")
        file_hostname:close()
    end
    return hostname
end

function utils.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. utils.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function utils.concat(t1, t2)
    local t = t1
    for k, v in pairs(t2) do
        t[k] = v
    end
    return t
end

return utils
