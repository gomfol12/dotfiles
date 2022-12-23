-- ==================== bufresize (bufresize.nvim) ==================== --

local status_ok, buf = pcall(require, "bufresize")
if not status_ok then
    return
end

local U = require("utils")

local opts = { noremap = true, silent = true }
buf.setup({
    register = {
        keys = {
            { "n", "<leader>w<", "20<C-w><", U.concat(opts, { desc = "Resize right" }) },
            { "n", "<leader>w>", "20<C-w>>", U.concat(opts, { desc = "Resize left" }) },
            { "n", "<leader>w+", "5<C-w>+", U.concat(opts, { desc = "Resize more" }) },
            { "n", "<leader>w-", "5<C-w>-", U.concat(opts, { desc = "Resize less" }) },
            { "n", "<leader>w_", "<C-w>_", U.concat(opts, { desc = "Resize horizontally" }) },
            { "n", "<leader>w=", "<C-w>=", U.concat(opts, { desc = "Resize equalize" }) },
            { "n", "<leader>w|", "<C-w>|", U.concat(opts, { desc = "Resize vertically" }) },
            { "n", "<leader>wo", "<C-w>|<C-w>_", U.concat(opts, { desc = "Resize horizontally and vertically" }) },

            { "n", "<C-w><", "<C-w><", U.concat(opts, { desc = "Resize right" }) },
            { "n", "<C-w>>", "<C-w>>", U.concat(opts, { desc = "Resize left" }) },
            { "n", "<C-w>+", "<C-w>+", U.concat(opts, { desc = "Resize more" }) },
            { "n", "<C-w>-", "<C-w>-", U.concat(opts, { desc = "Resize less" }) },
            { "n", "<C-w>_", "<C-w>_", U.concat(opts, { desc = "Resize horizontally" }) },
            { "n", "<C-w>=", "<C-w>=", U.concat(opts, { desc = "Resize equalize" }) },
            { "n", "<C-w>|", "<C-w>|", U.concat(opts, { desc = "Resize vertically" }) },
            { "", "<LeftRelease>", "<LeftRelease>", opts },
            { "i", "<LeftRelease>", "<LeftRelease><C-o>", opts },
        },
        trigger_events = { "BufWinEnter", "WinEnter" },
    },
    resize = {
        keys = {},
        trigger_events = { "VimResized" },
        increment = 5,
    },
})
