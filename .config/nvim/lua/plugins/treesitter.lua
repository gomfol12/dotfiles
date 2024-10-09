return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        main = "nvim-treesitter.configs", -- Sets main module to use for opts
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
            "nvim-treesitter/playground",
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
        opts = {
            ensure_installed = {
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
                "json",
                "kotlin",
                "latex",
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
            },
            auto_install = true,
            highlight = {
                enable = true,
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                -- If you are experiencing weird indenting issues, add the language to
                -- the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { "ruby" },
                disable = { "latex" },
            },
            indent = { enable = true, disable = { "ruby" } },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ib"] = { query = "@block.inner", desc = "in block" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer",
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer",
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer",
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer",
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner",
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner",
                    },
                },
                lsp_interop = {
                    enable = true,
                    border = "single",
                    peek_definition_code = {
                        ["<leader>df"] = "@function.outer",
                        ["<leader>dF"] = "@class.outer",
                    },
                },
                matchup = {
                    enable = true,
                },
            },
        },
    },
}
