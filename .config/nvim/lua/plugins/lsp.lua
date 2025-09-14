-- ==================== LSP ==================== --

local signs = {}
if vim.g.have_nerd_font then
    signs = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
    }
end

vim.diagnostic.config({
    virtual_text = false,
    signs = {
        text = signs or {},
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
        border = "single",
        source = true,
        header = "",
        prefix = "",
        suffix = "",
    },
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local map = function(keys, func, desc, mode, silent)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc, silent = silent or false })
        end

        map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        map("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype Definition")
        map("K", function()
            vim.lsp.buf.hover({ border = "single" })
        end, "[K]ind of symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
        map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        map("<F2>", vim.lsp.buf.rename, "[R]e[n]ame")
        map("[d", ":lua vim.diagnostic.goto_prev()<cr>", "Previous [D]iagnostic")
        map("]d", ":lua vim.diagnostic.goto_next()<cr>", "Next [D]iagnostic")
        map("gl", ":lua vim.diagnostic.open_float()<cr>", "Diagnostic [L]ist", { "n" }, true)
        map("<leader>q", ":lua vim.diagnostic.setloclist()<cr>", "Open diagnostic [Q]uickfix list")
        map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
        map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
        -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        -- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
        -- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

        -- auto highlighting
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>th", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay [H]ints")

            vim.lsp.inlay_hint.enable()
        end
    end,
})

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
                diagnostics = { disable = { "missing-fields", "unused-function" } },
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
    ltex = {
        on_init = function(client, bufnr)
            local settings = client.config.settings.ltex or {}
            local path = vim.fn.stdpath("config") .. "/spell/de.utf-8.add"
            local file = io.open(path, "r")

            if not file then
                vim.notify("Cannot open spell file: " .. path, vim.log.levels.WARN)
                return
            end

            settings.dictionary = settings.dictionary or {}
            settings.dictionary["en-US"] = settings.dictionary["en-US"] or {}
            settings.dictionary["de-DE"] = settings.dictionary["de-DE"] or {}

            local dict_en = settings.dictionary["en-US"]
            local dict_de = settings.dictionary["de-DE"]

            for word in file:lines() do
                table.insert(dict_en, word)
                table.insert(dict_de, word)
            end

            file:close()
        end,
        filetypes = { "tex" },
        flags = { debounce_text_changes = 300 },
        settings = {
            ltex = {
                language = "de-DE",
                setenceCacheSize = 2000,
                additionalRules = {
                    enablePickyRules = true,
                    motherTongue = "de-DE",
                },
                trace = { server = "verbose" },
                disabledRules = {},
                hiddenFalsePositives = {},
            },
        },
    },
    -- marksman = {},
    yamlls = {},
    emmet_language_server = {},
    zls = {},
    rust_analyzer = {},
    jdtls = {},
    fortls = {
        cmd = {
            "fortls",
            "--lowercase_intrinsics",
            "--hover_signature",
            "--hover_language=fortran",
            "--use_signature_help",
            "--notify_init",
            "--enable_code_actions",
        },
    },
    vimls = {},
}

local tools = {
    "stylua",
    "shfmt",
    "prettier",
    "latexindent",
    "markdownlint",
    "shellcheck",
    "mypy",
    "ruff",
    "hadolint",
    "jsonlint",
    "vale",
    "jupytext",
    "fprettify",
    "vint",
}

return {
    { "mason-org/mason.nvim", opts = {} },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        event = { "VeryLazy", "BufReadPre", "BufNewFile" },
        config = function()
            local mr = require("mason-registry")
            mr.refresh(function()
                for _, tool in pairs(tools) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install(nil, function()
                            print("Installed " .. tool)
                        end)
                    end
                end
            end)

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local ensure_installed = vim.tbl_keys(servers)

            for server, opts in pairs(servers) do
                vim.lsp.config[server] = vim.tbl_deep_extend("force", { capabilities = capabilities }, opts or {})
            end

            require("mason-lspconfig").setup({
                automatic_enable = {
                    exclude = {
                        "rust_analyzer",
                        "jdtls",
                    },
                },
                ensure_installed = ensure_installed,
            })
        end,
    },

    -- Useful status updates for LSP.
    {
        "j-hui/fidget.nvim",
        opts = {
            progress = {
                ignore = { "ltex" },
            },
        },
    },

    -- additional lsps / extensions
    {
        "p00f/clangd_extensions.nvim",
        ft = { "c", "cpp", "h", "hpp" },
        config = function()
            require("clangd_extensions").setup()
        end,
    },
    { "mfussenegger/nvim-jdtls", ft = "java" },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "mrcjkb/rustaceanvim",
        ft = "rust",
        lazy = false,
    },

    -- scala
    {
        "scalameta/nvim-metals",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        ft = { "scala", "sbt" },
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
            metals_config.capabilities =
                vim.tbl_deep_extend("force", metals_config.capabilities, require("cmp_nvim_lsp").default_capabilities())

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
}
