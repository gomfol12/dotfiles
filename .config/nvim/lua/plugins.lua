-- ==================== Plugins ==================== --
-- TODO: alpha custom buttons dont work

-- Automatically install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
    -- My plugins
    use 'wbthomason/packer.nvim'
    use {
        'goolord/alpha-nvim',
        requires = { 'kyazdani42/nvim-web-devicons' },
        config = function ()
            require'alpha'.setup(require'alpha.themes.startify'.opts)
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.buttons.val = {
                dashboard.button("e", "new file", ":ene <bar> startinsert <cr>"),
                dashboard.button("v", "neovim config", ":e ~/.config/nvim/init.lua<cr>"),
                dashboard.button("q", "quit nvim", ":qa<cr>"),
            }
            --vim.api.nvim_set_keymap('n', '<c-n>', ":Alpha<cr>", { noremap = true })
        end
    }
    use 'windwp/nvim-autopairs'
    use 'dstein64/vim-startuptime'

    -- colorscheme
    use {
        'Mofiqul/vscode.nvim',
        config = function()
            vim.g.vscode_style = "dark"
            vim.cmd[[colorscheme vscode]]
        end
    }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ":TSUpdate"
    }
    use 'p00f/nvim-ts-rainbow'

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'williamboman/nvim-lsp-installer'
    use 'ray-x/lsp_signature.nvim'

    -- cmp
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use 'hrsh7th/nvim-cmp'
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lua'

    -- snippets
    use 'L3MON4D3/LuaSnip'
    use 'rafamadriz/friendly-snippets'

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use 'nvim-lua/popup.nvim'
    use 'nvim-telescope/telescope-media-files.nvim'

    -- to add: nvim-ts-context-commentstring

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)