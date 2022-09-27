-- ==================== User variables ==================== --

-- Default libs
local awful = require("awful")

local helper = require("lib.helper")

local home = os.getenv("HOME")

-- get hostname
local hostname = ""
local file_hostname = io.popen("/bin/hostname")
if file_hostname then
    hostname = file_hostname:read("*a") or ""

    hostname = string.gsub(hostname, "\n$", "")
    file_hostname:close()
end

-- netdev check
local netdev = ""
if hostname == os.getenv("HOSTNAME_DESKTOP") then
    netdev = "enp37s0"
end
if hostname == os.getenv("HOSTNAME_LAPTOP") then
    netdev = "wlp170s0"
end
local netdev_tmp = ""
local file_netdev = io.popen('/bin/bash -c \'ip a | grep -E "^[[:digit:]]+" | cut -d" " -f2 | tr -d ":"\'')
if file_netdev then
    netdev_tmp = file_netdev:read("*a") or ""
    file_netdev:close()

    local data = {}
    for line in helper.magiclines(netdev_tmp) do
        table.insert(data, line)
    end
    local already_correct = false
    for _, d in ipairs(data) do
        if d == netdev then
            already_correct = true
        end
    end
    if not already_correct then
        netdev = data[2]
    end
end

local _M = {
    terminal = os.getenv("TERMINAL"),
    editor = os.getenv("EDITOR"),
    browser = os.getenv("BROWSER"),

    modkey = "Mod1",
    superkey = "Mod4",

    wallpaper = home .. "/.local/share/bg",

    netdev = netdev,

    hostname = hostname,
}

return _M
