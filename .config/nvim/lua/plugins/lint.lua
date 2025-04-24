-- ==================== Lint (nvim-lint) ==================== --

local utils = require("config.utils")

-- check if linter is installed
utils.check_linters({ "chktex", "clang-tidy", "fortitude" })

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
            c = { "clangtidy" },
            cpp = { "clangtidy" },
            dockerfile = { "hadolint" },
            json = { "jsonlint" },
            fortran = { "fortitude" },
            -- text = { "vale" },
        }

        lint.linters.chktex.ignore_exitcode = true

        local build_path = utils.scan_dir_with_name("build")
        if build_path ~= "" then
            lint.linters.clangtidy.args = { "-p", build_path }
        end

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                lint.try_lint()
            end,
        })
    end,
}
