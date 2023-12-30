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
-- TODO: move knap to tex and dap to lsp setup. shouldnt be here

local keymap = vim.keymap

-- leader --
vim.g.mapleader = " "
vim.b.mapleader = " "
vim.g.maplocalleader = "\\"
vim.b.maplocalleader = "\\"

-- general --
keymap.set("n", "Q", "<nop>", { desc = "Disable ex mode" })

-- disable search highlighting until the next search
keymap.set("n", "<cr>", ":noh<cr>", { silent = true, desc = "No highlight" })
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
keymap.set("x", "<leader>$", "<ESC>`>a$<ESC>`<i$<ESC>", { silent = true, desc = "$$ around selected word" })

-- move selected text
keymap.set("x", "K", ":move '<-2<CR>gv-gv", { silent = true, desc = "Move selected text" })
keymap.set("x", "J", ":move '>+1<CR>gv-gv", { silent = true, desc = "Move selected text" })

keymap.set("n", "<leader>Z", ":set formatoptions-=a<cr>", { desc = "Remove format options" })
keymap.set("n", "<leader>z", ":set formatoptions=a<cr>", { desc = "Add format options" })

-- format
keymap.set("n", "<leader>l", function()
    local conform_ok, conform = pcall(require, "conform")
    if conform_ok then
        conform.format()
    else
        vim.lsp.buf.format()
    end
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
    dapui.toggle()
    dap.terminate()
    require("notify")("Debugger session ended", "info")
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

-- Goyo
keymap.set("n", "<leader>go", ":Goyo<cr>", { silent = true, desc = "Goyo" })

-- leap-ast
-- vim.keymap.set({ "n", "x", "o" }, "m", function()
--     require("leap-ast").leap()
-- end, { desc = "Leap AST" })

-- Search
vim.keymap.set("n", "<leader>b", ":S<cr>", { desc = "Search" })

-- Fold
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
vim.keymap.set("n", "U", function()
    local winid = require("ufo").peekFoldedLinesUnderCursor()
    if not winid then
        vim.lsp.buf.hover()
    end
end)

-- copilot
vim.cmd([[imap <silent><script><expr> <C-q> copilot#Accept("\<CR>")]])

-- toggle checkbox
vim.keymap.set("n", "ch", require("toggle-checkbox").toggle, { silent = true, desc = "Toggle checkbox" })

-- advanced git search
-- stylua: ignore
vim.keymap.set("n", "<leader>gbf", require("telescope").extensions.advanced_git_search.diff_branch_file, { desc = "Git: diff branch file" })
-- stylua: ignore
vim.api.nvim_create_user_command("DiffCommitLine", "lua require('telescope').extensions.advanced_git_search.diff_commit_line()", { range = true })
vim.keymap.set("v", "<leader>gcl", ":DiffCommitLine<cr>", { desc = "Git: diff commit line" })
vim.keymap.set("n", "<leader>gcl", ":DiffCommitLine<cr>", { desc = "Git: diff commit line" })
-- stylua: ignore
vim.keymap.set("n", "<leader>gcf", require("telescope").extensions.advanced_git_search.diff_commit_file, { desc = "Git: diff commit file" })
-- stylua: ignore
vim.keymap.set("n", "<leader>gl", require("telescope").extensions.advanced_git_search.search_log_content_file, { desc = "Git: search log file" })
-- stylua: ignore
vim.keymap.set("n", "<leader>gcb", require("telescope").extensions.advanced_git_search.changed_on_branch, { desc = "Git: changed on branch" })
-- stylua: ignore
vim.keymap.set("n", "<leader>gcr", require("telescope").extensions.advanced_git_search.checkout_reflog, { desc = "Git: checkout reflog" })
-- stylua: ignore
vim.keymap.set("n", "<leader>ga", require("telescope").extensions.advanced_git_search.show_custom_functions, { desc = "Git: all advanced_git_search" })

-- luasnip
vim.keymap.set(
    "n",
    "<Leader>L",
    '<Cmd>lua require("luasnip.loaders.from_lua").load({paths = vim.fn.stdpath("config") .. "/snippets/"})<cr>',
    { desc = "Reload snippets" }
)

-- sniprun
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        -- exclude quarto files because uses molten
        if vim.bo.filetype == "quarto" then
            return
        end

        vim.keymap.set("v", "<leader>r", "<Plug>SnipRun", { silent = true })
        vim.keymap.set("n", "<leader>rr", "<Plug>SnipRun", { silent = true })
        vim.keymap.set("n", "<leader>rc", "<Plug>SnipClose", { silent = true })
        vim.keymap.set(
            "n",
            "<F3>",
            ":let b:caret=winsaveview() <CR> | :%SnipRun <CR>| :call winrestview(b:caret) <CR>",
            {}
        )
    end,
})

-- knap
vim.keymap.set("n", "<leader>po", function()
    require("knap").process_once()
end, { silent = true, desc = "knap: process once" })
vim.keymap.set("n", "<leader>pv", function()
    require("knap").close_viewer()
end, { silent = true, desc = "knap: close viewer" })
vim.keymap.set("n", "<leader>pa", function()
    require("knap").toggle_autopreviewing()
end, { silent = true, desc = "knap: toggle auto previewing" })
vim.keymap.set("n", "<leader>pf", function()
    require("knap").forward_jump()
end, { silent = true, desc = "knap: forward jump" })

-- nabla
vim.keymap.set("n", "<leader>na", function()
    require("nabla").popup()
end, { silent = true, desc = "nabla: popup" })

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

-- Mapping Notes

-- a.vim
-- :A switches to the header file corresponding to the current file being edited (or vise versa)
-- :AS splits and switches
-- :AV vertical splits and switches
-- :AT new tab and switches
-- :AN cycles through matches
-- :IH switches to file under cursor
-- :IHS splits and switches
-- :IHV vertical splits and switches
-- :IHT new tab and switches
-- :IHN cycles through matches
-- <Leader>ih switches to file under cursor
-- <Leader>is switches to the alternate file of file under cursor (e.g. on  <foo.h> switches to foo.cpp)
-- <Leader>ihn cycles through matches
