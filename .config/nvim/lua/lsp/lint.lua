-- ==================== lint (nvim-lint) ==================== --

local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
    return
end

lint.linters_by_ft = {
    bash = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
