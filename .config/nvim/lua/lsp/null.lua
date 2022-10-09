-- ==================== null-ls (null-ls.nvim, mason-null-ls.nvim) ==================== --
-- Install: cmake-format(aur),
-- TODO: latexindent.yaml, .latexmkrc

local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
    return
end

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_ok then
    return
end

mason_null_ls.setup({
    ensure_installed = {
        "stylua",
        "prettier",
        "shfmt",
        "shellcheck",
        "clang_format",
        "latexindent",
        "chktex",
    },
})

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
    sources = {
        formatting.stylua.with({
            extra_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        }),
        formatting.prettier.with({
            extra_args = { "--tab-width", "4" },
        }),
        formatting.shfmt.with({
            extra_args = { "-i", "4", "-fn" },
        }),
        -- formatting.clang_format.with({
        --     extra_args = { "-style={BasedOnStyle: Microsoft}" },
        -- }),
        formatting.cmake_format,

        code_actions.shellcheck,
        diagnostics.shellcheck,

        formatting.latexindent,
        diagnostics.chktex,
    },
    update_in_insert = true,
    --format on save
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        filter = function()
                            return client.name == "null-ls"
                        end,
                        bufnr = bufnr,
                    })
                end,
            })
        end
    end,
})
