-- ==================== Plugins ==================== --
-- TODO: diffview

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
    use({
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use("tpope/vim-fugitive")
    use("sindrets/diffview.nvim")
    use("moll/vim-bbye")
    use("rhysd/vim-grammarous")
    use("lewis6991/impatient.nvim")
    use("nanozuki/tabby.nvim")
    use({
        "jedrzejboczar/possession.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })
    use({ "vimwiki/vimwiki", branch = "dev" })
    use("lervag/vimtex")
    use("dhruvasagar/vim-table-mode")
    use("NvChad/nvim-colorizer.lua")
    use("superhawk610/ascii-blocks.nvim")
    use({ "ggandor/leap.nvim", requires = { "tpope/vim-repeat" } })
    use({ "ggandor/leap-spooky.nvim", requires = { "ggandor/leap.nvim" } })
    use({ "ggandor/flit.nvim", requires = { "ggandor/leap.nvim" } })
    use({ "ggandor/leap-ast.nvim", requires = { "ggandor/leap.nvim" } })
    use("aserowy/tmux.nvim")
    use("vim-pandoc/vim-pandoc-syntax")
    use("vim-pandoc/vim-pandoc")
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })
    use("lukas-reineke/indent-blankline.nvim")
    use({ "j-hui/fidget.nvim", tag = "legacy" })
    use("github/copilot.vim")
    use("folke/which-key.nvim")
    use("mbbill/undotree")
    use("rcarriga/nvim-notify")
    -- use("kwkarlwang/bufresize.nvim")
    use({ "akinsho/toggleterm.nvim", tag = "*" })
    use("junegunn/goyo.vim")
    use("stevearc/dressing.nvim")
    use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })
    use("luukvbaal/statuscol.nvim")
    use({
        "aaronhallaert/advanced-git-search.nvim",
        requires = {
            "nvim-telescope/telescope.nvim",
            "tpope/vim-fugitive",
            "tpope/vim-rhubarb",
            "sindrets/diffview.nvim",
        },
    })
    use("tpope/vim-surround")
    use("tpope/vim-repeat")
    use("tpope/vim-speeddating")
    -- use("tpope/vim-unimpaired")
    -- use("Konfekt/vim-CtrlXA") -- TODO: AndrewRadev/switch.vim
    use("paretje/nvim-man")
    use("LunarVim/bigfile.nvim")
    use({ "michaelb/sniprun", run = "sh ./install.sh" })
    use({
        "LintaoAmons/scratch.nvim",
        event = "VimEnter",
    })
    use({ "meain/vim-printer" })
    use({ "gomfol12/a.vim" })

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
    -- use({
    --     "projekt0n/github-nvim-theme",
    --     config = function()
    --         vim.cmd([[colorscheme github_dark_high_contrast]])
    --     end,
    -- })

    -- Treesitter
    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
            pcall(require("nvim-treesitter.install").update({ with_sync = true }))
        end,
        requires = {
            "nvim-treesitter/playground",
        },
    })
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
    use({ "HiPhish/nvim-ts-rainbow2", after = "nvim-treesitter" })

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

            "simrat39/rust-tools.nvim",
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

            "nvim-telescope/telescope-frecency.nvim",
            "kkharji/sqlite.lua",
        },
    })
    use({
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
    })
end)
