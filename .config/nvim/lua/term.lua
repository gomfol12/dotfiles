-- ==================== ToggleTerm (toggleterm.nvim) ==================== --

local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup({
    -- open_mapping = [[<c-\>]],
})

function _G.set_terminal_keymaps()
    local opts = { buffer = 0 }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
    vim.keymap.set("t", "<C-h>", require("tmux").move_left, opts)
    vim.keymap.set("t", "<C-j>", require("tmux").move_bottom, opts)
    vim.keymap.set("t", "<C-k>", require("tmux").move_top, opts)
    vim.keymap.set("t", "<C-l>", require("tmux").move_right, opts)

    vim.keymap.set("t", "<c-Up>", function()
        require("tmux").resize_top()
        require("bufresize").register()
    end, { silent = true, desc = "Resize up" })

    vim.keymap.set("t", "<c-Down>", function()
        require("tmux").resize_bottom()
        require("bufresize").register()
    end, { silent = true, desc = "Resize down" })

    vim.keymap.set("t", "<c-Left>", function()
        require("tmux").resize_left()
        require("bufresize").register()
    end, { silent = true, desc = "Resize left" })

    vim.keymap.set("t", "<c-Right>", function()
        require("tmux").resize_right()
        require("bufresize").register()
    end, { silent = true, desc = "Resize right" })
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
