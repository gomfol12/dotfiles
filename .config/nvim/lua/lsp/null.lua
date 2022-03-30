-- ==================== null-ls (null-ls.nvim) ==================== --
-- Install: stylua(aur), prettier, shfmt, shellcheck, clang_format, cmake-format(aur),
-- chktex, latexindent, cppcheck
-- TODO: latexindent.yaml, .latexmkrc

local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local completion = null_ls.builtins.completion

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

        diagnostics.shellcheck,

        diagnostics.cppcheck.with({
            extra_args = {
                "--enable=all",
                "--template=gcc",
                "--language=c++",
                "--suppress=missingIncludeSystem",
                "$FILENAME",
            },
        }),
    },
    --format on save
    on_attach = function(client)
        if client.resolved_capabilities.document_formatting then
            vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
        end
    end,
})
