-- ==================== Debug (nvim-dap, ...) ==================== --

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",

        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        "mfussenegger/nvim-dap-python",
    },
    keys = function(_, keys)
        local dap = require("dap")
        local dapui = require("dapui")
        return {
            { "<F5>", dap.continue, desc = "Debug: Start/Continue" },
            { "<F10>", dap.step_over, desc = "Debug: Step Over" },
            { "<F11>", dap.step_into, desc = "Debug: Step Into" },
            { "<F12>", dap.step_out, desc = "Debug: Step Out" },
            { "<leader>b", dap.toggle_breakpoint, desc = "Debug: Toggle Breakpoint" },
            {
                "<leader>B",
                function()
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end,
                desc = "Debug: Set Breakpoint",
            },
            { "<F7>", dapui.toggle, desc = "Debug: See last session result." },
            unpack(keys),
        }
    end,
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                "javadbg",
                "javatest",
                "debugpy",
            },
        })

        dapui.setup(vim.g.have_nerd_font and {
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            controls = {
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "",
                    terminate = "",
                },
            },
            floating = {
                border = "single",
            },
        } or {})

        if vim.g.have_nerd_font then
            vim.fn.sign_define("DapBreakpoint", { text = "󱀔 ", texthl = "", linehl = "", numhl = "" })
            vim.fn.sign_define("DapStopped", { text = "󱀒 ", texthl = "", linehl = "", numhl = "" })
        end

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Daps setup
        local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")
        require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")

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
    end,
}
