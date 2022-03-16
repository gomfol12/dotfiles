-- ==================== Settings ==================== --

local utils = require("utils")

local cmd = vim.cmd
local indent = 4

--cmd 'syntax on'
cmd("filetype plugin indent on") -- Enabling Plugin & Indent
utils.opt("o", "encoding", "UTF-8")
utils.opt("o", "autoread", true)
utils.opt("o", "wildmenu", true)
utils.opt("o", "wildmode", "list:longest") -- autocompletion
utils.opt("o", "completeopt", "menuone,noselect")
utils.opt("w", "number", true)
utils.opt("w", "relativenumber", true)
utils.opt("o", "backspace", "indent,eol,start") -- Making sure backspace works
utils.opt("o", "ruler", true) -- setting rulers & spacing, tabs
utils.opt("o", "confirm", true)
utils.opt("b", "shiftwidth", indent)
utils.opt("b", "autoindent", true)
utils.opt("b", "smartindent", true)
utils.opt("b", "tabstop", indent)
utils.opt("b", "softtabstop", indent)
utils.opt("b", "expandtab", true)
utils.opt("o", "hlsearch", true) -- search highlights
utils.opt("o", "ignorecase", true) -- ignorecase in search patterns
utils.opt("o", "history", 1000)
utils.opt("o", "showcmd", true)
utils.opt("o", "ttimeout", true)
utils.opt("o", "ttimeoutlen", 100)
utils.opt("o", "laststatus", 2)
utils.opt("o", "cmdheight", 2)
utils.opt("o", "termguicolors", true)
utils.opt("o", "backup", false)
utils.opt("b", "undofile", true)
utils.opt("o", "hidden", true)
utils.opt("o", "updatetime", 300)
utils.opt("w", "signcolumn", "yes")
utils.opt("o", "shortmess", vim.o.shortmess .. "c")
utils.opt("o", "mouse", "a")
utils.opt("o", "title", true)
utils.opt("o", "splitright", true) -- fix splitting
utils.opt("o", "splitbelow", true)
utils.opt("w", "wrap", true)
utils.opt("o", "path", vim.o.path .. "**") -- search down into subfolders. tab-completion
utils.opt("w", "list", true)
utils.opt("o", "listchars", "tab:>-,trail:-,precedes:<,extends:>")
utils.opt("w", "foldmethod", "expr")
utils.opt("w", "foldexpr", "nvim_treesitter#foldexpr()")
utils.opt("w", "foldnestmax", 20)
utils.opt("w", "foldenable", false)
utils.opt("w", "conceallevel", 0) -- so that `` is visible in markdown files'
utils.opt("o", "pumheight", 10)
vim.opt.iskeyword:append("-")
vim.cmd("language en_US.utf-8") -- language
cmd([[ set clipboard+=unnamedplus ]]) -- use system clipboard
vim.opt.sessionoptions:append("globals")
vim.g.colorizer_auto_color = 1

-- cursor
utils.opt("w", "cursorline", true)
--utils.opt('w', 'cursorcolumn', true)
vim.cmd([[
    highlight CursorLine ctermbg=Gray cterm=bold guibg=#333333
]])
--highlight CursorColumn ctermbg=Gray cterm=bold guibg=#222222

-- file browsing
vim.g.netrw_banner = 0 -- disable banner
vim.g.netrm_browse_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_liststyle = 3 -- tree view

-- highlight on yank
cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])

-- vertically center document when entering insert mode
cmd([[ autocmd InsertEnter * norm zz ]])

-- remove trailing whitespaces on save
cmd([[ autocmd BufWritePre * %s/\s\+$//e ]])

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Autocommand that reloads xresources
vim.cmd([[
  augroup xresources_user_config
    autocmd!
    autocmd BufWritePost Xresources silent !xrdb -merge "$HOME/.config/Xresources"
  augroup end
]])
