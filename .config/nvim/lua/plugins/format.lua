-- ==================== Format (conform.nvim) ==================== --

-- check if formatter is installed
local utils = require("config.utils")
utils.check_formatters({ "clang-format", "cmake-format" }) -- other formatter are automatically installed by mason

-- Enable/Disable autoformat
vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

-- Range Format
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true, desc = "Format range" })

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end,
            mode = "",
            desc = "[F]ormat buffer",
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end

            local disable_filetypes = {}
            local lsp_format_opt
            if disable_filetypes[vim.bo[bufnr].filetype] or vim.g.disable_autoformat then
                lsp_format_opt = "never"
            else
                lsp_format_opt = "fallback"
            end

            return {
                timeout_ms = 500,
                lsp_format = lsp_format_opt,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            bash = { "shfmt" },
            zsh = { "shfmt" },
            sh = { "shfmt" },
            html = { "prettier" },
            css = { "prettier" },
            json = { "prettier" },
            -- markdown = { "prettier" },
            yaml = { "prettier" },
            c = { "clang_format" },
            cpp = { "clang_format" },
            cuda = { "clang_format" },
            cmake = { "cmake_format" },
            tex = { "latexindent" },
            python = { "black" },

            javascript = { "prettier" },
            typescript = { "prettier" },
        },
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
            shfmt = {
                prepend_args = { "-i", "4", "-fn" },
            },
            prettier = {
                prepend_args = { "--tab-width", "4" },
            },
            clang_format = {
                prepend_args = { "-style={BasedOnStyle: Microsoft}" },
            },
        },
    },
}
