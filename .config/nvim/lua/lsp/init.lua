-- ==================== LSP (nvim-lspconfig, nvim-lsp-installer, cmp_nvim_lsp, ...) ==================== --

local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("lsp.lsp-installer")
require("lsp.handlers").setup()
require("lsp.signature")
require("lsp.null")
require("lsp.debug")
