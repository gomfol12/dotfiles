-- ==================== Completion (blink.cmp, LuaSnip, ...) ==================== --
-- TODO: "Kaiser-Yang/blink-cmp-dictionary"

return {
    "saghen/blink.cmp",

    version = "1.*",

    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "onsails/lspkind.nvim",
        "xzbdmw/colorful-menu.nvim",

        "disrupted/blink-cmp-conventional-commits",
        "Kaiser-Yang/blink-cmp-git",
        "MahanRahmati/blink-nerdfont.nvim",
        "moyiz/blink-emoji.nvim",
        "ribru17/blink-cmp-spell",

        {
            "saghen/blink.compat",
            -- use v2.* for blink.cmp v1.*
            version = "2.*",
            lazy = true,
            opts = {},
        },

        "hrsh7th/cmp-calc",

        {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets.
                -- This step is not supported in many windows environments.
                -- Remove the below condition to re-enable on windows.
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
            config = function()
                local luasnip = require("luasnip")
                local types = require("luasnip.util.types")

                luasnip.config.setup({
                    ext_opts = vim.g.have_nerd_font and {
                        [types.choiceNode] = {
                            active = {
                                virt_text = { { "●", "Todo" } }, -- yellow
                            },
                        },
                        [types.insertNode] = {
                            active = {
                                virt_text = { { "●", "Constant" } }, -- blue
                            },
                        },
                    } or {},
                    enable_autosnippets = true,
                    store_selection_keys = "<Tab>",
                    update_events = { "TextChanged", "TextChangedI" },
                    delete_check_events = { "TextChanged", "InsertLeave" },
                })

                -- load custom snippets
                require("luasnip.loaders.from_lua").lazy_load({
                    paths = { vim.fn.stdpath("config") .. "/lua/snippets/" },
                })
            end,
            keys = {
                {
                    "<Leader>L",
                    function()
                        require("luasnip.loaders.from_lua").lazy_load({
                            paths = { vim.fn.stdpath("config") .. "/lua/snippets/" },
                        })
                    end,
                    desc = "Reload snippets",
                },
            },
        },
        {
            "jmbuhr/otter.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
            },
            opts = {},
        },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",

            ["<C-space>"] = { "show", "hide" },

            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },

            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Tab>"] = { "select_next", "fallback" },

            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },

            ["<C-e>"] = { "hide", "fallback" },
            ["<C-y>"] = { "select_and_accept", "fallback" },
            ["<CR>"] = { "select_and_accept", "fallback" },

            ["<C-u>"] = { "scroll_signature_up", "fallback" },
            ["<C-d>"] = { "scroll_signature_down", "fallback" },

            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        },

        completion = {
            documentation = {
                auto_show = true,
                window = {
                    border = "single",
                },
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = false,
                },
            },
            menu = {
                border = "single",
                draw = {
                    treesitter = { "lsp" },
                    columns = {
                        -- "label" and "label_description" are combined by colorful-menu.nvim
                        { "label", gap = 1 },
                        { "kind_icon", gap = 1, "kind" },
                        -- { "source_name" },
                    },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                        kind_icon = {
                            text = function(ctx)
                                local icon = ctx.kind_icon
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = require("lspkind").symbol_map[ctx.kind] or ""
                                end

                                return icon .. ctx.icon_gap
                            end,

                            highlight = function(ctx)
                                local hl = ctx.kind_hl
                                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        },
                    },
                },
            },
        },

        cmdline = {
            keymap = {
                preset = "inherit",
                ["<CR>"] = { "accept_and_enter", "fallback" },
            },
            completion = {
                menu = {
                    auto_show = true,
                },
            },
        },

        signature = {
            enabled = true,
            window = { border = "single" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        snippets = { preset = "luasnip" },

        sources = {
            default = {
                "lazydev",
                "lsp",
                "path",
                "snippets",
                "conventional_commits",
                "git",
                "spell",
                "buffer",
                "calc",
                "nerdfont",
                "emoji",
            },
            providers = {
                cmdline = {
                    min_keyword_length = function(ctx)
                        -- when typing a command, only show when the keyword is 3 characters or longer
                        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                            return 3
                        end
                        return 0
                    end,
                },
                lazydev = {
                    name = "[LD]",
                    module = "lazydev.integrations.blink",
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                lsp = {
                    name = "[LSP]",
                },
                path = {
                    name = "[Path]",
                },
                snippets = {
                    name = "[Snip]",
                },
                conventional_commits = {
                    name = "[cc]",
                    module = "blink-cmp-conventional-commits",
                    enabled = function()
                        return vim.bo.filetype == "gitcommit"
                    end,
                    ---@module 'blink-cmp-conventional-commits'
                    ---@type blink-cmp-conventional-commits.Options
                    opts = {},
                },
                git = {
                    name = "[git]",
                    module = "blink-cmp-git",
                    opts = {},
                },
                spell = {
                    name = "[SP]",
                    module = "blink-cmp-spell",
                    opts = {
                        use_cmp_spell_sorting = true,
                        max_entries = 10,
                        -- Only enable source in `@spell` captures, and disable it
                        -- in `@nospell` captures.
                        enable_in_context = function()
                            local curpos = vim.api.nvim_win_get_cursor(0)
                            local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                            local in_spell_capture = false
                            for _, cap in ipairs(captures) do
                                if cap.capture == "spell" then
                                    in_spell_capture = true
                                elseif cap.capture == "nospell" then
                                    return false
                                end
                            end
                            return in_spell_capture
                        end,
                    },
                },
                buffer = {
                    name = "[Buf]",
                },
                calc = {
                    name = "[Calc]",
                    module = "blink.compat.source",
                },
                nerdfont = {
                    name = "[Nerd]",
                    module = "blink-nerdfont",
                    score_offset = 15,
                    opts = {
                        insert = true, -- Insert nerdfont icon (default) or complete its name
                        trigger = ":",
                    },
                },
                emoji = {
                    name = "[Emoji]",
                    module = "blink-emoji",
                    score_offset = 15,
                    opts = {
                        insert = true, -- Insert emoji (default) or complete its name
                        ---@type string|table|fun():table
                        trigger = ":",
                    },
                },
            },
        },

        fuzzy = {
            implementation = "prefer_rust_with_warning",
            sorts = {
                "exact",
                "score",
                "sort_text",
            },
        },
    },
    opts_extend = { "sources.default" },
}
