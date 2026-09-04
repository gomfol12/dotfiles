-- ==================== Treesitter ==================== --

return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
            "HiPhish/rainbow-delimiters.nvim",
            {
                "lukas-reineke/indent-blankline.nvim",
                config = function()
                    local highlight = {
                        "RainbowRed",
                        "RainbowYellow",
                        "RainbowBlue",
                        "RainbowOrange",
                        "RainbowGreen",
                        "RainbowViolet",
                        "RainbowCyan",
                    }
                    local hooks = require("ibl.hooks")
                    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#B16286" })
                        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
                        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
                        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
                        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#689d6a" })
                        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#E06C75" })
                        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#458588" })
                    end)

                    vim.g.rainbow_delimiters = { highlight = highlight }
                    require("ibl").setup({
                        scope = {
                            highlight = highlight,
                            show_start = false,
                            show_end = false,
                        },
                        indent = {
                            char = "▏",
                        },
                    })

                    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
                end,
            },
        },
        config = function()
            local ensureInstalled = vim.tbl_extend("force", {
                "c",
                "cpp",
                "lua",
                "luadoc",
                "python",
                "rust",
                "bash",
                "bibtex",
                "cmake",
                "make",
                "comment",
                "css",
                "diff",
                "dockerfile",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "http",
                "java",
                "javascript",
                "typescript",
                "json",
                "kotlin",
                "markdown",
                "markdown_inline",
                "ninja",
                "php",
                "perl",
                "racket",
                "regex",
                "scheme",
                "scss",
                "sql",
                "toml",
                "query",
                "vim",
                "vimdoc",
                "yaml",
                "fortran",
                "qmljs",
                "hyprlang",
            }, (vim.fn.executable("pdflatex") == 1 or vim.fn.executable("lualatex") == 1) and { "latex" } or {})

            local alreadyInstalled = require("nvim-treesitter.config").get_installed()
            local parsersToInstall = vim.iter(ensureInstalled)
                :filter(function(parser)
                    return not vim.tbl_contains(alreadyInstalled, parser)
                end)
                :totable()
            require("nvim-treesitter").install(parsersToInstall)

            for _, parser in ipairs(ensureInstalled) do
                vim.api.nvim_create_autocmd("FileType", {
                    pattern = parser,
                    callback = function(args)
                        local max_lines = 10000
                        if vim.api.nvim_buf_line_count(args.buf) > max_lines then
                            return
                        end
                        vim.schedule(function()
                            if vim.api.nvim_buf_is_valid(args.buf) then
                                vim.treesitter.start(args.buf)
                                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                            end
                        end)
                    end,
                })
            end

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    if not ensureInstalled[args.match] then
                        vim.schedule(function()
                            vim.cmd("syntax on")
                        end)
                    end
                end,
            })
        end,
    },
    --textobjects = {
    --    select = {
    --        enable = true,
    --        lookahead = true,
    --        keymaps = {
    --            ["af"] = "@function.outer",
    --            ["if"] = "@function.inner",
    --            ["ac"] = "@class.outer",
    --            ["ic"] = "@class.inner",
    --            ["ib"] = { query = "@block.inner", desc = "in block" },
    --        },
    --    },
    --    move = {
    --        enable = true,
    --        set_jumps = true,
    --        goto_next_start = {
    --            ["]m"] = "@function.outer",
    --            ["]]"] = "@class.outer",
    --        },
    --        goto_next_end = {
    --            ["]M"] = "@function.outer",
    --            ["]["] = "@class.outer",
    --        },
    --        goto_previous_start = {
    --            ["[m"] = "@function.outer",
    --            ["[["] = "@class.outer",
    --        },
    --        goto_previous_end = {
    --            ["[M"] = "@function.outer",
    --            ["[]"] = "@class.outer",
    --        },
    --    },
    --    swap = {
    --        enable = true,
    --        swap_next = {
    --            ["<leader>a"] = "@parameter.inner",
    --        },
    --        swap_previous = {
    --            ["<leader>A"] = "@parameter.inner",
    --        },
    --    },
    --    lsp_interop = {
    --        enable = true,
    --        border = "single",
    --        peek_definition_code = {
    --            ["<leader>df"] = "@function.outer",
    --            ["<leader>dF"] = "@class.outer",
    --        },
    --    },
    --    matchup = {
    --        enable = true,
    --    },
    --},
}
