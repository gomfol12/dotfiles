-- ==================== User variables ==================== --

-- Default libs
local awful = require("awful")

local helper = require("lib.helper")

local home = os.getenv("HOME")

local _M = {
    terminal = os.getenv("TERMINAL"),
    editor = os.getenv("EDITOR"),
    browser = os.getenv("BROWSER"),

    modkey = "Mod1",
    superkey = "Mod4",

    wallpaper = home .. "/.local/share/bg",

    netdev = "enp37s0",
}

-- netdev check
awful.spawn.easy_async_with_shell(
    'ip a | grep -E "^[[:digit:]]+" | cut -d" " -f2 | tr -d ":"',
    function(stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then
            _M.netdev = ""
            return
        end

        local data = {}
        for line in helper.magiclines(stdout) do
            table.insert(data, line)
        end
        for _, d in ipairs(data) do
            if d == _M.netdev then
                return
            end
        end
        _M.netdev = data[2]
    end
)

return _M
