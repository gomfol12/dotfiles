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
keymap.set("n", "<leader>nh", ":noh<cr><cr>", { silent = true, desc = "No highlight" })

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
keymap.set("n", "<c-Up>", function()
    require("tmux").resize_top()
    -- require("bufresize").register()
end, { silent = true, desc = "Resize up" })

keymap.set("n", "<c-Down>", function()
    require("tmux").resize_bottom()
    -- require("bufresize").register()
end, { silent = true, desc = "Resize down" })

keymap.set("n", "<c-Left>", function()
    require("tmux").resize_left()
    -- require("bufresize").register()
end, { silent = true, desc = "Resize left" })

keymap.set("n", "<c-Right>", function()
    require("tmux").resize_right()
    -- require("bufresize").register()
end, { silent = true, desc = "Resize right" })

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

keymap.set("n", "<leader>z", ":set formatoptions-=cro<cr>", { desc = "Remove format options" })
keymap.set("n", "<leader>Z", ":set formatoptions=cro<cr>", { desc = "Add format options" })

-- format
keymap.set("n", "<leader>l", function()
    vim.lsp.buf.format({
        filter = function(filter_client)
            return filter_client.name == "null-ls"
        end,
        bufnr = 0,
    })
end, { desc = "Format" })

-- stay in indent mode
keymap.set("v", "<", "<gv", { desc = "Indent left" })
keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- plugins
-- Telescope
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find files" })
-- stylua: ignore
vim.keymap.set("n", "<leader><leader>f", require('telescope').extensions.frecency.frecency, { desc = "Find frequent files" })
vim.keymap.set("n", "<leader>rg", require("telescope.builtin").live_grep, { desc = "Live grep" })
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

-- Session Manager(Possession)
keymap.set("n", "<leader>pl", ":Sload ", { desc = "SM: load" })
keymap.set("n", "<leader>ps", ":Ssave ", { desc = "SM: save" })
keymap.set("n", "<leader>pc", ":Sclose<cr>", { desc = "SM: close" })
keymap.set("n", "<leader>pd", ":Sdelete ", { desc = "SM: delete" })
keymap.set("n", "<leader>pp", require("telescope").extensions.possession.list, { desc = "SM: list" })

-- nvim tree
keymap.set("n", "<c-n>", function()
    vim.api.nvim_command("NvimTreeToggle")
    -- require("bufresize").register()
end, { silent = true, desc = "NvimTree toggle" })

-- Grammarous
keymap.set("n", "<leader>gg", ":GrammarousCheck --lang=de<cr>", { desc = "Grammarous check" })

-- dap
local dapw = require("dap.ui.widgets")
local dap = require("dap")
local dapui = require("dapui")

-- Start debugging session
vim.keymap.set("n", "<leader>ds", function()
    dap.continue()
    dapui.toggle()
    -- require("bufresize").register()
    require("notify")("Debugger session started", "info")
end, { desc = "Debug: start session" })

keymap.set("n", "<F5>", dap.continue, { silent = true, desc = "Debug: continue" })
keymap.set("n", "<F10>", dap.step_over, { silent = true, desc = "Debug: step over" })
keymap.set("n", "<F11>", dap.step_into, { silent = true, desc = "Debug: step into" })
keymap.set("n", "<F12>", dap.step_out, { silent = true, desc = "Debug: step out" })
keymap.set("n", "<leader>dc", dap.continue, { silent = true, desc = "Debug: continue" })
keymap.set("n", "<leader>dn", dap.step_over, { silent = true, desc = "Debug: step over" })
keymap.set("n", "<leader>di", dap.step_into, { silent = true, desc = "Debug: step into" })
keymap.set("n", "<leader>do", dap.step_out, { silent = true, desc = "Debug: step out" })

keymap.set("n", "<leader>db", dap.toggle_breakpoint, { silent = true, desc = "Debug: toggle breakpoint" })
-- stylua: ignore
keymap.set("n", "<leader>dB", function () dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { silent = true, desc = "Debug: set breakpoint condition" })
-- stylua: ignore
keymap.set("n", "<leader>dp", function () dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { silent = true, desc = "Debug: set breakpoint log message" })
keymap.set("n", "<leader>dr", dap.repl.toggle, { silent = true, desc = "Debug: repl toggle" })
keymap.set("n", "<leader>dl", dap.run_last, { silent = true, desc = "Debug: run last" })
keymap.set("n", "<leader>dh", dapw.hover, { silent = true, desc = "Debug: hover" })
keymap.set("n", "<leader>d?", function()
    dapw.centered_float(dapw.scopes)
end, { silent = true, desc = "Debug: local scopes" })

