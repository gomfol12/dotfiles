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

local utils = require("utils")

-- leader
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.b.mapleader = " "
vim.g.maplocalleader = "\\"
vim.b.maplocalleader = "\\"

-- saving
utils.map("n", "<c-s>", ":w<CR>")
utils.map("i", "<c-s>", "<ESC>:w<CR>a")

-- source
--utils.map('n', '<c-c>', ':source ~/.config/nvim/init.lua<cr>')

-- window navigation
utils.map("n", "<c-j>", "<c-w>j")
utils.map("n", "<c-h>", "<c-w>h")
utils.map("n", "<c-k>", "<c-w>k")
utils.map("n", "<c-l>", "<c-w>l")

-- window resize
utils.map("n", "<Up>", ":resize -2<CR>", { silent = true })
utils.map("n", "<Down>", ":resize +2<CR>", { silent = true })
utils.map("n", "<Left>", ":vertical resize -2<CR>", { silent = true })
utils.map("n", "<Right>", ":vertical resize +2<CR>", { silent = true })

-- window splits
utils.map("n", "<leader>s", ":split<Space>")
utils.map("n", "<leader>v", ":vsplit<Space>")

-- tabs
utils.map("n", "<S-l>", ":tabn<CR>", { silent = true })
utils.map("n", "<S-h>", ":tabp<CR>", { silent = true })
utils.map("n", "<leader>tx", ":tabclose<CR>", { silent = true })
utils.map("n", "<leader>tc", ":tabnew<CR>", { silent = true })
utils.map("n", "<leader>to", ":tabonly<CR>", { silent = true })
utils.map("n", "<leader>tn", ":tabn<CR>", { silent = true })
utils.map("n", "<leader>tp", ":tabp<CR>", { silent = true })
-- move current tab to previous position
utils.map("n", "<leader>tmp", ":-tabmove<CR>", { silent = true })
-- move current tab to next position
utils.map("n", "<leader>tmn", ":+tabmove<CR>", { silent = true })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
-- solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
utils.map("!", "<C-BS>", "<C-w>")
utils.map("!", "<C-h>", "<C-w>")

-- search replace
utils.map("n", "S", ":%s///g<Left><Left><Left>")

-- disable ex mode
utils.map("n", "Q", "<nop>")

-- quit
utils.map("n", "Q", ":q<cr>", { silent = true })

-- disable search highlighting until the next search
utils.map("n", "<cr>", ":noh<cr><cr>", { silent = true })

-- formatting
-- put brackets around word/s
utils.map("n", "<leader>(", "viwc()<esc>P")
utils.map("n", "<leader>{", "viwc{}<esc>P")
utils.map("n", "<leader>[", "viwc[]<esc>P")
utils.map("n", "<leader>'", "viwc''<esc>P")
utils.map("n", '<leader>"', 'viwc""<esc>P')

-- put brackets around selected
utils.map("x", "<leader>(", "<ESC>`>a)<ESC>`<i(<ESC>")
utils.map("x", "<leader>{", "<ESC>`>a}<ESC>`<i{<ESC>")
utils.map("x", "<leader>[", "<ESC>`>a]<ESC>`<i[<ESC>")
utils.map("x", "<leader>'", "<ESC>`>a'<ESC>`<i'<ESC>")
utils.map("x", '<leader>"', '<ESC>`>a"<ESC>`<i"<ESC>')

-- move selected text
utils.map("x", "K", ":move '<-2<CR>gv-gv")
utils.map("x", "J", ":move '>+1<CR>gv-gv")

utils.map("", "<leader>z", ":set formatoptions-=cro<cr>")
utils.map("", "<leader>Z", ":set formatoptions=cro<cr>")

-- Telescope
utils.map("n", "<leader>ff", ":Telescope find_files<cr>")
utils.map("n", "<leader>fg", ":Telescope live_grep<cr>")
utils.map("n", "<leader>fh", ":Telescope help_tags<cr>")
utils.map("n", "<leader>fp", ":Telescope media_files<cr>")
utils.map("n", "<leader>fb", ":Telescope buffers<cr>")
-- Session Manager
utils.map("n", "<leader>ml", ":SessionManager load_session<cr>")
utils.map("n", "<leader>md", ":SessionManager delete_session<cr>")
utils.map("n", "<leader>mcs", ":SessionManager save_current_session<cr>")
utils.map("n", "<leader>mcl", ":SessionManager load_current_dir_session<cr>")
utils.map("n", "<leader>ma", ":SessionManager load_last_session<cr>")

-- stay in indent mode
utils.map("v", "<", "<gv")
utils.map("v", ">", ">gv")

-- comments
--utils.map('n', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@l')
--utils.map('x', '<leader>c', ':set operatorfunc=v:lua.__toggle_contextual<cr>g@')

-- alpha
--utils.map("n", "<c-b>", ":Alpha<cr>")

-- nvim tree
utils.map("n", "<c-n>", ":NvimTreeToggle<cr>", { silent = true })

-- spell, Grammarous
utils.map("n", "<leader>gs", ":setlocal spell!<cr>", { silent = true })
utils.map("n", "<leader>gg", ":GrammarousCheck --lang=de<cr>")

-- vimux
utils.map("n", "<leader>pp", ":VimuxPromptCommand<cr>")
utils.map("n", "<leader>pl", ":VimuxRunLastCommand<cr>")
utils.map("n", "<leader>pi", ":VimuxInspectRunner<cr>")
utils.map("n", "<leader>pz", ":VimuxZoomRunner<cr>")

-- dap
utils.map("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true })
utils.map("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true })
utils.map("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true })
utils.map("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true })
utils.map("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
utils.map(
    "n",
    "<leader>dB",
    ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { silent = true }
)
utils.map(
    "n",
    "<leader>dp",
    ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { silent = true }
)
utils.map("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", { silent = true })
utils.map("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { silent = true })
utils.map("n", "<leader>di", ":lua require'dap.ui.widgets'.hover()<CR>", { silent = true })
utils.map("n", "<leader>d?", ":lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>")
utils.map("n", "<leader>dR", ":lua require'dap'.clear_breakpoints()<CR>")
utils.map("n", "<leader>dc", ":lua require'dap'.run_to_cursor()<CR>")
utils.map("n", "<leader>dk", ":lua require'dap'.up()<CR>zz")
utils.map("n", "<leader>dj", ":lua require'dap'.down()<CR>zz")
utils.map("n", "<leader>dt", ":lua require'dap'.terminate()<CR>")

-- dapui
utils.map("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { silent = true })
utils.map("v", "<leader>dh", ":lua require'dapui'.eval()<CR>", { silent = true })
