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

local keymap = vim.keymap

-- leader --
vim.g.mapleader = " "
vim.b.mapleader = " "
vim.g.maplocalleader = "\\"
vim.b.maplocalleader = "\\"

-- general --
keymap.set("n", "Q", "<nop>", { desc = "Disable ex mode" })

-- disable search highlighting until the next search
keymap.set("n", "<cr>", ":noh<cr><cr>", { silent = true, desc = "No highlight" })

-- delete buffer without closing neovim
keymap.set("n", "<leader>x", ":Bdelete<cr>", { desc = "Delete buffer" })

-- spell
keymap.set("n", "<leader>gs", ":setlocal spell!<cr>", { silent = true, desc = "Spell toggle" })

-- saving
keymap.set("n", "<c-s>", ":w<CR>", { desc = "Save current file" })
keymap.set("i", "<c-s>", "<ESC>:w<CR>a", { desc = "Save current file" })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
-- solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
keymap.set("!", "<C-BS>", "<C-w>", { silent = true, desc = "Fix Ctrl-Backspace" })
keymap.set("!", "<C-h>", "<C-w>", { silent = true, desc = "Fix Ctrl-Backspace" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- window, tabs, ... --
-- window navigation
keymap.set("n", "<c-j>", "lua require('tmux').move_bottom()<cr>", { silent = true, desc = "Move down" })
keymap.set("n", "<c-h>", "lua require('tmux').move_left()<cr>", { silent = true, desc = "Move left" })
keymap.set("n", "<c-k>", "lua require('tmux').move_top()<cr>", { silent = true, desc = "Move up" })
keymap.set("n", "<c-l>", "lua require('tmux').move_right()<cr>", { silent = true, desc = "Move right" })

-- window resize
keymap.set("n", "<c-Up>", ":lua require('tmux').resize_top()<cr>", { silent = true, desc = "Resize up" })
keymap.set("n", "<c-Down>", ":lua require('tmux').resize_bottom()<cr>", { silent = true, desc = "Resize down" })
keymap.set("n", "<c-Left>", ":lua require('tmux').resize_left()<cr>", { silent = true, desc = "Resize left" })
keymap.set("n", "<c-Right>", ":lua require('tmux').resize_right()<cr>", { silent = true, desc = "Resize right" })

-- window splits
keymap.set("n", "<leader>s", ":split<Space>", { desc = "split" })
keymap.set("n", "<leader>v", ":vsplit<Space>", { desc = "vsplit" })

-- tabs
keymap.set("n", "<leader>tx", ":tabclose<CR>", { silent = true, desc = "Close tab" })
keymap.set("n", "<leader>tc", ":tabnew<CR>", { silent = true, desc = "New tab" })
keymap.set("n", "<leader>to", ":tabonly<CR>", { silent = true, desc = "Only tab" })
keymap.set("n", "<S-l>", ":tabn<CR>", { silent = true, desc = "Next tab" })
keymap.set("n", "<S-h>", ":tabp<CR>", { silent = true, desc = "Prev tab" })
-- move current tab to next position
keymap.set("n", "<leader>tn", ":+tabmove<CR>", { silent = true, desc = "Move to next tab" })
-- move current tab to previous position
keymap.set("n", "<leader>tp", ":-tabmove<CR>", { silent = true, desc = "Move to prev tab" })

-- formatting
-- put brackets around word/s
keymap.set("n", "<leader>(", "viwc()<esc>P", { silent = true, desc = "() around word" })
keymap.set("n", "<leader>{", "viwc{}<esc>P", { silent = true, desc = "{} around word" })
keymap.set("n", "<leader>[", "viwc[]<esc>P", { silent = true, desc = "[] around word" })
keymap.set("n", "<leader>'", "viwc''<esc>P", { silent = true, desc = "'' around word" })
keymap.set("n", '<leader>"', 'viwc""<esc>P', { silent = true, desc = '"" around word' })

-- put brackets around selected
keymap.set("x", "<leader>(", "<ESC>`>a)<ESC>`<i(<ESC>", { silent = true, desc = "() around selected word" })
keymap.set("x", "<leader>{", "<ESC>`>a}<ESC>`<i{<ESC>", { silent = true, desc = "{} around selected word" })
keymap.set("x", "<leader>[", "<ESC>`>a]<ESC>`<i[<ESC>", { silent = true, desc = "[] around selected word" })
keymap.set("x", "<leader>'", "<ESC>`>a'<ESC>`<i'<ESC>", { silent = true, desc = "'' around selected word" })
keymap.set("x", '<leader>"', '<ESC>`>a"<ESC>`<i"<ESC>', { silent = true, desc = '"" around selected word' })

-- move selected text
keymap.set("x", "K", ":move '<-2<CR>gv-gv", { silent = true, desc = "Move selected text" })
keymap.set("x", "J", ":move '>+1<CR>gv-gv", { silent = true, desc = "Move selected text" })

keymap.set("", "<leader>z", ":set formatoptions-=cro<cr>", { desc = "Remove format options" })
keymap.set("", "<leader>Z", ":set formatoptions=cro<cr>", { desc = "Add format options" })

-- stay in indent mode
keymap.set("v", "<", "<gv", { desc = "Indent left" })
keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- plugins
-- Telescope
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "Find old files" })
vim.keymap.set("n", "<leader>/", function()
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "Fuzzy search current buffer" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "Find diagnostics" })

