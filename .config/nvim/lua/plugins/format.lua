-- ==================== Format (conform.nvim) ==================== --

-- check if formatter is installed
local utils = require("config.utils")
utils.check_formatters({ "clang-format", "cmake-format" }) -- other formatter are automatically installed by mason

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

local clang_format_args = {}
local clang_format_file = utils.scan_dir_with_name(".clang.*format")
if clang_format_file == "" then
    clang_format_args = { "-style={BasedOnStyle: Microsoft}" }
end

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
            html = { "prettier", prepend_args = { "--tab-width", "4" } },
            css = { "prettier", prepend_args = { "--tab-width", "4" } },
            json = { "prettier", prepend_args = { "--tab-width", "4" } },
            markdown = {
                "prettier",
                prepend_args = {
                    "--print-width",
                    "80",
                    "--prose-wrap",
                    "always",
                    "--tab-width",
                    "2",
                },
            },
            yaml = { "prettier", prepend_args = { "--tab-width", "4" } },
            c = { "clang_format" },
            cpp = { "clang_format" },
            cuda = { "clang_format" },
            cmake = { "cmake_format" },
            tex = { "latexindent" },
            python = { "ruff" },
            fortran = { "fprettify" },

            javascript = { "prettier", prepend_args = { "--tab-width", "4" } },
            typescript = { "prettier", prepend_args = { "--tab-width", "4" } },
        },
        formatters = {
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
            shfmt = {
                prepend_args = { "-i", "4", "-fn" },
            },
            clang_format = {
                prepend_args = clang_format_args,
            },
            fprettify = {
                prepend_args = { "--silent", "--indent", "4" },
            },
        },
    },
}
