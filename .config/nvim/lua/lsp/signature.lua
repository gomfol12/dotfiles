-- ==================== lsp_signature (lsp_signature.nvim) ==================== --

local sig_status_ok, lsp_signature = pcall(require, "lsp_signature")
if not sig_status_ok then
    return
end

lsp_signature.setup({
    bind = true,
    handler_opts = {
        border = "none",
    },
    hint_enable = false,
    hint_prefix = ": ",
    hint_scheme = "String",
    timer_interval = 100,
    toggle_key = "<c-x>",
})
