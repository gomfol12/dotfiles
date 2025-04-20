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

-- ========== leader ========== --
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ========== General ========== --
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable ex mode" })

-- disable search highlighting until the next search
vim.keymap.set("n", "<CR>", function()
    if vim.fn.getwininfo(vim.fn.win_getid())[1]["quickfix"] == 1 or vim.bo.filetype == "codecompanion" then
        vim.cmd("call feedkeys(\"\\<CR>\", 'n')")
        return
    end

    vim.cmd("nohlsearch")
end, { silent = true, desc = "No highlight" })
vim.keymap.set("n", "<leader>nh", ":noh<CR><CR>", { silent = true, desc = "No highlight" })

-- spell
vim.keymap.set("n", "<leader>gs", ":setlocal spell!<CR>", { silent = true, desc = "Spell toggle" })

-- saving
vim.keymap.set("n", "<c-s>", ":w<CR>", { desc = "Save current file" })
vim.keymap.set("i", "<c-s>", "<ESC>:w<CR>a", { desc = "Save current file" })

-- Map Ctrl-Backspace to delete the previous word in insert mode.
-- solution: https://vim.fandom.com/wiki/Map_Ctrl-Backspace_to_delete_previous_word
vim.keymap.set("!", "<C-BS>", "<C-w>", { silent = true, desc = "Fix Ctrl-Backspace" })
vim.keymap.set("!", "<C-h>", "<C-w>", { silent = true, desc = "Fix Ctrl-Backspace" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- stay in indent mode
-- vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
-- vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })
vim.keymap.set("v", "–", "<gv", { desc = "Indent left" })
vim.keymap.set("v", "•", ">gv", { desc = "Indent right" })

-- quickfix
vim.keymap.set("n", "[q", ":cnext<cr>", { desc = "Next Quickfix Entry" })
vim.keymap.set("n", "]q", ":cprev<cr>", { desc = "Previous Quickfix Entry" })

-- toggle checkbox
vim.keymap.set("n", "ch", require("config.toggle-checkbox").toggle, { silent = true, desc = "Toggle checkbox" })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- clipboard
-- vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
-- vim.keymap.set(
--     { "n", "v", "x" },
--     "<leader>Y",
--     '"+yy',
--     { noremap = true, silent = true, desc = "Yank line to clipboard" }
-- )
-- vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Maybe useful some time in the future
-- vim.keymap.set("", "<Space>", "<Nop>", { silent = true })

-- ========== window, tabs, ... ========== --
-- window navigation
if os.getenv("TMUX") then
    vim.keymap.set("n", "<c-j>", function()
        require("tmux").move_bottom()
    end, { silent = true, desc = "Move down" })
    vim.keymap.set("n", "<c-h>", function()
        require("tmux").move_left()
    end, { silent = true, desc = "Move left" })
    vim.keymap.set("n", "<c-k>", function()
        require("tmux").move_top()
    end, { silent = true, desc = "Move up" })
    vim.keymap.set("n", "<c-l>", function()
        require("tmux").move_right()
    end, { silent = true, desc = "Move right" })
elseif os.getenv("KITTY_WINDOW_ID") then
    vim.keymap.set("n", "<c-j>", ":KittyNavigateDown<CR>", { silent = true, desc = "Move down" })
    vim.keymap.set("n", "<c-h>", ":KittyNavigateLeft<CR>", { silent = true, desc = "Move left" })
    vim.keymap.set("n", "<c-k>", ":KittyNavigateUp<CR>", { silent = true, desc = "Move up" })
    vim.keymap.set("n", "<c-l>", ":KittyNavigateRight<CR>", { silent = true, desc = "Move right" })
else
    vim.keymap.set("n", "<c-j>", "<c-w>j", { silent = true, desc = "Move down" })
    vim.keymap.set("n", "<c-h>", "<c-w>h", { silent = true, desc = "Move left" })
    vim.keymap.set("n", "<c-k>", "<c-w>k", { silent = true, desc = "Move up" })
    vim.keymap.set("n", "<c-l>", "<c-w>l", { silent = true, desc = "Move right" })
