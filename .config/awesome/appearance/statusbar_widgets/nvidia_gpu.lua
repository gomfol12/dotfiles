return setmetatable({}, {
    __call = function(format, warg)
        local f = io.popen("nvidia-smi --format=csv,noheader --query-gpu=temperature.gpu")
        if f == nil then
            return { -1 }
        end
        local gpu_temp = f:read("*all")
        f:close()

        f = io.popen("nvidia-smi --format=csv,noheader,nounits --query-gpu=utilization.gpu")
        if f == nil then
            return { -1 }
        end
        local gpu_util = f:read("*all")
        f:close()

        return { tonumber(gpu_util), tonumber(gpu_temp) }
    end,
})
