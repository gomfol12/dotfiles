-- ==================== Plugins ==================== --

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float()
        end,
    },
})

return packer.startup(function(use)
    -- My plugins
    use("wbthomason/packer.nvim")
    use({
        "goolord/alpha-nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    use("windwp/nvim-autopairs")
    use("dstein64/vim-startuptime")
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use("moll/vim-bbye")
    use("rhysd/vim-grammarous")
    use("lewis6991/impatient.nvim")
    -- use("nanozuki/tabby.nvim") -- dont work ??
    use("Shatur/neovim-session-manager")
    use({
        "vimwiki/vimwiki",
        branch = "dev",
        config = function()
            vim.g.vimwiki_list = {
                {
                    path = "~/doc/vimwiki",
                    template_path = "~/doc/vimwiki/templates/",
                    template_default = "default",
                    syntax = "markdown",
                    ext = ".md",
                    path_html = "~/doc/vimwiki/site_html",
                    custom_wiki2html = "vimwiki_markdown",
                    template_ext = ".tpl",
                    auto_diary_index = 1,
                },
            }
            vim.g.vimwiki_global_ext = 0
        end,
    })
    use({
        "lervag/vimtex",
        config = function()
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                options = {
                    "-pdf",
                    "-shell-escape",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }
            vim.g.vimtex_toc_config = {
                name = "TOC",
                split_width = 30,
                todo_sorted = 0,
                show_help = 0,
                show_numbers = 1,
                mode = 2,
            }
        end,
    })
    use({
        "dhruvasagar/vim-table-mode",
        config = function()
            vim.g.table_mode_corner = "|"
        end,
    })
    use("NvChad/nvim-colorizer.lua")
    use("superhawk610/ascii-blocks.nvim")
    use({
        "ggandor/leap.nvim",
        requires = { "tpope/vim-repeat" },
        config = function()
            require("leap").set_default_keymaps()
            vim.cmd("autocmd ColorScheme * lua require('leap').init_highlight(true)")
        end,
    })
    use({
        "aserowy/tmux.nvim",
        config = function()
            require("tmux").setup({
                copy_sync = {
                    enable = false,
                },
            })
        end,
    })
    use("vim-pandoc/vim-pandoc-syntax")
    use("vim-pandoc/vim-pandoc")
    use({
        "lukas-reineke/indent-blankline.nvim",
        setup = function()
            require("indent_blankline").setup()
        end,
    })
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end,
    })

    -- comments
    use("numToStr/Comment.nvim")

    -- color scheme
    use({
        "Mofiqul/vscode.nvim",
        config = function()
            vim.g.vscode_style = "dark"
            vim.cmd([[colorscheme vscode]])
        end,
    })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update({ with_sync = true }))
        end,
        requires = {
            "p00f/nvim-ts-rainbow",
            "nvim-treesitter/playground",
        },
    })
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })

    -- LSP
    use({
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "jayp0521/mason-null-ls.nvim",
            "jayp0521/mason-nvim-dap.nvim",
            "RubixDev/mason-update-all",

            "p00f/clangd_extensions.nvim",

            "mfussenegger/nvim-jdtls",

            "jose-elias-alvarez/null-ls.nvim",
            "nvim-lua/plenary.nvim",

            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
    })

    -- overseer
    use("stevearc/overseer.nvim")

    -- cmp
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",

            "lukas-reineke/cmp-rg",
            "petertriho/cmp-git",
            "nvim-lua/plenary.nvim",
            "hrsh7th/cmp-calc",
            "uga-rosa/cmp-dynamic",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-buffer",

            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",

            "hrsh7th/cmp-omni",
        },
    })

    -- snippets
    use({ "L3MON4D3/LuaSnip", requires = {
        "rafamadriz/friendly-snippets",
    } })

    -- javadoc
    use({
        "danymat/neogen",
        config = function()
            require("neogen").setup({ snippet_engine = "luasnip" })
        end,
        requires = "nvim-treesitter/nvim-treesitter",
    })

    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            "nvim-lua/plenary.nvim",

            "nvim-lua/popup.nvim",
            "nvim-telescope/telescope-ui-select.nvim",

            "JoosepAlviste/nvim-ts-context-commentstring",
        },
    })
end)
