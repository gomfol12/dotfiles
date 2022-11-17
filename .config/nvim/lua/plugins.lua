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
    --[[ use("dstein64/vim-startuptime") ]]
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use({
        "APZelos/blamer.nvim",
        config = function()
            vim.g.blamer_enabled = 1
            vim.g.blamer_date_format = "%d.%m.%Y %H:%M"
        end,
    })
    use("moll/vim-bbye")
    use("rhysd/vim-grammarous")
    use("lewis6991/impatient.nvim")
    use({
        "preservim/vimux",
        config = function()
            vim.g.VimuxCloseOnExit = 1
        end,
    })
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

    -- comments
    use("numToStr/Comment.nvim")
    use("JoosepAlviste/nvim-ts-context-commentstring")

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
        run = ":TSUpdate",
    })
    use("nvim-treesitter/nvim-treesitter-textobjects")
    use("p00f/nvim-ts-rainbow")
    use("nvim-treesitter/playground")

    -- LSP
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("neovim/nvim-lspconfig")
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use("jayp0521/mason-null-ls.nvim")
    use("RubixDev/mason-update-all")
    use("p00f/clangd_extensions.nvim")
    use("mfussenegger/nvim-jdtls")

    -- dap
    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("jayp0521/mason-nvim-dap.nvim")

    -- overseer
    use("stevearc/overseer.nvim")

    -- cmp
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/nvim-cmp")
    use("saadparwaiz1/cmp_luasnip")
    use("hrsh7th/cmp-nvim-lua")
    use("f3fora/cmp-spell")
    use("hrsh7th/cmp-calc")
    use("kdheepak/cmp-latex-symbols")
    use("hrsh7th/cmp-omni")
    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("dmitmel/cmp-cmdline-history")

    -- snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

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
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope-media-files.nvim")
    use("nvim-telescope/telescope-ui-select.nvim")
end)
