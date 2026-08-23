local PRIMARY = os.getenv("PRIMARY")
local SECONDARY = os.getenv("SECONDARY")

return {
    {
        repo = "zjeffer/split-monitor-workspaces",
        tag = "v0.56.2",
        init = function()
            local smw = require("plugins.split-monitor-workspaces")
            local smw_options = {
                workspace_count = 9,
                enable_wrapping = false,
                keep_focused = true,
                enable_persistent_workspaces = true,
                -- enable_notifications = true,
            }

            if SECONDARY then
                smw_options.monitor_priority = { PRIMARY, SECONDARY }
                smw_options.max_workspaces = {
                    [SECONDARY] = 5,
                }
            elseif PRIMARY then
                smw_options.monitor_priority = { PRIMARY }
                smw_options.max_workspaces = {
                    [PRIMARY] = 9,
                }
            end

            smw.setup(smw_options)
        end,
    },
}
