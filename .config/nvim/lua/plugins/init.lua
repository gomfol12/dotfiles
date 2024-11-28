-- ==================== Plugins ==================== --
-- This file contains general plugins or plugins with litte to no configuration.
-- TODO: overseer, some kind of colorizer, test debug

-- Maybe useful some time
-- { "frabjous/knap" }
-- { "monaqa/dial.nvim" },
-- { "AndrewRadev/switch.vim" },

return {
    { "tpope/vim-sleuth" }, -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-fugitive" }, -- Git wrapper
    { "sindrets/diffview.nvim" },
    {
        lazy = false,
        "rhysd/vim-grammarous",
        keys = { { "<leader>gg", ":GrammarousCheck --lang=de<CR>", desc = "Grammarous check" } },
    },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
    { "Konfekt/vim-CtrlXA" },
    { "gomfol12/a.vim", lazy = true, ft = { "c", "cpp" } },
    { "stevearc/overseer.nvim" },
    -- { "vim-pandoc/vim-pandoc-syntax" },
    -- { "vim-pandoc/vim-pandoc" },
    { "fladson/vim-kitty", lazy = false },
    { "knubie/vim-kitty-navigator", lazy = false, build = "cp ./*.py ~/.config/kitty/" },
    { "LunarVim/bigfile.nvim", config = true },
    { "gbprod/stay-in-place.nvim", config = true },
    { "bullets-vim/bullets.vim", lazy = true, ft = { "markdown", "pandoc" } },
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme vscode]])
        end,
    },
    { "numToStr/Comment.nvim", opts = {
        ignore = "^$",
    } },
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
    -- {
    --     "echasnovski/mini.nvim",
    --     config = function()
    --         require("mini.ai").setup({ n_lines = 500 })
    --         require("mini.surround").setup()
    --     end,
    -- },
    {
        "dhruvasagar/vim-table-mode",
        init = function()
            vim.g.table_mode_corner = "|"
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
    {
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    {
        "jbyuki/nabla.nvim",
        lazy = true,
        ft = { "markdown", "vimwiki", "tex", "pandoc" },
        keys = {
            {
                "<leader>na",
                function()
                    require("nabla").popup()
                end,
            },
        },
    },
    -- {
    --     "goerz/jupytext.vim",
    --     init = function()
    --         vim.g.jupytext_filetype_map = { ["md"] = "quarto" }
    --     end,
    -- },
    {
        "GCBallesteros/jupytext.nvim",
        opts = {
            style = "hydrogen",
            output_extension = "auto", -- don't change
            force_ft = nil, -- don't change
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        },
    },
    {
        "danymat/neogen",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        keys = {
            {
                "<Leader>nf",
                function()
                    require("neogen").generate()
                end,
                desc = "Neogen generate",
            },
        },
        opts = { snippet_engine = "luasnip" },
    },
    {
        "3rd/image.nvim",
        ft = { "markdown", "vimwiki", "pandoc" },
        dependencies = { "leafo/magick" },
        opts = {
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    only_render_image_at_cursor = true,
                    filetypes = { "markdown", "vimwiki", "pandoc" },
                },
            },
            window_overlap_clear_enabled = true,
        },
    },
    {
        "HakonHarnes/img-clip.nvim",
        lazy = true,
        cmd = { "PasteImage" },
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
    -- {
    --     "lukas-reineke/headlines.nvim",
    --     lazy = true,
    --     ft = { "markdown", "pandoc" },
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     config = function()
    --         vim.cmd([[highlight Headline1 guibg=#2b2b2b]])
    --         vim.cmd([[highlight CodeBlock guibg=#1c1c1c]])
    --         vim.cmd([[highlight Dash guibg=#D19A66 gui=bold]])

    --         require("headlines").setup({
    --             markdown = {
    --                 headline_highlights = { "Headline1" },
    --                 bullets = { "#", "##", "###", "####", "#####", "######" },
    --             },
    --             pandoc = {},
    --         })
    --     end,
    -- },
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
    {
        "iamcco/markdown-preview.nvim",
        lazy = true,
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
        "jghauser/auto-pandoc.nvim",
        lazy = true,
        ft = "markdown",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.api.nvim_create_user_command("AutoPandoc", function()
                require("auto-pandoc").run_pandoc()
            end, {})
        end,
    },
    {
        "michaelb/sniprun",
        lazy = true,
        cmd = { "SnipRun" },
        cond = function()
            return vim.bo.filetype ~= "quarto"
        end,
        build = "sh ./install.sh",
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
