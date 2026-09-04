-- ==================== Lint (nvim-lint) ==================== --

local utils = require("config.utils")

-- check if linter is installed

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lint = require("lint")

        utils.check_linters({ "chktex", "clang-tidy", "fortitude" })

        lint.linters_by_ft = {
            -- markdown = { "markdownlint" },
            bash = { "shellcheck" },
            tex = { "chktex" },
            python = { "mypy", "ruff" },
            c = { "clangtidy" },
            cpp = { "clangtidy" },
            dockerfile = { "hadolint" },
            json = { "jsonlint" },
            fortran = { "fortitude" },
            vim = { "vint" },
            -- text = { "vale" },
            proto = { "protolint" },
        }

        lint.linters.chktex.ignore_exitcode = true

        local build_path = utils.scan_dir_with_name("compile_commands.json")
        if build_path ~= "" then
            lint.linters.clangtidy.args = { "-p", build_path }
        end

        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            group = lint_augroup,
            callback = function(args)
                lint.try_lint()
            end,
        })
    end,
}
