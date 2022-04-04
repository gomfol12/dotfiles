local utils = require("utils")

local opts = { noremap = true, silent = true }

utils.map("n", "[d", ':lua vim.diagnostic.goto_prev({ border = "none" })<cr>', opts)
utils.map("n", "]d", ':lua vim.diagnostic.goto_next({ border = "none" })<cr>', opts)
utils.map("n", "gl", ':lua vim.diagnostic.open_float({ border = "none" })<cr>', opts)
utils.map("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", opts)
vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])

utils.map("n", "<leader>li", ":VimtexInfo<CR>", { silent = true })
utils.map("n", "<leader>lt", ":VimtexTocToggle<CR>", { silent = true })
utils.map("n", "<leader>ll", ":VimtexCompile<CR>", { silent = true })
utils.map("n", "<leader>ls", ":VimtexStop<CR>", { silent = true })
utils.map("n", "<leader>lc", ":VimtexClean<CR>", { silent = true })
utils.map("n", "<leader>le", ":VimtexErrors<CR>", { silent = true })
utils.map("n", "<leader>lv", ":VimtexView<CR>", { silent = true })

-- function Synctex()
--     os.execute(
--         "zathura.sh --synctex-forward "
--             .. vim.api.nvim_win_get_cursor(0)[1]
--             .. ":1:"
--             .. vim.fn.expand("%:p")
--             .. " "
--             .. vim.fn.expand("%:p"):gsub(".tex$", ".pdf")
--     )
-- end

-- function OpenZathura()
--     os.execute("zathura.sh " .. vim.fn.expand("%:p"):gsub(".tex$", ".pdf"))
-- end

-- utils.map("n", "<leader>o", ":lua OpenZathura()<cr>", { silent = true })
-- utils.map("n", "<c-cr>", ":lua Synctex()<cr>", { silent = true })
