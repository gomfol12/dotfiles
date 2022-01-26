-- ==================== null-ls (null-ls.nvim) ==================== --
-- Install: stylua(aur), prettier, shfmt, shellcheck, uncrustify, cmake-format(aur)
-- TODO: cpp formatter

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
        -- throws waring
        --[[ formatting.uncrustify.with({
            extra_args = { "-c", vim.fn.expand("~/.config/nvim/uncrustify.cfg") },
        }), ]]
        formatting.cmake_format,

        diagnostics.shellcheck,
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
