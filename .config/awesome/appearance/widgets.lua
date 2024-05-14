-- ==================== Custom widgets ==================== --
-- TODO: icons

-- Default libs
local awful = require("awful")
local wibox = require("wibox")

local helper = require("lib.helper")

local _M = {}

local update_timeout = 5
if RC.vars.hostname == os.getenv("HOSTNAME_DESKTOP") then
    update_timeout = 5
elseif RC.vars.hostname == os.getenv("HOSTNAME_LAPTOP") then
    update_timeout = 10
end

-- Mem widget
_M.mem = awful.widget.watch("free", update_timeout, function(widget, stdout, stderr, reason, exit_code)
    if exit_code ~= 0 then
        widget:set_text("-1% (-1MiB)")
        return
    end

    local total, used = stdout:match("Mem:%s+(%d+)%s+(%d+)")
    widget:set_text(math.floor((used / total) * 100) .. "% (" .. math.floor(used / 1024) .. "MiB)")
end)

-- CPU widget
_M.cpu = awful.widget.watch(
    -- field names for first line of /proc/stat (https://www.kernel.org/doc/Documentation/filesystems/proc.txt)
    --      user    nice   system  idle      iowait irq   softirq  steal  guest  guest_nice
    -- cpu  74608   2520   24433   1117073   6176   4054  0        0      0      0
    "sh -c \"grep 'cpu ' /proc/stat && sleep 1 && grep 'cpu ' /proc/stat\"",
    update_timeout,
    function(widget, stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then
            widget:set_text("-1%")
            return
        end

        local data = {}
        for line in helper.magiclines(stdout) do
            for word in line:gmatch("(%d+)") do
                table.insert(data, tonumber(word))
            end
        end

        -- Algorithm to calculate CPU usage percentage
        -- PrevIdle = previdle + previowait
        -- Idle = idle + iowait

        -- PrevNonIdle = prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal
        -- NonIdle = user + nice + system + irq + softirq + steal

        -- PrevTotal = PrevIdle + PrevNonIdle
        -- Total = Idle + NonIdle

        -- differentiate: actual value minus the previous one
        -- totald = Total - PrevTotal
        -- idled = Idle - PrevIdle

        -- CPU_Percentage = (totald - idled)/totald

        local totald = 0
        for i = 11, 18 do
            totald = totald + data[i]
        end
        for i = 1, 8 do
            totald = totald - data[i]
        end
        local idled = (data[14] + data[15]) - (data[4] + data[5])

        widget:set_text(math.floor(((totald - idled) / totald) * 100 + 0.5) .. "%")
    end
)

-- CPU temp widget
_M.cpu_temp = awful.widget.watch("sensors", update_timeout, function(widget, stdout, stderr, reason, exit_code)
    if exit_code ~= 0 then
        widget:set_text("-1°C")
        return
    end

    local temp = -1

    if RC.vars.hostname == os.getenv("HOSTNAME_DESKTOP") then
        temp = stdout:match("Tdie:%s*%+(%d*.%d*).-\n")
    end
    if RC.vars.hostname == os.getenv("HOSTNAME_LAPTOP") then
        temp = stdout:match("Package%sid%s0:%s*%+(%d*.%d*).-\n")
    end

    widget:set_text(math.floor(temp + 0.5) .. "°C")
end)

-- GPU widget only desktop
if RC.vars.hostname == os.getenv("HOSTNAME_DESKTOP") then
    _M.gpu = awful.widget.watch(
        "nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu,temperature.gpu",
        update_timeout,
        function(widget, stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                widget:set_text("-1% -1°C")
                return
            end

            local usage, temp = stdout:match("(%d+),%s(%d+)")
            widget:set_text(usage .. "% " .. temp .. "°C")
        end
    )
end

-- Network widget
local interface = RC.vars.netdev
_M.net = awful.widget.watch(
    "cat /sys/class/net/" .. interface .. "/operstate",
    update_timeout,
    function(widget, stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then
            widget:set_text("󰇚 -1MiB 󰕒 -1MiB")
            return
        end

        if stdout:match("(.*)\n") == "up" then
            awful.spawn.easy_async_with_shell(
                "cat /sys/class/net/"
                    .. interface
                    .. "/statistics/rx_bytes && \
                 cat /sys/class/net/"
                    .. interface
                    .. "/statistics/tx_bytes && \
                 sleep 1 && \
                 cat /sys/class/net/"
                    .. interface
                    .. "/statistics/rx_bytes && \
                 cat /sys/class/net/"
                    .. interface
                    .. "/statistics/tx_bytes",
                function(stdout2, stderr2, reason2, exit_code2)
                    if exit_code2 ~= 0 then
                        widget:set_text("󰇚 -1MiB 󰕒 -1MiB")
                        return
                    end

                    local data = {}
                    for line in helper.magiclines(stdout2) do
                        table.insert(data, tonumber(line))
                    end

                    -- in MiB
                    widget:set_text(
                        "󰇚 "
                            .. string.format("%.1f", (data[3] - data[1]) / 1024 / 1024)
                            .. "MiB 󰕒 "
                            .. string.format("%.1f", (data[4] - data[2]) / 1024 / 1024)
                            .. "MiB"
                    )
                end
            )
        else
            widget:set_text("not connected")
        end
    end
)

-- Audio widget
_M.audio, _M.audio_timer = awful.widget.watch(
    'sh -c "audio.sh info"',
    60,
    function(widget, stdout, stderr, reason, exit_code)
        if exit_code ~= 0 then
            widget:set_text("  -1%")
            return
        end

        local device, sink_volume, sink_mute, mic_mute =
            stdout:match("device:%s(.*)\nsink_volume:%s(%d+)%%\nsink_mute:%s(.*)\nmicrophone_mute:%s(.*)\n")
        sink_volume = tonumber(sink_volume)

        local sink_icon = " "
        if device == "speaker" then
            if sink_mute == "yes" then
                sink_icon = "󰝟 "
            elseif sink_volume < 100 and sink_volume >= 50 then
                sink_icon = " "
            elseif sink_volume < 50 and sink_volume > 0 then
                sink_icon = " "
            elseif sink_volume == 0 then
                sink_icon = " "
            end
        elseif device == "headphones" then
            if sink_mute == "yes" then
                sink_icon = "󰟎 "
            else
                sink_icon = "󰋋 "
            end
        else
            sink_icon = "󰝟 "
        end

        local mic_icon = " "
        if mic_mute == "yes" then
            mic_icon = " "
        end

        widget:set_text(sink_icon .. " " .. sink_volume .. "% " .. mic_icon)
    end
)

-- Battery widget only laptop
local batdev = RC.vars.batdev
if RC.vars.hostname == os.getenv("HOSTNAME_LAPTOP") then
    _M.bat = awful.widget.watch(
        "cat /sys/class/power_supply/" .. batdev .. "/charge_full /sys/class/power_supply/" .. batdev .. "/charge_now",
        60,
        function(widget, stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                widget:set_text("-1%")
                return
            end

            local charge_full, charge_now = stdout:match("(%d+)\n(%d+)")
            widget:set_text(string.format("%.0f%%", ((100 / tonumber(charge_full)) * tonumber(charge_now)) + 0.5))
        end
    )
end

if RC.vars.hostname == os.getenv("HOSTNAME_LAPTOP") then
    _M.brightness, _M.brightness_timer = awful.widget.watch(
        "brillo",
        0,
        function(widget, stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                widget:set_text("-1%")
                return
            end
            local brightness = stdout:match("(%d*.%d*)")
            widget:set_text(brightness .. "%")
        end
    )
end

_M.weather = awful.widget.watch("weather.sh", 900, function(widget, stdout, stderr, reason, exit_code)
    if exit_code ~= 0 then
        widget:set_text("no weather data")
        return
    end

    widget:set_text(stdout:match("(.*)\n"))
end)

-- _M.updates = wibox.widget({
--     text = "",
--     widget = wibox.widget.textbox,
--     set_updates = function(self, val)
--         if val == 0 then
--             self.text = " |"
--             self.visible = true
--         else
--             self.visible = false
--         end
--     end,
-- })
-- _M.updates_timer = gears.timer({
--     timeout = 3600,
--     call_now = true,
--     autostart = true,
--     callback = function()
--         awful.spawn.easy_async_with_shell("checkupdates", function(stdout, stderr, reason, exit_code)
--             if exit_code == 1 then
--                 _M.updates.updates = "Err: checkupdates"
--                 return
--             end
--             if exit_code == 0 then
--                 _M.updates.updates = 0
--             end
--         end)
--     end,
-- })

return _M
