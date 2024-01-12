-- ==================== lint (nvim-lint) ==================== --

local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
    return
end

local utils = require("utils")
utils.check_linters({ "shellcheck", "chktex", "mypy", "ruff" })

lint.linters_by_ft = {
    bash = { "shellcheck" },
    tex = { "chktex" },
    python = { "mypy", "ruff" },
}

lint.linters.chktex.ignore_exitcode = true

vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
