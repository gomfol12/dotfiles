-- ==================== dap (nvim-dap) ==================== --
-- NOTE: install lldb

local status_ok, dap = pcall(require, "dap")
if not status_ok then
    return
end

vim.fn.sign_define("DapBreakpoint", { text = "👉", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "✋", texthl = "", linehl = "", numhl = "" })

dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb",
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
