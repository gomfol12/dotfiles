-- ==================== Settings ==================== --
-- Default options are not included

local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local utils = require("utils")

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
opt.jumpoptions:append("view")

-- ========== UI ========== --
opt.number = true -- Show line number
opt.showmatch = true -- Highlight matching parenthesis
opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.linebreak = true -- Wrap on word boundary
opt.termguicolors = true -- Enable 24-bit RGB colors
opt.laststatus = 2 -- Set global statusline
opt.relativenumber = true
opt.cmdheight = 2 -- Wider cmd for better readability
opt.signcolumn = "yes" -- sign column for line numbers, diagnostics and stuff
opt.title = true
opt.list = true
opt.listchars = "tab:>-,trail:-,precedes:<,extends:>,nbsp:+"
opt.conceallevel = 1
opt.pumheight = 10 -- Max number of items to show in the popup menu

-- folding
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.fillchars = [[eob: ,fold:🢒,foldopen:🢒,foldsep: ,foldclose:🠗]]
opt.numberwidth = 3

-- old see statuscolumn.lua
-- require("statuscolumn")
-- vim.o.statuscolumn = "%!v:lua.get_statuscolumn()"

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
vim.g.vimtex_compiler_engine = "lualatex"
vim.g.vimtex_compiler_latexmk = {
    out_dir = "build",
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
vim.g.vimtex_fold_enabled = true
-- vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_syntax_conceal_disable = 1

-- vim table mode
vim.g.table_mode_corner = "|"

-- copilot
vim.g.copilot_no_tab_map = true

-- undotree
vim.g.undotree_WindowLayout = 3

-- Goyo
vim.g.goyo_width = 100

-- vim-pandoc
vim.g["pandoc#command#custom_open"] = "MyPandocOpen"

vim.cmd([[
function! MyPandocOpen(file)
    let file = shellescape(fnamemodify(a:file, ':p'))
    let file_extension = fnamemodify(a:file, ':e')
    if file_extension is? 'pdf'
        if !empty($PDFVIEWER)
            return expand('$PDFVIEWER') . ' ' . file
        elseif executable('zathura')
            return 'zathura ' . file
        elseif executable('mupdf')
            return 'mupdf ' . file
        endif
    elseif file_extension is? 'html'
        if !empty($BROWSER)
            return expand('$BROWSER') . ' ' . file
        elseif executable('firefox')
            return 'firefox ' . file
        elseif executable('chromium')
            return 'chromium ' . file
        endif
    elseif file_extension is? 'odt' && executable('okular')
        return 'okular ' . file
    elseif file_extension is? 'epub' && executable('okular')
        return 'okular ' . file
    else
        return 'xdg-open ' . file
    endif
endfunction
]])

-- vim-printer
vim.g.vim_printer_print_below_keybinding = "<leader>pr"
vim.g.vim_printer_print_above_keybinding = "<leader>Pr"

vim.g.vim_printer_items = {
    c = 'printf("{$}: %d", {$});',
    cpp = 'std::cout << "{$}: " << {$} << "\\n";',
}

-- knap
vim.g.knap_settings = {
    texoutputext = "pdf",
    textopdf = "pdflatex -synctex=1 -halt-on-error -interaction=batchmode %docroot%",
    textopdfviewerlaunch = "zathura --synctex-editor-command 'nvim --headless -es --cmd \"lua require('\"'\"'knaphelper'\"'\"').relayjump('\"'\"'%servername%'\"'\"','\"'\"'%{input}'\"'\"',%{line},0)\"' %outputfile%",
    textopdfviewerrefresh = "none",
    textopdfforwardjump = "zathura --synctex-forward=%line%:%column%:%srcfile% %outputfile%",
    mdtopdf = "pandoc %docroot% -o %outputfile%",
    mdtopdfviewerlaunch = "zathura %outputfile%",
    mdtopdfviewerrefresh = "none",
    mdoutputext = "pdf",
    textopdfshorterror = 'A=%outputfile% ; LOGFILE="${A%.pdf}.log" ; rubber-info "$LOGFILE" 2>&1 | head -n 1',
}

-- ts_commentstring
vim.g.skip_ts_context_commentstring_module = true

-- python/lua venv
local nvim_python_venv_dir = os.getenv("NVIM_PYTHON_VENV_DIR")
local nvim_lua_venv_dir = os.getenv("NVIM_LUA_VENV_DIR")
if
    nvim_python_venv_dir ~= nil
    and nvim_lua_venv_dir ~= nil
    and utils.dir_exists(nvim_python_venv_dir)
    and utils.dir_exists(nvim_lua_venv_dir)
then
    vim.g.python_host_prog = nvim_python_venv_dir .. "/bin/python"
    vim.g.python3_host_prog = nvim_python_venv_dir .. "/bin/python3"
    package.path = package.path .. ";" .. os.getenv("NVIM_LUA_VENV_DIR") .. "/share/lua/5.1/?/init.lua;"
    package.path = package.path .. ";" .. os.getenv("NVIM_LUA_VENV_DIR") .. "/share/lua/5.1/?.lua;"
else
    print("Python/lua venv not configured. Run nvim_setup command")
end

-- molten-nvim
vim.g.molten_image_provider = "image.nvim"
vim.g.molten_output_win_max_height = 20
vim.g.molten_auto_open_output = true
vim.g.molten_copy_output = true

-- jupytext.vim
vim.g.jupytext_filetype_map = { ["md"] = "quarto" }

-- ========== Autocmds ========== --
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- disable on BufEnter conceal for specific filetypes and re-enable it on BufLeave
autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.qmd", "*.md", "*.json" },
    callback = function()
        if vim.bo.filetype == "vimwiki" then
            vim.cmd("set conceallevel=2")
            return
        end
        vim.cmd("set conceallevel=0")
    end,
})
vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
    pattern = { "*.qmd", "*.md", "*.json" },
    callback = function()
        if vim.bo.filetype == "vimwiki" then
            vim.cmd("set conceallevel=2")
            return
        end
        vim.cmd("set conceallevel=1")
    end,
})

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
if utils.getHost() == os.getenv("HOSTNAME_LAPTOP") then
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

