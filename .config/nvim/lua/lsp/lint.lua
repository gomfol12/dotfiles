-- ==================== lint (nvim-lint) ==================== --

local lint_ok, lint = pcall(require, "lint")
if not lint_ok then
    return
end

lint.linters_by_ft = {
    bash = { "shellcheck" },
    tex = { "chktex" },
}

vim.api.nvim_create_autocmd({ "InsertLeave", "BufEnter", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
