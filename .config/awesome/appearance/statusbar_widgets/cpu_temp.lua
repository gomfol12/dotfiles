return setmetatable({}, {
    __call = function(format, warg)
        local f = io.popen("sensors")
        if f == nil then
            return { -1 }
        end
        local lm_sensors = f:read("*all")
        f:close()

        local cpu_temp = tonumber(string.match(lm_sensors, "Tdie:%s*%+(%d*.%d*).-\n"))

        return { math.floor(cpu_temp + 0.5) }
    end,
})
