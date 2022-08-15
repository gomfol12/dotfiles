-- ==================== Global Buttons ==================== --

-- Default libs
local gears = require("gears")
local awful = require("awful")

return gears.table.join(awful.button({}, 3, function()
    RC.menu:toggle()
end))
