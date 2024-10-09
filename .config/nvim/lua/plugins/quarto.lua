return {
    "quarto-dev/quarto-nvim",
    ft = { "quarto" },
    dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
        {
            "benlubas/molten-nvim",
            init = function()
                vim.g.molten_image_provider = "image.nvim"
                vim.g.molten_output_win_max_height = 20
                vim.g.molten_auto_open_output = true
                vim.g.molten_copy_output = true
            end,
        },
    },
    keys = {
        {
            "<leader>qp",
            function()
                require("quarto.runner").quartoPreview()
            end,
            desc = "QMD: Preview",
        },
        {
            "<leader>rc",
            function()
                require("quarto.runner").run_cell()
            end,
            desc = "QMD: Run cell",
        },
        {
            "<leader>ra",
            function()
                require("quarto.runner").run_above()
            end,
            desc = "QMD: Run cell and above",
        },
        {
            "<leader>rA",
            function()
                require("quarto.runner").run_all()
            end,
            desc = "QMD: Run all",
        },
        {
            "<leader>rl",
            function()
                require("quarto.runner").run_line()
            end,
            desc = "QMD: Run line",
        },
        {
            "<leader>r",
            function()
                require("quarto.runner").run_range()
            end,
            mode = "v",
            desc = "QMD: Run visual range",
        },
    },
    opts = {
        debug = false,
        closePreviewOnExit = true,
        lspFeatures = {
            enabled = true,
            languages = { "r", "python", "julia", "bash" },
            chunks = "curly", -- 'curly' or 'all'
            diagnostics = {
                enabled = true,
                triggers = { "BufWritePost" },
            },
            completion = {
                enabled = true,
            },
        },
        codeRunner = {
            enabled = true,
            default_method = "molten",
            ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
            -- Takes precedence over `default_method`
            never_run = { "yaml" }, -- filetypes which are never sent to a code runner
        },
        keymap = {
            hover = "K",
            definition = "gd",
            rename = "F2",
            references = "gr",
        },
    },
}