-- Session Manager
keymap.set("n", "<leader>ml", ":SessionManager load_session<cr>", { desc = "SM: load" })
keymap.set("n", "<leader>md", ":SessionManager delete_session<cr>", { desc = "SM: delete" })
keymap.set("n", "<leader>mcs", ":SessionManager save_current_session<cr>", { desc = "SM: save current" })
keymap.set("n", "<leader>mcl", ":SessionManager load_current_dir_session<cr>", { desc = "SM: load current dir" })
keymap.set("n", "<leader>ma", ":SessionManager load_last_session<cr>", { desc = "SM: load last" })

-- nvim tree
keymap.set("n", "<c-n>", ":NvimTreeToggle<cr>", { silent = true, desc = "NvimTree toggle" })

-- Grammarous
keymap.set("n", "<leader>gg", ":GrammarousCheck --lang=de<cr>", { desc = "Grammarous check" })

-- dap
keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>", { silent = true, desc = "Debug: continue" })
keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>", { silent = true, desc = "Debug: step over" })
keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>", { silent = true, desc = "Debug: step into" })
keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>", { silent = true, desc = "Debug: step out" })
keymap.set(
    "n",
    "<leader>db",
    ":lua require'dap'.toggle_breakpoint()<CR>",
    { silent = true, desc = "Debug: toggle breakpoint" }
)
keymap.set(
    "n",
    "<leader>dB",
    ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { silent = true, desc = "Debug: set breakpoint condition" }
)
keymap.set(
    "n",
    "<leader>dp",
    ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { silent = true, desc = "Debug: set breakpoint log message" }
)
keymap.set("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR>", { silent = true, desc = "Debug: repl toggle" })
keymap.set("n", "<leader>dl", ":lua require'dap'.run_last()<CR>", { silent = true, desc = "Debug: run last" })
keymap.set("n", "<leader>di", ":lua require'dap.ui.widgets'.hover()<CR>", { silent = true, desc = "Debug: hover" })
keymap.set(
    "n",
    "<leader>d?",
    ":lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
    { silent = true, desc = "Debug: local scopes" }
)
keymap.set(
    "n",
    "<leader>dR",
    ":lua require'dap'.clear_breakpoints()<CR>",
    { silent = true, desc = "Debug: clear breakpoints" }
)
keymap.set("n", "<leader>dc", ":lua require'dap'.run_to_cursor()<CR>", { silent = true, desc = "Debug: run to cursor" })
keymap.set("n", "<leader>dk", ":lua require'dap'.up()<CR>zz", { silent = true, desc = "Debug: up" })
keymap.set("n", "<leader>dj", ":lua require'dap'.down()<CR>zz", { silent = true, desc = "Debug: down" })
keymap.set("n", "<leader>dt", ":lua require'dap'.terminate()<CR>", { silent = true, desc = "Debug: terminate" })

-- dapui
keymap.set("n", "<leader>du", ":lua require'dapui'.toggle()<CR>", { silent = true, desc = "Debug: UI toggle" })
keymap.set("v", "<leader>dh", ":lua require'dapui'.eval()<CR>", { silent = true, desc = "Debug: UI eval" })

-- overseer
keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { silent = true, desc = "Overseer toggle" })
keymap.set("n", "<leader>bb", ":OverseerRun<CR>", { silent = true, desc = "Overseer run" })
keymap.set("n", "<leader>bl", ":OverseerRestartLast<CR>", { silent = true, desc = "Overseer restart last" })
keymap.set("n", "<leader>oa", ":OverseerQuickAction<CR>", { silent = true, desc = "Overseer quick action" })

-- neogen
keymap.set("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", { silent = true, desc = "Neogen generate" })

-- undotree
keymap.set("n", "<F4>", ":UndotreeToggle<cr>", { silent = true, desc = "UndoTreeToggle" })

-- Maybe useful some time in the future
-- keymap.set("", "<Space>", "<Nop>", { silent = true })

-- keymap.set("n", "<c-j>", "<c-w>j")
-- keymap.set("n", "<c-h>", "<c-w>h")
-- keymap.set("n", "<c-k>", "<c-w>k")
-- keymap.set("n", "<c-l>", "<c-w>l")

-- keymap.set("n", "<c-Up>", ":resize -2<CR>", { silent = true })
-- keymap.set("n", "<c-Down>", ":resize +2<CR>", { silent = true })
-- keymap.set("n", "<c-Left>", ":vertical resize +2<CR>", { silent = true })
-- keymap.set("n", "<c-Right>", ":vertical resize -2<CR>", { silent = true })
