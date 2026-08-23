local M = {}

---@class MonitorProfile
---@field monitors HL.MonitorSpec[]
---@field exec? string

---@type MonitorProfile[]
local profiles = {}

---@param profile MonitorProfile
---@return boolean
local function matches(profile)
    ---@type table<string, boolean>
    local connected = {}
    for _, mon in ipairs(hl.get_monitors()) do
        connected[mon.name] = true
    end

    ---@type table<string, boolean>
    local wanted = {}
    for _, mon in ipairs(profile.monitors) do
        wanted[mon.output] = true
    end

    for output in pairs(connected) do
        if not wanted[output] then
            return false
        end
    end

    for output in pairs(wanted) do
        if not connected[output] then
            return false
        end
    end

    return true
end

---@return nil
function M.apply_profile()
    for _, profile in ipairs(profiles) do
        if matches(profile) then
            for _, mon in ipairs(profile.monitors) do
                hl.monitor(mon)
            end

            if profile.exec then
                hl.exec_cmd(profile.exec)
            end

            return
        end
    end
end

---@param profiles_list MonitorProfile[]
function M.add_profiles(profiles_list)
    for _, profile in ipairs(profiles_list) do
        table.insert(profiles, profile)
    end
end

hl.on("hyprland.start", function()
    M.apply_profile()
end)

hl.on("config.reloaded", function()
    M.apply_profile()
end)

hl.on("monitor.added", function()
    M.apply_profile()
end)

hl.on("monitor.removed", function()
    M.apply_profile()
end)

-- default
hl.monitor({
    output = "",
    mode = "highres",
    position = "auto",
    scale = "auto",
})

return M
