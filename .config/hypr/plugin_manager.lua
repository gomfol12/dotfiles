local M = {}

local config = {
    enable_notifications = true,
}

local PLUGIN_DIR = os.getenv("HOME") .. "/.config/hypr/plugins"

---@class PluginSpec
---@field repo string
---@field tag? string
---@field branch? string
---@field init? fun()

---@type (string|PluginSpec)[]
local plugins = require("plugins")

---@param msg string
local function notify(msg)
    if config.enable_notifications then
        if not hl or not hl.notification then
            print("[Plugin-Manager] " .. msg)
            return
        end
        hl.notification.create({ text = "[Plugin-Manager] " .. msg, duration = 5000, icon = "info" })
    end
end

---@param plugin string|PluginSpec
---@return PluginSpec
local function normalize(plugin)
    if type(plugin) == "string" then
        return { repo = plugin }
    end

    return plugin
end

--- @param repo string
--- @return string
local function repo_name(repo)
    return repo:match("/([^/]+)$")
end

--- @param repo string
--- @return string
local function plugin_path(repo)
    return PLUGIN_DIR .. "/" .. repo_name(repo)
end

--- @return nil
function M.sync()
    os.execute('mkdir -p "' .. PLUGIN_DIR .. '"')

    for _, p in ipairs(plugins) do
        local plugin = normalize(p)
        local path = plugin_path(plugin.repo)

        if not io.open(path .. "/.git", "r") then
            local url = ("https://github.com/%s.git"):format(plugin.repo)

            notify("Installing " .. plugin.repo)

            local clone_cmd = ('git clone "%s" "%s"'):format(url, path)

            if plugin.branch then
                clone_cmd = ('git clone --branch "%s" "%s" "%s"'):format(plugin.branch, url, path)
            end

            os.execute(clone_cmd)

            if plugin.tag then
                os.execute(('git -C "%s" checkout tags/%s'):format(path, plugin.tag))
            end
        end
    end
end

--- @return nil
function M.load()
    package.path = package.path .. ";" .. PLUGIN_DIR .. "/?.lua" .. ";" .. PLUGIN_DIR .. "/?/init.lua"

    for _, p in ipairs(plugins) do
        local plugin = normalize(p)

        if plugin.init then
            local ok, err = pcall(plugin.init)

            if not ok then
                notify(("Init failed for %s: %s"):format(plugin.repo, err))
            end
        end
    end
end

return M
