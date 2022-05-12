-- ==================== LSP (nvim-lspconfig, nvim-lsp-installer, cmp_nvim_lsp, ...) ==================== --

local inst_status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not inst_status_ok then
    return
end

local conf_status_ok, lsp_config = pcall(require, "lspconfig")
if not conf_status_ok then
    return
end

local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = false,
    signs = {
        active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
    },
})

local function lsp_keymaps(bufnr)
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<cr>", opts)
    vim.keymap.set("n", "gD", ":lua vim.lsp.buf.declaration()<cr>", opts)
    vim.keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", opts)
    vim.keymap.set("n", "gw", ":lua vim.lsp.buf.document_symbol()<cr>", opts)
    vim.keymap.set("n", "gw", ":lua vim.lsp.buf.workspace_symbol()<cr>", opts)
    vim.keymap.set("n", "gr", ":lua vim.lsp.buf.references()<cr>", opts)
    vim.keymap.set("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<cr>", opts)
    vim.keymap.set("n", "gs", ":lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "<leader>af", ":lua vim.lsp.buf.code_action()<cr>", opts)
    vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "<F2>", ":lua vim.lsp.buf.rename()<cr>", opts)
    vim.keymap.set("n", "<leader>m", ":lua vim.lsp.buf.formatting()<cr>", opts)
    vim.keymap.set("n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", opts)
    vim.keymap.set("n", "]d", ":lua vim.diagnostic.goto_next()<cr>", opts)
    vim.keymap.set("n", "gl", ":lua vim.diagnostic.open_float()<cr>", opts)
    vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", opts)
end

local function lsp_highlight_document(client)
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
            false
        )
    end
end

lsp_installer.setup({
    automatic_installation = true,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
    return
end
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local opts = {
    on_attach = function(client, bufnr)
        for _, server in ipairs({ "html", "clangd", "cmake", "jsonls", "sumneko_lua" }) do
            if client.name == server then
                client.resolved_capabilities.document_formatting = false
            end
        end

        lsp_keymaps(bufnr)
        lsp_highlight_document(client)
    end,
    flags = {
        debounce_text_changes = 150,
    },
    capabilities = capabilities,
}

lsp_config.sumneko_lua.setup(vim.tbl_deep_extend("force", require("lsp.settings.sumneko_lua"), opts))
lsp_config.jsonls.setup(vim.tbl_deep_extend("force", require("lsp.settings.jsonls_lua"), opts))
lsp_config.bashls.setup(opts)
lsp_config.clangd.setup(opts)
lsp_config.cmake.setup(opts)
lsp_config.html.setup(opts)
lsp_config.cssls.setup(opts)
--lsp_config.ltex.setup(vim.tbl_deep_extend("force", require("lsp.settings.ltex_lua"), opts))

require("lsp.null")
require("lsp.debug")
