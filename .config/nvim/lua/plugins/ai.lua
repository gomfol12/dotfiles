-- ==================== AI (copilot.vim, codecompanion.nvim) ==================== --

return {
    {
        "github/copilot.vim",
        init = function()
            vim.g.copilot_no_tab_map = true
        end,
        config = function()
            vim.cmd([[imap <silent><script><expr> <C-q> copilot#Accept("\<CR>")]])

            -- disable Copilot by default and commands for enabling it by buffer
            vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
                pattern = "*",
                callback = function()
                    vim.b.copilot_enabled = 0
                end,
            })
            vim.api.nvim_create_user_command("CopilotEnable", function()
                vim.b.copilot_enabled = 1
            end, {})

            vim.api.nvim_create_user_command("CopilotDisable", function()
                vim.b.copilot_enabled = 0
            end, {})
        end,
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
            { "stevearc/dressing.nvim", opts = {} },
        },
        config = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = "chat",
                    },
                    inline = {
                        adapter = "inline",
                    },
                    agent = {
                        adapter = "chat",
                    },
                },
                adapters = {
                    chat = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = "chat",
                            schema = {
                                model = {
                                    -- default = "llama3.2:3b",
                                    default = "llama3.1:8b",
                                    -- default = "llama3:8b",
                                    -- default = "codellama:7b",
                                },
                            },
                        })
                    end,
                    inline = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            name = "inline",
                            schema = {
                                model = {
                                    default = "deepseek-coder:6.7b-base",
                                },
                            },
                        })
                    end,
                    codestral = function()
                        return require("codecompanion.adapters").extend("ollama", {
                            schema = {
                                name = "codestral",
                                model = {
                                    default = "codestral:latest",
                                },
                            },
                        })
                    end,
                },
            })

            vim.cmd([[cab cc CodeCompanion]])
            vim.cmd([[cab ccc CodeCompanionChat]])
        end,
    },
}
