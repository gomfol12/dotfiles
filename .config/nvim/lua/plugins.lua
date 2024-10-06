-- ==================== Plugins ==================== --
-- TODO: diffview, smart-splits.nvim, https://github.com/MeanderingProgrammer/markdown.nvim, hologram.nvim

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
    use("j-hui/fidget.nvim")
    use("github/copilot.vim")
    use({ "folke/which-key.nvim", requires = { "echasnovski/mini.icons" } })
    use("mbbill/undotree")
    use("rcarriga/nvim-notify") -- TODO: vigoux/notifier.nvim
    -- use("kwkarlwang/bufresize.nvim")
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
    -- use("Konfekt/vim-CtrlXA") -- TODO: AndrewRadev/switch.vim, monaqa/dial.nvim
    use("paretje/nvim-man")
    use("LunarVim/bigfile.nvim")
    use({ "michaelb/sniprun", run = "sh ./install.sh" }) -- run code snippets
    use({ "meain/vim-printer" })
    use({ "gomfol12/a.vim" })
    use({ "smjonas/inc-rename.nvim" })
    use({ "nacro90/numb.nvim" })
    use({ "andymass/vim-matchup" })
    use({ "gbprod/stay-in-place.nvim" })
    use({ "frabjous/knap" }) -- markdown, latex live preview
    use("dfendr/clipboard-image.nvim")
    use("jbyuki/nabla.nvim")
    use("fladson/vim-kitty")
    use({ "knubie/vim-kitty-navigator", run = "cp ./*.py ~/.config/kitty/" })
    use({
        "olimorris/codecompanion.nvim",
        config = function()
            require("codecompanion").setup()
        end,
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
            "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
            "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        },
    })

    use("benlubas/molten-nvim")
    use("3rd/image.nvim")

    use("quarto-dev/quarto-nvim")
    use("jmbuhr/otter.nvim")

    use("goerz/jupytext.vim")

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
            "nvim-treesitter/playground",
        },
    })
    use({ "nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" })
    use("HiPhish/rainbow-delimiters.nvim")

    -- LSP
    use({
        "neovim/nvim-lspconfig",
        requires = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "jayp0521/mason-nvim-dap.nvim",
            "RubixDev/mason-update-all",

            "p00f/clangd_extensions.nvim",

            "mfussenegger/nvim-jdtls",

            "scalameta/nvim-metals",
            "nvim-lua/plenary.nvim",

            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",

            "mfussenegger/nvim-dap-python",

            "simrat39/rust-tools.nvim",

            "stevearc/conform.nvim",
            "mfussenegger/nvim-lint",
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
            "jmbuhr/cmp-pandoc-references",
            "hrsh7th/cmp-emoji",
            "ray-x/cmp-treesitter",
            -- "f3fora/cmp-spell",

            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",

            "hrsh7th/cmp-omni",
        },
    })

    -- snippets
    use({
        "L3MON4D3/LuaSnip",
        run = "make install_jsregexp",
        requires = {
            "rafamadriz/friendly-snippets",
        },
    })

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
