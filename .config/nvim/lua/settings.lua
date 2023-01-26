-- ==================== Settings ==================== --
-- Default options are not included

local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

local indent = 4

-- ========== General ========== --
opt.mouse = "a" -- Enable mouse support
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard
opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options
opt.wildmode = "list:longest"
opt.confirm = true -- Confirmation dialog
opt.undofile = true -- Persistent undo
opt.wrap = true
opt.iskeyword:append("-")
-- opt.sessionoptions:append("globals")
opt.sessionoptions:remove("buffers")
opt.path:append("**") -- search down into subfolders. Tab-completion
opt.shortmess:append("c")

-- ========== UI ========== --
opt.number = true -- Show line number
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "expr" -- Folding method
opt.foldexpr = "nvim_treesitter#foldexpr()" -- Folding is handled by treesitter
opt.foldenable = false -- Disable Folding
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 3 -- Set global statusline
opt.relativenumber = true
opt.cmdheight = 2 -- Wider cmd for better readability
opt.signcolumn = "yes"
opt.title = true
opt.list = true
opt.listchars = "tab:>-,trail:-,precedes:<,extends:>,nbsp:+"
opt.conceallevel = 1
opt.pumheight = 10 -- Max number of items to show in the popup menu

-- vim.o.foldcolumn = "1"
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.o.statuscolumn = "%=%r%s%C"

-- ========== Tabs, indent ========== --
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = indent -- Shift 4 spaces when tab
opt.tabstop = indent -- 1 tab == 4 spaces
opt.softtabstop = indent
opt.smartindent = true -- Autoindent new lines

-- opt.showtabline = 2 -- Always show tabline

-- ========== Performance ========== --
opt.history = 1000 -- Remember N lines in history
opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 320 -- Max column for syntax highlight
opt.updatetime = 300 -- ms to wait for trigger an event
opt.ttimeoutlen = 100 -- ms to wait for a key code sequence to complete
opt.timeoutlen = 500 -- ms to wait for a mapped sequence to complete

-- ========== Cursor ========== --
opt.cursorline = true
cmd([[
    highlight CursorLine ctermbg=Gray cterm=bold guibg=#333333
]])
-- opt.cursorcolumn = true
-- highlight CursorColumn ctermbg=Gray cterm=bold guibg=#222222

-- ========== Plugin Settings ========== --
g.colorizer_auto_color = 1

-- disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- file browsing
g.netrw_banner = 0 -- disable banner
g.netrm_browse_split = 4 -- open in prior window
g.netrw_altv = 1 -- open splits to the right
g.netrw_liststyle = 3 -- tree view

-- vimwiki
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

-- vimtex
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

-- vim table mode
vim.g.table_mode_corner = "|"

-- copilot
-- vim.g.copilot_no_tab_map = true

-- undotree
vim.g.undotree_WindowLayout = 3

-- Goyo
vim.g.goyo_width = 100

-- ========== Autocmds ========== --
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- vertically center document when entering insert mode
autocmd("InsertEnter", {
    command = "norm zz",
})

-- remove trailing whitespaces on save
-- autocmd("BufWritePre", {
--     pattern = "*",
--     command = ":%s/\\s\\+$//e",
-- })

-- Autocmd for PackerCompile on save in plugins.lua
augroup("packer_user_config", { clear = true })
autocmd("BufWritePost", {
    group = "packer_user_config",
    pattern = "plugins.lua",
    command = "source <afile> | PackerCompile",
})

-- Autocommand that reloads xresources
augroup("xresources_user_config", { clear = true })
if require("utils").getHost() == os.getenv("HOSTNAME_LAPTOP") then
    autocmd("BufWritePost", {
        group = "xresources_user_config",
        pattern = "laptop.Xresources",
        command = "silent! !xrdb -merge " .. os.getenv("XDG_CONFIG_HOME") .. "/laptop.Xresources",
    })
else
    autocmd("BufWritePost", {
        group = "xresources_user_config",
        pattern = "Xresources",
        command = "silent! !xrdb -merge " .. os.getenv("XDG_CONFIG_HOME") .. "/Xresources",
    })
end

-- Function that adds "vfile:" in vimwiki for linking external files and opening them in a new tab
cmd([[
    function! VimwikiLinkHandler(link)
        let link = a:link
        if link =~# '^vfile:'
            let link = link[1:]
        else
            return 0
        endif
        let link_infos = vimwiki#base#resolve_link(link)
        if link_infos.filename == ''
            echomsg 'Vimwiki Error: Unable to resolve link!'
            return 0
        else
            exe 'tabnew ' . fnameescape(link_infos.filename)
            return 1
        endif
    endfunction
]])

-- Mason Autoupdate after packer
autocmd("User", {
    pattern = "PackerCompileDone",
    command = ":MasonUpdateAll",
})

-- Disable automatic comment insertion
autocmd("FileType", {
    pattern = "*",
    command = "setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
})

-- Line length marker at 80 columns
for _, k in pairs({ "vimwiki", "tex", "markdown" }) do
    autocmd("FileType", {
        pattern = k,
        command = 'lua vim.opt.colorcolumn = "80"',
    })
end

autocmd("BufRead,BufNewFile", {
    pattern = "/tmp/calcurse*",
    command = "set filetype=markdown",
})

autocmd("BufRead,BufNewFile", {
    pattern = "~/.local/share/calcurse/notes/*",
    command = "set filetype=markdown",
})

-- ========== Useful functions ========== --
local function usercmd(alias, command)
    return vim.api.nvim_create_user_command(alias, command, { nargs = 0 })
end

-- Search
usercmd("Search", function()
    local search = vim.fn.input("Search: ")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- our picker function: colors
    local searcher = function(opts)
        opts = opts or {}
        pickers
            .new(opts, {
                prompt_title = "OmniSearch",
                finder = finders.new_table({
                    results = {
                        { "Brave Search", ("search.brave.com/search\\?q\\=" .. search:gsub(" ", "+")) },
                        { "Youtube", ("https://www.youtube.com/results\\?search_query\\=" .. search:gsub(" ", "+")) },
                        { "Github", ("https://github.com/search\\?q\\=" .. search:gsub(" ", "+")) },
                        { "Stack Overflow", ("www.stackoverflow.com/search\\?q\\=" .. search:gsub(" ", "+")) },
                        { "Wikipedia", ("https://en.wikipedia.org/w/index.php\\?search\\=" .. search:gsub(" ", "+")) },
                        { "Google Search", ("www.google.com/search\\?q\\=" .. search:gsub(" ", "+")) },
                    },
                    entry_maker = function(entry)
                        return { value = entry, display = entry[1], ordinal = entry[1] }
                    end,
                }),
                sorter = conf.generic_sorter(opts),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        vim.cmd(("silent execute '!" .. os.getenv("BROWSER") .. " %s &'"):format(selection["value"][2]))
                    end)
                    return true
                end,
            })
            :find()
    end
    searcher(require("telescope.themes").get_dropdown({}))
end)
