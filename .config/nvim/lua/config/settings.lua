-- ==================== Settings ==================== --

local indent = 4

-- ========== General ========== --
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options
vim.opt.wildmode = "list:longest"
vim.opt.confirm = true -- Confirmation dialog
vim.opt.undofile = true -- Persistent undo
vim.opt.wrap = true
vim.opt.iskeyword:append("-")
vim.opt.sessionoptions:remove("buffers")
vim.opt.path:append("**") -- search down into subfolders. Tab-completion
vim.opt.shortmess:append("c")
vim.opt.jumpoptions:append("view")
vim.opt.breakindent = true -- preserve indent on indented lines that wrap
vim.opt.inccommand = "split" -- preview substitutions live

vim.opt.number = true -- Show line number
vim.opt.showmatch = true -- Highlight matching parenthesis
vim.opt.splitright = true -- Vertical split to the right
vim.opt.splitbelow = true -- Horizontal split to the bottom
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Ignore lowercase for the whole pattern
vim.opt.linebreak = true -- Wrap on word boundary
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.laststatus = 2 -- Set global statusline
vim.opt.relativenumber = true
vim.opt.cmdheight = 2 -- Wider cmd for better readability
vim.opt.signcolumn = "yes" -- sign column for line numbers, diagnostics and stuff
vim.opt.title = true
vim.opt.list = true
vim.opt.listchars = "tab:>-,trail:-,precedes:<,extends:>,nbsp:+"
vim.opt.conceallevel = 1
vim.opt.pumheight = 10 -- Max number of items to show in the popup menu
-- vim.opt.winborder = "single" -- Square borders

-- folding
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.fillchars = [[eob: ,fold:🢒,foldopen:🢒,foldsep: ,foldclose:🠗]]
vim.opt.numberwidth = 3

vim.g.have_nerd_font = true

-- Synchronize clipboard between system and neovim
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)
vim.opt.sessionoptions:append("globals")

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- file browsing
vim.g.netrw_banner = 0 -- disable banner
vim.g.netrm_browse_split = 4 -- open in prior window
vim.g.netrw_altv = 1 -- open splits to the right
vim.g.netrw_liststyle = 3 -- tree view

-- ========== Tabs, indent ========== --
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = indent -- Shift 4 spaces when tab
vim.opt.tabstop = indent -- 1 tab == 4 spaces
vim.opt.softtabstop = indent
vim.opt.smartindent = true -- Autoindent new lines

-- vim.opt.showtabline = 2 -- Always show tabline

-- ========== Performance ========== --
vim.opt.history = 1000 -- Remember N lines in history
vim.opt.lazyredraw = true -- Faster scrolling
vim.opt.synmaxcol = 320 -- Max column for syntax highlight
vim.opt.updatetime = 250 -- ms to wait for trigger an event
vim.opt.ttimeoutlen = 100 -- ms to wait for a key code sequence to complete
vim.opt.timeoutlen = 300 -- ms to wait for a mapped sequence to complete

-- ========== Cursor ========== --
vim.opt.cursorline = true
vim.cmd([[
    highlight CursorLine ctermbg=Gray cterm=bold guibg=#333333
]])

-- vim.opt.cursorcolumn = true
-- vim.cmd([[
--     highlight CursorColumn ctermbg=Gray cterm=bold guibg=#222222
-- ]])
