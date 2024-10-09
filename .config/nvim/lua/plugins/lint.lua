-- ==================== Lint (nvim-lint) ==================== --

-- check if linter is installed
local utils = require("config.utils")
utils.check_linters({ "chktex", "cppcheck" })

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        lint.linters_by_ft = {
            markdown = { "markdownlint" },
            bash = { "shellcheck" },
            tex = { "chktex" },
            python = { "mypy", "ruff" },
            c = { "cppcheck" },
            cpp = { "cppcheck" },
            dockerfile = { "hadolint" },
            json = { "jsonlint" },
            text = { "vale" },
        }

        lint.linters.chktex.ignore_exitcode = true

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
