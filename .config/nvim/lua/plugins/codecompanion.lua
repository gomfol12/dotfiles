return {
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
                                default = "llama3:8b",
                                -- defaule = "codellama:7b",
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
}
