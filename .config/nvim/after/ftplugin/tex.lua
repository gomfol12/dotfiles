local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "[d", ':lua vim.diagnostic.goto_prev({ border = "none" })<cr>', opts)
keymap.set("n", "]d", ':lua vim.diagnostic.goto_next({ border = "none" })<cr>', opts)
keymap.set("n", "gl", ':lua vim.diagnostic.open_float({ border = "none" })<cr>', opts)
keymap.set("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", opts)
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

keymap.set("n", "<leader>li", ":VimtexInfo<CR>", { silent = true })
keymap.set("n", "<leader>lt", ":VimtexTocToggle<CR>", { silent = true })
keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", { silent = true })
keymap.set("n", "<leader>ls", ":VimtexStop<CR>", { silent = true })
keymap.set("n", "<leader>lc", ":VimtexClean<CR>", { silent = true })
keymap.set("n", "<leader>le", ":VimtexErrors<CR>", { silent = true })
keymap.set("n", "<leader>lv", ":VimtexView<CR>", { silent = true })
