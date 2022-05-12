-- ==================== Mappings ==================== --
-- :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
-- :nmap  :nnoremap :nunmap    Normal
-- :vmap  :vnoremap :vunmap    Visual and Select
-- :smap  :snoremap :sunmap    Select
-- :xmap  :xnoremap :xunmap    Visual
-- :omap  :onoremap :ounmap    Operator-pending
-- :map!  :noremap! :unmap!    Insert and Command-line
-- :imap  :inoremap :iunmap    Insert
-- :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
-- :cmap  :cnoremap :cunmap    Command-line
-- :tmap  :tnoremap :tunmap    Terminal-Job
--
-- normal_mode          n
-- insert_mode          i
-- visual_mode          v
-- visual_block_mode    x
-- term_mode            t
-- command_mode         c
-- TODO: show documentation in preview window

local keymap = vim.keymap
local g = vim.g
local b = vim.b

-- leader
keymap.set("", "<Space>", "<Nop>", { silent = true })
g.mapleader = " "
b.mapleader = " "
g.maplocalleader = "\\"
b.maplocalleader = "\\"

-- saving
keymap.set("n", "<c-s>", ":w<CR>")
keymap.set("i", "<c-s>", "<ESC>:w<CR>a")

-- source
--keymap.set('n', '<c-c>', ':source ~/.config/nvim/init.lua<cr>')

-- window navigation
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<c-h>", "<c-w>h")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-l>", "<c-w>l")

-- window resize
keymap.set("n", "<Up>", ":resize -2<CR>", { silent = true })
keymap.set("n", "<Down>", ":resize +2<CR>", { silent = true })
keymap.set("n", "<Left>", ":vertical resize -2<CR>", { silent = true })
keymap.set("n", "<Right>", ":vertical resize +2<CR>", { silent = true })

-- window splits
keymap.set("n", "<leader>s", ":split<Space>")
keymap.set("n", "<leader>v", ":vsplit<Space>")

-- tabs
keymap.set("n", "<S-l>", ":tabn<CR>", { silent = true })
keymap.set("n", "<S-h>", ":tabp<CR>", { silent = true })
keymap.set("n", "<leader>tx", ":tabclose<CR>", { silent = true })
keymap.set("n", "<leader>tc", ":tabnew<CR>", { silent = true })
keymap.set("n", "<leader>to", ":tabonly<CR>", { silent = true })
keymap.set("n", "<leader>tn", ":tabn<CR>", { silent = true })
keymap.set("n", "<leader>tp", ":tabp<CR>", { silent = true })
-- move current tab to previous position
keymap.set("n", "<leader>tmp", ":-tabmove<CR>", { silent = true })
-- move current tab to next position
keymap.set("n", "<leader>tmn", ":+tabmove<CR>", { silent = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
-- solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
keymap.set("!", "<C-BS>", "<C-w>")
keymap.set("!", "<C-h>", "<C-w>")

-- search replace
keymap.set("n", "S", ":%s///g<Left><Left><Left>")

-- disable ex mode
keymap.set("n", "Q", "<nop>")

-- quit
keymap.set("n", "Q", ":q<cr>", { silent = true })

-- disable search highlighting until the next search
keymap.set("n", "<cr>", ":noh<cr><cr>", { silent = true })

-- delete buffer without closing neovim
keymap.set("n", "<leader>x", ":Bdelete<cr>")

-- formatting
-- put brackets around word/s
keymap.set("n", "<leader>(", "viwc()<esc>P")
keymap.set("n", "<leader>{", "viwc{}<esc>P")
keymap.set("n", "<leader>[", "viwc[]<esc>P")
keymap.set("n", "<leader>'", "viwc''<esc>P")
keymap.set("n", '<leader>"', 'viwc""<esc>P')

-- put brackets around selected
keymap.set("x", "<leader>(", "<ESC>`>a)<ESC>`<i(<ESC>")
keymap.set("x", "<leader>{", "<ESC>`>a}<ESC>`<i{<ESC>")
keymap.set("x", "<leader>[", "<ESC>`>a]<ESC>`<i[<ESC>")
keymap.set("x", "<leader>'", "<ESC>`>a'<ESC>`<i'<ESC>")
keymap.set("x", '<leader>"', '<ESC>`>a"<ESC>`<i"<ESC>')

-- move selected text
keymap.set("x", "K", ":move '<-2<CR>gv-gv")
keymap.set("x", "J", ":move '>+1<CR>gv-gv")

keymap.set("", "<leader>z", ":set formatoptions-=cro<cr>")
keymap.set("", "<leader>Z", ":set formatoptions=cro<cr>")

-- Telescope
keymap.set("n", "<leader>ff", ":Telescope find_files<cr>")
keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>")
keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>")
keymap.set("n", "<leader>fp", ":Telescope media_files<cr>")
keymap.set("n", "<leader>fb", ":Telescope buffers<cr>")

-- Session Manager
keymap.set("n", "<leader>ml", ":SessionManager load_session<cr>")
keymap.set("n", "<leader>md", ":SessionManager delete_session<cr>")
keymap.set("n", "<leader>mcs", ":SessionManager save_current_session<cr>")
keymap.set("n", "<leader>mcl", ":SessionManager load_current_dir_session<cr>")
keymap.set("n", "<leader>ma", ":SessionManager load_last_session<cr>")

-- stay in indent mode
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- comments
--keymap.set('n', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@l')
--keymap.set('x', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@')

-- alpha
--keymap.set("n", "<c-b>", ":Alpha<cr>")

-- nvim tree
keymap.set("n", "<c-n>", ":NvimTreeToggle<cr>", { silent = true })

-- spell, Grammarous
keymap.set("n", "<leader>gs", ":setlocal spell!<cr>", { silent = true })
keymap.set("n", "<leader>gg", ":GrammarousCheck --lang=de<cr>")

-- vimux
keymap.set("n", "<leader>pp", ":VimuxPromptCommand<cr>")
keymap.set("n", "<leader>pl", ":VimuxRunLastCommand<cr>")
keymap.set("n", "<leader>pi", ":VimuxInspectRunner<cr>")
keymap.set("n", "<leader>pz", ":VimuxZoomRunner<cr>")

-- dap
keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true })
keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true })
keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true })
keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true })
keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
keymap.set(
    "n",
    "<leader>dB",
    ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { silent = true }
)
keymap.set(
    "n",
    "<leader>dp",
    ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { silent = true }
)
keymap.set("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", { silent = true })
keymap.set("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { silent = true })
keymap.set("n", "<leader>di", ":lua require'dap.ui.widgets'.hover()<CR>", { silent = true })
keymap.set("n", "<leader>d?", ":lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")
keymap.set("n", "<leader>dR", ":lua require'dap'.clear_breakpoints()<CR>")
keymap.set("n", "<leader>dc", ":lua require'dap'.run_to_cursor()<CR>")
keymap.set("n", "<leader>dk", ":lua require'dap'.up()<CR>zz")
keymap.set("n", "<leader>dj", ":lua require'dap'.down()<CR>zz")
keymap.set("n", "<leader>dt", ":lua require'dap'.terminate()<CR>")

-- dapui
keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { silent = true })
keymap.set("v", "<leader>dh", ":lua require'dapui'.eval()<CR>", { silent = true })
