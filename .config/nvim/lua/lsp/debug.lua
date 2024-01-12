-- ==================== dap (nvim-dap) ==================== --
-- NOTE: install lldb

local dap_ok, dap = pcall(require, "dap")
local mason_dap_ok, mason_dap = pcall(require, "mason-nvim-dap")
local python_dap_ok, python_dap = pcall(require, "dap-python")

if not dap_ok and not mason_dap_ok and not python_dap_ok then
    return
end

mason_dap.setup({
    ensure_installed = {
        "javadbg",
        "javatest",
        "debugpy",
    },
})

local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
python_dap.setup(mason_path .. "packages/debugpy/venv/bin/python")

vim.fn.sign_define("DapBreakpoint", { text = "👉", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "✋", texthl = "", linehl = "", numhl = "" })

dap.defaults.fallback.external_terminal = {
    command = "st",
    args = { "-e" },
}

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

dap.configurations.scala = {
    {
        type = "scala",
        request = "launch",
        name = "RunOrTest",
        metals = {
            runType = "runOrTestFile",
        },
    },
    {
        type = "scala",
        request = "launch",
        name = "Test Target",
        metals = {
            runType = "testTarget",
        },
    },
}
