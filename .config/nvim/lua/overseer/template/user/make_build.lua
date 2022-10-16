return {
    name = "make",
    builder = function()
        local pwd = vim.fn.getcwd()
        return {
            cmd = { "make" },
            args = { "-C", pwd .. "/build" },
            components = { { "on_output_quickfix", open = true }, "default" },
        }
    end,
    condition = {
        filetype = { "cpp" },
    },
}