end

-- window resize
if os.getenv("TMUX") then
    vim.keymap.set("n", "<c-Up>", function()
        require("tmux").resize_top()
    end, { silent = true, desc = "Resize up" })
    vim.keymap.set("n", "<c-Down>", function()
        require("tmux").resize_bottom()
    end, { silent = true, desc = "Resize down" })
    vim.keymap.set("n", "<c-Left>", function()
        require("tmux").resize_left()
    end, { silent = true, desc = "Resize left" })
    vim.keymap.set("n", "<c-Right>", function()
        require("tmux").resize_right()
    end, { silent = true, desc = "Resize right" })
else
    vim.keymap.set("n", "<c-Up>", ":resize -2<CR>", { silent = true })
    vim.keymap.set("n", "<c-Down>", ":resize +2<CR>", { silent = true })
    vim.keymap.set("n", "<c-Left>", ":vertical resize +2<CR>", { silent = true })
    vim.keymap.set("n", "<c-Right>", ":vertical resize -2<CR>", { silent = true })
end

-- window splits
-- vim.keymap.set("n", "<leader>s", ":split<Space>", { desc = "split" })
-- vim.keymap.set("n", "<leader>v", ":vsplit<Space>", { desc = "vsplit" })

-- tabs
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", { silent = true, desc = "Close tab" })
vim.keymap.set("n", "<leader>tc", ":tabnew<CR>", { silent = true, desc = "New tab" })
vim.keymap.set("n", "<leader>to", ":tabonly<CR>", { silent = true, desc = "Only tab" })
vim.keymap.set("n", "<S-l>", ":tabn<CR>", { silent = true, desc = "Next tab" })
vim.keymap.set("n", "<S-h>", ":tabp<CR>", { silent = true, desc = "Prev tab" })
-- move current tab to next position
vim.keymap.set("n", "<leader>tn", ":+tabmove<CR>", { silent = true, desc = "Move to next tab" })
-- move current tab to previous position
vim.keymap.set("n", "<leader>tp", ":-tabmove<CR>", { silent = true, desc = "Move to prev tab" })

-- ========== formatting ========== --
-- put brackets around word/s
vim.keymap.set("n", "<leader>(", "viwc()<esc>P", { silent = true, desc = "() around word" })
vim.keymap.set("n", "<leader>{", "viwc{}<esc>P", { silent = true, desc = "{} around word" })
vim.keymap.set("n", "<leader>[", "viwc[]<esc>P", { silent = true, desc = "[] around word" })
vim.keymap.set("n", "<leader>'", "viwc''<esc>P", { silent = true, desc = "'' around word" })
vim.keymap.set("n", '<leader>"', 'viwc""<esc>P', { silent = true, desc = '"" around word' })

-- put brackets around selected
vim.keymap.set("x", "<leader>(", "<ESC>`>a)<ESC>`<i(<ESC>", { silent = true, desc = "() around selected word" })
vim.keymap.set("x", "<leader>{", "<ESC>`>a}<ESC>`<i{<ESC>", { silent = true, desc = "{} around selected word" })
vim.keymap.set("x", "<leader>[", "<ESC>`>a]<ESC>`<i[<ESC>", { silent = true, desc = "[] around selected word" })
vim.keymap.set("x", "<leader>'", "<ESC>`>a'<ESC>`<i'<ESC>", { silent = true, desc = "'' around selected word" })
vim.keymap.set("x", '<leader>"', '<ESC>`>a"<ESC>`<i"<ESC>', { silent = true, desc = '"" around selected word' })
vim.keymap.set("x", "<leader>$", "<ESC>`>a$<ESC>`<i$<ESC>", { silent = true, desc = "$$ around selected word" })

-- move selected text
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", { silent = true, desc = "Move selected text" })
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", { silent = true, desc = "Move selected text" })

vim.keymap.set("n", "<leader>Z", ":set formatoptions-=a<cr>", { desc = "Remove format options" })
vim.keymap.set("n", "<leader>z", ":set formatoptions=a<cr>", { desc = "Add format options" })

-- ========== Mapping Notes ========== --
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
