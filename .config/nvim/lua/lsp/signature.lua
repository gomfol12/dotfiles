local sig_status_ok, lsp_signature = pcall(require, 'lsp_signature')
if not sig_status_ok then
    return
end

lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "rounded",
    },
    hint_enable = true,
    hint_prefix = "param: "
})
