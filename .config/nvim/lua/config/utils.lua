local function getHost()
    local hostname = ""
    local file_hostname = io.popen("/bin/hostname")
    if file_hostname then
        hostname = file_hostname:read("*a") or ""

        hostname = string.gsub(hostname, "\n$", "")
        file_hostname:close()
    end
    return hostname
end

local function concat(...)
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

local function dump(o)
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

local function file_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end

local function dir_exists(path)
    if path == nil or type(path) ~= "string" or path == "" then
        return false
    end
    local ok = os.execute("cd " .. path .. " >/dev/null 2>&1")
    if ok == 0 then
        return true
    end
    return false
end

local function check_executable(progs, msg)
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

local function check_formatters(T)
    check_executable(T, "Formatters not installed:")
end

local function check_linters(T)
    check_executable(T, "Linters not installed:")
end

local function in_mathzone()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
local function in_text()
    return not in_mathzone()
end
local function in_comment()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end
local function in_env(name)
    local is_inside = vim.fn["vimtex#env#is_inside"](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end
local function in_equation()
    return in_env("equation")
end
local function in_itemize()
    return in_env("itemize")
end
local function in_tikz()
    return in_env("tikzpicture")
end

return {
    getHost = getHost,
    concat = concat,
    dump = dump,
    file_exists = file_exists,
    dir_exists = dir_exists,
    check_executable = check_executable,
    check_formatters = check_formatters,
    check_linters = check_linters,
    latex = {
        in_mathzone = in_mathzone,
        in_text = in_text,
        in_comment = in_comment,
        in_env = in_env,
        in_equation = in_equation,
        in_itemize = in_itemize,
        in_tikz = in_tikz,
    },
}
