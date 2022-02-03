local utils = require("utils")

function Synctex()
    os.execute(
        "zathura.sh --synctex-forward "
            .. vim.api.nvim_win_get_cursor(0)[1]
            .. ":1:"
            .. vim.fn.expand("%:p")
            .. " "
            .. vim.fn.expand("%:p"):gsub(".tex$", ".pdf")
    )
end

function OpenZathura()
    os.execute("zathura.sh " .. vim.fn.expand("%:p"):gsub(".tex$", ".pdf"))
end

utils.map("n", "<leader>o", ":lua OpenZathura()<cr>", { silent = true })
utils.map("n", "<c-cr>", ":lua Synctex()<cr>", { silent = true })

vim.opt.spell = true
