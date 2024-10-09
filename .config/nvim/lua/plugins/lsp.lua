-- ==================== LSP ==================== --

local signs = {}
if vim.g.have_nerd_font then
    signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end
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
        source = true,
        header = "",
        prefix = "",
        border = "single",
    },
})

return {
    {
        -- proper luals configuration
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            -- Useful status updates for LSP.
            { "j-hui/fidget.nvim", opts = {} },

            -- Allows extra capabilities provided by nvim-cmp
            "hrsh7th/cmp-nvim-lsp",

            -- {
            --     "ray-x/lsp_signature.nvim",
            --     event = "InsertEnter",
            --     opts = {
            --         bind = true,
            --         handler_opts = {
            --             border = "single",
            --         },
            --         doc_lines = 0,
            --         hint_enable = false,
            --     },
            --     config = function(_, opts)
            --         -- require("lsp_signature").setup(opts)
            --     end,
            -- },

            -- additional lsps / extensions
            "p00f/clangd_extensions.nvim",
            "mfussenegger/nvim-jdtls",
            -- scala
            {
                "scalameta/nvim-metals",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                },
                ft = { "scala", "sbt", "java" },
                opts = function()
                    -- check for coursier. Is required for Metals
                    local utils = require("config.utils")
                    if
                        not utils.check_executable(
                            { "coursier" },
                            "Coursier is required for Metals. Remember to run `coursier setup` before first use."
                        )
                    then
                        return
                    end

                    local metals_config = require("metals").bare_config()
                    metals_config.settings = {
                        showImplicitArguments = true,
                        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
                    }

                    metals_config.capabilities = vim.lsp.protocol.make_client_capabilities()
                    metals_config.capabilities = vim.tbl_deep_extend(
                        "force",
                        metals_config.capabilities,
                        require("cmp_nvim_lsp").default_capabilities()
                    )

                    -- metals_config.on_attach = function(client, bufnr) end

                    return metals_config
                end,
                config = function(self, metals_config)
                    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
                    vim.api.nvim_create_autocmd("FileType", {
                        pattern = self.ft,
                        callback = function()
                            require("metals").initialize_or_attach(metals_config)
                        end,
                        group = nvim_metals_group,
                    })
                end,
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode, silent)
                        mode = mode or "n"
                        vim.keymap.set(
                            mode,
                            keys,
                            func,
                            { buffer = event.buf, desc = "LSP: " .. desc, silent = silent or false }
                        )
                    end

                    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                    map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
                    map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
                    map("K", vim.lsp.buf.hover, "[K]ind of symbol")
                    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
                    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("[d", ":lua vim.diagnostic.goto_prev()<cr>", "Previous [D]iagnostic")
                    map("]d", ":lua vim.diagnostic.goto_next()<cr>", "Next [D]iagnostic")
                    map("gl", ":lua vim.diagnostic.open_float()<cr>", "Diagnostic [L]ist", { "n" }, true)
                    map("<leader>q", ":lua vim.diagnostic.setloclist()<cr>", "Open diagnostic [Q]uickfix list")
                    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                    map(
                        "<leader>ws",
                        require("telescope.builtin").lsp_dynamic_workspace_symbols,
                        "[W]orkspace [S]ymbols"
                    )
                    -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                    -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                    -- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                    -- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

                    -- auto highlighting
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                        local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")

                        vim.lsp.inlay_hint.enable()
                    end

                    -- border stuff
                    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                        border = "single",
                    })
                    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signatureHelp, {
                        border = "single",
                    })
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            -- Overridable fields
            --  - cmd (table): start command for the server
            --  - filetypes (table): associated filetypes for the server
            --  - capabilities (table)
            --  - settings (table)
            local servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--function-arg-placeholders=false",
                    },
                    inlay_hints = {
                        highlight = "LspInlayHint",
                    },
                    ast = {
                        role_icons = vim.g.have_nerd_font and {
                            type = "",
                            declaration = "",
                            expression = "",
                            specifier = "",
                            statement = "",
                            ["template argument"] = "",
                        } or {},
                        kind_icons = vim.g.have_nerd_font and {
                            Compound = "",
                            Recovery = "",
                            TranslationUnit = "",
                            PackExpansion = "",
                            TemplateTypeParm = "",
                            TemplateTemplateParm = "",
                            TemplateParamObject = "",
                        } or {},
                        highlights = {
                            detail = "Comment",
                        },
                    },
                    memory_usage = {
                        border = "single",
                    },
                    symbol_info = {
                        border = "single",
                    },
                },
                pyright = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = { disable = { "missing-fields" } },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },
                jsonls = {},
                bashls = {},
                cmake = {},
                html = {},
                cssls = {},
                svlangserver = {},
                texlab = {},
                marksman = {},
                yamlls = {},
                emmet_language_server = {},
                zls = {},
                rust_analyzer = {},
                jdtls = {},
            }

            -- mason
            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "shfmt",
                "prettier",
                "latexindent",
                "black",
                "markdownlint",
                "shellcheck",
                "mypy",
                "ruff",
                "hadolint",
                "jsonlint",
                "vale",
                "jupytext",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        if server_name == "clangd" then
                            require("clangd_extensions").setup()
                            capabilities.offsetEncoding = { "utf-16" } -- clangd uses utf-16 offsets
                        end

                        if server_name == "rust_analyzer" or server_name == "jdtls" then
                            return
                        end

                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
