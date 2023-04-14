local keymap = vim.keymap

require("lsp").keybinds(0)
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

keymap.set("n", "<leader>li", ":VimtexInfo<CR>", { silent = true, desc = "Vimtex info" })
keymap.set("n", "<leader>lt", ":VimtexTocToggle<CR>", { silent = true, desc = "Vimtex toc toggle" })
keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", { silent = true, desc = "Vimtex compile" })
keymap.set("n", "<leader>ls", ":VimtexStop<CR>", { silent = true, desc = "Vimtex stop" })
keymap.set("n", "<leader>lc", ":VimtexClean<CR>", { silent = true, desc = "Vimtex clean" })
keymap.set("n", "<leader>le", ":VimtexErrors<CR>", { silent = true, desc = "Vimtex errors" })
keymap.set("n", "<leader>lv", ":VimtexView<CR>", { silent = true, desc = "Vimtex view" })

vim.cmd(":autocmd BufNewFile,BufRead *.tex VimtexCompile")