autocmd("User", {
    pattern = "PackerCompileDone",
    command = ":UpdateRemotePlugins",
})

-- Disable automatic comment insertion
autocmd("FileType", {
    pattern = "*",
    command = "setlocal formatoptions-=cro",
})

-- Line length marker at 80 columns and format
for _, k in pairs({ "markdown", "pandoc" }) do
    autocmd("FileType", {
        pattern = k,
        callback = function()
            vim.opt.colorcolumn = "80"
            vim.opt.textwidth = 80
            -- vim.cmd("set fo+=a")
        end,
    })
end

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "/tmp/calcurse*",
    command = "set filetype=markdown",
})

autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "~/.local/share/calcurse/notes/*",
    command = "set filetype=markdown",
})

-- speeddating
autocmd("BufEnter", {
    pattern = "*",
    command = [[
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
    ]],
})

-- remove trailing spaces
augroup("myformat", { clear = true })
autocmd("BufWritePre", {
    group = "myformat",
    pattern = "*",
    callback = function()
        if
            vim.bo.filetype == "markdown"
            or vim.bo.filetype == "vimwiki"
            or vim.bo.filetype == "pandoc"
            or vim.bo.filetype == "latex"
            or vim.bo.filetype == "quarto"
        then
            return
        end
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\v\s+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- ========== Useful functions ========== --
local function usercmd(alias, command)
    return vim.api.nvim_create_user_command(alias, command, { nargs = 0 })
end

-- Search
usercmd("S", function()
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

usercmd("Bonly", function()
    vim.cmd('execute "%bd|e#|bd#"')
end)

usercmd("P", function(...)
    print(vim.inspect(...))
end)

-- Search Escape String
usercmd("Sescstr", [[/\\".\{-}\\"]])
-- Search String
usercmd("Sstr", [[/".\{-}"]])
