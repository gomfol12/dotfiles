local M = {}

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
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
            border = "none",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "none",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "none",
    })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", ":lua vim.lsp.buf.definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", ":lua vim.lsp.buf.declaration()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":lua vim.lsp.buf.implementation()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gw", ":lua vim.lsp.buf.document_symbol()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gw", ":lua vim.lsp.buf.workspace_symbol()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":lua vim.lsp.buf.references()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", ":lua vim.lsp.buf.hover()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>af", ":lua vim.lsp.buf.code_action()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", ":lua vim.lsp.buf.rename()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", ':lua vim.diagnostic.goto_prev({ border = "none" })<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", ':lua vim.diagnostic.goto_next({ border = "none" })<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gl", ':lua vim.diagnostic.open_float({ border = "none" })<cr>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", opts)
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
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

-- local function lsp_open_float_on_highlight(client)
--     if client.resolved_capabilities.document_highlight then
--         vim.api.nvim_exec(
--             [[
--             augroup lsp_open_float_on_highlight
--                 autocmd! * <buffer>
--                 autocmd CursorHold <buffer> lua vim.diagnostic.open_float({ border = "rounded" })
--             augroup END
--             ]],
--             false
--         )
--     end
-- end

M.on_attach = function(client, bufnr)
    -- if client.name == "ccls" or "cmake" then
    --     client.resolved_capabilities.textDocument.completion.completionItem.snippetSupport = true
    -- end
    if client.name == "html" then
        client.resolved_capabilities.document_formatting = false
    end
    if client.name == "clangd" then
        client.resolved_capabilities.document_formatting = false
    end
    if client.name == "cmake" then
        client.resolved_capabilities.document_formatting = false
    end
    if client.name == "jsonls" then
        client.resolved_capabilities.document_formatting = false
    end

    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
    -- lsp_open_float_on_highlight(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
-- fix for "warning: multiple different client offset_encodings detected for buffer, this is not supported yet"
capabilities.offsetEncoding = { "utf-16" }

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

return M
