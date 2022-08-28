-- ==================== Custom widgets ==================== --

-- Default libs
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local helper = require("lib.helper")

local _M = {}

_M.mem = awful.widget.watch("free", 5, function(widget, stdout)
    local total, used = stdout:match("Mem:%s+(%d+)%s+(%d+)")
    widget:set_text(math.floor(100 / total * used) .. "% (" .. math.floor(used / 1024) .. "MiB)")
end)

_M.cpu = wibox.widget({
    text = "0%",
    widget = wibox.widget.textbox,
    set_cpu = function(self, num)
        self.text = math.floor(num + 0.5) .. "%"
    end,
})
_M.cpu_timer = gears.timer({
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell(
            -- field names for first line of /proc/stat (https://www.kernel.org/doc/Documentation/filesystems/proc.txt)
            --      user    nice   system  idle      iowait irq   softirq  steal  guest  guest_nice
            -- cpu  74608   2520   24433   1117073   6176   4054  0        0      0      0
            "grep 'cpu ' /proc/stat && sleep 1 && grep 'cpu ' /proc/stat",
            function(stdout, stderr, reason, exit_code)
                if exit_code ~= 0 then
                    _M.cpu.cpu = "Err: In cpu widget"
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

                _M.cpu.cpu = ((totald - idled) / totald) * 100
            end
        )
    end,
})

_M.cpu_temp = awful.widget.watch("sensors", 5, function(widget, stdout)
    local temp = stdout:match("Tdie:%s*%+(%d*.%d*).-\n")
    widget:set_text(math.floor(temp + 0.5) .. "°C")
end)

_M.gpu = awful.widget.watch(
    "nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu,temperature.gpu",
    5,
    function(widget, stdout)
        local usage, temp = stdout:match("(%d+),%s(%d+)")
        widget:set_text(usage .. "% " .. temp .. "°C")
    end
)

_M.net = wibox.widget({
    text = " 0.0MiB 祝 0.0MiB",
    widget = wibox.widget.textbox,
    set_net = function(self, vals)
        if vals.state == "up" then
            self.text = " "
                .. string.format("%.1f", vals.received)
                .. "MiB 祝 "
                .. string.format("%.1f", vals.transmitted)
                .. "MiB"
        else
            self.text = "not connected"
        end
    end,
})
_M.net_timer = gears.timer({
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        local interface = RC.vars.netdev

        awful.spawn.easy_async_with_shell("cat /sys/class/net/" .. interface .. "/statistics/rx_bytes && \
                 cat /sys/class/net/" .. interface .. "/statistics/tx_bytes && \
                 sleep 1 && \
                 cat /sys/class/net/" .. interface .. "/statistics/rx_bytes && \
                 cat /sys/class/net/" .. interface .. "/statistics/tx_bytes && \
                 cat /sys/class/net/" .. interface .. "/operstate", function(stdout, stderr, reason, exit_code)
            if exit_code ~= 0 then
                _M.net.net = "Err: In net widget"
                return
            end

            local data = {}
            local interface_state = "unknown"
            for line in helper.magiclines(stdout) do
                if line == "up" then
                    interface_state = "up"
                    goto continue
                end
                table.insert(data, tonumber(line))
                ::continue::
            end
            -- in MiB
            _M.net.net = {
                state = interface_state,
                received = (data[3] - data[1]) / 1024 / 1024,
                transmitted = (data[4] - data[2]) / 1024 / 1024,
            }
        end)
    end,
})

_M.audio, _M.audio_timer = awful.widget.watch(
    'sh -c "audio.sh volume get && audio.sh device"',
    60,
    function(widget, stdout)
        local volume, device = stdout:match("(%d+)%%\n(.+)\n")
        volume = tonumber(volume)

        local icon = "  "
        if device == "speaker" then
            if volume < 80 and volume >= 40 then
                icon = "墳 "
            elseif volume < 40 and volume > 0 then
                icon = "  "
            elseif volume == 0 then
                icon = "  "
            end
        elseif device == "headphones" then
            icon = "  "
        end
        widget:set_text(icon .. volume .. "%")
    end
)

_M.updates = wibox.widget({
    text = "",
    widget = wibox.widget.textbox,
    set_updates = function(self, val)
        if val == 0 then
            self.text = " |"
            self.visible = true
        else
            self.visible = false
        end
    end,
})
_M.updates_timer = gears.timer({
    timeout = 3600,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell("checkupdates", function(stdout, stderr, reason, exit_code)
            if exit_code == 1 then
                _M.updates.updates = "Err: checkupdates"
                return
            end
            if exit_code == 0 then
                _M.updates.updates = 0
            end
        end)
    end,
})

return _M
