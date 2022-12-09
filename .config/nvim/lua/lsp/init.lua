-- ==================== LSP (mason.nvim, mason-lspconfig.nvim, lspconfig.nvim, cmp-nvim-lsp.nvim) ==================== --

local _M = {}

local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp_config = pcall(require, "mason-lspconfig")
local lsp_ok, lsp_config = pcall(require, "lspconfig")
local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not mason_ok and not mason_lsp_ok and not lsp_ok and not cmp_ok then
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
        border = "single",
    },
})

mason.setup()

mason_lsp_config.setup({
    ensure_installed = { "jdtls" },
    automatic_installation = true,
})

_M.capabilities = cmp_nvim_lsp.default_capabilities()

-- fix for clangd
_M.capabilities.offsetEncoding = { "utf-16" }

-- Keybinds
function _M.keybinds(bufnr)
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

-- Auto highlighting
function _M.highlight(client, bufnr)
    if client.supports_method("textDocument/documentHighlight") then
        local augroup = vim.api.nvim_create_augroup("LspHighlighting", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            group = augroup,
            buffer = bufnr,
            command = ":lua vim.lsp.buf.document_highlight()",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            group = augroup,
            buffer = bufnr,
            command = ":lua vim.lsp.buf.clear_references()",
        })
    end
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
        border = "single",
    })
end

local opts = {
    on_attach = function(client, bufnr)
        _M.highlight(client, bufnr)
        _M.keybinds(bufnr)
    end,
    capabilities = _M.capabilities,
}

return setmetatable(_M, {
    __call = function()
        lsp_config.sumneko_lua.setup(vim.tbl_deep_extend("force", require("lsp.settings.sumneko_lua"), opts))
        lsp_config.jsonls.setup(vim.tbl_deep_extend("force", require("lsp.settings.jsonls_lua"), opts))
        lsp_config.bashls.setup(opts)
        lsp_config.cmake.setup(opts)
        lsp_config.html.setup(opts)
        lsp_config.cssls.setup(opts)
        lsp_config.ltex.setup(vim.tbl_deep_extend("force", require("lsp.settings.ltex_lua"), opts))
        -- lsp_config.marksman.setup(opts)

        require("clangd_extensions").setup({
            server = {
                on_attach = function(client, bufnr)
                    _M.highlight(client, bufnr)
                    _M.keybinds(bufnr)
                    -- local augroup = vim.api.nvim_create_augroup("LspClangSymbolInfo", { clear = true })
                    -- vim.api.nvim_create_autocmd("CursorHold", {
                    --     group = augroup,
                    --     buffer = bufnr,
                    --     command = ":ClangdSymbolInfo",
                    -- })
                end,
                capabilities = _M.capabilities,
            },
            extensions = {
                -- Automatically set inlay hints (type hints)
                autoSetHints = true,
                -- These apply to the default ClangdSetInlayHints command
                inlay_hints = {
                    -- Only show inlay hints for the current line
                    only_current_line = true,
                    -- Event which triggers a refersh of the inlay hints.
                    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                    -- not that this may cause  higher CPU usage.
                    -- This option is only respected when only_current_line and
                    -- autoSetHints both are true.
                    only_current_line_autocmd = "CursorHold",
                    -- whether to show parameter hints with the inlay hints or not
                    show_parameter_hints = true,
                    -- prefix for parameter hints
                    parameter_hints_prefix = "<- ",
                    -- prefix for all the other hints (type, chaining)
                    other_hints_prefix = "=> ",
                    -- whether to align to the length of the longest line in the file
                    max_len_align = true,
                    -- padding from the left if max_len_align is true
                    max_len_align_padding = 4,
                    -- whether to align to the extreme right or not
                    right_align = false,
                    -- padding from the right if right_align is true
                    right_align_padding = 7,
                    -- The color of the hints
                    highlight = "Comment",
                    -- The highlight group priority for extmark
                    priority = 100,
                },
                ast = {
                    role_icons = {
                        type = "",
                        declaration = "",
                        expression = "",
                        specifier = "",
                        statement = "",
                        ["template argument"] = "",
                    },

                    kind_icons = {
                        Compound = "",
                        Recovery = "",
                        TranslationUnit = "",
                        PackExpansion = "",
                        TemplateTypeParm = "",
                        TemplateTemplateParm = "",
                        TemplateParamObject = "",
                    },
                    highlights = {
                        detail = "Comment",
                    },
                },
                memory_usage = {
                    border = "none",
                },
                symbol_info = {
                    border = "none",
                },
            },
        })

        require("lsp.null")
        require("lsp.debug")
    end,
})
