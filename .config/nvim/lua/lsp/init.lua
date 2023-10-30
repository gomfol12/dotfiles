-- ==================== LSP (mason.nvim, mason-lspconfig.nvim, lspconfig.nvim, cmp-nvim-lsp.nvim) ==================== --

local _M = {}
local U = require("utils")

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
        severity = {
            min = vim.diagnostic.severity.INFO,
        },
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

-- folding
_M.capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
}

-- inc-rename.nvim
local function inc_rename()
    return ":IncRename " .. vim.fn.expand("<cword>")
end

-- Keybinds
-- stylua: ignore
function _M.keybinds(bufnr)
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<cr>", U.concat(opts, { desc = "LSP: go to definition" }))
    vim.keymap.set("n", "gD", ":lua vim.lsp.buf.declaration()<cr>", U.concat(opts, { desc = "LSP: go to declaration" }))
    vim.keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", U.concat(opts, { desc = "LSP: go to implementation" }))
    vim.keymap.set("n", "gw", ":lua vim.lsp.buf.document_symbol()<cr>", U.concat(opts, { desc = "LSP: list document symbols " }))
    vim.keymap.set("n", "gq", ":lua vim.lsp.buf.workspace_symbol()<cr>", U.concat(opts, { desc = "LSP: query document symbol" }))
    vim.keymap.set("n", "gr", ":lua vim.lsp.buf.references()<cr>", U.concat(opts, { desc = "LSP: references" }))
    vim.keymap.set("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", U.concat(opts, { desc = "LSP: type definition" }))
    vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<cr>",  U.concat(opts, { desc = "LSP: hover info" }))
    -- vim.keymap.set("n", "gs", ":lua vim.lsp.buf.signature_help()<cr>",  U.concat(opts, { desc = "LSP: signature help" }))
    vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>",  U.concat(opts, { desc = "LSP: code action" }))
    -- vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>",  U.concat(opts, { desc = "LSP: rename" }))
    -- vim.keymap.set("n", "<leader>n", ":lua vim.lsp.buf.rename()<cr>",  U.concat(opts, { desc = "LSP: rename" }))
    -- vim.keymap.set("n", "<F2>", ":lua vim.lsp.buf.rename()<cr>",  U.concat(opts, { desc = "LSP: rename" }))
    vim.keymap.set("n", "<leader>rn", inc_rename, U.concat(opts, { desc = "LSP: rename", expr = true }))
    vim.keymap.set("n", "<leader>n", inc_rename, U.concat(opts, { desc = "LSP: rename", expr = true }))
    vim.keymap.set("n", "<F2>", inc_rename, U.concat(opts, { desc = "LSP: rename", expr = true }))
    vim.keymap.set("n", "<leader>m", ":lua vim.lsp.buf.formatting()<cr>",  U.concat(opts, { desc = "LSP: format" }))
    vim.keymap.set("n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", U.concat(opts, { desc = "LSP: diagnostic next" }))
    vim.keymap.set("n", "]d", ":lua vim.diagnostic.goto_next()<cr>",  U.concat(opts, { desc = "LSP: diagnostic prev" }))
    vim.keymap.set("n", "gl", ":lua vim.diagnostic.open_float()<cr>",  U.concat(opts, { desc = "LSP: diagnostic cursor" }))
    vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", U.concat(opts, { desc = "LSP: diagnostic all" }))
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

        if client.name == "clangd" then
            require("clangd_extensions.inlay_hints").setup_autocmd()
            require("clangd_extensions.inlay_hints").set_inlay_hints()
        elseif client.name == "metals" then
            require("metals").setup_dap()
        end
    end,
    capabilities = _M.capabilities,
}

local function setup_scala()
    local metals_ok, metals = pcall(require, "metals")
    if not metals_ok then
        return
    end

    -- check for coursier. Is required for Metals
    local utils = require("utils")
    if not utils.check_executable({ "coursier" }, "Coursier is required for Metals") then
        return
    end

    local metals_config = require("metals").bare_config()
    metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
    }
    metals_config.capabilities = opts.capabilities
    metals_config.on_attach = opts.on_attach

    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt" },
        callback = function()
            metals.initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
    })
end

return setmetatable(_M, {
    __call = function()
        lsp_config.lua_ls.setup(vim.tbl_deep_extend("force", require("lsp.settings.lua_ls"), opts))
        lsp_config.jsonls.setup(vim.tbl_deep_extend("force", require("lsp.settings.jsonls_lua"), opts))
        lsp_config.bashls.setup(opts)
        lsp_config.cmake.setup(opts)
        lsp_config.html.setup(opts)
        lsp_config.cssls.setup(opts)
        lsp_config.svlangserver.setup(vim.tbl_deep_extend("force", require("lsp.settings.svlangserver_lua"), opts))
        lsp_config.texlab.setup(opts)
        lsp_config.pyright.setup(opts)
        lsp_config.clangd.setup(opts)
        local clangd_extensions_ok, clangd_extensions = pcall(require, "clangd_extensions")
        if clangd_extensions_ok then
            clangd_extensions.setup(require("lsp.settings.clangd_ext_lua"))
        end
        local rust_tools_ok, rust_tools = pcall(require, "rust-tools")
        if rust_tools_ok then
            rust_tools.setup(require("lsp.settings.rust_tools_lua")(opts))
        end
        setup_scala()

        -- lsp_config.ltex.setup(vim.tbl_deep_extend("force", require("lsp.settings.ltex_lua"), opts))
        -- lsp_config.marksman.setup(opts)

        require("lsp.format")
        require("lsp.lint")
        require("lsp.debug")
        require("lsp.fold")
    end,
})
