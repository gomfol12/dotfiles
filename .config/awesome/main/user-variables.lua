-- ==================== User variables ==================== --

local home = os.getenv("HOME")

local _M = {
    terminal = os.getenv("TERMINAL"),
    editor = os.getenv("EDITOR"),
    browser = os.getenv("BROWSER"),

    modkey = "Mod1",
    superkey = "Mod4",

    wallpaper = home .. "/.config/bg-saved.png",

    netdev = "enp37s0",
}

return _M