keymap.set("n", "<leader>dR", function()
    dap.clear_breakpoints()
    require("notify")("Breakpoints cleared", "warn")
end, { silent = true, desc = "Debug: clear breakpoints" })

keymap.set("n", "<leader>dq", dap.run_to_cursor, { silent = true, desc = "Debug: run to cursor" })
keymap.set("n", "<leader>dk", dap.up, { silent = true, desc = "Debug: up" })
keymap.set("n", "<leader>dj", dap.down, { silent = true, desc = "Debug: down" })
keymap.set("n", "<leader>dt", dap.terminate, { silent = true, desc = "Debug: terminate" })

-- Close debugger and clear breakpoints
vim.keymap.set("n", "<leader>de", function()
    dap.clear_breakpoints()
    dapui.toggle()
    dap.terminate()
    require("notify")("Debugger session ended", "warn")
end)

-- dapui
keymap.set("n", "<leader>du", function()
    dapui.toggle()
    -- require("bufresize").register()
end, { silent = true, desc = "Debug: UI toggle" })

keymap.set("v", "<leader>dh", dapui.eval, { silent = true, desc = "Debug: UI eval" })

-- overseer
keymap.set("n", "<leader>ot", ":OverseerToggle<CR>", { silent = true, desc = "Overseer toggle" })
keymap.set("n", "<leader>ob", ":OverseerRun<CR>", { silent = true, desc = "Overseer run" })
keymap.set("n", "<leader>ol", ":OverseerRestartLast<CR>", { silent = true, desc = "Overseer restart last" })
keymap.set("n", "<leader>oa", ":OverseerQuickAction<CR>", { silent = true, desc = "Overseer quick action" })

-- neogen
keymap.set("n", "<Leader>nf", require("neogen").generate, { silent = true, desc = "Neogen generate" })

-- undotree
keymap.set("n", "<F4>", ":UndotreeToggle<cr>", { silent = true, desc = "UndoTreeToggle" })

-- ToggleTerm`
ToggleTerm = function(direction)
    local command = "ToggleTerm"
    if direction == "horizontal" then
        command = command .. " direction=horizontal size=20"
    elseif direction == "vertical" then
        command = command .. " direction=vertical size=" .. vim.o.columns * 0.4
    end
    if vim.bo.filetype == "toggleterm" then
        -- require("bufresize").block_register()
        vim.api.nvim_command(command)
        -- require("bufresize").resize_close()
    else
        -- require("bufresize").block_register()
        vim.api.nvim_command(command)
        -- require("bufresize").resize_open()
        vim.cmd([[execute "normal! i"]])
    end
end
keymap.set("n", "<C-\\>", ":lua ToggleTerm()<cr>", { noremap = true, silent = true, desc = "ToggleTerm" })
-- stylua: ignore
keymap.set("n", "<leader>th", [[:lua ToggleTerm("horizontal")<cr>]], { noremap = true, silent = true, desc = "ToggleTerm horizontally" })
-- stylua: ignore
keymap.set("n", "<leader>tv", [[:lua ToggleTerm("vertical")<cr>]], { noremap = true, silent = true, desc = "ToggleTerm vertically" })
keymap.set("i", "<C-\\>", "<esc>:lua ToggleTerm()<cr>", { noremap = true, silent = true, desc = "ToggleTerm" })
keymap.set("t", "<C-\\>", "<C-\\><C-n>:lua ToggleTerm()<cr>", { noremap = true, silent = true, desc = "ToggleTerm" })

-- Goyo
keymap.set("n", "<leader>go", ":Goyo<cr>", { silent = true, desc = "Goyo" })

-- leap-ast
vim.keymap.set({ "n", "x", "o" }, "m", function()
    require("leap-ast").leap()
end, { desc = "Leap AST" })

-- Search
vim.keymap.set("n", "<leader>b", ":Search<cr>", { desc = "Search" })

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
