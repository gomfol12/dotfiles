local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function cmp_format(entry, vim_item)
    if vim.tbl_contains({ "path" }, entry.source.name) then
        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
        if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
        end
    end
    return require("lspkind").cmp_format({ mode = "symbol_text", show_labelDetails = true })(entry, vim_item)
end

return {
    "hrsh7th/nvim-cmp",
    event = { "CmdlineEnter", "InsertEnter" },
    dependencies = {
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
            dependencies = {
                {
                    "rafamadriz/friendly-snippets",
                    config = function()
                        require("luasnip.loaders.from_vscode").lazy_load()
                    end,
                },
            },
            keys = {
                {
                    "<Leader>L",
                    function()
                        require("luasnip.loaders.from_lua").lazy_load({
                            paths = vim.fn.stdpath("config") .. "/lua/snippets/",
                        })
                    end,
                    desc = "Reload snippets",
                },
            },
        },
        "saadparwaiz1/cmp_luasnip",

        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "lukas-reineke/cmp-rg",
        "petertriho/cmp-git",
        "nvim-lua/plenary.nvim",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-buffer",
        "jmbuhr/cmp-pandoc-references",
        "hrsh7th/cmp-emoji",

        "hrsh7th/cmp-cmdline",
        "dmitmel/cmp-cmdline-history",

        "hrsh7th/cmp-omni",

        "nvim-tree/nvim-web-devicons",
        "onsails/lspkind.nvim",

        {
            "jmbuhr/otter.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
            },
        },
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local types = require("luasnip.util.types")

        luasnip.config.setup({
            ext_opts = vim.g.have_nerd_font
                    and {
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
                    }
                or {},
            enable_autosnippets = true,
            store_selection_keys = "<Tab>",
            update_events = { "TextChanged", "TextChangedI" },
            delete_check_events = { "TextChanged", "InsertLeave" },
        })

        -- load custom snippets
        require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/lua/snippets/" })

        cmp.setup({
            preselect = "none",
            completion = { completeopt = "menu,menuone,noinsert,noselect" },
            window = {
                completion = cmp.config.window.bordered({
                    border = "single",
                }),
                documentation = cmp.config.window.bordered({
                    border = "single",
                }),
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                }),

                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),

                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-y>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-x>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-c>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    end
                end, { "i", "s" }),
            }),
            formatting = {
                format = cmp_format,
            },
            sources = {
                {
                    name = "lazydev",
                    -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
                    group_index = 0,
                },
                { name = "nvim_lsp_signature_help" },
                { name = "nvim_lsp" },
                { name = "otter" },
                { name = "luasnip" },
                { name = "pandoc_references" },
                { name = "path" },
                { name = "git" },
                { name = "emoji" },
                { name = "calc" },
                { name = "path" },
                { name = "buffer" },
            },
        })

        cmp.setup.cmdline("/", {
            mapping = cmp.mapping.preset.cmdline(),
            formatting = {
                format = cmp_format,
            },
            sources = {
                {
                    name = "lazydev",
                    group_index = 0,
                },
                { name = "buffer" },
                { name = "cmdline_history" },
            },
        })

        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            formatting = {
                format = cmp_format,
            },
            sources = {
                {
                    name = "lazydev",
                    group_index = 0,
                },
                { name = "path" },
                { name = "cmdline" },
                { name = "cmdline_history" },
            },
        })
    end,
}
