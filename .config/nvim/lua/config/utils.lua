-- ==================== Utils ==================== --

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
            s = s .. "[" .. k .. "] = " .. dump(v) .. ","
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

local function get_node_at_cursor()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local cursor_range = { cursor[1] - 1, cursor[2] }
    local buf = vim.api.nvim_get_current_buf()
    local ok, parser = pcall(require("vim.treesitter").get_parser, buf, "latex")
    if not ok or not parser then
        return
    end
    local root_tree = parser:parse()[1]
    local root = root_tree and root_tree:root()

    if not root then
        return
    end

    return root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
end

local function in_mathzone_vimtex()
    return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function in_mathzone_treesitter()
    local MATH_ENVIRONMENTS = {
        displaymath = true,
        equation = true,
        eqnarray = true,
        align = true,
        math = true,
        array = true,
    }
    local MATH_NODES = {
        displayed_equation = true,
        inline_formula = true,
    }
    local node = get_node_at_cursor()

    local has_ts, ts = pcall(require, "vim.treesitter")
    if not has_ts then
        return false
    end

    while node do
        if MATH_NODES[node:type()] then
            return true
        elseif node:type() == "math_environment" or node:type() == "generic_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if
                names
                and names[1]
                and MATH_ENVIRONMENTS[ts.get_node_text(names[1], vim.api.nvim_get_current_buf()):match("[A-Za-z]+")]
            then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

local function in_mathzone()
    if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil then
        return in_mathzone_treesitter()
    else
        return in_mathzone_vimtex()
    end
end

local function in_text()
    return not in_mathzone()
end

local function in_comment_vimtex()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end

local function in_comment_treesitter()
    local node = get_node_at_cursor()
    while node do
        if node:type() == "comment" then
            return true
        end
        node = node:parent()
    end
    return false
end

local function in_comment()
    if vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil then
        return in_comment_treesitter()
    else
        return in_comment_vimtex()
    end
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
