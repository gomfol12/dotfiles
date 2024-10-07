-- ==================== Plugins ==================== --
-- This file contains general plugins or plugins with litte to no configuration.

return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme vscode]])
        end,
    },
    { "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
    {
        "moll/vim-bbye",
        keys = {
            { "<leader>x", ":Bdelete<CR>", desc = "Delete buffer" }, -- Bdelete
        },
    },
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },
    {
        "echasnovski/mini.nvim",
        config = function()
            -- require("mini.ai").setup({ n_lines = 500 })
            -- require("mini.surround").setup()
        end,
    },
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = {
            {
                "<leader>o",
                function()
                    vim.cmd((vim.bo.filetype == "oil") and "bd" or "Oil --float")
                end,
            },
        },
        opts = {
            view_options = {
                show_hidden = true,
            },
            keymaps_help = {
                border = "single",
            },
            float = {
                border = "single",
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    { "fladson/vim-kitty" },
    { "knubie/vim-kitty-navigator", build = "cp ./*.py ~/.config/kitty/" },
    { "tpope/vim-fugitive" },
    { "sindrets/diffview.nvim" },
    { "rhysd/vim-grammarous" },
    {
        "dhruvasagar/vim-table-mode",
        init = function()
            vim.g.table_mode_corner = "|"
        end,
    },
    {
        "ggandor/leap.nvim",
        dependencies = {
            { "tpope/vim-repeat" },
            {
                "ggandor/leap-spooky.nvim",
                opts = {
                    affixes = {
                        remote = { window = "r", cross_window = "R" },
                        magnetic = { window = "m", cross_window = "M" },
                    },
                    -- automatically pasted yanked text at cursor position, if unnamed register is set
                    paste_on_remote_yank = false,
                },
            },
            {
                "ggandor/flit.nvim",
                opts = {
                    keys = { f = "f", F = "F", t = "t", T = "T" },
                    labeled_modes = "v",
                    multiline = true,
                    opts = {},
                },
            },
            { "ggandor/leap-ast.nvim" },
        },
        config = function()
            require("leap").add_default_mappings()
            vim.cmd("autocmd ColorScheme * lua require('leap').init_highlight(true)")
        end,
    },
    { "aserowy/tmux.nvim", opts = {
        copy_sync = {
            enable = false,
        },
    } },
    { "vim-pandoc/vim-pandoc-syntax" },
    { "vim-pandoc/vim-pandoc" },
    {
        "github/copilot.vim",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        config = function()
            vim.cmd([[imap <silent><script><expr> <C-q> copilot#Accept("\<CR>")]])

            vim.cmd([[au BufNewFile,BufRead * let b:copilot_enabled = 0]])

            -- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
            --     pattern = "*",
            --     callback = function()
            --         vim.bo.copilot_enabled = 0
            --     end,
            -- })
            -- vim.api.nvim_create_user_command("CopilotEnable", function()
            --     vim.bo.copilot_enabled = 1
            -- end, { nargs = 0, desc = "Enable copilot" })
        end,
    },
}
