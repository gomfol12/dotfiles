local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local servers = {
    "sumneko_lua",
    "jsonls",
    "bashls",
}

for _, name in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end

lsp_installer.on_server_ready(function(server)
    local opts = {
        on_attach = require("lsp.handlers").on_attach,
        capabilities = require("lsp.handlers").capabilities,
    }

    if server.name == "sumneko_lua" then
        local sumneko_lua_opts = require("lsp.settings.sumneko_lua")
        opts = vim.tbl_deep_extend("force", sumneko_lua_opts, opts)
    end

    if server.name == "jsonls" then
        local jsonls_opts = require("lsp.settings.jsonls_lua")
        opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
    end

    server:setup(opts)
end)
