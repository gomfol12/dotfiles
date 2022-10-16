return {
    name = "run current file",
    builder = function()
        local file = vim.fn.expand("%:p")
        return {
            cmd = file,
            components = {
                { "on_output_quickfix", set_diagnostics = true },
                "on_result_diagnostics",
                "default",
            },
        }
    end,
    condition = {
        filetype = { "sh", "python" },
    },
}
