-- install jdtls

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

local config = {
    cmd = { "jdtls" },
    root_dir = vim.fs.dirname(vim.fs.find({ ".gradlew", ".git", "mvnw" }, { upward = true })[1]),
}
require("jdtls").start_or_attach(config)
