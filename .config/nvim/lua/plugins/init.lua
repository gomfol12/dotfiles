-- ==================== Plugins ==================== --
-- This file contains general plugins or plugins with litte to no configuration.

-- Maybe useful some time
-- frabjous/knap

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
    { "fladson/vim-kitty", lazy = false },
    { "knubie/vim-kitty-navigator", lazy = false, build = "cp ./*.py ~/.config/kitty/" },
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
    {
        "aserowy/tmux.nvim",
        opts = {
            copy_sync = {
                enable = false,
            },
        },
    },
    -- { "vim-pandoc/vim-pandoc-syntax" },
    -- { "vim-pandoc/vim-pandoc" },
    {
        "github/copilot.vim",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        config = function()
            vim.cmd([[imap <silent><script><expr> <C-q> copilot#Accept("\<CR>")]])

            vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
                pattern = "*",
                callback = function()
                    vim.b.copilot_enabled = 0
                end,
            })

            vim.api.nvim_create_user_command("CopilotEnable", function()
                vim.b.copilot_enabled = 1
            end, {})

            vim.api.nvim_create_user_command("CopilotDisable", function()
                vim.b.copilot_enabled = 0
            end, {})
        end,
    },
    {
        "mbbill/undotree",
        init = function()
            vim.g.undotree_WindowLayout = 3
        end,
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                enabled = false,
            },
        },
    },
    { "tpope/vim-surround" },
    {
        "tpope/vim-speeddating",
        config = function()
            vim.cmd([[
SpeedDatingFormat %d%[/-\\.]%m%1%Y
SpeedDatingFormat %d%[/-\\.]%m%1%Y +%H:%M
SpeedDatingFormat %d%[/-\\.]%m%1%Y +%H:%M:%S
SpeedDatingFormat %d%[/-\\.]%m%1%Y+%H:%M
SpeedDatingFormat %d%[/-\\.]%m%1%Y+%H:%M:%S
SpeedDatingFormat %d%[/-\\.]%m%1%Y %H:%M
SpeedDatingFormat %d%[/-\\.]%m%1%Y %H:%M:%S
SpeedDatingFormat %H:%M
SpeedDatingFormat %H:%M:%S
SpeedDatingFormat %H %M
SpeedDatingFormat %H %M %S
        ]])
        end,
    },
    { "tpope/vim-unimpaired" },
    { "Konfekt/vim-CtrlXA" },
    -- { "monaqa/dial.nvim" },
    -- { "AndrewRadev/switch.vim" },
    { "LunarVim/bigfile.nvim", opts = {} },
    { "gomfol12/a.vim" },
    {
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    { "gbprod/stay-in-place.nvim", opts = {} },
    {
        "jbyuki/nabla.nvim",
        keys = {
            {
                "<leader>na",
                function()
                    require("nabla").popup()
                end,
            },
        },
    },
    {
        "3rd/image.nvim",
        dependencies = { "leafo/magick" },
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    only_render_image_at_cursor = true,
                    filetypes = { "markdown", "vimwiki" },
                },
            },
            window_overlap_clear_enabled = true,
        },
    },
    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            default = {
                dir_path = "res",
                file_name = "%d.%m.%Y-%H-%M-%S",
                extension = "png",
            },
        },
        keys = {
            { "<leader>pp", ":PasteImage<CR>", desc = "Paste image from system clipboard" },
        },
    },
    {
        "lukas-reineke/headlines.nvim",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            vim.cmd([[highlight Headline1 guibg=#2b2b2b]])
            vim.cmd([[highlight CodeBlock guibg=#1c1c1c]])
            vim.cmd([[highlight Dash guibg=#D19A66 gui=bold]])

            require("headlines").setup({
                markdown = {
                    headline_highlights = { "Headline1" },
                    bullets = { "#", "##", "###", "####", "#####", "######" },
                },
            })
        end,
    },
    {
        "hedyhli/outline.nvim",
        lazy = true,
        cmd = { "Outline", "OutlineOpen" },
        opts = {
            outline_window = {
                position = "right",
            },
            symbols = {
                icon_source = "lspkind",
            },
        },
    },
    { "bullets-vim/bullets.vim" },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function(plugin)
            if vim.fn.executable("npx") then
                vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
            else
                vim.cmd([[Lazy load markdown-preview.nvim]])
                vim.fn["mkdp#util#install"]()
            end
        end,
        init = function()
            if vim.fn.executable("npx") then
                vim.g.mkdp_filetypes = { "markdown" }
            end
        end,
    },
    {
        "quarto-dev/quarto-nvim",
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = true,
    },
    {
        "goerz/jupytext.vim",
        init = function()
            vim.g.jupytext_filetype_map = { ["md"] = "quarto" }
        end,
    },
    {
        "benlubas/molten-nvim",
        init = function()
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
            vim.g.molten_auto_open_output = true
            vim.g.molten_copy_output = true
        end,
    },
    { "numToStr/Comment.nvim", opts = {
        ignore = "^$",
    } },
    { "stevearc/overseer.nvim" },
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "michaelb/sniprun",
        lazy = false,
        build = "sh ./install.sh",
        cond = function()
            return vim.bo.filetype ~= "quarto"
        end,
        keys = {
            { "<leader>r", "<Plug>SnipRun", mode = "v", desc = "Run code" },
            { "<leader>rr", "<Plug>SnipRun", desc = "Run code" },
            { "<leader>rc", "<Plug>SnipClose", desc = "Close code" },
            {
                "<F3>",
                ":let b:caret=winsaveview() <CR> | :%SnipRun <CR>| :call winrestview(b:caret) <CR>",
                desc = "Run code",
            },
        },
    },
}
