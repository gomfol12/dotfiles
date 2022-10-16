return {
    name = "cmake debug build",
    builder = function()
        local pwd = vim.fn.getcwd()
        return {
            cmd = { "cmake" },
            args = { "-S", pwd, "-B", pwd .. "/build", "-D", "CMAKE_BUILD_TYPE=Debug" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
