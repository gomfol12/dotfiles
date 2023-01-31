-- ==================== null-ls (null-ls.nvim, mason-null-ls.nvim) ==================== --
-- Install: cmake-format(aur),
-- TODO: latexindent.yaml, .latexmkrc

local null_ls_ok, null_ls = pcall(require, "null-ls")
local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")

if not null_ls_ok and not mason_null_ls_ok then
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
        -- "checkstyle",
    },
})

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics

-- autoformat
local lsp_format = function(bufnr)
    vim.lsp.buf.format({
        filter = function(filter_client)
            return filter_client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

local on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                lsp_format(bufnr)
            end,
        })
    end
end

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
        formatting.clang_format.with({
            extra_args = { "-style={BasedOnStyle: Microsoft}" },
        }),
        formatting.cmake_format,

        code_actions.shellcheck,
        diagnostics.shellcheck,

        formatting.latexindent,
        diagnostics.chktex,

        -- diagnostics.checkstyle.with({
        --     extra_args = { "-c", "/sun_checks.xml" },
        -- }),
    },
    update_in_insert = true,
    on_attach = on_attach,
})
