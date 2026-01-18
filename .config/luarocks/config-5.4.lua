-- LuaRocks configuration

rocks_trees = {
    { name = "user", root = home .. "/.local/share/luarocks" },
    { name = "system", root = "/usr" },
}
variables = {
    LUA_DIR = "/usr",
    LUA_BINDIR = "/usr/bin",
    LUA_VERSION = "5.4",
    LUA = "/usr/bin/lua5.4",
}
