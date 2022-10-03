-- ==================== null-ls (null-ls.nvim) ==================== --
-- Install: stylua, prettier, shfmt, shellcheck, clang-format, cmake-format(aur),
-- chktex, latexindent
-- TODO: latexindent.yaml, .latexmkrc

local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local code_actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local hover = null_ls.builtins.hover
local completion = null_ls.builtins.completion

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == "null-ls"
        end,
        bufnr = bufnr,
    })
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end,
            })
        end
    end,
})
